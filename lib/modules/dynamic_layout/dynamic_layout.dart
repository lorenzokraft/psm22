import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fstore/common/config.dart';
import 'package:fstore/generated/l10n.dart';
import 'package:fstore/modules/dynamic_layout/food-cupboard-items.dart';
import 'package:fstore/modules/dynamic_layout/home-selling-products.dart';
import 'package:fstore/modules/dynamic_layout/non-food-items.dart';
import 'package:fstore/screens/map/Base-delivery-mode.dart';
import 'package:fstore/widgets/category-conatiner.dart';
import 'package:fstore/widgets/product/product_simple_view.dart';
import 'package:inspireui/widgets/expandable/expandable_listtile.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/index.dart';
import '../../routes/flux_navigate.dart';
import '../../screens/buy-again.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/map/Home-delivery.dart';
import '../../services/index.dart';
import '../../widgets/discount-container.dart';
import '../../widgets/top-categories-container.dart';
import 'banner/banner_animate_items.dart';
import 'banner/banner_group_items.dart';
import 'banner/banner_slider.dart';
import 'blog/blog_grid.dart';
import 'brand/brand_layout.dart';
import 'button/button.dart';
import 'category/category_icon.dart';
import 'category/category_image.dart';
import 'category/category_menu_with_products.dart';
import 'category/category_text.dart';
import 'config/brand_config.dart';
import 'config/index.dart';
import 'divider/divider.dart';
import 'food-items.dart';
import 'header/header_search.dart';
import 'header/header_text.dart';
import 'index.dart';
import 'instagram_story/instagram_story.dart';
import 'logo/logo.dart';
import 'product/product_list_simple.dart';
import 'product/product_recent_placeholder.dart';
import 'slider_testimonial/index.dart';
import 'spacer/spacer.dart';
import 'story/index.dart';
import 'testimonial/index.dart';
import 'video/index.dart';

class DynamicLayout extends StatefulWidget {
  final config;
  final bool cleanCache;

  const DynamicLayout({this.config, this.cleanCache = false});

  @override
  State<DynamicLayout> createState() => _DynamicLayoutState();
}

class _DynamicLayoutState extends State<DynamicLayout> {
  @override
  //  List<Product> products=[];
  //
  //   Future<List<Product>?> getProducts()  async  {
  //   var url = Uri.parse('https://psm-website.myshopify.com/products.json?limit=50&fields=title,vendor,handle');
  //   var response = await http.post(url);
  //   print(response);
  //   var data =json.decode(response.body);
  //
  //   setState(() => products   =  data.map<Product>((e) => Product.fromJson(e)).toList());
  //
  //     print(products.toList());
  //
  //
  //   // brandDetailsList!.map((e) => print(e.toJson())).toList();
  //   return products;
  // }

