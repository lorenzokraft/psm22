import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fstore/modules/dynamic_layout/bakery.dart';
import 'package:fstore/modules/dynamic_layout/beverages.dart';
import 'package:fstore/modules/dynamic_layout/food-cupboard-items.dart';
import 'package:fstore/modules/dynamic_layout/fresh-food.dart';
import 'package:fstore/modules/dynamic_layout/frozen-foods.dart';
import 'package:fstore/modules/dynamic_layout/fruit-vegetables.dart';
import 'package:fstore/modules/dynamic_layout/houshold-items.dart';
import 'package:inspireui/inspireui.dart' show Skeleton;
import 'package:transparent_image/transparent_image.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show BackDropArguments, Category;
import '../../../modules/dynamic_layout/beauty-and-hygiene.dart';
import '../../../modules/dynamic_layout/pak-foods.dart';
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/tree_view.dart';
import '../../base_screen.dart';
import '../../index.dart';

class CardCategories extends StatefulWidget {
  static const String type = 'card';

  final List<Category>? categories;

  const CardCategories(this.categories);

  @override
  _StateCardCategories createState() => _StateCardCategories();
}

class _StateCardCategories extends BaseScreen<CardCategories> {
  ScrollController controller = ScrollController();
  late double page;

  @override
  void initState() {
    page = 0.0;
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    controller.addListener(() {
      setState(() {
        page = _getPage(controller.position, screenSize.width * 0.30 + 10);
      });
    });
  }

  bool hasChildren(id) {
    return widget.categories!.where((o) => o.parent == id).toList().isNotEmpty;
  }

  double _getPage(ScrollPosition position, double width) {
    return position.pixels / width;
  }

  List<Category> getSubCategories(id) {
    return widget.categories!.where((o) => o.parent == id).toList();
  }

  void navigateToBackDrop(Category category) {
    FluxNavigate.pushNamed(
      RouteList.backdrop,
      arguments: BackDropArguments(
        cateId: category.id,
        cateName: category.name,
      ),
    );
  }

