import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/entities/coupon.dart';
import '../../models/index.dart'
    show
        AddonsOption,
        CartModel,
        Country,
        CountryState,
        Coupons,
        Order,
        PaymentMethod,
        Product,
        ProductVariation,
        ShippingMethodModel,
        User,
        UserModel;
import '../../routes/flux_navigate.dart';
import '../../screens/index.dart'
    show PaymentWebview, WebviewCheckoutSuccessScreen;
import '../../services/index.dart';
import '../frameworks.dart';
import '../product_variant_mixin.dart';
import 'services/shopify_service.dart';
import 'shopify_variant_mixin.dart';

class ShopifyWidget extends BaseFrameworks
    with ProductVariantMixin, ShopifyVariantMixin {
  final ShopifyService shopifyService;

  ShopifyWidget(this.shopifyService);

  @override
  bool get enableProductReview => false; // currently did not support review

  @override
  Future<void> applyCoupon(
    context, {
    Coupons? coupons,
    String? code,
    Function? success,
    Function? error,
  }) async {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    try {
      /// check exist checkoutId
      var isExisted = false;

      if (cartModel.checkout != null && cartModel.checkout!.id != null) {
        isExisted = true;
      }
      final userCookie = cartModel.user?.cookie;
      var checkout = isExisted
          ? await shopifyService.updateItemsToCart(cartModel, userCookie)
          : await shopifyService.addItemsToCart(cartModel);
      cartModel.setCheckout(checkout);

      if (checkout != null) {
        /// apply coupon code
        var checkoutCoupon =
            await shopifyService.applyCoupon(cartModel, code!.toUpperCase());

        cartModel.setCheckout(checkoutCoupon);

        if (checkoutCoupon.coupon?.code == null) {
          final checkout =
              await shopifyService.removeCoupon(cartModel.checkout!.id);

          cartModel.setCheckout(checkout);
          error!(S.of(context).couponInvalid);
          return;
        }

        success!(Discount(coupon: checkoutCoupon.coupon));

        return;
      }

      error!(S.of(context).couponInvalid);
    } catch (e) {
      error!(e.toString());
    }
  }

  @override
  Future<void> removeCoupon(context) async {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    try {
      final checkout =
          await shopifyService.removeCoupon(cartModel.checkout!.id);

      cartModel.setCheckout(checkout);
    } catch (e) {
      printLog(e);
    }
  }

  @override
  Future<void> doCheckout(context,
      {Function? success, Function? loading, Function? error}) async {
    final cartModel = Provider.of<CartModel>(context, listen: false);

    try {
      // check exist checkoutId
      var isExisted = false;

      if (cartModel.checkout != null && cartModel.checkout!.id != null) {
        isExisted = true;
      }
      final userCookie = cartModel.user?.cookie;
      var checkout = isExisted
          ? await shopifyService.updateItemsToCart(cartModel, userCookie)
          : await shopifyService.addItemsToCart(cartModel);
      cartModel.setCheckout(checkout);

      if (kPaymentConfig['EnableOnePageCheckout']) {
        if (checkout != null) {
          /// Navigate to Webview payment
          /// payment screen
          String? orderNum;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentWebview(
                url: cartModel.checkout!.webUrl,
                onFinish: (number) async {
                  orderNum = number;
                },
              ),
            ),
          );
          if (orderNum != null) {
            cartModel.clearCart();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebviewCheckoutSuccessScreen(
                  order: Order(number: orderNum),
                ),
              ),
            );
          }
          loading!(false);
          return;
        }
      }
      success!();
    } catch (e) {
      error!(e.toString());
    }
  }

  @override
  Future<void> createOrder(context,
      {Function? onLoading,
      Function? success,
      Function? error,
      paid = false,
      cod = false,
      bacs = false,
      transactionId = ''}) async {}

  @override
  void placeOrder(
    context, {
    CartModel? cartModel,
    PaymentMethod? paymentMethod,
    Function? onLoading,
    Function? success,
    Function? error,
  }) async {
    {
      await shopifyService.updateCheckout(
        checkoutId: cartModel!.checkout!.id,
        note: cartModel.notes,
        deliveryDate: cartModel.selectedDate?.dateTime,
      );

      await FluxNavigate.push(
        MaterialPageRoute(
          builder: (context) => PaymentWebview(
            onFinish: (number) async {
              // Success
              if (number == '0') {
                if (kPaymentConfig['GuestCheckout'] == false) {
                  final order = await shopifyService.getLatestOrder(
                      cookie: cartModel.user?.cookie ?? '');
                  if (order == null) return error!('Checkout failed');
                  success!(order);
                  return;
                }
                success!(Order());
              }
            },
            onClose: () {
              onLoading!(false);
              error!('Payment cancelled');
            },
          ),
        ),
        forceRootNavigator: true,
      );
    }
  }

  @override
  Map<dynamic, dynamic> getPaymentUrl(context) {
    return {
      'headers': {},
      'url': Provider.of<CartModel>(context, listen: false).checkout?.webUrl
    };
  }

  @override
  void updateUserInfo(
      {User? loggedInUser,
      context,
      required onError,
      onSuccess,
      required currentPassword,
      required userDisplayName,
      userEmail,
      userNiceName,
      userUrl,
      userPassword}) {
    final names = userDisplayName.trim().split(' ');
    final firstName = names.first;
    final lastName = names.sublist(1).join(' ');
    final params = {
      'email': userEmail,
      'firstName': firstName,
      'lastName': lastName,
      'password': userPassword,
    };

    Services().api.updateUserInfo(params, loggedInUser!.cookie)!.then((value) {
      params['cookie'] = loggedInUser.cookie;
      // ignore: unnecessary_null_comparison
      onSuccess!(params != null
          ? User.fromShopifyJson(params, loggedInUser.cookie)
          : loggedInUser);
    }).catchError((e) {
      onError(e.toString());
    });
  }

  @override
  Widget renderVariantCartItem(
      BuildContext context, variation, Map<String, dynamic>? options) {
    var list = <Widget>[];
    for (var att in variation.attributes) {
      list.add(Row(
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 50.0, maxWidth: 200),
            child: Text(
              '${att.name![0].toUpperCase()}${att.name!.substring(1)} ',
            ),
          ),
          att.name == 'color'
              ? Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: HexColor(
                          kNameToHex[att.option!.toLowerCase()]!,
                        ),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Text(
                  att.option!,
                  textAlign: TextAlign.end,
                )),
        ],
      ));
      list.add(const SizedBox(
        height: 5.0,
      ));
    }

    return Column(children: list);
  }

  @override
  void loadShippingMethods(context, CartModel cartModel, bool beforehand) {
//    if (!beforehand) return;
    final cartModel = Provider.of<CartModel>(context, listen: false);
    Future.delayed(Duration.zero, () {
      final token = Provider.of<UserModel>(context, listen: false).user != null
          ? Provider.of<UserModel>(context, listen: false).user!.cookie
          : null;
      Provider.of<ShippingMethodModel>(context, listen: false)
          .getShippingMethods(
              cartModel: cartModel,
              token: token,
              checkoutId: cartModel.getCheckoutId());
    });
  }

  @override
  String? getPriceItemInCart(Product product, ProductVariation? variation,
      currencyRate, String? currency,
      {List<AddonsOption>? selectedOptions}) {
    return variation != null && variation.id != null
        ? PriceTools.getVariantPriceProductValue(
            variation,
            currencyRate,
            currency,
            onSale: true,
            selectedOptions: selectedOptions,
          )
        : PriceTools.getPriceProduct(product, currencyRate, currency,
            onSale: true);
  }

  @override
  Future<List<Country>> loadCountries() async {
    var countries = <Country>[];
    if (kDefaultCountry.isNotEmpty) {
      for (var item in kDefaultCountry) {
        countries.add(Country.fromConfig(
            item['iosCode'], item['name'], item['icon'], []));
      }
    }
    return countries;
  }

  @override
  Future<List<CountryState>> loadStates(Country country) async {
    final items = await Tools.loadStatesByCountry(country.id!);
    var states = <CountryState>[];
    if (items.isNotEmpty) {
      for (var item in items) {
        states.add(CountryState.fromConfig(item));
      }
    }
    return states;
  }

  @override
  Future<void> resetPassword(BuildContext context, String username) async {
    try {
      final val = await (Provider.of<UserModel>(context, listen: false)
          .submitForgotPassword(forgotPwLink: '', data: {'email': username}));
      if (val?.isEmpty ?? true) {
        Future.delayed(
            const Duration(seconds: 1), () => Navigator.of(context).pop());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).checkConfirmLink),
          duration: const Duration(seconds: 5),
        ));
      } else {
        Tools.showSnackBar(Scaffold.of(context), val);
      }
      return;
    } catch (e) {
      printLog(e);
      if (e.toString().contains('UNIDENTIFIED_CUSTOMER')) {
        throw Exception(S.of(context).emailDoesNotExist);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget renderRelatedBlog({categoryId, required kBlogLayout type}) {
    return const SizedBox();
  }

  @override
  Widget renderCommentField(dynamic postId) {
    return const SizedBox();
  }

  @override
  Widget renderCommentLayout(dynamic postId, kBlogLayout type) {
    return const SizedBox();
  }
}
