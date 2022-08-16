import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';

import '../../../common/config.dart';
import '../helper/helper.dart';
import 'box_shadow_config.dart';

/// category : '57'
/// name : 'Woman Collections'
/// layout : 'threeColumn'
/// isSnapping : true

enum CardDesign { card, glass }

class ProductConfig {
  String? category;
  String? tag;
  String? image;
  String? name;
  String? layout;
  bool? isSnapping;
  double? height;
  double? imageWidth;
  double? borderRadius;
  double hMargin = 6.0;
  double vMargin = 0;
  double hPadding = 0;
  double vPadding = 0;
  dynamic jsonData;
  BoxShadowConfig? boxShadow;
  String? backgroundImage;
  num? spaceWidth;
  EdgeInsets? paddingBGP;
  num? backgroundHeight;
  num? backgroundWidth;
  bool? backgroundWidthMode;
  String? backgroundBoxFit;
  CardDesign cardDesign = CardDesign.card;
  int? titleLine;
  String? orderby;
  int? limit;

  /// limit product
  List? include;

  /// load special products

  Color? backgroundColor;
  double backgroundRadius = 10;

  bool showCountDown = false;
  bool onSale = false;
  int rows = 1;
  int columns = 3;
  double imageRatio = 1.2;
  String imageBoxfit = 'cover';
  bool hidePrice = false;
  bool hideStore = false;
  bool hideTitle = false;
  bool? featured;
  bool enableRating = true;
  bool showStockStatus = true;
  bool hideEmptyProductListRating = false;
  bool showHeart = false;
  bool showCartButton = false;
  bool showCartIcon = true;
  bool showCartIconColor = false;
  double cartIconRadius = 12;
  bool showQuantity = false;
  bool enableBottomAddToCart = kAdvanceConfig['EnableBottomAddToCart'] ?? false;
  bool showOnlyImage = false;
  bool showCartButtonWithQuantity = false;

  ProductConfig({
    this.category,
    this.image,
    this.name,
    required this.layout,
    this.isSnapping,
    this.onSale = false,
    this.featured,
    this.height,
    this.imageWidth,
    this.showCountDown = false,
    this.jsonData,
    this.boxShadow,
    this.borderRadius,
    this.vMargin = 0.0,
    this.hMargin = 6.0,
    this.vPadding = 0.0,
    this.hPadding = 0.0,
    this.showHeart = false,
    this.showCartButton = false,
    this.showCartIcon = true,
    this.cartIconRadius = 9,
    this.showCartIconColor = false,
    this.showQuantity = false,
    this.enableBottomAddToCart = false,
    this.showOnlyImage = false,
    this.backgroundImage,
    this.spaceWidth,
    this.paddingBGP,
    this.backgroundHeight,
    this.backgroundWidth,
    this.backgroundBoxFit,
    this.backgroundWidthMode,
    this.showCartButtonWithQuantity = false,
    this.titleLine,
    this.orderby,
    this.limit,
    required this.rows,
    required this.columns,
    required this.imageRatio,
    required this.imageBoxfit,
    required this.hidePrice,
    required this.hideStore,
    required this.hideTitle,
    required this.enableRating,
    required this.showStockStatus,
    required this.hideEmptyProductListRating,
  });

