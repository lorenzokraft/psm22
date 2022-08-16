import 'package:flutter/material.dart';
import 'package:fstore/screens/map/Base-delivery-mode.dart';
import 'package:fstore/screens/map/Home-delivery.dart';
import 'package:webview_flutter_web/shims/dart_ui_real.dart';

import '../common/constants.dart';

class BuyAgainPage extends StatefulWidget {
  const BuyAgainPage({Key? key}) : super(key: key);

  @override
  _BuyAgainPageState createState() => _BuyAgainPageState();
}

class _BuyAgainPageState extends State<BuyAgainPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.green.shade700,
       elevation: 0.0,
       iconTheme: const IconThemeData(
         color: Colors.white, //change your color here
       ),
       title: const Text('Buy Again',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
     ),
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context , rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => BaseDeliveryMode(fromHome: true)));
            },
            child:  Container(
              height: 50,
              color: Colors.green.shade900,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Row(
                        children:  [
                          const Icon(Icons.location_on_rounded,color: Colors.white),
                          const SizedBox(width: 5),
                          Container(
                              width: 250,
                              child: Text(address,style: const TextStyle(color: Colors.white,fontSize: 10))),
                        ],
                      ),
                      const Text('CHANGE',style: TextStyle(color:Colors.white))
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height/3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height:60,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                    color: const Color(0xfffff7ef),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: const Icon(Icons.wallet_giftcard_rounded,color: Colors.brown,size: 30)),

                const Text('Buy your favourite \n products again easily!',textAlign: TextAlign.center, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20 )),
                const Text('Continue to log in to see your \n past purchased items',textAlign: TextAlign.center, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15 )),
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                      onPressed:(){
                        Navigator.of(context , rootNavigator: true).pushReplacementNamed(RouteList.authentication);
                      } ,
                      child: const Text('LOG IN TO CONTINUE',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top:30.0,bottom: 20.0),
            child: Divider(),
          ),

        ],
      ),
    );
  }
}