  Widget getChildCategoryList(category) {
    return ChildList(
      children: [
        // GestureDetector(
        //   onTap: () => navigateToBackDrop(category),
        //   child: SubItem(
        //     category,
        //     seeAll: S.of(context).seeAll,
        //   ),
        // ),
        for (var category in getSubCategories(category.id))
          Parent(
            callback: (isSelected) {
              if (getSubCategories(category.id).isEmpty) {
                navigateToBackDrop(category);
              }
            },
            parent: SubItem(category),
            childList: ChildList(
              children: [
                for (var cate in getSubCategories(category.id))
                  Parent(
                    callback: (isSelected) {
                      if (getSubCategories(cate.id).isEmpty) {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId: cate.id,
                            cateName: cate.name,
                          ),
                        );
                      }
                    },
                    parent: SubItem(cate, level: 1),
                    childList: ChildList(
                      children: [
                        for (var _cate in getSubCategories(cate.id))
                          Parent(
                            callback: (isSelected) {
                              FluxNavigate.pushNamed(
                                RouteList.backdrop,
                                arguments: BackDropArguments(
                                  cateId: _cate.id,
                                  cateName: _cate.name,
                                ),
                              );
                            },
                            parent: SubItem(_cate, level: 2),
                            childList: const ChildList(children: []),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _categories =
        widget.categories!.where((item) => item.parent == '0').toList();
    if (_categories.isEmpty) {
      _categories = widget.categories!;
    }

    var updatedCat = [];
    _categories.map((e) {

      if (e.name == 'Fresh Food' ||
          e.name == 'Pak Foods' ||
          e.name == 'Food Cupboard' ||
          e.name == 'Beverages' ||
          e.name == 'Frozen Foods' ||
          e.name == 'Bakery' ||
          e.name == 'Beauty and Hygiene' ||
          e.name == 'Fruit & Vegetables' ||
          e.name == 'Household Items' ||
          e.name == 'Deals') {

           updatedCat.add(e);
      }
    }).toList();

    // var  categ   =updatedCat.sublist(0,(updatedCat.length/2).ceil());
    // var  catego   =updatedCat.sublist((updatedCat.length/2).ceil());
    var  categ   =updatedCat.sublist(0,5);
    var  catego   =updatedCat.sublist(5,10);


    print('======================rr==========================');

    print(updatedCat);
    print(updatedCat.length);
    print('======================rr==========================');
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: categ.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Parent(
                parent: _CategoryCardItem(
                  categ[index],
                  hasChildren: hasChildren(categ[index].id),
                  offset: page - index,
                ),
                childList: getChildCategoryList(categ[index]) as ChildList,
              ),
              Parent(
                parent: _CategoryCardItem(
                  catego[index],
                  hasChildren: hasChildren(catego[index].id),
                  offset: page - index,
                ),
                childList: getChildCategoryList(catego[index]) as ChildList,
              ),
            ],
          );
        });
  }
}

class _CategoryCardItem extends StatelessWidget {
  final Category category;
  final bool hasChildren;
  final offset;

  const _CategoryCardItem(this.category,
      {this.hasChildren = false, this.offset});

  /// Render category Image support caching on ios/android
  /// also fix loading on Web
  Widget renderCategoryImage(maxWidth) {
    final image = category.image ?? '';
    if (image.isEmpty) return const SizedBox();

    var imageProxy = '$kImageProxy${maxWidth}x,q30/';

    if (image.contains('http') && kIsWeb) {
      return CircleAvatar(
        radius: 40,
        child: FadeInImage.memoryNetwork(
          image: '$imageProxy$image',
          fit: BoxFit.cover,
          placeholder: kTransparentImage,
        ),
      );
    }

    return image.contains('http')
        ? Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(category.image!)),
                borderRadius: BorderRadius.circular(40)))
        : CircleAvatar(
            radius: 40,
            child: Image.asset(
              category.image!,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    List categoryName = category.name!.split('&').toList();
    var catName = category.name;

    return GestureDetector(
      onTap: hasChildren
          ? null
          : () {
              if (category.name == 'Food Cupboard') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FoodCupboardItems()));
              } else if (category.name == 'Fresh Food') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FreshFood()));
              } else if (category.name == 'Fruit & Vegetables') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FruitVegetables()));
              } else if (category.name == 'Beverages') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Beverages()));
              } else if (category.name == 'Frozen Foods') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FrozenFoods()));
              } else if (category.name == 'Bakery') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Bakery()));
              } else if (category.name == 'Household Items') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HouseHoldItems()));
              } else if (category.name == 'Pak Foods') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PakFoods()));
              } else if (category.name == 'Beauty and Hygiene') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const BeautyAndHygiene()));
              } else {
                FluxNavigate.pushNamed(
                  RouteList.backdrop,
                  arguments: BackDropArguments(
                    cateId: category.id,
                    cateName: category.name,
                  ),
                );
              }
            },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 4.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                    radius: 30,
                    child: renderCategoryImage(constraints.maxWidth)),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      Text(catName!.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),

                      // for (var i = 0; i < categoryName.length; i++)
                      //   Text(
                      //     categoryName[i] == '&'
                      //         ? ''
                      //         : '${categoryName[i].toUpperCase() ?? ''}',
                      //     textAlign: TextAlign.center,
                      //     style: const TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 10,
                      //         fontWeight: FontWeight.w600),
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SubItem extends StatelessWidget {
  final Category category;
  final String seeAll;
  final int level;

  const SubItem(this.category, {this.seeAll = '', this.level = 0});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Container(
          width:
              screenSize.width / (2 / (screenSize.height / screenSize.width)),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 0.5,
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withOpacity(level == 0 && seeAll == '' ? 0.2 : 0),
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 15.0),
              for (int i = 1; i <= level; i++)
                Container(
                  width: 20.0,
                  margin: const EdgeInsets.only(top: 8.0, right: 4),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  seeAll != '' ? seeAll : category.name!,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Text(
                S.of(context).nItems(category.totalProduct.toString()),
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).primaryColor),
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right),
                onPressed: () {
                  FluxNavigate.pushNamed(
                    RouteList.backdrop,
                    arguments: BackDropArguments(
                      cateId: category.id,
                      cateName: category.name,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
