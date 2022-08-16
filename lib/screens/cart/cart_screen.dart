import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/cart/cart_base.dart';
import '../../widgets/common/loading_body.dart';
import '../common/app_bar_mixin.dart';
import 'my_cart_screen.dart';

class CartScreenArgument {
  final bool isModal;
  final bool isBuyNow;

  CartScreenArgument({
    required this.isModal,
    required this.isBuyNow,
  });
}

class CartScreen extends StatefulWidget {
  final bool? isModal;
  final bool isBuyNow;

  const CartScreen({this.isModal, this.isBuyNow = false});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with AppBarMixin {
  @override






  Widget build(BuildContext context) {
    setState(() {});
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.green.shade700,
      ),
    );
    return Scaffold(
      appBar: showAppBar(RouteList.cart) ? appBarWidget : null,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Selector<CartModel, bool>(
        selector: (_, cartModel) => cartModel.calculatingDiscount,
        builder: (context, calculatingDiscount, child) {
          return LoadingBody(
            isLoading: calculatingDiscount,
            child: child!,
          );
        },
        child: MyCart(
          isBuyNow: widget.isBuyNow,
          isModal: widget.isModal,
        ),
      ),
    );
  }
}
