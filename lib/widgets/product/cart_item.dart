import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/entities/index.dart' show AddonsOption;
import '../../models/index.dart' show AppModel, CartModel, Product, ProductVariation;
import '../../services/index.dart';
import 'widgets/quantity_selection.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ShoppingCartRow extends StatelessWidget {
  const ShoppingCartRow({
    required this.product,
    required this.quantity,
    this.onRemove,
    this.onChangeQuantity,
    this.variation,
    this.options,
    this.addonsOptions,
  });

  final Product? product;
  final List<AddonsOption>? addonsOptions;
  final ProductVariation? variation;
  final Map<String, dynamic>? options;
  final int? quantity;
  final Function? onChangeQuantity;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<AppModel>(context).currency;
        final cartModel = Provider.of<CartModel>(context);

    final currencyRate = Provider.of<AppModel>(context).currencyRate;
      Map<String, dynamic>? defaultCurrency = kAdvanceConfig['DefaultCurrency'];


    final price = Services().widget.getPriceItemInCart(
        product!, variation, currencyRate, currency,
        selectedOptions: addonsOptions);
    final imageFeature = variation != null && variation!.imageFeature != null
        ? variation!.imageFeature
        : product!.imageFeature;
    var maxQuantity = kCartDetail['maxAllowQuantity'] ?? 100;
    var totalQuantity = variation != null
        ? (variation!.stockQuantity ?? maxQuantity)
        : (product!.stockQuantity ?? maxQuantity);
    var limitQuantity =
        totalQuantity > maxQuantity ? maxQuantity : totalQuantity;

    var theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Column(
              children: [
                Row(
                  key: ValueKey(product!.id),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)
                        ),
                        elevation: 4.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: constraints.maxWidth * 0.14,
                              height: constraints.maxWidth * 0.2,
                              child: ImageTools.image(url: imageFeature),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 13),
                                    Text(product!.name!, style: TextStyle(color: theme.colorScheme.secondary), maxLines: 4, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                      Text(price!, style: TextStyle(color: theme.colorScheme.secondary,fontWeight: FontWeight.bold, fontSize: 12)),
                                        Text(variation!.attributes.last.option??''),
                                      Padding(
                                        padding: const EdgeInsets.only(right:8.0),
                                        child: Row(
                                          children: [
                                            if (onRemove != null)
                                            GestureDetector(
                                              onTap: onRemove,
                                              child: Image.asset('assets/delete.png'),
                                            ),
                                             SizedBox(width: 5.0),
                                             if (kProductDetail.showStockQuantity)
                                          QuantitySelection(
                                          enabled: onChangeQuantity != null,
                                          width: 60,
                                          height: 32,
                                          color: Theme.of(context).colorScheme.secondary,
                                          limitSelectQuantity: limitQuantity,
                                          value: quantity,
                                          onChanged: onChangeQuantity,
                                          useNewDesign: false,
                                        ),
                                          ],
                                        ),
                                      ),


                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (product!.options != null && options != null)
                                      Services().widget.renderOptionsCartItem(product!, options),
                                    // if (variation != null)
                                    //   Services().widget.renderVariantCartItem(
                                    //       context, variation!, options),
                                    if (addonsOptions?.isNotEmpty ?? false)
                                      Services().widget.renderAddonsOptionsCartItem(context, addonsOptions),

                                    if (product?.store != null &&
                                        (product?.store?.name != null &&
                                            product!.store!.name!.trim().isNotEmpty))
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          product!.store!.name!,
                                          style: TextStyle(
                                              color: theme.colorScheme.secondary,
                                              fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children:  [
                //       Text("Subtotal",style: TextStyle(fontSize: 14),),
                //       Text( PriceTools.getCurrencyFormatted(
                //                       cartModel.getTotal()! -
                //                           cartModel.getShippingCost()!,
                //                       currencyRate,
                //                       currency: cartModel.isWalletCart()
                //                           ? defaultCurrency!['currencyCode']
                //                           : currency)!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                //     ],
                //   ),
                // ),

              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(color: kGrey200, height: 1),
            const SizedBox(height: 10.0),
          ],
        );
      },
    );
  }
}
