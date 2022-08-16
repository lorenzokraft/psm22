import 'package:flutter/material.dart';
import 'package:fstore/widgets/product/widgets/heart_button.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show AppModel, Product;
import '../../../routes/flux_navigate.dart';
import '../../../modules/dynamic_layout/config/product_config.dart';
import '../index.dart' show CartIcon, CartQuantity, ProductOnSale;

enum SimpleType { backgroundColor, priceOnTheRight }

class ProductSimpleView2 extends StatelessWidget {
  final Product? item;
  final SimpleType? type;
  final bool isFromSearchScreen;
  final bool enableBackgroundColor;
  final ProductConfig? config;

  const ProductSimpleView2({
    this.item,
    this.type,
    this.isFromSearchScreen = false,
    this.enableBackgroundColor = true,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (item?.name == null) return const SizedBox();
    var productConfig = config ?? ProductConfig.empty();

    final currency = Provider.of<AppModel>(context).currency;
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    var screenWidth = MediaQuery.of(context).size.width;
    var titleFontSize = 15.0;
    var imageWidth = 60.0;
    var imageHeight = 60.0;

    final theme = Theme.of(context);

    var isSale = (item!.onSale ?? false) &&
        PriceTools.getPriceProductValue(item, currency, onSale: true) !=
            PriceTools.getPriceProductValue(item, currency, onSale: false);
    if (item!.isVariableProduct) {
      isSale = item!.onSale ?? false;
    }

    var _canAddToCart = !item!.isEmptyProduct() &&
        ((item?.inStock ?? false) || item!.backordersAllowed) &&
        item!.type != 'variable' &&
        item!.type != 'appointment' &&
        item!.type != 'booking' &&
        item!.type != 'external' &&
        (item!.addOns?.isEmpty ?? true);

    var priceProduct = PriceTools.getPriceProductValue(
      item,
      currency,
      onSale: true,
    );

    void onTapProduct(BuildContext context) {
      if (item!.imageFeature == '') return;

      if (isFromSearchScreen) {
        Navigator.of(context).pushNamed(
          RouteList.productDetail,
          arguments: item,
        );
        return;
      }
      FluxNavigate.pushNamed(
        RouteList.productDetail,
        arguments: item,
      );
    }

    /// Product Pricing
    Widget _productPricing = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(
          item!.type == 'grouped'
              ? '${S.of(context).from} ${PriceTools.getPriceProduct(item, currencyRate, currency, onSale: true)}'
              : priceProduct == '0.0'
                  ? S.of(context).loading
                  : PriceTools.getPriceProduct(item, currencyRate, currency,
                      onSale: true)!,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 15,
                color: Colors.black,
              ),
        ),
        if (isSale) ...[
          const SizedBox(width: 5),
          Text(
            item!.type == 'grouped'
                ? ''
                : PriceTools.getPriceProduct(item, currencyRate, currency,
                    onSale: false)!,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                  decoration: TextDecoration.lineThrough,
                ),
          ),
        ]
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: () => onTapProduct(context),
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: type == SimpleType.backgroundColor && enableBackgroundColor
                ? Theme.of(context).primaryColorLight
                : null,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: ImageTools.image(
                        url: item!.imageFeature,
                        width: imageWidth,
                        size: kSize.medium,
                        isResize: true,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ProductOnSale(
                      product: item!,
                      config: productConfig,
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      margin: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        item!.name!,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (type != SimpleType.priceOnTheRight)
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: _productPricing,
                            ),
                            const Spacer(),
                            if (productConfig.showQuantity)
                              SizedBox(
                                width: 140,
                                child: CartQuantity(
                                  product: item!,
                                  config: productConfig,
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (type == SimpleType.priceOnTheRight)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: _productPricing,
                  ),
                // if ((kProductDetail.showAddToCartInSearchResult &&
                //     canAddToCart &&
                //     !productConfig.showQuantity))
                //   CartIcon(
                //     product: item!,
                //     config: productConfig,
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
