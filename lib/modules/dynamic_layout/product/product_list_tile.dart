import 'package:flutter/material.dart';

import '../../../models/index.dart' show Product;
import '../../../services/index.dart';
import '../config/product_config.dart';

class ProductListTitle extends StatelessWidget {
  final List<Product>? products;
  final ProductConfig config;

  const ProductListTitle({this.products, required this.config});

  Widget renderProductItemTileView({required Product item, dynamic config}) {
    return Services().widget.renderProductItemTileView(
          item: item,
          config: config,
        );
  }

  @override
  Widget build(BuildContext context) {
    var _products = products ?? [];

    /// mark empty
    if (_products.isEmpty) {
      return const SizedBox(height: 200);
    }

    if (_products.length < 3) {
      return Column(
        children: List.generate(
          _products.length,
          (index) => renderProductItemTileView(
            item: _products[index],
            config: config,
          ),
        ),
      );
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth + 180,
          child: PageView(
            children: <Widget>[
              for (var i = 0; i < products!.length; i = i + 3)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: renderProductItemTileView(
                        item: products![i],
                        config: config,
                      ),
                    ),
                    if (i + 1 < products!.length)
                      Expanded(
                        child: renderProductItemTileView(
                          item: products![i + 1],
                          config: config,
                        ),
                      ),
                    if (i + 2 < products!.length)
                      Expanded(
                        child: renderProductItemTileView(
                          item: products![i + 2],
                          config: config,
                        ),
                      ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