  ProductConfig.empty() {
    layout = Layout.threeColumn;

    rows = 1;
    columns = 3;
    titleLine = Helper.formatInt(kProductCard['titleLine']);
    orderby = kProductCard['orderby'];
    vMargin = Helper.formatDouble(kProductCard['vMargin']) ?? 0.0;
    hMargin = Helper.formatDouble(kProductCard['hMargin']) ?? 6.0;
    imageRatio = kAdvanceConfig['RatioProductImage'] ?? 1.2;
    imageBoxfit = Configurations.productCard['fit'] ?? 'cover';
    hidePrice = kProductCard['hidePrice'] ?? false;
    hideTitle = kProductCard['hideTitle'] ?? false;
    hideStore = kProductCard['hideStore'] ?? false;
    showQuantity = kProductDetail.showQuantityInList;
    enableRating = kProductCard['enableRating'] ?? true;
    showCountDown = false;
    hideEmptyProductListRating =
        kProductCard['hideEmptyProductListRating'] ?? false;
    showStockStatus = kAdvanceConfig['showStockStatus'] ?? false;
    if (kProductCard['borderRadius'] != null) {
      borderRadius = Helper.formatDouble(kProductCard['borderRadius']);
    }
    if (kProductCard['boxShadow'] != null) {
      boxShadow = BoxShadowConfig.fromJson(kProductCard['boxShadow']);
    }
    if (kProductCard['cardDesign'] != null) {
      cardDesign = kProductCard['cardDesign'] == 'glass'
          ? CardDesign.glass
          : CardDesign.card;
    }
  }

