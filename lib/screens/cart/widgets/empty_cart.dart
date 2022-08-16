import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../generated/l10n.dart';

class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.green.shade700,
      ),
    );

    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: screenSize.width / (2 / (screenSize.height / screenSize.width)),
          child: Stack(
            children: <Widget>[
              // Positioned(
              //   top: 0,
              //   right: 0,
              //   child: Image.asset(
              //     'assets/images/leaves.png',
              //     width: 120,
              //     height: 120,
              //   ),
              // ),
              Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  const Text('Your cart is empty', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text('Below are few top trending search items for you to explore', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 10),
                  Image.asset('assets/emptycart.png',height:60,width:60),
                  const SizedBox(height: 10),
                  const Text('Top trending search',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22), textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top:12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        trendingSearch('deals',context),
                        const SizedBox(width: 10),
                        trendingSearch('splash-sales',context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        trendingSearch('Bakery',context),
                        const SizedBox(width: 10),
                        trendingSearch('Cupboard Food',context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        trendingSearch('Dairy',context),
                        const SizedBox(width: 10),
                        trendingSearch('Frozen Foods',context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        trendingSearch('Groceries',context),
                        const SizedBox(width: 10),
                        trendingSearch('Herbals',context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        trendingSearch('Liquid & Beverages',context),
                        const SizedBox(width: 10),
                        trendingSearch('Fruits & Vegetables',context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        trendingSearch('Meat',context),
                        const SizedBox(width: 10),
                        trendingSearch('Beauty & Hygiene',context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        trendingSearch('Traditional Items',context),
                        const SizedBox(width: 10),
                        trendingSearch('House Hold',context),
                      ],
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget trendingSearch(String title,context){
  return Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width/2.4,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color:Colors.grey)
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
      child: Text(title,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
    ),
  );
}
