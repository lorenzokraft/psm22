import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/index.dart' show Product, RecentModel;
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../routes/flux_navigate.dart';
import 'index.dart'
    show
        CartButton,
        CartIcon,
        CartQuantity,
        HeartButton,
        ProductPricing,
        ProductRating,
        ProductTitle,
        StockStatus,
        StoreName;

class ProductItemTileView extends StatelessWidget {
  final Product item;
  final EdgeInsets? padding;
  final ProductConfig config;

  const ProductItemTileView({
    required this.item,
    this.padding,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapProduct(context),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(width: 8),
            Flexible(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 15.0),
                      child: getImageFeature(
                        () => onTapProduct(context),
                      ),
                    ),
                    if ((item.onSale ?? false) && item.regularPrice!.isNotEmpty)
                      InkWell(
                        onTap: () => onTapProduct(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.only(
                              bottomLeft: context.isRtl
                                  ? Radius.zero
                                  : const Radius.circular(8),
                              bottomRight: context.isRtl
                                  ? const Radius.circular(8)
                                  : Radius.zero,
                            ),
                          ),
                          child: Text(
                            '${(100 - double.parse(item.price!) / double.parse(item.regularPrice.toString()) * 100).toInt()} %',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              flex: 3,
              child: _ProductDescription(
                item: item,
                config: config,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageFeature(onTapProduct) {
    return GestureDetector(
      onTap: onTapProduct,
      child: ImageTools.image(
        url: item.imageFeature,
        size: kSize.medium,
        isResize: true,
        // height: _height,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  void onTapProduct(context) {
    if (item.imageFeature == '') return;
    Provider.of<RecentModel>(context, listen: false).addRecentProduct(item);

    FluxNavigate.pushNamed(
      RouteList.productDetail,
      arguments: item,
      forceRootNavigator: kIsWeb,
    );
  }
}

class _ProductDescription extends StatelessWidget {
  final ProductConfig config;

  const _ProductDescription({
    Key? key,
    required this.item,
    required this.config,
  }) : super(key: key);

  final Product item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            if (item.categoryName != null)
              Text(
                item.categoryName!.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ProductTitle(
              product: item,
              hide: config.hideTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
              maxLines: config.titleLine,
            ),
            const SizedBox(height: 4),
            StoreName(product: item, hide: config.hideStore),
            if (item.tagLine != null)
              Text(
                item.tagLine.toString(),
                maxLines: 1,
                style: const TextStyle(fontSize: 13),
              ),
            ProductPricing(product: item, hide: config.hidePrice),
            StockStatus(product: item, config: config),
            const SizedBox(height: 6),
            ProductRating(
              product: item,
              config: config,
            ),
            if (!config.showQuantity)
              Align(
                alignment:
                    context.isRtl ? Alignment.topLeft : Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CartIcon(product: item, config: config),
                ),
              ),
            if (kEnableShoppingCart)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CartQuantity(product: item, config: config),
              ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (config.showCartButton && kEnableShoppingCart)
                  CartButton(
                    product: item,
                    hide: !item.canBeAddedToCartFromList(
                            enableBottomAddToCart:
                                config.enableBottomAddToCart) &&
                        config.showCartButton,
                    enableBottomAddToCart: config.enableBottomAddToCart,
                  ),
                const Spacer(),
                if (config.showHeart && !item.isEmptyProduct())
                  CircleAvatar(child: HeartButton(product: item, size: 18)),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
