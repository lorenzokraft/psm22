import 'package:flutter/material.dart';

import '../../../common/config.dart';
import '../../../models/entities/product.dart';
import '../../../modules/dynamic_layout/config/product_config.dart';
import '../action_button_mixin.dart';

class CartIcon extends StatelessWidget with ActionButtonMixin {
  final Product product;
  final ProductConfig config;
  final int quantity;

  const CartIcon({
    Key? key,
    required this.product,
    required this.config,
    this.quantity = 1,
  }) : super(key: key);

  void _addToCart(context, enableBottomSheet) {
    addToCart(
      context,
      product: product,
      quantity: quantity,
      enableBottomAddToCart: enableBottomSheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!config.showCartIcon ||
        product.isEmptyProduct() ||
        !kEnableShoppingCart) {
      return const SizedBox();
    }

    var enableBottomSheet =
        config.enableBottomAddToCart ? true : !product.canBeAddedToCartFromList();

    if (config.showCartIconColor) {
      return Container(
        height: 36.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(config.cartIconRadius),
          color: Theme.of(context).primaryColor,
        ),
        child: SizedBox(
          height: 20,
           width: double.infinity,
           child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                 primary: Colors.red, //background color of button
                 elevation: 0,
                 padding: EdgeInsets.zero,//elevation of button
                 shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(4)
                      ),
                ),
               onPressed: (){
                _addToCart(context, enableBottomSheet);
               }, child: const Text('ADD',style: TextStyle(color: Colors.white))),
         )
      );
    }
    return SizedBox(
            height: 35,
           width: double.infinity,
           child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                 primary:  Colors.red, //background color of button
                 elevation: 0,
                 padding: EdgeInsets.zero,//elevation of button
                 shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(4)
                      ),
                ),
               onPressed: (){
                _addToCart(context, enableBottomSheet);
               }, child: const Text('ADD',style:TextStyle(color: Colors.white))),
         );
  }
}
