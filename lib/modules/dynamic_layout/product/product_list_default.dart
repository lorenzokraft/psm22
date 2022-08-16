import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/tools.dart';
import '../../../models/index.dart' show AppModel;
import '../../../services/index.dart';
import '../../../widgets/common/index.dart';
import '../config/product_config.dart';
import '../helper/custom_physic.dart';
import '../helper/helper.dart';

class ProductListDefault extends StatelessWidget {
  final maxWidth;
  final products;
  final int? row;
  final ProductConfig config;

  const ProductListDefault({
    required Key key,
    this.maxWidth,
    this.products,
    this.row = 1,
    required this.config,
  }) : super(key: key);

  Widget renderHorizontal(BuildContext context, {bool enableBackground = false}) {
    var _ratioProductImage = Provider.of<AppModel>(context, listen: false).ratioProductImage;
    /// allow override imageRatio when there is single Row
    if (config.rows == 1) {
      _ratioProductImage = config.imageRatio;
    }

    final padding = enableBackground ? 0.0 : 12.0;
    var width = maxWidth - padding;
    var layout = config.layout ?? Layout.threeColumn;

    return Container(
      height: 265,
      color: Colors.white,
      padding: EdgeInsets.only(left: padding),
      constraints: BoxConstraints(
        minHeight: Layout.buildProductHeight(
          layout: layout,
          defaultHeight: width,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: config.isSnapping ?? false
            ? CustomScrollPhysic(
                width: Layout.buildProductWidth(
                    screenWidth: width, layout: layout))
            : const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (enableBackground)
              SizedBox(
                width: config.spaceWidth != null
                    ? config.spaceWidth?.toDouble()
                    : Layout.buildProductWidth(
                        screenWidth: maxWidth,
                        layout: layout,
                      ),
                height: Layout.buildProductHeight(
                  layout: layout,
                  defaultHeight: width,
                ),
              ),
            for (var i = 0; i < products.length; i++)
              Services().widget.renderProductCardView(
                    item: products[i],
                    width: Layout.buildProductWidth(
                      screenWidth: maxWidth,
                      layout: layout,
                    ),
                    maxWidth: Layout.buildProductMaxWidth(layout: layout),
                    height: Layout.buildProductHeight(
                      layout: layout,
                      defaultHeight: width,
                    ),
                    ratioProductImage: _ratioProductImage,
                    config: config,
                  )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (products == null) return Container();

    var enableBackground =
        config.backgroundImage != null || config.backgroundColor != null;
    var backgroundHeight = config.backgroundHeight?.toDouble();
    var backgroundWidth = (config.backgroundWidthMode ?? false)
        ? MediaQuery.of(context).size.width
        : config.backgroundWidth?.toDouble();

    if (enableBackground) {
      return Stack(
        children: [
          if (config.backgroundColor != null)
            Container(
              height: backgroundHeight,
              width: backgroundWidth,
              decoration: BoxDecoration(
                color: config.backgroundColor,
                borderRadius: BorderRadius.circular(config.backgroundRadius),
              ),
            ),
          if (config.backgroundImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(config.backgroundRadius),
              child: FluxImage(
                imageUrl: config.backgroundImage!,
                fit: ImageTools.boxFit(config.backgroundBoxFit),
                height: backgroundHeight,
                width: backgroundWidth,
              ),
            ),
          Padding(
            padding: config.paddingBGP ?? const EdgeInsets.only(),
            child: renderHorizontal(context, enableBackground: enableBackground),
          ),
        ],
      );
    }

    return renderHorizontal(context);
  }
}
