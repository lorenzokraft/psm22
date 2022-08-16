import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fstore/app.dart';
import 'package:fstore/menu/main_layout.dart';
import 'package:fstore/menu/maintab_delegate.dart';
import 'package:fstore/models/app_model.dart';
import 'package:fstore/modules/dynamic_layout/config/app_config.dart';
import 'package:fstore/modules/dynamic_layout/config/tab_bar_floating_config.dart';
import 'package:fstore/modules/dynamic_layout/config/tab_bar_indicator_config.dart';
import 'package:fstore/modules/dynamic_layout/tabbar/tab_indicator/material_indicator.dart';
import 'package:fstore/modules/dynamic_layout/tabbar/tabbar_floating_action.dart';
import 'package:fstore/routes/route.dart';
import 'package:fstore/routes/route_observer.dart';
import 'package:fstore/widgets/overlay/custom_overlay_state.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../menu/maintab.dart';
import '../../../models/index.dart' show CartModel, Product, ProductModel, UserModel;
import '../../../modules/dynamic_layout/config/app_setting.dart';
import '../../../modules/dynamic_layout/config/tab_bar_config.dart';
import '../../../modules/dynamic_layout/tabbar/tabbar_custom.dart';
import '../../../services/index.dart';
import '../../../widgets/product/product_bottom_sheet.dart';
import '../../../widgets/product/widgets/heart_button.dart';
import '../../chat/vendor_chat.dart';
import '../product_detail_screen.dart';
import '../widgets/index.dart';
import '../widgets/product_image_slider.dart';
import 'package:collection/src/iterable_extensions.dart';

class SimpleLayout extends StatefulWidget {
  final Product product;
  final bool isLoading;

  const SimpleLayout({required this.product, this.isLoading = false});

  @override
  // ignore: no_logic_in_create_state
  _SimpleLayoutState createState() => _SimpleLayoutState(product: product);
}

class _SimpleLayoutState extends State<SimpleLayout> with TickerProviderStateMixin  , WidgetsBindingObserver{
  final _scrollController = ScrollController();
  late Product product;

  _SimpleLayoutState({required this.product});

  Map<String, String> mapAttribute = HashMap();
  var _hideController;
  var top = 0.0;
  AppSetting get appSetting => Provider.of<AppModel>(context, listen: true).appConfig!.settings;

  List<TabBarMenuConfig> get tabData => Provider.of<AppModel>(context, listen: false).appConfig!.tabBar;


  final navigators = <int, GlobalKey<NavigatorState>>{};


  /// TabBar variable
  late TabController tabController;
  var isInitialized = false;

  final List<Widget> _tabView = [];
  Map saveIndexTab = {};
  Map<String, String?> childTabName = {};
  int currentTabIndex = 0;

  /// Drawer variable
  bool isShowCustomDrawer = false;

  StreamSubscription? _subOpenCustomDrawer;
  StreamSubscription? _subCloseCustomDrawer;

  // @override
  // Future<void> afterFirstLayout(BuildContext context) async {
  //
  // }

  /// init the Event Bus listening
  void _initListenEvent() {
    _subOpenCustomDrawer = eventBus.on<EventOpenCustomDrawer>().listen((event) {
      setState(() {
        isShowCustomDrawer = true;
      });
    });
    _subCloseCustomDrawer =
        eventBus.on<EventCloseCustomDrawer>().listen((event) {
          setState(() {
            isShowCustomDrawer = false;
          });
        });
  }


