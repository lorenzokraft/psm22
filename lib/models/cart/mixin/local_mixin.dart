import 'package:localstorage/localstorage.dart';

import '../../../common/constants.dart';
import '../../../services/index.dart';
import '../../index.dart';
import 'cart_mixin.dart';

/// Everything relate to Local storage
mixin LocalMixin on CartMixin {
  Future<void> saveCartToLocal(
      {Product? product,
      int? quantity = 1,
      ProductVariation? variation,
      Map<String, dynamic>? options}) async {
    final storage = injector<LocalStorage>();
    try {
      List? items = await storage.getItem(kLocalKey['cart']!);
      if (items != null && items.isNotEmpty) {
        items.add({
          'product': product!.toJson(),
          'quantity': quantity,
          'variation': variation != null ? variation.toJson() : 'null',
          'options': options
        });
      } else {
        items = [
          {
            'product': product!.toJson(),
            'quantity': quantity,
            'variation': variation != null ? variation.toJson() : 'null',
            'options': options
          }
        ];
      }
      await storage.setItem(kLocalKey['cart']!, items);
    } catch (err) {
      printLog('[saveCartToLocal] failed: $err');
    }
  }

  Future<void> updateQuantityCartLocal({String? key, int quantity = 1}) async {
    final storage = injector<LocalStorage>();
    try {
      List? items = await storage.getItem(kLocalKey['cart']!);
      var results = [];
      if (items != null && items.isNotEmpty) {
        for (var item in items) {
          final product = Product.fromLocalJson(item['product']);
          final ids = key!.split('-');
          var variant = '${item['variation']}' != 'null'
              ? ProductVariation.fromLocalJson(item['variation'])
              : null;
          if ((product.id == ids[0].toString() && ids.length == 1) ||
              (variant != null &&
                  product.id == ids[0].toString() &&
                  // ignore: unrelated_type_equality_checks
                  variant.id == ids[1])) {
            results.add(
              {
                'product': product.toJson(),
                'quantity': quantity,
                'variation': variant,
                'options': item['options']
              },
            );
          } else {
            results.add(item);
          }
        }
      }
      await storage.setItem(kLocalKey['cart']!, results);
    } catch (err) {
      printLog(err);
    }
  }

  Future<void> clearCartLocal() async {
    final storage = injector<LocalStorage>();
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.deleteItem(kLocalKey['cart']!);
      }
    } catch (err) {
      printLog(err);
    }
  }

  Future<void> removeProductLocal(String key) async {
    final storage = injector<LocalStorage>();
    try {
      List? items = await storage.getItem(kLocalKey['cart']!);
      if (items != null && items.isNotEmpty) {
        final ids = key.split('-');
        var newItems = [];
        for (var item in items) {
          if (Product.fromLocalJson(item['product']).id != ids[0]) {
            newItems.add(item);
          }
        }
        await storage.setItem(kLocalKey['cart']!, newItems);
      }
    } catch (err) {
      printLog(err);
    }
  }

  Future<void> getCartInLocal() async {
    if (Config().isVendorManagerType()) {
      return;
    }
    final storage = injector<LocalStorage>();
    try {
      List? items = await storage.getItem(kLocalKey['cart']!);
      if (items != null && items.isNotEmpty) {
        for (final item in items) {
          addProductToCart(
            product: Product.fromLocalJson(item['product']),
            quantity: item['quantity'],
            variation: item['variation'] != 'null'
                ? ProductVariation.fromLocalJson(item['variation'])
                : null,
            options: item['options'],
            isSaveLocal: false,
            notify: () {},
          );
        }
      }
    } catch (err) {
      printLog('::::::::: Get Cart In Local Error: $err');
    }
  }

  // Adds a product to the cart.
  String addProductToCart({
    required Product product,
    int? quantity = 1,
    ProductVariation? variation,
    Map<String, dynamic>? options,
    required Function notify,
    isSaveLocal = true,
  }) {
    var message = '';

    var key = product.id.toString();
    if (variation != null) {
      if (variation.id != null) {
        key += '-${variation.id}';
      }
      if (options != null) {
        for (var option in options.keys) {
          key += '-' + option + options[option];
        }
      }
    }

    //Check product's quantity before adding to cart
    var total = !productsInCart.containsKey(key)
        ? quantity
        : (productsInCart[key]! + quantity!);
    var stockQuantity =
        variation == null ? product.stockQuantity : variation.stockQuantity;
//    printLog('stock is here');
//    printLog(product.manageStock);

    if (!product.manageStock) {
      productsInCart[key] = total;
    } else if (total! <= stockQuantity!) {
      if (product.minQuantity == null && product.maxQuantity == null) {
        productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity == null) {
        total < product.minQuantity!
            ? message = 'Minimum quantity is ${product.minQuantity}'
            : productsInCart[key] = total;
      } else if (product.minQuantity == null && product.maxQuantity != null) {
        total > product.maxQuantity!
            ? message =
                'You can only purchase ${product.maxQuantity} for this product'
            : productsInCart[key] = total;
      } else if (product.minQuantity != null && product.maxQuantity != null) {
        if (total >= product.minQuantity! && total <= product.maxQuantity!) {
          productsInCart[key] = total;
        } else {
          if (total < product.minQuantity!) {
            message = 'Minimum quantity is ${product.minQuantity}';
          }
          if (total > product.maxQuantity!) {
            message =
                'You can only purchase ${product.maxQuantity} for this product';
          }
        }
      }
    } else {
      message = 'Currently we only have $stockQuantity of this product';
    }

    if (message.isEmpty) {
      item[product.id] = product;
      productVariationInCart[key] = variation;
      productsMetaDataInCart[key] = options;

      if (isSaveLocal) {
        saveCartToLocal(
            product: product,
            quantity: quantity,
            variation: variation,
            options: options);
      }
    }

    notify();
    return message;
  }
}
