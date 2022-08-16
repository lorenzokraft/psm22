import 'package:flutter/material.dart';
import 'package:fstore/common/constants.dart';
import 'package:fstore/models/entities/back_drop_arguments.dart';
import 'package:fstore/modules/dynamic_layout/home-selling-products.dart';
import 'package:fstore/routes/flux_navigate.dart';
import 'package:fstore/screens/map/Base-delivery-mode.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fstore/screens/map/Home-delivery.dart';

class HouseHoldItems extends StatefulWidget {
  const HouseHoldItems({Key? key}) : super(key: key);

  @override
  State<HouseHoldItems> createState() => _HouseHoldItemsState();
}

class _HouseHoldItemsState extends State<HouseHoldItems> {
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
                padding: const EdgeInsets.only(left:10.0,top:20.0,bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [
                    Text('HouseHold Items',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green.shade700)),
                  ],
                ),
              ),

              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 2.4),
                  itemCount: subCategories.length,
                  itemBuilder: (context,index){
                    return   Padding(
                      padding: const EdgeInsets.only(left:4.0,right: 4.0,bottom: 4.0),
                      child: foodItemContainer(context,subCategories[index].subCategories,(){
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:  subCategories[index].id,
                            cateName:  subCategories[index].subCategories,
                          ),
                        );

                      }),
                    );
                  }),

              // Padding(
              //   padding: const EdgeInsets.only(left:4.0,right: 4.0,bottom: 4.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       foodItemContainer(context,'Bakery',(){
              //         FluxNavigate.pushNamed(
              //           RouteList.backdrop,
              //           arguments: BackDropArguments(
              //             cateId:  'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MTA5NDY0Mg==',
              //             cateName:  'Bakery',
              //           ),
              //         );
              //
              //       }),
              //
              //       foodItemContainer(context,'Beverages',(){
              //         FluxNavigate.pushNamed(
              //           RouteList.backdrop,
              //           arguments: BackDropArguments(
              //             cateId:  'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTg4MjIyNg==',
              //             cateName:  'Beverages',
              //           ),
              //         );
              //
              //
              //       }),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left:4.0,right: 4.0,bottom: 4.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       foodItemContainer(context,'Food Cupboard ',(){
              //         FluxNavigate.pushNamed(
              //           RouteList.backdrop,
              //           arguments: BackDropArguments(
              //             cateId:  'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTIyNjg2Ng==',
              //             cateName:  'Food Cupboard',
              //           ),
              //         );
              //       }),
              //       foodItemContainer(context,'Fresh Food ',(){
              //         FluxNavigate.pushNamed(
              //           RouteList.backdrop,
              //           arguments: BackDropArguments(
              //             cateId:  'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzNzk0ODkxNA==',
              //             cateName:  'Fresh Food',
              //           ),
              //         );
              //       }),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left:4.0,right: 4.0,bottom: 4.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       foodItemContainer(context,'Frozen Foods ',(){
              //         FluxNavigate.pushNamed(
              //           RouteList.backdrop,
              //           arguments: BackDropArguments(
              //             cateId:  'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDU3MDM1NA==',
              //             cateName:  'Frozen Foods',
              //           ),
              //         );
              //       }),
              //       foodItemContainer(context,'Fruits & Vegetables',(){
              //         FluxNavigate.pushNamed(
              //           RouteList.backdrop,
              //           arguments: BackDropArguments(
              //             cateId:  'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODQ0MDQzNA==',
              //             cateName:  'Fruit & Vegetables',
              //           ),
              //         );
              //       }),
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
                    Text('Top Selling Products',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
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
          color: const Color(0xffb0efe7),
          borderRadius: BorderRadius.circular(12)
      ),
      width: MediaQuery.of(context).size.width/2.1,
      alignment: Alignment.center,
      child:  Text(text,textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
    ),
  );


}



class SubCategory{
  String title;
  String subCategories;
  Icon icon;
  String id;
  SubCategory({this.id='',this.title='',this.subCategories='',required this.icon});
}

List<SubCategory>  subCategories=[
SubCategory(title: 'House Hold Items', subCategories: 'Air Freshners',id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTIzNTU3MA==',icon: const Icon(Icons.arrow_drop_down)),
SubCategory(title: 'House Hold Items', subCategories: 'Accessories',id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTMwMTEwNg==',icon: const Icon(Icons.arrow_drop_down)),
SubCategory(title: 'House Hold Items', subCategories: 'Cleaning',id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTMzMzg3NA==',icon: const Icon(Icons.arrow_drop_down)),
SubCategory(title: 'House Hold Items', subCategories: 'Crockery',id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTM5OTQxMA==',icon: const Icon(Icons.arrow_drop_down)),
SubCategory(title: 'House Hold Items', subCategories: 'General',id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTQzMjE3OA==',icon: const Icon(Icons.arrow_drop_down)),
];