  ProductConfig.fromJson(dynamic json) {
    /// init default values
    var env = ProductConfig.empty();
    if (json['cardDesign'] != null) {
      cardDesign =
          json['cardDesign'] == 'glass' ? CardDesign.glass : CardDesign.card;
    } else {
      cardDesign = env.cardDesign;
    }

    /// nullable
    category = json['category']?.toString();
    tag = json['tag']?.toString();
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    isSnapping = json['isSnapping'] ?? false;
    featured = json['featured'];
    onSale = json['onSale'] ?? false;
    showHeart = json['showHeart'] ?? false;
    showCartButton = json['showCartButton'] ?? false;
    showCartIcon = json['showCartIcon'] ?? true;
    showCartIconColor = json['showCartIconColor'] ?? false;
    enableBottomAddToCart = json['enableBottomAddToCart'] ??
        kAdvanceConfig['EnableBottomAddToCart'] ??
        false;
    backgroundImage = json['backgroundImage'];
    spaceWidth = json['spaceWidth'];
    backgroundHeight = json['backgroundHeight'];
    if (json['backgroundColor'] != null) {
      backgroundColor = HexColor(json['backgroundColor']);
    }
    backgroundWidth = json['backgroundWidth'];
    backgroundRadius = Helper.formatDouble(json['backgroundRadius']) ?? 10.0;

    backgroundBoxFit = json['backgroundBoxFit'];
    backgroundWidthMode = json['backgroundWidthMode'];
    if (json['paddingBGP'] != null) {
      paddingBGP = EdgeInsets.fromLTRB(
        Helper.formatDouble(json['paddingBGP']['left']) ?? 0.0,
        Helper.formatDouble(json['paddingBGP']['top']) ?? 0.0,
        Helper.formatDouble(json['paddingBGP']['right']) ?? 0.0,
        Helper.formatDouble(json['paddingBGP']['bottom']) ?? 0.0,
      );
    }
    // ignore: prefer_initializing_formals
    jsonData = json;
    height = Helper.formatDouble(json['height']);
    cartIconRadius = Helper.formatDouble(json['cartIconRadius']) ?? 9;
    imageWidth = Helper.formatDouble(json['imageWidth']);
    vMargin = Helper.formatDouble(json['vMargin']) ?? env.vMargin;
    hMargin = Helper.formatDouble(json['hMargin']) ?? env.hMargin;
    vPadding = Helper.formatDouble(json['vPadding']) ?? 0.0;
    hPadding = Helper.formatDouble(json['hPadding']) ?? 0.0;
    titleLine = Helper.formatInt(json['titleLine']) ?? env.titleLine;
    orderby = json['orderby'] ?? env.orderby;

    borderRadius =
        Helper.formatDouble(json['borderRadius']) ?? env.borderRadius ?? 3;
    if (json['boxShadow'] != null) {
      boxShadow = BoxShadowConfig.fromJson(json['boxShadow']);
    }

    /// support new advance config not nullable
    layout = json['layout'] ?? env.layout;

    /// only show count down for Sale off product
    showCountDown = (json['showCountDown'] ?? env.showCountDown) &&
        layout == Layout.saleOff;

    rows = Helper.formatInt(json['rows']) ?? env.rows;
    showQuantity = json['showQuantity'] ?? env.showQuantity;
    columns = Helper.formatInt(json['columns']) ?? env.columns;
    imageRatio = Helper.formatDouble(json['imageRatio']) ?? env.imageRatio;
    imageBoxfit = json['imageBoxfit'] ?? env.imageBoxfit;
    hidePrice = json['hidePrice'] ?? env.hidePrice;
    hideTitle = json['hideTitle'] ?? env.hideTitle;
    hideStore = json['hideStore'] ?? env.hideStore;
    showStockStatus = json['showStockStatus'] ?? env.showStockStatus;
    enableRating = json['enableRating'] ?? env.enableRating;
    hideEmptyProductListRating =
        json['hideEmptyProductListRating'] ?? env.hideEmptyProductListRating;
    showOnlyImage = json['showOnlyImage'] ?? false;
    showCartButtonWithQuantity = json['showCartButtonWithQuantity'] ?? false;
    limit = Helper.formatInt(json['limit']);
    include = json['include'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (jsonData is Map) {
      map.addAll(Map<String, dynamic>.from(jsonData));
    }
    map['category'] = category;
    map['name'] = name;
    map['layout'] = layout;
    map['isSnapping'] = isSnapping;
    map['tag'] = tag;
    map['image'] = image;
    map['height'] = height;
    map['imageWidth'] = imageWidth;
    map['borderRadius'] = borderRadius;
    map['hMargin'] = hMargin;
    map['vMargin'] = vMargin;
    map['hPadding'] = hPadding;
    map['vPadding'] = vPadding;
    map['boxShadow'] = boxShadow?.toJson();
    map['backgroundImage'] = backgroundImage;
    map['spaceWidth'] = spaceWidth;
    if (paddingBGP != null) {
      map['paddingBGP'] = {
        'left': paddingBGP?.left,
        'right': paddingBGP?.right,
        'top': paddingBGP?.top,
        'bottom': paddingBGP?.bottom,
      };
    }
    map['backgroundHeight'] = backgroundHeight;
    map['backgroundWidth'] = backgroundWidth;
    map['backgroundBoxFit'] = backgroundBoxFit;
    map['cardDesign'] = cardDesign.toString().split('.').last;
    map['titleLine'] = titleLine;
    map['orderby'] = orderby;
    map['limit'] = limit;
    map['include'] = include;
    map['backgroundColor'] = backgroundColor?.value.toRadixString(16);
    map['backgroundRadius'] = backgroundRadius;
    map['showCountDown'] = showCountDown;
    map['onSale'] = onSale;
    map['rows'] = rows;
    map['columns'] = columns;
    map['imageRatio'] = imageRatio;
    map['imageBoxfit'] = imageBoxfit;
    map['hidePrice'] = hidePrice;
    map['hideStore'] = hideStore;
    map['hideTitle'] = hideTitle;
    map['featured'] = featured;
    map['enableRating'] = enableRating;
    map['showStockStatus'] = showStockStatus;
    map['hideEmptyProductListRating'] = hideEmptyProductListRating;
    map['showHeart'] = showHeart;
    map['showCartButton'] = showCartButton;
    map['showCartIcon'] = showCartIcon;
    map['showCartIconColor'] = showCartIconColor;
    map['cartIconRadius'] = cartIconRadius;
    map['showQuantity'] = showQuantity;
    map['enableBottomAddToCart'] = enableBottomAddToCart;
    map['showOnlyImage'] = showOnlyImage;
    map['showCartButtonWithQuantity'] = showCartButtonWithQuantity;
    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString() {
    return '♻️ ProductConfig:: '
        'category:$category, '
        'image:$image, '
        'name:$name, '
        'layout:$layout, '
        'onSale:$onSale, ';
  }
}
