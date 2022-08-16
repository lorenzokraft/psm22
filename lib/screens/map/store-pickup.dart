import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fstore/common/constants.dart';
import 'package:fstore/screens/map/Home-delivery.dart';

class StorePickup extends StatefulWidget {
  const StorePickup({Key? key}) : super(key: key);

  @override
  State<StorePickup> createState() => _StorePickupState();
}

class _StorePickupState extends State<StorePickup> {


  List<String> storeList=[
    'Al Karama Branch',
    'Al Barsha Branch',
  ];

  alertDialogPop1() {
    // set up the AlertDialog
    showDialog(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.green.shade200,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Store Address',
                        style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 13)),
                    IconButton(
                      onPressed: (){
                      Navigator.pop(context);  },
                      icon: Icon(Icons.cancel),),
                  ],
                ),
                SizedBox(height: 15),

                Text('Al Barsha 1 - Al Barsha,',
                    style:TextStyle(color:Colors.black,fontSize: 15)),
                SizedBox(height: 10),
                Text('Barsha 1 - Dubai',
                    style:TextStyle(color:Colors.black,fontSize: 15)),
              ],
            ),


          );

        }


    ); }

  alertDialogPop2() {
    // set up the AlertDialog
    showDialog(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.green.shade200,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Store Address',
                        style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 13)),
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);  },
                      icon: Icon(Icons.cancel),),
                  ],
                ),
                SizedBox(height: 15),

                Text('Al Karama 1 - Al Karama,',
                    style:TextStyle(color:Colors.black,fontSize: 15)),
                SizedBox(height: 10),
                Text('Karama 1 - Dubai',
                    style:TextStyle(color:Colors.black,fontSize: 15)),
              ],
            ),


          );

        }


    ); }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:const BouncingScrollPhysics(),
      child: Column(
        children: [
          Column(
            children: storeList.map((e) => Column(
              children: [
                ListTile(
                  onTap: () async {
                    address = e;
                    await Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteList.dashboard, (Route<dynamic> route) => true);
                  },
                  title: Row(
                    children: [
                      Text(e),
                      IconButton(
                          onPressed: (){
                            return e == "Al Karama Branch"?alertDialogPop2():alertDialogPop1();
                          },
                          icon: Icon(Icons.info,color: Colors.green.shade700,)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,color: Colors.green,),
                ),
                 Divider(color: Colors.grey.shade200)
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}