  @override
  void initState() {
    super.initState();
    _initListenEvent();
    _initTabDelegate();
    _initTabData(context);
    _hideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(SimpleLayout oldWidget) {
    if (oldWidget.product.type != widget.product.type) {
      setState(() {
        product = widget.product;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Render product default: booking, group, variant, simple, booking
  Widget renderProductInfo() {
    var body;

    if (widget.isLoading == true) {
      body = kLoadingWidget(context);
    } else {
      switch (product.type) {
        case 'appointment':
          return Services().getBookingLayout(product: product);
        case 'booking':
          body = ListingBooking(product);
          break;
        case 'grouped':
          body = GroupedProduct(product);
          break;
        default:
          body = ProductVariant(product);
      }
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: body,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthHeight = size.height;
    //customTabBar();
    printLog('[TabBar] ============== tabbar.dart ==============');

    var appConfig = Provider.of<AppModel>(context, listen: true).appConfig;
    final media = MediaQuery.of(context);

    if (_tabView.isEmpty || appConfig == null) {
      return Container(
        color: Colors.white,
      );
    }

    final userModel = Provider.of<UserModel>(context, listen: false);
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        bottom: false,
        top: kProductDetail.safeArea,
        child: ChangeNotifierProvider(
          create: (_) => ProductModel(),
          child: Stack(
            children: <Widget>[
              Scaffold(
                //bottomNavigationBar: tabBarMenu(),
                floatingActionButton: (!Config().isVendorType() ||
                        !kConfigChat['EnableSmartChat'])
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: VendorChat(
                          user: userModel.user,
                          store: product.store,
                        ),
                      ),
                backgroundColor: Theme.of(context).backgroundColor,
                body: CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      systemOverlayStyle: SystemUiOverlayStyle.light,
                      backgroundColor: Theme.of(context).backgroundColor,
                      elevation: 1.0,
                      expandedHeight:
                          kIsWeb ? 0 : widthHeight * kProductDetail.height,
                      pinned: true,
                      floating: false,
                      leading: Padding(
                        padding: const EdgeInsets.all(8),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: kGrey400,
                            ),
                            onPressed: () {
                              context
                                  .read<ProductModel>()
                                  .clearProductVariations();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        if (widget.isLoading != true)
                          HeartButton(
                            product: product,
                            size: 18.0,
                            color: kGrey400,
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            child: IconButton(
                              icon: const Icon(Icons.more_vert, size: 19),
                              color: kGrey400,
                              onPressed: () => ProductDetailScreen.showMenu(
                                  context, widget.product,
                                  isLoading: widget.isLoading),
                            ),
                          ),
                        ),
                      ],
                      flexibleSpace: kIsWeb
                          ? const SizedBox()
                          : ProductImageSlider(product: product),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          const SizedBox(height: 2),
                          if (kIsWeb)
                            ProductGallery(
                              product: widget.product,
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 4.0,
                              left: 15,
                              right: 15,
                            ),
                            child: product.type == 'grouped'
                                ? const SizedBox()
                                : ProductTitle(product),
                          ),
                        ],
                      ),
                    ),
                    if (kEnableShoppingCart) renderProductInfo(),
                    if (!kEnableShoppingCart && product.shortDescription != null && product.shortDescription!.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ProductShortDescription(product),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          // horizontal: 15.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Column(
                                children: [
                                  Services().widget.renderVendorInfo(product),
                                  ProductDescription(product),
                                  if (kProductDetail.showProductCategories)
                                    ProductDetailCategories(product),
                                  if (kProductDetail.showProductTags)
                                    ProductTag(product),
                                  Services()
                                      .widget
                                      .productReviewWidget(product.id!),
                                ],
                              ),
                            ),
                            RelatedProduct(product),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              // if (kEnableShoppingCart)
              //   Align(
              //     alignment: Alignment.bottomRight,
              //     child: ExpandingBottomSheet(
              //       hideController: _hideController,
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}


extension TabBarMenuExtention on _SimpleLayoutState {
  /// on change tabBar name
  void _onChangeTab(String? nameTab) {
    if (saveIndexTab[nameTab] != null) {
      tabController.animateTo(saveIndexTab[nameTab]);
      _emitChildTabName();
    } else {
      Navigator.of(App.fluxStoreNavigatorKey.currentContext!).pushNamed(nameTab.toString());
    }
  }

  /// init Tab Delegate to use for SmartChat & Ads feature
  void _initTabDelegate() {
    var tabDelegate = MainTabControlDelegate.getInstance();
    tabDelegate.changeTab = _onChangeTab;
    tabDelegate.tabKey = () => navigators[tabController.index];
    tabDelegate.currentTabName = _getCurrentTabName;
    tabDelegate.tabAnimateTo = (int index) {
      tabController.animateTo(index);
    };
    WidgetsBinding.instance!.addObserver(this);
  }

  /// init the tabView data and tabController
  void _initTabData(context) async {
    var appModel = Provider.of<AppModel>(context, listen: false);

    /// Fix the empty loading appConfig on Web
    // if (appModel.appConfig == null && kIsWeb) {
    //   await appModel.loadAppConfig();
    // }

    var tabData = appModel.appConfig!.tabBar;

    for (var i = 0; i < tabData.length; i++) {
      var _dataOfTab = tabData[i];
      saveIndexTab[_dataOfTab.layout] = i;
      print("============================================================-===================================");
      print( saveIndexTab[_dataOfTab.layout]);
      print("============================================================-===================================");

      navigators[i] = GlobalKey<NavigatorState>();
      final initialRoute = _dataOfTab.layout;
      _tabView.add(
        Navigator(
          key: navigators[i],
          initialRoute: initialRoute,
          observers: [
            MyRouteObserver(
              action: (screenName) {
                childTabName[initialRoute!] = screenName;
                OverlayControlDelegate().emitTab?.call(screenName);
              },
            ),
          ],
          onGenerateRoute: (RouteSettings settings) {
            if (settings.name == initialRoute) {
              return Routes.getRouteGenerate(RouteSettings(
                name: initialRoute,
                arguments: _dataOfTab,
              ));
            }
            return Routes.getRouteGenerate(settings);
          },
        ),
      );
    }
    // ignore: invalid_use_of_protected_member
    setState(() {
      tabController = TabController(length: _tabView.length, vsync: this);
    });
    if (MainTabControlDelegate.getInstance().index != null) {
      tabController.animateTo(MainTabControlDelegate.getInstance().index!);
    } else {
      MainTabControlDelegate.getInstance().index = 0;
    }
    isInitialized = true;

    /// Load the Design from FluxBuilder
    tabController.addListener(() {
      if (tabController.index == currentTabIndex) {
        eventBus.fire(EventNavigatorTabbar(tabController.index));
        MainTabControlDelegate.getInstance().index = tabController.index;
      }
    });
  }





  void _emitChildTabName() {
    final tabName = _getCurrentTabName();
    OverlayControlDelegate().emitTab?.call(childTabName[tabName]);
  }

  String _getCurrentTabName() {
    if (saveIndexTab.isEmpty) {
      return '';
    }
    return saveIndexTab.entries
        .firstWhereOrNull((element) => element.value == tabController.index)
        ?.key ??
        '';
  }

  /// on tap on the TabBar icon
  void _onTapTabBar(index) {

    if (currentTabIndex == index) {

      navigators[tabController.index]!.currentState!.popUntil((r) => r.isFirst);

    }
    currentTabIndex = index;

    _emitChildTabName();

    // if (!kIsWeb && !isDesktop) {
    //   if ('cart' == tabData[index].layout) {
    //     FlutterWebviewPlugin().show();
    //   } else {
    //     FlutterWebviewPlugin().hide();
    //   }
    // }
  }

  /// return the tabBar widget
  Widget tabBarMenu() {
    return Selector<CartModel, int>(
      selector: (_, cartModel) => cartModel.totalCartQuantity,
      builder: (context, totalCart, child) {
        return TabBarCustom(
          onTap: _onTapTabBar,
          tabData: tabData,
          tabController: tabController,
          config: appSetting,
          isShowDrawer: isShowCustomDrawer,
          totalCart: totalCart,
        );
      },
    );
  }

  /// Return the Tabbar Floating
  Widget getTabBarMenuAction() {
    var position = appSetting.tabBarConfig.tabBarFloating.position;
    var itemIndex = (position != null && position < tabData.length)
        ? position
        : (tabData.length / 2).floor();

    return Selector<CartModel, int>(
      selector: (_, cartModel) => cartModel.totalCartQuantity,
      builder: (context, totalCart, child) {
        return IconFloatingAction(
          config: appSetting.tabBarConfig.tabBarFloating,
          item: tabData[itemIndex].jsonData,
          onTap: () {
            tabController.animateTo(itemIndex);
            _onTapTabBar(itemIndex);
          },
          totalCart: totalCart,
        );
      },
    );
  }

  void customTabBar() {
    /// Design TabBar style
    appSetting.tabBarConfig
      ..colorIcon = HexColor('7A7B7F')
      ..colorActiveIcon = HexColor('FF672D')
      ..indicatorStyle = IndicatorStyle.none
      ..showFloating = true
      ..showFloatingClip = false
      ..tabBarFloating = TabBarFloatingConfig(
        color: HexColor('FF672D'),
        // width: 65,
        // height: 40,
      );
  }

  /// custom the TabBar Style
  void customTabBar3() {
    /// Design TabBar style
    appSetting.tabBarConfig
      ..colorIcon = HexColor('7A7B7F')
      ..colorActiveIcon = HexColor('FF672D')
      ..indicatorStyle = IndicatorStyle.none
      ..showFloating = true
      ..showFloatingClip = false
      ..tabBarFloating = TabBarFloatingConfig(
        color: HexColor('FF672D'),
        width: 70,
        height: 70,
        elevation: 10.0,
        floatingType: FloatingType.diamond,
        // width: 65,
        // height: 40,
      );
  }

  void customTabBar2() {
    /// Design TabBar style
    appSetting.tabBarConfig
      ..colorCart = HexColor('FE2060')
      ..colorIcon = HexColor('7A7B7F')
      ..colorActiveIcon = HexColor('1D34C5')
      ..indicatorStyle = IndicatorStyle.material
      ..showFloating = true
      ..showFloatingClip = true
      ..tabBarFloating = TabBarFloatingConfig(
        color: HexColor('1D34C5'),
        elevation: 2.0,
      )
      ..tabBarIndicator = TabBarIndicatorConfig(
        color: HexColor('1D34C5'),
        verticalPadding: 10,
        tabPosition: TabPosition.top,
        topLeftRadius: 0,
        topRightRadius: 0,
        bottomLeftRadius: 10,
        bottomRightRadius: 10,
      );
  }

  void customTabBar1() {
    /// Design TabBar style 1
    appSetting.tabBarConfig
      ..color = HexColor('1C1D21')
      ..colorCart = HexColor('FE2060')
      ..isSafeArea = false
      ..marginBottom = 15.0
      ..marginLeft = 15.0
      ..marginRight = 15.0
      ..paddingTop = 12.0
      ..paddingBottom = 12.0
      ..radiusTopRight = 15.0
      ..radiusTopLeft = 15.0
      ..radiusBottomRight = 15.0
      ..radiusBottomLeft = 15.0
      ..paddingRight = 10.0
      ..indicatorStyle = IndicatorStyle.rectangular
      ..tabBarIndicator = TabBarIndicatorConfig(
        color: HexColor('22262C'),
        topRightRadius: 9.0,
        topLeftRadius: 9.0,
        bottomLeftRadius: 9.0,
        bottomRightRadius: 9.0,
        distanceFromCenter: 10.0,
        horizontalPadding: 10.0,
      );
  }
}

