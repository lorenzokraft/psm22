import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show CartModel, ProductWishListModel;
import '../common/app_bar_mixin.dart';
import 'empty_wishlist.dart';

class ProductWishListScreen extends StatefulWidget {
  const ProductWishListScreen();

  @override
  State<StatefulWidget> createState() => _WishListState();
}

class _WishListState extends State<ProductWishListScreen> with AppBarMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: showAppBar(RouteList.wishlist) ? appBarWidget : null,
          body: Column(
            children: [
              AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.light,
                elevation: 0.5,
                backgroundColor: Theme.of(context).backgroundColor,
                title: Text(
                  S.of(context).myWishList,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: ListenableProvider.value(
                  value:
                      Provider.of<ProductWishListModel>(context, listen: false),
                  child: Consumer<ProductWishListModel>(
                    builder: (context, model, child) {
                      if (model.products.isEmpty) {
                        return EmptyWishlist(
                          onShowHome: () => NavigateTools.navigateHome(context),
                          onSearchForItem: () =>
                              NavigateTools.navigateToRootTab(
                            context,
                            RouteList.search,
                          ),
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                              child: Text(
                                '${model.products.length} ' +
                                    S.of(context).items,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: kGrey400,
                                ),
                              ),
                            ),
                            const Divider(height: 1, color: kGrey200),
                            const SizedBox(height: 15),
                            Expanded(
                              child: ListView.builder(
                                itemCount: model.products.length,
                                itemBuilder: (context, index) {
                                  return WishlistItem(
                                    product: model.products[index],
                                    onRemove: () {
                                      Provider.of<ProductWishListModel>(context,
                                              listen: false)
                                          .removeToWishlist(
                                              model.products[index]);
                                    },
                                    onAddToCart: () {
                                      if (model.products[index].isPurchased &&
                                          model.products[index]
                                              .isDownloadable!) {
                                        Tools.launchURL(
                                            model.products[index].files![0]!);
                                        return;
                                      }
                                      var msg = Provider.of<CartModel>(context,
                                              listen: false)
                                          .addProductToCart(
                                        context: context,
                                        product: model.products[index],
                                        quantity: 1,
                                      );
                                      if (msg.isEmpty) {
                                        msg =
                                            '${model.products[index].name} ${S.of(context).addToCartSucessfully}';
                                      }
                                      Tools.showSnackBar(
                                          Scaffold.of(context), msg);
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
