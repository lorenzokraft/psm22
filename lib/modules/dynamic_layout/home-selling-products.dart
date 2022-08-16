import 'package:flutter/material.dart';
import 'package:fstore/models/entities/index.dart';
import 'package:fstore/services/services.dart';
import 'package:fstore/widgets/product/product_simple_view.dart';

class HomeSellingProducts extends StatefulWidget {
  const HomeSellingProducts({Key? key}) : super(key: key);

  @override
  State<HomeSellingProducts> createState() => _HomeSellingProductsState();
}

class _HomeSellingProductsState extends State<HomeSellingProducts> {

  Future<List<Product>?> getProductsByCategoryId() async {
    try {
      //  var bannerItems = widget.config.items;
      // var item = bannerItems[indexSelected!];
      return await Services().api.fetchProductsByCategory(
        categoryId: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTM2NTEyOTQ1OA==',
        page: 1,
      );
    } catch (e) {
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>?>(
      future: getProductsByCategoryId(),
      builder: (context, snapshot) {
        var length = snapshot.data?.length ?? 0;
        if (snapshot.hasData) {

          return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: length,
              padding: EdgeInsets.zero,
              itemBuilder: (context,index){
                ///Best Sellers Data
                return ProductSimpleView(
                  item: snapshot.data![index],
                  type: SimpleType.backgroundColor,
                  enableBackgroundColor: false,
                );
              });
        }
        ///its nt changing anything
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding:EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: length,
            itemBuilder: (context,index){
              return Container();


              // return ProductSimpleView(
              //     item: Product.empty(index.toString()),
              //     type: SimpleType.backgroundColor,
              //     enableBackgroundColor: false);
            });
      },
    );
  }
}
