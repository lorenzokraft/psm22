import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/tools/adaptive_tools.dart';
import '../../../common/tools/price_tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show AppModel, Product;
import '../../../modules/dynamic_layout/config/product_config.dart';

class ProductOnSale extends StatelessWidget {
  final Product product;
  final ProductConfig config;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxDecoration? decoration;

  const ProductOnSale({
    Key? key,
    required this.product,
    required this.config,
    this.padding,
    this.margin,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? regularPrice = 0.0;
    final currency = Provider.of<AppModel>(context, listen: false).currencyCode;
    var salePercent = 0;

    if (product.regularPrice != null &&
        product.regularPrice!.isNotEmpty &&
        product.regularPrice != '0.0') {
      regularPrice = (double.tryParse(product.regularPrice.toString()));
    }

    /// Calculate the Sale price
    var isSale = (product.onSale ?? false) &&
        PriceTools.getPriceProductValue(product, currency, onSale: true) !=
            PriceTools.getPriceProductValue(product, currency, onSale: false);
    if (isSale && regularPrice != 0) {
      salePercent = (double.parse(product.salePrice!) - regularPrice!) *
          100 ~/
          regularPrice;
    }

    if (isSale &&
        (product.regularPrice?.isNotEmpty ?? false) &&
        regularPrice != null &&
        regularPrice != 0.0 &&
        product.type != 'variable') {
      return Container(
        margin: margin ??
            EdgeInsets.symmetric(
              horizontal: config.hMargin,
              vertical: config.vMargin / 2,
            ),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: decoration ??
            _getSaleDecoration(context, borderRadius: config.borderRadius),
        child: Text(
          '$salePercent%',
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )
              .apply(fontSizeFactor: 0.9),
        ),
      );
    }

    if (isSale && product.isVariableProduct) {
      return Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: margin ??
              EdgeInsets.symmetric(
                horizontal: config.hMargin,
                vertical: config.vMargin / 2,
              ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: _getSaleDecoration(context, borderRadius: config.borderRadius),
          child: Text(
            S.of(context).onSale,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      );
    }

    return const SizedBox();
  }
}

BoxDecoration _getSaleDecoration(BuildContext context,
        {double? borderRadius = 0.0}) =>
    BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.only(
        topLeft:
            context.isRtl ? Radius.zero : Radius.circular(borderRadius ?? 0.0),
        topRight:
            context.isRtl ? Radius.circular(borderRadius ?? 0.0) : Radius.zero,
        bottomRight: context.isRtl ? Radius.zero : const Radius.circular(12),
        bottomLeft: context.isRtl ? const Radius.circular(12) : Radius.zero,
      ),
    );
