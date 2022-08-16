import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fstore/screens/map/Home-delivery.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/config.dart' as config;

import '../../main.dart';
import 'store-pickup.dart';

class BaseDeliveryMode extends StatefulWidget {
  bool fromHome;
  BaseDeliveryMode({Key? key,this.fromHome=false}) : super(key: key);

  @override
  State<BaseDeliveryMode> createState() => _BaseDeliveryModeState();
}

class _BaseDeliveryModeState extends State<BaseDeliveryMode> with SingleTickerProviderStateMixin {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() {
              isAlertSet = true;
            });
          }
        },
      );







  late TabController _tabController;
  bool newLaunches=true;


  Future<bool>  loadNewLaunch() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      var _newLaunch = ((prefs.getBool('newLaunch') ?? true));
      newLaunches = _newLaunch;
    });
    return newLaunches;
  }

  // void _incrementCounter() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _counter = ((prefs.getBool('counter') ?? 0) + 1);
  //     prefs.setInt('counter', _counter);
  //   });
  // }




  showAlertDialog() {

    // set up the AlertDialog
    showDialog(
        context: context,
        barrierDismissible: false,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(

            //title: Text("My title"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadius.circular(40)
                  ),
                  child: Image.asset('assets/tab/alert.PNG'),
                ),
                const Padding(
                  padding: EdgeInsets.only(top:12.0,bottom: 12.0),
                  child: Text('Select A Delivery Mode',style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 12)),
                ),
                const Text('Drag the pin to your desired location or select the store pickup tab for In-store pickup',style:TextStyle(color:Colors.black,fontSize: 13)),
                TextButton(
                    onPressed:() async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('newLaunch', false);
                      Navigator.of(context).pop();
                    },
                    child:   const Text('OK, GOT IT',style: TextStyle(color: Colors.green))
                )
              ],
            ),


          );

        }


    ); }

  @override
  void initState() {
    getConnectivity();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async{
      // Add Your Code here.
      var  isPop =await loadNewLaunch();
      if(isPop){
        if(!widget.fromHome) {
          showAlertDialog();
        }
      }
    });
  }



  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  ///Alert Dialog on pop

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                Container(
                  height: 70,
                    width: double.infinity,
                    color:Colors.green.shade700,
                    alignment: Alignment.center,
                    child: const Text('Delivery Mode',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17))),
                const SizedBox(height: 10),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.green,
                      indicatorWeight: 3,
                      labelPadding: EdgeInsets.zero,
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          child: Container(
                            alignment: Alignment.center,
                            height: double.infinity,
                            decoration:  BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                right: BorderSide(color: Colors.grey.shade200),
                                top: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/deliverygreen.png',height: 20,width: 20),
                                SizedBox(width: 4),
                                Text('Home Delivery',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            alignment: Alignment.center,
                            height: double.infinity,
                            decoration:  BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade200),
                                right: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/pickupgreen.png',height: 19,width: 20,),
                                SizedBox(width: 4),
                                Text('Store Pickup',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children:  [
                        HomeDelivery(),
                        const StorePickup(),
                      ]),
                )
              ],
            )
        ),
      );
  }

  ///Dialog Box
  showDialogBox() {
    double w = MediaQuery
        .of(context)
        .size
        .width;
    double h = MediaQuery
        .of(context)
        .size
        .height;

    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(

              content: Container(
                width: double.maxFinite,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Container(),

                    Column(
                      children: [
                        Image.asset('assets/wifiicon.png'),
                        SizedBox(height: 25,),
                        Text('We can\'t detect an internet\nconnection',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,),
                            textAlign: TextAlign.center),
                        SizedBox(height: 5),
                        Text('Please check your connection and retry',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                      ],
                    ),


                  ],
                ),
              ),
              actions: [

                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context, 'Cancel');
                    setState(() async {
                      isAlertSet = false;
                      isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                      if (!isDeviceConnected) {
                        showDialogBox();
                        setState(() {
                          isAlertSet = true;
                        });
                      }
                    });
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green.shade700,fixedSize: Size(w, 50)),
                    onPressed: () async {
                      isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;

                      if (isDeviceConnected) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Retry',style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,),

                    ),
                  ),
                ),
              ],
            ));
  }

}
