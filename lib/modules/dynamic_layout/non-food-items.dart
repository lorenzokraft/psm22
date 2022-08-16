import 'package:flutter/material.dart';
import 'package:fstore/common/constants.dart';
import 'package:fstore/models/entities/back_drop_arguments.dart';
import 'package:fstore/modules/dynamic_layout/home-selling-products.dart';
import 'package:fstore/routes/flux_navigate.dart';
import 'package:fstore/screens/map/Base-delivery-mode.dart';
import 'package:fstore/screens/map/Home-delivery.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NonFoodItems extends StatefulWidget {
  const NonFoodItems({Key? key}) : super(key: key);

  @override
  _NonFoodItemsState createState() => _NonFoodItemsState();
}

class _NonFoodItemsState extends State<NonFoodItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  color: Colors.green.shade700,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top:16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, icon: const Icon(Icons.arrow_back,color: Colors.white)),
                        Container()
                      ],
                    ),
                  )),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pushNamed(RouteList.homeSearch);
                },
                child: Container(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:4.0,bottom: 4.0),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width*0.93,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0XFFF0F0F0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(Icons.search,size: 22),
                                ),
                                SizedBox(width: 10),
                                Text('What are you looking for?',
                                  style: TextStyle(color: Colors.grey.shade500,fontSize: 15),),
                              ],),


                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context , rootNavigator: true).pushReplacement(
                      MaterialPageRoute(builder: (context) => BaseDeliveryMode(fromHome: true)));
                },
                child: Container(
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
              Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(0.0, 4.5)
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Center(child: const Text('Get Free delivery on orders worth AED 100 & above'))),

              Padding(
                padding: const EdgeInsets.only(left:10.0,top:20.0,bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [
                    Text('Non Food Items',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green.shade700)),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left:4.0,right: 4.0,bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    foodItemContainer(context,'Traditional Items ',(){
                      FluxNavigate.pushNamed(
                        RouteList.backdrop,
                        arguments: BackDropArguments(
                          cateId:  'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MTU1MzM5NA==',
                          cateName:  'Traditional Items',
                        ),
                      );

                    }),

                    foodItemContainer(context,'Household Items ',(){
                      FluxNavigate.pushNamed(
                        RouteList.backdrop,
                        arguments: BackDropArguments(
                          cateId:  'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MTYxODkzMA==',
                          cateName:  'Household Items',
                        ),
                      );


                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:4.0,right: 4.0,bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    foodItemContainer(context,'Beauty & Hygiene',(){
                      FluxNavigate.pushNamed(
                        RouteList.backdrop,
                        arguments: BackDropArguments(
                          cateId:  'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MTU4NjE2Mg==',
                          cateName:  'beauty & Hygiene',
                        ),
                      );
                    }),
                    // foodItemContainer(context,'Frozen Foods',(){}),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left:4.0,right: 4.0,bottom: 4.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       foodItemContainer(context,'Groceries',(){}),
              //       foodItemContainer(context,'Herbals',(){}),
              //     ],
              //   ),
              // ),
              //
              // Padding(
              //   padding: const EdgeInsets.only(left:10.0,top:20.0,bottom: 10.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: const [
              //       Text('Our Top Selling Products',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left:10.0,top:20.0,bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Top Selling Items',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(
                  height: 271,
                  child:  HomeSellingProducts())
            ],
          ),
        )
    );
  }
}
Widget foodItemContainer(BuildContext context,String text,Function()? onTap){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 70,
      decoration: BoxDecoration(
          color: Color(0xffb0efe7),
          borderRadius: BorderRadius.circular(12)
      ),
      width: MediaQuery.of(context).size.width/2.1,
      alignment: Alignment.center,
      child:  Text(text,style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}