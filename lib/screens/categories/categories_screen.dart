import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fstore/routes/flux_navigate.dart';
import 'package:fstore/screens/categories/layouts/card.dart';
import 'package:fstore/screens/map/Base-delivery-mode.dart';
import 'package:fstore/widgets/common/tree_view.dart';
import 'package:inspireui/widgets/skeleton_widget/skeleton_widget.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../menu/appbar.dart';
import '../../models/entities/back_drop_arguments.dart';
import '../../models/index.dart' show AppModel, Category, CategoryModel;
import '../../modules/dynamic_layout/config/app_config.dart';
import '../../services/index.dart';
import '../map/Home-delivery.dart';
import 'layouts/column.dart';
import 'layouts/grid.dart';
import 'layouts/side_menu.dart';
import 'layouts/side_menu_with_sub.dart';
import 'layouts/sub.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesScreen extends StatefulWidget {
  bool showSearch;
  String categoryName;

  CategoriesScreen({
    Key? key,
    this.categoryName = "Meat & Popularity",
    this.showSearch = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoriesScreenState();
  }
}

class CategoriesScreenState extends State<CategoriesScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  String categoryTitle = 'Fresh Food';
  String subCategory = 'Dairy & Eggs';
  List<String> listOfSub = [];

  late FocusNode _focus;
  bool isVisibleSearch = false;
  String? searchText;
  var textController = TextEditingController();
  bool isVisible = false;
  bool selectedIndex = false;
  bool metaAvailable = false;
  int currentIndex = -1;

  late Animation<double> animation;
  late AnimationController controller;
  ScrollController scrollController = ScrollController();
  late double page;

  AppBarConfig? get appBar =>
      context.select((AppModel model) => model.appConfig?.appBar);

  @override
  void afterFirstLayout(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    scrollController.addListener(() {
      setState(() {
        page =
            _getPage(scrollController.position, screenSize.width * 0.30 + 10);
      });
    });
  }

  bool hasChildren(id, categories) {
    return categories!.where((o) => o.parent == id).toList().isNotEmpty;
  }

  double _getPage(ScrollPosition position, double width) {
    return position.pixels / width;
  }

  List<Category> getSubCategories({id, required List<Category> category}) {
    return category.where((o) => o.parent == id).toList();
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
        for (var category in getSubCategories(
            id: category.id, category: category.subCategories))
          Parent(
            callback: (isSelected) {
              if (getSubCategories(
                      id: category.id, category: category.subCategories)
                  .isEmpty) {
                navigateToBackDrop(category);
              }
            },
            parent: SubItem(category),
            childList: ChildList(
              children: [
                for (var cate in getSubCategories(
                    id: category.id, category: category.subCategories))
                  Parent(
                    callback: (isSelected) {
                      if (getSubCategories(
                              id: cate.id, category: category.subCategories)
                          .isEmpty) {
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
                        for (var _cate in getSubCategories(
                            id: cate.id, category: category.subCategories))
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
  void initState() {
    super.initState();
    page = 0.0;
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: 0, end: 60).animate(controller);
    animation.addListener(() {
      setState(() {});
    });

    _focus = FocusNode();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focus.hasFocus && animation.value == 0) {
      controller.forward();
      setState(() {
        isVisibleSearch = true;
      });
    }
  }

  var categories;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final category = Provider.of<CategoryModel>(context);
    final appModel = Provider.of<AppModel>(context);
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: (appBar?.shouldShowOn(RouteList.category) ?? false)
          ? AppBar(
              titleSpacing: 0,
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).backgroundColor,
              title: FluxAppBar(),
            )
          : null,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
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
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.93,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0XFFF0F0F0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Icon(Icons.search, size: 22),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'What are you looking for?',
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ///Change Line
              GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              BaseDeliveryMode(fromHome: true)));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(0.0, 5))
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  color: Colors.white),
                              const SizedBox(width: 5),
                              Container(
                                  width: 250,
                                  child: Text(address,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10))),
                            ],
                          ),
                          const Text('CHANGE',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Colors.grey.shade100,
                      height: 600,
                      child: ListView.builder(
                        itemCount: categoryData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              categoryTitle = categoryData[index].title;
                              for (var i = 0; i <= categoryData.length; i++) {
                                if (index != i) {
                                  setState(
                                      () => categoryData[i].isPressed = false);
                                } else if (index == i) {
                                  setState(() =>
                                      categoryData[index].isPressed = true);
                                }
                              }
                              setState(() {});
                            },

                            ///Left List
                            child: Container(
                              width: double.infinity / 2,
                              color: Colors.grey.shade100,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 48,
                                        width: 10,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: categoryData[index].isPressed
                                              ? Colors.green.shade800
                                              : Colors.grey.shade100,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0,
                                                bottom: 1,
                                                left: 10.0),
                                            child: Text(
                                                categoryData[index].title,
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey.shade500,
                                    indent: 15,
                                    endIndent: 5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  ///Right List
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        height: 600,
                        child: ListView.builder(
                          itemCount: subCategories.length,
                          itemBuilder: (context, index) {
                            if (subCategories[index].title == categoryTitle) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                              subCategories[index]
                                                  .subCategories,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              if (listOfMetaSubCategories.any(
                                                  (element) => element
                                                      .subCategories
                                                      .contains(subCategories[
                                                              index]
                                                          .subCategories))) {
                                                isVisible = !isVisible;
                                                currentIndex =
                                                    currentIndex == index
                                                        ? -1
                                                        : index;
                                                setState(() {});
                                              } else {
                                                FluxNavigate.pushNamed(
                                                  RouteList.backdrop,
                                                  arguments: BackDropArguments(
                                                    cateId:
                                                        subCategories[index].id,
                                                    cateName:
                                                        subCategories[index]
                                                            .subCategories,
                                                  ),
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.arrow_drop_down))
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade500,
                                    endIndent: 17,
                                  ),
                                  if (currentIndex == index)
                                    Column(
                                      children: [
                                        ///Products Row

                                        Row(
                                          children:
                                              listOfMetaSubCategories.map((e) {
                                            listOfSub.add(e.subCategories);
                                            subCategory = e.subCategories;
                                            if (e.subCategories ==
                                                subCategories[index]
                                                    .subCategories) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FluxNavigate.pushNamed(
                                                    RouteList.backdrop,
                                                    arguments:
                                                        BackDropArguments(
                                                      cateId: e.id,
                                                      cateName:
                                                          e.metaSubCatories,
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: Column(
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                          radius: 30,
                                                          backgroundImage:
                                                              AssetImage(
                                                                  e.image)),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Text(
                                                            e.metaSubCatories,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                            return const SizedBox();
                                          }).toList(),
                                        ),

                                        SizedBox(height: 12),
                                        GestureDetector(
                                          onTap: () {
                                            FluxNavigate.pushNamed(
                                              RouteList.backdrop,
                                              arguments: BackDropArguments(
                                                cateId: subCategories[index].id,
                                                cateName: subCategories[index]
                                                    .subCategories,
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("View All Items",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  )),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey.shade500,
                                          endIndent: 17,
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            }
                            return SizedBox();
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderHeader() {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width:
              screenSize.width / (2 / (screenSize.height / screenSize.width)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (Navigator.canPop(context))
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, bottom: 10, right: 10),
                child: Text(
                  S.of(context).category,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (widget.showSearch)
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.6),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteList.categorySearch);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderCategories(List<Category>? categories, String layout) {
    return Services().widget.renderCategoryLayout(categories, layout);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
      return FadeInImage.memoryNetwork(
        image: '$imageProxy$image',
        fit: BoxFit.cover,
        width: 140,
        height: 60,
        placeholder: kTransparentImage,
      );
    }

    return image.contains('http')
        ? CachedNetworkImage(
            imageUrl: category.image!,
            fit: BoxFit.cover,

            // fadeInCurve: Curves.easeIn,
            errorWidget: (context, url, error) => const SizedBox(),
            imageBuilder:
                (BuildContext context, ImageProvider<dynamic> imageProvider) {
              return Image(
                width: maxWidth,
                image: imageProvider as ImageProvider<Object>,
                fit: BoxFit.cover,
              );
            },
            placeholder: (context, url) => Skeleton(
              width: 140,
              height: 60,
            ),
          )
        : Image.asset(
            category.image!,
            fit: BoxFit.cover,
            width: 140,
            height: 60,
            alignment: Alignment(
              0.0,
              (offset >= -1 && offset <= 1)
                  ? offset
                  : (offset > 0)
                      ? 1.0
                      : -1.0,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoriesScreen(
                      categoryName: category.name!,
                    )));
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      category.name?.toUpperCase() ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Divider()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoriesData {
  String title;
  bool isPressed;
  MetaSubCategories? metaSubCategories;
  CategoriesData(
      {this.title = '', this.isPressed = false, this.metaSubCategories});
}

List<CategoriesData> categoryData = [
  CategoriesData(title: 'Pak Foods', isPressed: false),
  CategoriesData(title: 'Fresh Food', isPressed: false),
  CategoriesData(title: 'Fruits & Vegetables', isPressed: false),
  CategoriesData(title: 'Food Cupboard', isPressed: false),
  CategoriesData(title: 'Frozen Food', isPressed: false),
  CategoriesData(title: 'Bakery', isPressed: false),
  CategoriesData(title: 'Traditional Items', isPressed: false),
  CategoriesData(title: 'House Hold Items', isPressed: false),
  CategoriesData(title: 'Beauty & Hygiene', isPressed: false),
  CategoriesData(title: 'Beverages', isPressed: false),
];

//Images
class MetaSubCategories {
  String subCategories;
  String metaSubCatories;
  String id;
  String image;
  MetaSubCategories(
      {this.subCategories = '',
      this.image = '',
      this.metaSubCatories = '',
      this.id = ''});
}

List<MetaSubCategories> listOfMetaSubCategories = [
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDIyMjE5OTAyNg==',
      subCategories: 'Pak Foods',
      metaSubCatories: 'Pak Foods',
      image: 'assets/pakfoods.png'),
      
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNzUyOTMzMA==',
      subCategories: 'Dairy & Eggs',
      metaSubCatories: 'Dairy',
      image: 'assets/dairy1.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNzU2MjA5OA==',
      subCategories: 'Dairy & Eggs',
      metaSubCatories: 'Eggs',
      image: 'assets/eggs.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzIwOTc3MTI1MA==',
      subCategories: 'Meat & Poultry',
      metaSubCatories: 'Chicken',
      image: 'assets/chicken.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzIwOTgwNDAxOA==',
      subCategories: 'Meat & Poultry',
      metaSubCatories: 'Mutton',
      image: 'assets/mutton.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzIwOTgzNjc4Ng==',
      subCategories: 'Meat & Poultry',
      metaSubCatories: 'Beef',
      image: 'assets/beef.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNzY2MDQwMg==',
      subCategories: 'Rice, Pasta & Pulses',
      metaSubCatories: 'Rice',
      image: 'assets/rice.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNzc5MTQ3NA==',
      subCategories: 'Rice, Pasta & Pulses',
      metaSubCatories: 'Pasta',
      image: 'assets/pasta.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNzkyMjU0Ng==',
      subCategories: 'Rice, Pasta & Pulses',
      metaSubCatories: 'Pulses',
      image: 'assets/pulses.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNzk1NTMxNA==',
      subCategories: 'Condiments',
      metaSubCatories: 'Condiments',
      image: 'assets/condiments.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNzk4ODA4Mg==',
      subCategories: 'Condiments',
      metaSubCatories: 'Dressing & Merinades',
      image: 'assets/dressing.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExODIxNzQ1OA==',
      subCategories: 'Nuts, Dates & Dry Fruits',
      metaSubCatories: 'Dates',
      image: 'assets/dates.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExODI1MDIyNg==',
      subCategories: 'Nuts, Dates & Dry Fruits',
      metaSubCatories: 'Nuts & Dry Fruits',
      image: 'assets/nuts.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODM3NDg5OA==',
      subCategories: 'Fruits',
      metaSubCatories: 'Fruits',
      image: 'assets/Fruits.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODMwOTM2Mg==',
      subCategories: 'Vegetables',
      metaSubCatories: 'Vegetables',
      image: 'assets/Vegetables.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODIxMTA1OA==',
      subCategories: 'Herbs',
      metaSubCatories: 'Herbs',
      image: 'assets/Herbs.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODE3ODI5MA==',
      subCategories: 'Fresh Box',
      metaSubCatories: 'Fresh Box',
      image: 'assets/FreshBox.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODE0NTUyMg==',
      subCategories: 'Mangoes',
      metaSubCatories: 'Mangoes',
      image: 'assets/Mangoes.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODUwNTk3MA==',
      subCategories: 'Masala & Spices',
      metaSubCatories: 'Masala & Spices',
      image: 'assets/Masala and Spices.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExODA1MzYxOA==',
      subCategories: 'Jams, Honey & Spreads',
      metaSubCatories: 'Jams',
      image: 'assets/Jams.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExODA4NjM4Ng==',
      subCategories: 'Jams, Honey & Spreads',
      metaSubCatories: 'Honey',
      image: 'assets/Honey.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExODExOTE1NA==',
      subCategories: 'Jams, Honey & Spreads',
      metaSubCatories: 'Spreads',
      image: 'assets/Spreads.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODY2OTgxMA==',
      subCategories: 'Cooking Ingredients',
      metaSubCatories: 'Cooking Ingredients',
      image: 'assets/Cooking Ingrediants.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODgzMzY1MA==',
      subCategories: 'Chocolates & Confectionery',
      metaSubCatories: 'Chocolates & Confectionery',
      image: 'assets/Chocolate & Confectionery.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODg2NjQxOA==',
      subCategories: 'Chips, Dips & Snacks',
      metaSubCatories: 'Chips, Dips & Snacks',
      image: 'assets/Chips.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODg5OTE4Ng==',
      subCategories: 'Rusk & Bakarhani',
      metaSubCatories: 'Rusk & Bakarhani',
      image: 'assets/Rusk & Bakerkhani.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODkzMTk1NA==',
      subCategories: 'Tins, Jars & Packets',
      metaSubCatories: 'Tins, Jars & Packets',
      image: 'assets/Tins,Jars and Packets.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODk2NDcyMg==',
      subCategories: 'Biscuits & Cakes',
      metaSubCatories: 'Biscuits & Cakes',
      image: 'assets/Biscuits and cakes.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODk5NzQ5MA==',
      subCategories: 'Sugar & Home baking',
      metaSubCatories: 'Sugar & Home baking',
      image: 'assets/Sugar & Home Baking.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDA3ODgzNA==',
      subCategories: 'Ice Cream & Deserts',
      metaSubCatories: 'Ice Cream & Deserts',
      image: 'assets/Ice Cream & Desserts.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDExMTYwMg==',
      subCategories: 'Frozen Sweets',
      metaSubCatories: 'Frozen Sweets',
      image: 'assets/Frozen Foods.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDI0MjY3NA==',
      subCategories: 'Ready to Eat',
      metaSubCatories: 'Ready to Eat',
      image: 'assets/Ready to Eat.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDc2Njk2Mg==',
      subCategories: 'Puff & Biscuits',
      metaSubCatories: 'Puff & Biscuits',
      image: 'assets/Puff & Biscuits.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDgzMjQ5OA==',
      subCategories: 'Bread & Buns',
      metaSubCatories: 'Bread & Buns',
      image: 'assets/Bread & Buns.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDg2NTI2Ng==',
      subCategories: 'Sweets',
      metaSubCatories: 'Sweets',
      image: 'assets/Sweets.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTIzNTU3MA==',
      subCategories: 'Air Freshners',
      metaSubCatories: 'Air Freshners',
      image: 'assets/Air Freshner.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTMwMTEwNg==',
      subCategories: 'Accessories',
      metaSubCatories: 'Accessories',
      image: 'assets/Accessories.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTMzMzg3NA==',
      subCategories: 'Cleaning',
      metaSubCatories: 'Cleaning',
      image: 'assets/Cleaning.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTM5OTQxMA==',
      subCategories: 'Crockery',
      metaSubCatories: 'Crockery',
      image: 'assets/Crockery.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTQzMjE3OA==',
      subCategories: 'General',
      metaSubCatories: 'General',
      image: 'assets/General.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTYyMDA4Mg==',
      subCategories: 'Tea',
      metaSubCatories: 'Tea',
      image: 'assets/Tea.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTU4NzMxNA==',
      subCategories: 'Coffee',
      metaSubCatories: 'Coffee',
      image: 'assets/Coffee.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTU1NDU0Ng==',
      subCategories: 'Herbal Drinks',
      metaSubCatories: 'Herbal Drinks',
      image: 'assets/Herbal Drinks.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTUyMTc3OA==',
      subCategories: 'Flavoured Syrups',
      metaSubCatories: 'Flavoured Syrups',
      image: 'assets/Flavoured Syrups.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTQ4OTAxMA==',
      subCategories: 'Juices',
      metaSubCatories: 'Juices',
      image: 'assets/Juices.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTQ1NjI0Mg==',
      subCategories: 'Pakistani Soft Drinks',
      metaSubCatories: 'Pakistani Soft Drinks',
      image: 'assets/Pakistani Soft Drinks.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTQyMzQ3NA==',
      subCategories: 'Kids Drinks',
      metaSubCatories: 'Kids Drinks',
      image: 'assets/Kids Drinks.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTM5MDcwNg==',
      subCategories: 'Powdered Drinks',
      metaSubCatories: 'Powdered Drinks',
      image: 'assets/Powdered Drinks.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTM1NzkzOA==',
      subCategories: 'Water',
      metaSubCatories: 'Water',
      image: 'assets/Water.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTUxNDIyNg==',
      subCategories: 'Hair Care',
      metaSubCatories: 'Hair Care',
      image: 'assets/Hair Care.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTU0Njk5NA==',
      subCategories: 'Body Care',
      metaSubCatories: 'Body Care',
      image: 'assets/Body Care.png'),
      

  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTU3OTc2Mg==',
      subCategories: 'Face Care',
      metaSubCatories: 'Face Care',
      image: 'assets/Face Care.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTYxMjUzMA==',
      subCategories: 'Eye Care',
      metaSubCatories: 'Eye Care',
      image: 'assets/Eye Care.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTY0NTI5OA==',
      subCategories: 'Oral Care',
      metaSubCatories: 'Oral Care',
      image: 'assets/Oral Care.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTY3ODA2Ng==',
      subCategories: 'Hand Care',
      metaSubCatories: 'Hand Care',
      image: 'assets/Hand Care.png'),
  MetaSubCategories(
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MTU1MzM5NA==',
      subCategories: 'Traditional Items',
      metaSubCatories: 'Traditional Items',
      image: 'assets/Traditional Items.png'),
];

//Drop Down and Names
class SubCategory {
  String title;
  String subCategories;
  MetaSubCategories? metaSubCategories;
  Icon icon;
  String id;
  SubCategory(
      {this.id = '',
      this.title = '',
      this.metaSubCategories,
      this.subCategories = '',
      required this.icon});
}

List<SubCategory> subCategories = [
  SubCategory(
      title: 'Fresh Food',
      subCategories: 'Dairy & Eggs',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzNzcxOTUzOA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Fresh Food',
      subCategories: 'Meat & Poultry',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzNzYyMTIzNA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Fruits & Vegetables',
      subCategories: 'Fruits',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODM3NDg5OA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Fruits & Vegetables',
      subCategories: 'Vegetables',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODMwOTM2Mg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Fruits & Vegetables',
      subCategories: 'Herbs',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODIxMTA1OA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Fruits & Vegetables',
      subCategories: 'Fresh Box',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODE3ODI5MA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Fruits & Vegetables',
      subCategories: 'Mangoes',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODE0NTUyMg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Rice, Pasta & Pulses',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTAzMDI1OA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Sugar & Home baking',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODk5NzQ5MA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Biscuits & Cakes',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODk2NDcyMg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Tins, Jars & Packets',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODkzMTk1NA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Rusk & Bakarhani',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODg5OTE4Ng==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Chips, Dips & Snacks',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODg2NjQxOA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Chocolates & Confectionery',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODgzMzY1MA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Condiments',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNzk1NTMxNA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Cooking Ingredients',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODY2OTgxMA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Jams, Honey & Spreads',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODYwNDI3NA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Nuts, Dates & Dry Fruits',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODUzODczOA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Food Cupboard',
      subCategories: 'Masala & Spices',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODUwNTk3MA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Frozen Food',
      subCategories: 'Ice Cream & Deserts',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDA3ODgzNA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Frozen Food',
      subCategories: 'Frozen Sweets',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDExMTYwMg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Frozen Food',
      subCategories: 'Ready to Eat',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDI0MjY3NA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beverages',
      subCategories: 'Tea',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTYyMDA4Mg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beverages',
      subCategories: 'Coffee',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTU4NzMxNA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beverages',
      subCategories: 'Herbal Drinks',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTU1NDU0Ng==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beverages',
      subCategories: 'Flavoured Syrups',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTUyMTc3OA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beverages',
      subCategories: 'Juices',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTQ4OTAxMA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beverages',
      subCategories: 'Pakistani Soft Drinks',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTQ1NjI0Mg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beverages',
      subCategories: 'Kids Drinks',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTQyMzQ3NA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beverages',
      subCategories: 'Powdered Drinks',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTM5MDcwNg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beverages',
      subCategories: 'Water',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTM1NzkzOA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Bakery',
      subCategories: 'Sweets',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDg2NTI2Ng==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Bakery',
      subCategories: 'Bread & Buns',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDgzMjQ5OA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Bakery',
      subCategories: 'Puff & Biscuits',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MDc2Njk2Mg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'House Hold Items',
      subCategories: 'Air Freshners',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTIzNTU3MA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'House Hold Items',
      subCategories: 'Accessories',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTMwMTEwNg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'House Hold Items',
      subCategories: 'Cleaning',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTMzMzg3NA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'House Hold Items',
      subCategories: 'Crockery',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTM5OTQxMA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'House Hold Items',
      subCategories: 'General',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNTQzMjE3OA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beauty & Hygiene',
      subCategories: 'Hair Care',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTUxNDIyNg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beauty & Hygiene',
      subCategories: 'Body Care',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTU0Njk5NA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beauty & Hygiene',
      subCategories: 'Face Care',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTU3OTc2Mg==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beauty & Hygiene',
      subCategories: 'Eye Care',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTYxMjUzMA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beauty & Hygiene',
      subCategories: 'Oral Care',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTY0NTI5OA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Beauty & Hygiene',
      subCategories: 'Hand Care',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTY3ODA2Ng==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Traditional Items',
      subCategories: 'Traditional Items',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTE0MTU1MzM5NA==',
      icon: const Icon(Icons.arrow_drop_down)),
  SubCategory(
      title: 'Pak Foods',
      subCategories: 'Pak Foods',
      id: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDIyMjE5OTAyNg==',
      // image
      icon: const Icon(Icons.arrow_drop_down)),
];
