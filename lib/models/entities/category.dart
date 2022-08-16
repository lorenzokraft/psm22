import 'package:html_unescape/html_unescape.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../services/service_config.dart';
import '../serializers/product_category.dart';
import 'product.dart';

class Category {
  String? id;
  String? sku;
  String? name;
  String? image;
  String? parent;
  String? slug;
  int? totalProduct;
  List<Product>? products;
  bool hasChildren = false;
  List<Category> subCategories = [];

  Category.fromListingJson(Map<String, dynamic>? parsedJson) {
    try {
      id = Tools.getValueByKey(
              parsedJson, DataMapping().kCategoryDataMapping['id'])
          .toString();
      name = HtmlUnescape().convert(Tools.getValueByKey(
          parsedJson, DataMapping().kCategoryDataMapping['name']));
      parent = Tools.getValueByKey(
              parsedJson, DataMapping().kCategoryDataMapping['parent'])
          .toString();
      totalProduct = int.parse(Tools.getValueByKey(
              parsedJson, DataMapping().kCategoryDataMapping['count'])
          .toString());
      var termImage = Tools.getValueByKey(
          parsedJson, DataMapping().kCategoryDataMapping['image']);
      if (termImage is String) {
        image = termImage;
      }
      if (image == null) {
        if (DataMapping().kCategoryImages[id!] != null) {
          image = DataMapping().kCategoryImages[id!];
        } else {
          image = kDefaultImage;
        }
      }
    } catch (err) {
      rethrow;
    }
  }

  Category.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson['slug'] == 'uncategorized') {
      return;
    }

    try {
      id = parsedJson['id']?.toString() ?? parsedJson['term_id'].toString();
      name = HtmlUnescape().convert(parsedJson['name']);
      parent = parsedJson['parent'].toString();
      totalProduct = parsedJson['count'];
      slug = parsedJson['slug'];
      final image = parsedJson['image'];
      if (image != null) {
        this.image = image['src'].toString();
      } else {
        this.image = kDefaultImage;
      }
      hasChildren = parsedJson['has_children'] ?? false;
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'parent': parent,
        'image': {'src': image}
      };

  Category.fromOpencartJson(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson['id'] ?? '0';
      name = HtmlUnescape().convert(parsedJson['name']);
      image = parsedJson['image'] ?? kDefaultImage;
      totalProduct = parsedJson['count'] != null
          ? int.parse(parsedJson['count'].toString())
          : 0;
      parent =
          parsedJson['parent'] != null ? parsedJson['parent'].toString() : '0';
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Category.fromMagentoJson(Map<String, dynamic> parsedJson) {
    try {
      id = '${parsedJson['id']}';
      name = parsedJson['name'];
      image = parsedJson['image'] ?? kDefaultImage;
      parent = '${parsedJson['parent_id']}';
      totalProduct = parsedJson['product_count'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Category.fromJsonShopify(Map<String, dynamic> parsedJson) {
    // printLog('fromJsonShopify id $parsedJson');

    if (parsedJson['slug'] == 'uncategorized') {
      return;
    }

    try {
      id = parsedJson['id'];
      sku = parsedJson['id'];
      name = parsedJson['title'];
      parent = '0';

      final image = parsedJson['image'];
      if (image != null) {
        this.image = image['src'].toString();
      } else {
        this.image = kDefaultImage;
      }
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Category.fromJsonPresta(Map<String, dynamic> parsedJson, apiLink) {
    try {
      id = parsedJson['id'].toString();
      name = HtmlUnescape().convert(parsedJson['name']);
      parent = parsedJson['id_parent'];
      image = apiLink('images/categories/$id');
      totalProduct = parsedJson['nb_products_recursive'] != null
          ? int.parse(parsedJson['nb_products_recursive'].toString())
          : null;
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Category.fromJsonStrapi(Map<String, dynamic> parsedJson, Function apiLink) {
    try {
      var model = SerializerProductCategory.fromJson(parsedJson);
      id = model.id.toString();
      name = model.name;
      parent = '0';
      totalProduct = model.products!.length;

      products = [];
      for (var product in model.products!) {
        var newProduct = Product.fromJsonStrapi(product, apiLink);
        products!.add(newProduct);
      }

      if (model.featureImage != null) {
        image = apiLink(model.featureImage!.url);
      } else {
        image = kDefaultImage;
      }
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Category.fromWordPress(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'].toString();
    name = parsedJson['name'];
    parent = parsedJson['parent'].toString();
    totalProduct = parsedJson['count'];
    if (kCategoryStaticImages!.isNotEmpty) {
      /// prioritize local category images over remote ones
      image = kCategoryStaticImages![parsedJson['id']] ?? kDefaultImage;
    } else {
      /// "Organize my uploads into month- and year-based folders" must be unchecked
      /// at CMS DashBoard > Settings > Media
      /// Automatically get category image by following common format:
      /// https://customer-site.com/wp-content/uploads/category-{category-id}.jpeg
      image = '${Config().url}/wp-content/uploads/category-$id.jpeg';
    }
  }
  // final image = parsedJson['image'];
  // if (image != null) {
  //   this.image = image['src'].toString();
  // } else {
  //   this.image = kCategoryStaticImages[parsedJson['id']] ?? kDefaultImage;
  // }

  Category.fromNotion(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson['id'] ?? '';
      final properties = parsedJson['properties'];

      if (properties == null) {
        throw Exception('Something went wrong!');
      }
      name = NotionDataTools.fromTitle(properties['Name']);
      final dataParent =
          NotionDataTools.fromRelation(properties['Parent']) ?? ['0'];
      parent = dataParent.isNotEmpty ? dataParent.first : '0';

      totalProduct =
          (NotionDataTools.fromNumber(properties['Count']) ?? 0) as int;
      final getImage = NotionDataTools.fromFile(properties['Image']);

      final slugData = NotionDataTools.fromRichText(properties['Slug']);

      if (slugData?.isNotEmpty ?? false) {
        slug = slugData!.first;
      }

      if (getImage != null && getImage.isNotEmpty) {
        image = getImage.first;
      } else {
        image = kDefaultImage;
      }

      printLog(this);
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  @override
  String toString() => 'Category { id: $id  name: $name}';
}
