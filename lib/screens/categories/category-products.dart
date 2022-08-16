import 'package:flutter/material.dart';
import 'package:fstore/models/entities/product.dart';
import 'package:fstore/services/services.dart';
import 'package:fstore/widgets/product/product_simple_view.dart';

class CategoriesProducts extends StatefulWidget {
  const CategoriesProducts({Key? key}) : super(key: key);

  @override
  _CategoriesProductsState createState() => _CategoriesProductsState();
}

class _CategoriesProductsState extends State<CategoriesProducts> {


  Future<Product?> getProductById(String id) async {
    try {
      return await Services().api.getProduct(id);
    } catch (e) {
      return null;
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Product?>(
          future: getProductById('Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTIyNzUzNjYyNg=='),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ProductSimpleView(
                item: snapshot.data,
                type: SimpleType.backgroundColor,
                enableBackgroundColor: false,
              );
            }
            return ProductSimpleView(
              item: Product.empty(''),
              type: SimpleType.backgroundColor,
              enableBackgroundColor: false,
            );
          })
    );
  }
}