  // @override
  //  void initState() {
  //    super.initState();
  //   getProducts();
  //  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.green.shade700,
      ),
    );
    final appModel = Provider.of<AppModel>(context, listen: true);
    final category = Provider.of<CategoryModel>(context);
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    switch (widget.config['layout']) {
      case 'logo':
        final themeConfig = appModel.themeConfig;
        return Logo(
          config: LogoConfig.fromJson(widget.config),
          logo: themeConfig.logo,
          totalCart:
              Provider.of<CartModel>(context, listen: true).totalCartQuantity,
          notificationCount:
              Provider.of<NotificationModel>(context).unreadCount,
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
          onSearch: () => Navigator.of(context).pushNamed(RouteList.homeSearch),
          onCheckout: () {
            Navigator.pop(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  body: const CartScreen(isModal: true),
                ),
                fullscreenDialog: true,
              ),
            );
          },
          onTapNotifications: () {
            Navigator.of(context).pushNamed(RouteList.notify);
          },
          onTapDrawerMenu: () => NavigateTools.onTapOpenDrawerMenu(context),
        );

      // case 'header_text':
      //   return HeaderText(
      //     config: HeaderConfig.fromJson(widget.config),
      //     onSearch: () => Navigator.of(context).pushNamed(RouteList.homeSearch),
      //     key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //   );

      // case 'header_search':
      //   return HeaderSearch(
      //     config: HeaderConfig.fromJson(widget.config),
      //     onSearch: () {
      //       Navigator.of(App.fluxStoreNavigatorKey.currentContext!)
      //           .pushNamed(RouteList.homeSearch);
      //     },
      //     key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //   );
      case 'featuredVendors':
        return Services().widget.renderFeatureVendor(widget.config);
      // case 'category':
      //   if (widget.config['type'] == 'image') {
      //     return CategoryImages(
      //       config: CategoryConfig.fromJson(widget.config),
      //       key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //     );
      //   }
      //   return Consumer<CategoryModel>(builder: (context, model, child) {
      //     var _config = CategoryConfig.fromJson(widget.config);
      //     var _listCategoryName = model.categoryList.map((key, value) => MapEntry(key, value.name));
      //     void _onShowProductList(CategoryItemConfig item) {
      //       FluxNavigate.pushNamed(
      //         RouteList.backdrop,
      //         arguments: BackDropArguments(
      //           config: item.jsonData,
      //           data: item.data,
      //         ),
      //       );
      //     }
      //
      //     if (widget.config['type'] == 'menuWithProducts') {
      //       return CategoryMenuWithProducts(
      //         config: _config,
      //         listCategoryName: _listCategoryName,
      //         onShowProductList: _onShowProductList,
      //         key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //       );
      //     }
      //
      //     if (widget.config['type'] == 'text') {
      //       return CategoryTexts(
      //         config: _config,
      //         listCategoryName: _listCategoryName,
      //         onShowProductList: _onShowProductList,
      //         key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //       );
      //     }
      //
      //     return CategoryIcons(
      //       config: _config,
      //       listCategoryName: _listCategoryName,
      //       onShowProductList: _onShowProductList,
      //       key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //     );
      //   });
      // case 'bannerAnimated':
      //   if (kIsWeb) return const SizedBox();
      //   return BannerAnimated(
      //     config: BannerConfig.fromJson(widget.config),
      //     key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //   );

      // case 'category':
      //   if (widget.config['type'] == 'image') {
      //     return CategoryImages(
      //       config: CategoryConfig.fromJson(widget.config),
      //       key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //     );
      //   }
      //   return Consumer<CategoryModel>(builder: (context, model, child) {
      //     var _config = CategoryConfig.fromJson(widget.config);
      //     var _listCategoryName = model.categoryList.map((key, value) => MapEntry(key, value.name));
      //     void _onShowProductList(CategoryItemConfig item) {
      //       FluxNavigate.pushNamed(
      //         RouteList.backdrop,
      //         arguments: BackDropArguments(
      //           config: item.jsonData,
      //           data: item.data,
      //         ),
      //       );
      //     }
      //
      //     if (widget.config['type'] == 'menuWithProducts') {
      //       return CategoryMenuWithProducts(
      //         config: _config,
      //         listCategoryName: _listCategoryName,
      //         onShowProductList: _onShowProductList,
      //         key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //       );
      //     }
      //
      //     if (widget.config['type'] == 'text') {
      //       return CategoryTexts(
      //         config: _config,
      //         listCategoryName: _listCategoryName,
      //         onShowProductList: _onShowProductList,
      //         key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //       );
      //     }
      //
      //     return CategoryIcons(
      //       config: _config,
      //       listCategoryName: _listCategoryName,
      //       onShowProductList: _onShowProductList,
      //       key: widget.config['key'] != null ? Key(widget.config['key']) : UniqueKey(),
      //     );
      //   });
      //

      case 'bannerImage':
        if (widget.config['isSlider'] == true) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///Top PS-Logo
              Container(
                  color: Colors.green.shade700,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Image.asset('assets/tab/logo1.png',
                        width: 50, height: 50),
                  )),

              ///Text Field 'What are you..
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
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
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

              ///Change Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              BaseDeliveryMode(fromHome: true)));
                },
                child: Container(
                  height: 50,
                  color: Colors.green.shade900,
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

              ///Get Free Delivery Text
              Container(
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(0.0, 4.5))
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Center(
                      child: Text(
                          'Get Free delivery on orders worth AED 100 & above'))),

              const SizedBox(height: 10),

              ///Launch Offer Banners
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: SizedBox(
                  height: 180,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      bannerContainer(
                          onPressed: () {},
                          context: context,
                          image:
                              'https://cdn.shopify.com/s/files/1/0629/3677/6946/files/bnr2.jpg?v=1649678719'),
                      bannerContainer(
                          onPressed: () {},
                          context: context,
                          image:
                              'https://cdn.shopify.com/s/files/1/0629/3677/6946/files/bn1.jpg?v=1649678684'),
                    ],
                  ),
                ),
              ),

              ///Fresh Food, Fruit Veg....
              ListenableProvider.value(
                value: category,
                child: Consumer<CategoryModel>(
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return kLoadingWidget(context);
                    }
                    if (value.categories == null) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Text(S.of(context).dataEmpty),
                      );
                    }
                    var categories = value.categories;
                    print(categories);
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        height: 200,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            renderCategories(categories, appModel.categoryLayout)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              ///Food Items, Non-Food...
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    categoryContainer(
                        text: 'Food Items',
                        color: const Color(0xff008536),
                        context: context,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FoodItems()));
                        }),
                    categoryContainer(
                        text: 'Non-Food',
                        color: const Color(0xffd5262d),
                        context: context,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NonFoodItems()));
                        }),
                    categoryContainer(
                        text: 'Buy Again',
                        color: const Color(0xfffed507),
                        context: context,
                        onTap: () {
                          // final user =
                          //     Provider.of<UserModel>(context, listen: false)
                          //         .user;
                          // FluxNavigate.pushNamed(
                          //   RouteList.orders,
                          //   arguments: user,
                          // );
                           Navigator.push(context, MaterialPageRoute(builder : (context)=> const BuyAgainPage()));
                        }),
                  ],
                ),
              ),

              ///Honey-Mango Banner
              GestureDetector(
                onTap: () {
                  FluxNavigate.pushNamed(
                    RouteList.backdrop,
                    arguments: BackDropArguments(
                      cateId:
                          'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODE0NTUyMg==',
                      cateName: 'Mangoes',
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                  child: SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset('assets/banner.png',
                              fit: BoxFit.cover))),
                ),
              ),
              // Padding(
              //   padding:  const EdgeInsets.symmetric(horizontal: 10.0,vertical:12.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children:  [
              //       const Text('Top Categories',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
              //       Row(
              //         children: const [
              //           Text('View All',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
              //           Icon(Icons.arrow_forward_ios,size: 15)
              //         ],
              //       )
              //     ],
              //   ),
              // ),
              //  Container(
              //    height: 120,
              //    child: Padding(
              //     padding:  EdgeInsets.symmetric(horizontal: 10.0,vertical:12.0),
              //     child: ListView(
              //       physics: BouncingScrollPhysics(),
              //       shrinkWrap: true,
              //       scrollDirection: Axis.horizontal,
              //       children:  [
              //         topCategoriesContainer(text: 'Dairy',color: Color(0xffFCCF9B)),
              //         topCategoriesContainer(text: 'Groceries',color: Color(0xffFFB7B7)),
              //         topCategoriesContainer(text: 'Frozen\nFoods',color: Color(0x77AD22D0)),
              //         topCategoriesContainer(text: 'Cupboard\nFood',color: Color(0x7711A551)),
              //         topCategoriesContainer(text: 'Bakery',color: Color(0x77F5DF11)),
              //       ],
              //     ),
              // )),

              // TimeRange(
              //   fromTitle: Text('From', style: TextStyle(fontSize: 18, color: Colors.grey),),
              //   toTitle: Text('To', style: TextStyle(fontSize: 18, color: Colors.grey),),
              //   titlePadding: 20,
              //   textStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
              //   activeTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              //   borderColor: Colors.black45,
              //   backgroundColor: Colors.white,
              //   activeBackgroundColor: Colors.orange,
              //   firstTime: TimeOfDay(hour: 10, minute: 00),
              //   lastTime: TimeOfDay(hour: 9, minute: 00),
              //   timeStep: 10,
              //   timeBlock: 30,
              //   onRangeCompleted: (range) => setState(() => print(range)),
              // ),

              ///Best Sellers
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Best Sellers',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 271, child: HomeSellingProducts()),

              ///banner 3
              GestureDetector(
                onTap: () {
                  FluxNavigate.pushNamed(
                    RouteList.backdrop,
                    arguments: BackDropArguments(
                      cateId:
                          'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODg2NjQxOA==',
                      cateName: 'Chips, Dips & Snacks',
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: h * 0.1655,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/banner2.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzOTg4MjIyNg==',
                            cateName: 'Beverages',
                          ),
                        );
                      },
                      child: Container(
                        height: 97,
                        width: w * 0.47,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/banner3.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.025),
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODQ0MDQzNA==',
                            cateName: 'Fruits & Vegetables',
                          ),
                        );
                      },
                      child: Container(
                        height: 97,
                        width: w * 0.47,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: AssetImage('assets/banner4.png'),
                            )),
                      ),
                    ),
                  ],
                ),
              ),

              // ///Image banner
              // SizedBox(height: 10),
              // Image.asset('assets/banner1.jpg'),

              ///Handpicked for you Text
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Handpicked for you',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 271, child: HomeSellingProducts()),

              ///Refill your food...
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Refill your Food Cupboard',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 8),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          FluxNavigate.pushNamed(
                            RouteList.backdrop,
                            arguments: BackDropArguments(
                              cateId:
                                  'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNzkyMjU0Ng==',
                              cateName: 'Pulses',
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/Pulsesgrid.png',
                          width: w * 0.3,
                        )),
                    SizedBox(width: w * 0.02),
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExNzc5MTQ3NA==',
                            cateName: 'Pasta',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/Pastagrid.png',
                        width: w * 0.3,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDY0MTQ2NTU4Ng==',
                            cateName: 'Mouth Freshner',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/MouthFreshnergrid.jpg',
                        width: w * 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.012),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODUwNTk3MA==',
                            cateName: 'Masala & Spices',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/Masalagrid.png',
                        width: w * 0.3,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNzExODA1MzYxOA==',
                            cateName: 'Jams',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/Jamsgrid.png',
                        width: w * 0.3,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTEzODgzMzY1MA==',
                            cateName: 'Chocolate & Confectionery',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/Chocolategrid.jpg',
                        width: w * 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              ///Fruit direct from Pakistan
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Fruit direct from Pakistan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 271, child: HomeSellingProducts()),

              ///Browse our Beauty Products...
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Browse our Beauty Products',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTUxNDIyNg==',
                            cateName: 'Hair Care',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/HairCaregrid.png',
                        width: w * 0.3,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTU3OTc2Mg==',
                            cateName: 'Face Care',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/FaceCaregrid.png',
                        width: w * 0.3,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTY0NTI5OA==',
                            cateName: 'Oral Care',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/OralCaregrid.jpg',
                        width: w * 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.012),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTYxMjUzMA==',
                            cateName: 'Eye Care',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/EyeCaregrid.png',
                        width: w * 0.3,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTU0Njk5NA==',
                            cateName: 'Body Care',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/BodyCaregrid.png',
                        width: w * 0.3,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    GestureDetector(
                      onTap: () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId:
                                'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQxMDMyOTY3ODA2Ng==',
                            cateName: 'Hand Care',
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/HandCaregrid.jpg',
                        width: w * 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              ///All items 1 - aed 10
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  height: h * 0.1655,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage('assets/banner5.png'),
                    ),
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(6),
              //   child: Container(
              //     height: 125,
              //     decoration: BoxDecoration(
              //       color: Colors.redAccent,
              //       borderRadius: BorderRadius.circular(8)
              //     ),
              //     child: Column(
              //       children: [
              //         SizedBox(height: 20,),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //                 Text('All Items 1 - AED 10',style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 26,
              //                 color: Colors.white),),
              //         ],),
              //         SizedBox(height: 15,),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Container(
              //               height: 40,
              //               width: 190,
              //               decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.circular(12),
              //               ),
              //               child: Center(
              //                 child: Text('Shop Now',style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 16,
              //                 ),),
              //               ),
              //             ),
              //
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // Container(
              //   height: 200,
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: products.length,
              //     itemBuilder: (context,index){
              //       var product= products[index];
              //       return Text(product.name!);
              //     }),
              // )

              //  Services().widget.renderHorizontalListItem(widget.config, cleanCache: widget.cleanCache)

              //   BannerGroupItems(
              //   config: BannerConfig.fromJson(config),
              //   onTap: (itemConfig) {
              //     NavigateTools.onTapNavigateOptions(
              //       context: context,
              //       config: itemConfig,
              //     );
              //   },
              //   key: config['key'] != null ? Key(config['key']) : UniqueKey(),
              // )
              // Services().widget.renderHorizontalListItem(config, cleanCache: cleanCache),
              // Container(
              //   height: 60,
              //   child: FutureBuilder<List<Product>?>(
              //      future: getProducts(),
              //      builder: (context, snapshot) {
              //        var length = snapshot.data?.length ?? 0;
              //        if (snapshot.hasData) {
              //          return Column(
              //            children: List.generate(
              //              length,
              //              (index) => ProductSimpleView(
              //                item: snapshot.data![index],
              //                type: SimpleType.backgroundColor,
              //                enableBackgroundColor: false,
              //              ),
              //            ),
              //          );
              //        }
              //        return Column(
              //          children: List.generate(
              //            length,
              //            (index) => ProductSimpleView(
              //              item: Product.empty(index.toString()),
              //              type: SimpleType.backgroundColor,
              //              enableBackgroundColor: false,
              //            ),
              //          ),
              //        );
              //      },
              //    ),
              // )

              // Padding(
              //    padding:  EdgeInsets.symmetric(horizontal: 10.0,vertical:12.0),
              //    child: Row(
              //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //      children:  [
              //        Text('Trending picks',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
              //      ],
              //    ),
              //  ),

              // BackDropArguments(
              //     cateId: category.id,
              //     cateName: category.name,
              //   ),

              // BannerSlider(
              //     config: BannerConfig.fromJson(config),
              //     onTap: (itemConfig) {
              //       NavigateTools.onTapNavigateOptions(
              //         context: context,
              //         config: itemConfig,
              //       );
              //     },
              //     key: config['key'] != null ? Key(config['key']) : UniqueKey()),
            ],
          );
        }

        return Container();

        if (Config().isBuilder) {
          return ProductRecentPlaceholder();
        }
        return Services().widget.renderHorizontalListItem(widget.config);

        BannerGroupItems(
          config: BannerConfig.fromJson(widget.config),
          onTap: (itemConfig) {
            NavigateTools.onTapNavigateOptions(
              context: context,
              config: itemConfig,
            );
          },
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
        );

      case 'blog':
        return BlogGrid(
          config: BlogConfig.fromJson(widget.config),
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
        );

      case 'video':
        return VideoLayout(
          config: widget.config,
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
        );

      case 'story':
        return StoryWidget(
          config: widget.config,
          onTapStoryText: (cfg) {
            NavigateTools.onTapNavigateOptions(context: context, config: cfg);
          },
        );

      case 'recentView':
        if (Config().isBuilder) {
          return ProductRecentPlaceholder();
        }
        return Services().widget.renderHorizontalListItem(widget.config);

      case 'fourColumn':
      case 'threeColumn':
      case 'twoColumn':
      case 'staggered':
      case 'saleOff':
      case 'card':
      case 'listTile':
        return Services().widget.renderHorizontalListItem(widget.config,
            cleanCache: widget.cleanCache);

      /// New product layout style.
      case 'largeCardHorizontalListItems':
      case 'largeCard':
        return Services()
            .widget
            .renderLargeCardHorizontalListItems(widget.config);
      case 'simpleVerticalListItems':
      case 'simpleList':
        return SimpleVerticalProductList(
          config: ProductConfig.fromJson(widget.config),
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
        );

      case 'brand':
        return BrandLayout(
          config: BrandConfig.fromJson(widget.config),
        );

      /// FluxNews
      case 'sliderList':
        return Services().widget.renderSliderList(widget.config);
      case 'sliderItem':
        return Services().widget.renderSliderItem(widget.config);

      case 'geoSearch':
        return Services().widget.renderGeoSearch(widget.config);
      case 'divider':
        return DividerLayout(
          config: DividerConfig.fromJson(widget.config),
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
        );
      case 'spacer':
        return SpacerLayout(
          config: SpacerConfig.fromJson(widget.config),
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
        );
      case 'button':
        return ButtonLayout(
          config: ButtonConfig.fromJson(widget.config),
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
        );
      case 'testimonial':
        return TestimonialLayout(
          config: TestimonialConfig.fromJson(widget.config),
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
        );
      case 'sliderTestimonial':
        return SliderTestimonial(
          config: SliderTestimonialConfig.fromJson(widget.config),
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
        );
      case 'instagramStory':
        return InstagramStory(
          config: InstagramStoryConfig.fromJson(widget.config),
          key: widget.config['key'] != null
              ? Key(widget.config['key'])
              : UniqueKey(),
        );
      default:
        return const SizedBox();
    }
  }
}

Widget renderCategories(List<Category>? categories, String layout) {
  return Services().widget.renderCategoryLayout(categories, layout);
}