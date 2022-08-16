import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/entities/product.dart';
import '../action_button_mixin.dart';

class CartButton extends StatefulWidget with ActionButtonMixin {
  final Product product;
  final bool hide;
  final int quantity;
  final bool enableBottomAddToCart;

  const CartButton({
    Key? key,
    required this.product,
    required this.hide,
    this.enableBottomAddToCart = false,
    this.quantity = 1,
  }) : super(key: key);

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.hide) return const SizedBox();

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        onSurface: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      onPressed: () {
        widget.addToCart(
          context,
          product: widget.product,
          quantity: widget.quantity,
          enableBottomAddToCart: widget.enableBottomAddToCart,
        );
        setState(() {});
      },
      child: Text(S.of(context).addToCart, style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white,),
      ),
    );
  }
}
