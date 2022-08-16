import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show Order, UserModel, PointModel;
import '../../../modules/dynamic_layout/dynamic_layout.dart';
import '../../../services/index.dart';
import '../../base_screen.dart';

class OrderedSuccess extends StatefulWidget {
  final Order? order;

  const OrderedSuccess({this.order});

  @override
  _OrderedSuccessState createState() => _OrderedSuccessState();
}

class _OrderedSuccessState extends BaseScreen<OrderedSuccess> {
  @override
  void afterFirstLayout(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false).user;
    if (user != null &&
        user.cookie != null &&
        kAdvanceConfig['EnablePointReward']) {
      Services().api.updatePoints(user.cookie, widget.order);
      Provider.of<PointModel>(context, listen: false).getMyPoint(user.cookie);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return ListView(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        // Container(
        //   margin: const EdgeInsets.only(top: 20),
        //   decoration: BoxDecoration(color: Theme.of(context).primaryColorLight),
        //   child: Padding(
        //     padding: const EdgeInsets.all(15.0),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         Text(
        //           S.of(context).itsOrdered,
        //           style: TextStyle(
        //               fontSize: 16,
        //               color: Theme.of(context).colorScheme.secondary),
        //         ),
        //         const SizedBox(height: 5),
        //         if (widget.order?.number != null)
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: <Widget>[
        //               Text(
        //                 S.of(context).orderNo,
        //                 style: TextStyle(
        //                     fontSize: 14,
        //                     color: Theme.of(context).colorScheme.secondary),
        //               ),
        //               const SizedBox(width: 5),
        //               Expanded(
        //                 child: Text(
        //                   '#${widget.order!.number}',
        //                   style: TextStyle(
        //                       fontSize: 14,
        //                       color: Theme.of(context).colorScheme.secondary),
        //                 ),
        //               )
        //             ],
        //           )
        //       ],
        //     ),
        //   ),
        // ),


        const SizedBox(height: 30),
         Center(
           child: Text(
            'Thank You for shopping with us',
            style: TextStyle(
                fontSize: 17, color:Colors.green,fontWeight: FontWeight.bold),
        ),
         ),
        const SizedBox(height: 10),
         Center(
           child: Text('Your order is on the way!',
            style: TextStyle(color: Colors.green, fontSize: 15,fontWeight: FontWeight.bold),
        ),
         ),
        Image.asset('assets/delivery-van.gif'),

        if (userModel.user != null)
          Row(children: [
            Expanded(
              child: ButtonTheme(
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    final user =
                        Provider.of<UserModel>(context, listen: false).user;
                    Navigator.of(context).pushNamed(
                      RouteList.orders,
                      arguments: user,
                    );
                  },
                  child: Text(
                    S.of(context).viewOrderStatus.toUpperCase(),
                  ),
                ),
              ),
            ),
          ]),
        // const SizedBox(height: 40),
        // Text(
        //   S.of(context).orderSuccessTitle2,
        //   style: TextStyle(
        //       fontSize: 18, color: Theme.of(context).colorScheme.secondary),
        // ),
        // const SizedBox(height: 10),
        // Text(
        //   S.of(context).orderSuccessMsg2,
        //   style: TextStyle(
        //       color: Theme.of(context).colorScheme.secondary,
        //       height: 1.4,
        //       fontSize: 14),
        // ),


        ///Button Back to Shop
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: ButtonTheme(
                  height: 30,
                  //45
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () {

                      //Navigator.of(context).popUntil((route) => route.isFirst);

                     Navigator.pop(context, MaterialPageRoute(builder: (context)=> DynamicLayout()));

                    },
                    child: Text(
                      S.of(context).backToShop.toUpperCase(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
