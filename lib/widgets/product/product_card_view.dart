import 'package:flutter/material.dart';
import 'package:fstore/common/tools.dart';
import 'package:fstore/generated/l10n.dart';
import 'package:fstore/widgets/product/widgets/quantity_selection.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/tools/adaptive_tools.dart';
import '../../models/entities/product_variation.dart';
import '../../models/index.dart' show CartModel, Product;
import '../../modules/dynamic_layout/config/product_config.dart';
import 'action_button_mixin.dart';
import 'index.dart'
    show
        CartButton,
        CartIcon,
        CartQuantity,
        HeartButton,
        ProductImage,
        ProductOnSale,
        ProductPricing,
        ProductRating,
        ProductTitle,
        SaleProgressBar,
        StockStatus,
        StoreName;
import 'widgets/cart_button_with_quantity.dart';

class ProductCard extends StatefulWidget {
  final Product item;
  final double? width;
  final double? maxWidth;
  final bool hideDetail;
  final offset;
  final ProductConfig config;
  final onTapDelete;

   ProductCard({
    required this.item,
    this.width,
    this.maxWidth,
    this.offset,
    this.hideDetail = false,
    required this.config,
    this.onTapDelete,
  });



  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with ActionButtonMixin {
  int _quantity = 1;

   List<Widget> makeBuyButtonWidget(BuildContext context,
    ProductVariation? productVariation,
    Product product,
    Map<String?, String?>? mapAttribute,
    int maxQuantity,
    int quantity,
    Function addToCart,
    Function onChangeQuantity,
    bool isAvailable,
  ) {
    final theme = Theme.of(context);

    // ignore: unnecessary_null_comparison
    var inStock = (productVariation != null
            ? productVariation.inStock
            : product.inStock) ??
        false;
    var allowBackorder = productVariation != null
        ? (productVariation.backordersAllowed ?? false)
        : product.backordersAllowed;

    final isExternal = product.type == 'external' ? true : false;
    final isVariationLoading =
        // ignore: unnecessary_null_comparison
        (product.isVariableProduct || product.type == 'configurable') &&
            productVariation == null &&
            (mapAttribute?.isEmpty ?? true);

    final buyOrOutOfStockButton = Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: isExternal
            ? ((inStock || allowBackorder) &&
                    (product.attributes!.length == mapAttribute!.length) &&
                    isAvailable)
                ? theme.primaryColor
                : theme.disabledColor
            : theme.primaryColor,
      ),
      child: Center(
        child: Text(
          ((((inStock || allowBackorder) && isAvailable) || isExternal) &&
                  !isVariationLoading
              ? S.of(context).buyNow
              : (isAvailable && !isVariationLoading
                      ? S.of(context).outOfStock
                      : isVariationLoading
                          ? S.of(context).loading
                          : S.of(context).unavailable)
                  .toUpperCase()),
          style: Theme.of(context).textTheme.button!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );

    if (!inStock && !isExternal && !allowBackorder) {
      return [
        buyOrOutOfStockButton,
      ];
    }

    if ((product.isPurchased) && (product.isDownloadable ?? false)) {
      return [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async => await Tools.launchURL(product.files![0]!),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                      child: Text(
                    S.of(context).download,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.white,
                        ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ];
    }

    return [
      if (!isExternal && kProductDetail.showStockQuantity) ...[
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).selectTheQuantity + ':',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Expanded(
              child: Container(
                height: 32.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: QuantitySelection(
                  height: 32.0,
                  expanded: true,
                  value: quantity,
                  color: theme.colorScheme.secondary,
                  limitSelectQuantity: maxQuantity,
                  onChanged: onChangeQuantity,
                ),
              ),
            ),
          ],
        ),
      ],
      const SizedBox(height: 10),

      /// Action Buttons: Buy Now, Add To Cart, Recent View Screen
      Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: (){
                isAvailable
                    ? () => addToCart(true, inStock || allowBackorder)
                    : null;
                setState(() {});
              },
              child: buyOrOutOfStockButton,
            ),
          ),
          const SizedBox(width: 10),
          if (isAvailable &&
              (inStock || allowBackorder) &&
              !isExternal &&
              !isVariationLoading)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  addToCart(false, inStock || allowBackorder);
                  setState(() {});
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Theme.of(context).primaryColorLight,
                  ),
                  child: Center(
                    child: Text(
                      S.of(context).addToCart.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      )
    ];
  }



  @override
  Widget build(BuildContext context) {
    /// use for Staged layout
    if (widget.hideDetail) {
      return ProductImage(
        width: widget.width!,
        product: widget.item,
        config: widget.config,
        ratioProductImage: widget.config.imageRatio,
        offset: widget.offset,
        onTapProduct: () => onTapProduct(context, product: widget.item),
      );
    }
    ///Product Info..
    Widget _productInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height:2),
        ProductTitle(
          product: widget.item,
          hide: widget.config.hideTitle,
          maxLines: widget.config.titleLine,
        ),
        StoreName(product: widget.item, hide: widget.config.hideStore),
        Align(
          alignment: Alignment.bottomLeft,
          child: Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ProductPricing(
                          product: widget.item,
                          hide: widget.config.hidePrice,
                        ),
                        const SizedBox(height: 2),
                        StockStatus(product: widget.item, config: widget.config),
                        ProductRating(
                          product: widget.item,
                          config: widget.config,
                        ),
                        SaleProgressBar(
                          width: widget.width,
                          product: widget.item,
                          show: widget.config.showCountDown,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
        CartQuantity(
          product: widget.item,
          config: widget.config,
          onChangeQuantity: (val) {
            setState(() {
              _quantity = val;
            });
          },
        ),
        if (widget.config.showCartButton && kEnableShoppingCart) ...[
          const SizedBox(height: 6),
          CartButton(
            product: widget.item,
            hide: !widget.item.canBeAddedToCartFromList(
            enableBottomAddToCart: widget.config.enableBottomAddToCart),
            enableBottomAddToCart: widget.config.enableBottomAddToCart,
            quantity: _quantity,
          ),
        ],
        ///add button
        if (!widget.config.showQuantity) ...[
                SizedBox(
                    width: double.infinity,
                    child: CartIcon(product: widget.item, config: widget.config)),
              ],
      ],
    );


    ///Recent Views data....
    return GestureDetector(
      onTap: () => onTapProduct(context, product: widget.item),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(right: 12,top: 8),
        child: Container(
          width: 160,
          height: 238,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 1.5,
                  offset: Offset(0.0, 1)
              )
            ],
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[

              ///1
               Container(
                height: 290,
                constraints: BoxConstraints(maxWidth: 160),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,

                    borderRadius: BorderRadius.circular(12)),
                 ///Product Detail
                child: Container(

                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.config.borderRadius ?? 3),
                    boxShadow: [
                      if (widget.config.boxShadow != null)
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(
                            widget.config.boxShadow?.x ?? 0.0,
                            widget.config.boxShadow?.y ?? 0.0,
                          ),
                          blurRadius: widget.config.boxShadow?.blurRadius ?? 0.0,
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.config.borderRadius ?? 3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ///product image
                        Stack(
                          children: [
                            ProductImage(
                              width: widget.width!,
                              product: widget.item,
                              config: widget.config,
                              ratioProductImage: widget.config.imageRatio,
                              offset: widget.offset,
                              onTapProduct: () => onTapProduct(context, product: widget.item),
                            ),
                            if (widget.config.showCartButtonWithQuantity && widget.item.canBeAddedToCartFromList(enableBottomAddToCart: widget.config.enableBottomAddToCart,))
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Selector<CartModel, int>(
                                    selector: (context, cartModel) => cartModel.productsInCart[widget.item.id!] ?? 0,
                                    builder: (context, quantity, child) {
                                      return CartButtonWithQuantity(
                                        quantity: quantity,
                                        borderRadiusValue: widget.config.cartIconRadius,
                                        increaseQuantityFunction: () {
                                          // final minQuantityNeedAdd =
                                          //     widget.item.getMinQuantity();
                                          // var quantityWillAdd = 1;
                                          // if (quantity == 0 &&
                                          //     minQuantityNeedAdd > 1) {
                                          //   quantityWillAdd = minQuantityNeedAdd;
                                          // }
                                          addToCart(context, quantity: 1, product: widget.item);
                                          setState(() {});
                                        },
                                        decreaseQuantityFunction: () =>
                                            updateQuantity(
                                          context: context,
                                          quantity: quantity - 1,
                                          product: widget.item,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0,right: 3.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: widget.config.hPadding,
                              vertical: widget.config.vPadding,
                            ),
                            child: _productInfo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ///2
              ProductOnSale(product: widget.item, config: widget.config),
              if (widget.config.showHeart && !widget.item.isEmptyProduct())
                Positioned(
                  top: widget.config.vMargin,
                  right: context.isRtl ? null : widget.config.hMargin,
                  left: context.isRtl ? widget.config.hMargin : null,
                  child: HeartButton(
                    product: widget.item,
                    size: 18,
                  ),
                ),

              ///3
              if (widget.onTapDelete != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Theme.of(context).primaryColor,
                    ),
                    onPressed: widget.onTapDelete,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
