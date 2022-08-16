import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/app_model.dart';
import '../../models/cart/cart_base.dart';
import '../../models/notification_model.dart';
import '../../modules/dynamic_layout/config/logo_config.dart';
import '../../modules/dynamic_layout/dynamic_layout.dart';
import '../../modules/dynamic_layout/logo/logo.dart';
import '../../screens/blog/models/list_blog_model.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/common/app_bar_mixin.dart';
import '../../services/index.dart';
import 'preview_overlay.dart';

class HomeLayout extends StatefulWidget {
  final configs;
  final bool isPinAppBar;
  final bool isShowAppbar;
  final bool showNewAppBar;

  const HomeLayout({
    this.configs,
    this.isPinAppBar = false,
    this.isShowAppbar = true,
    this.showNewAppBar = false,
    Key? key,
  }) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with AppBarMixin {
   List widgetData=[];

  bool isPreviewingAppBar = false;

  bool cleanCache = false;

  @override
  void initState() {
    /// init config data
    widgetData =
        List<Map<String, dynamic>>.from(widget.configs['HorizonLayout']);
    if (widgetData.isNotEmpty && widget.isShowAppbar && !widget.showNewAppBar) {
      widgetData.removeAt(0);
    }

    /// init single vertical layout
    if (widget.configs['VerticalLayout'] != null &&
        widget.configs['VerticalLayout'].isNotEmpty) {
      Map verticalData =
          Map<String, dynamic>.from(widget.configs['VerticalLayout']);
      verticalData['type'] = 'vertical';
      widgetData.add(verticalData);
    }

    /// init multi vertical layout
    if (widget.configs['VerticalLayouts'] != null) {
      List verticalLayouts = widget.configs['VerticalLayouts'];
      for (var i = 0; i < verticalLayouts.length; i++) {
        Map verticalData = verticalLayouts[i];
        verticalData['type'] = 'vertical';
        widgetData.add(verticalData);
      }
    }

    super.initState();
  }

  @override
  void didUpdateWidget(HomeLayout oldWidget) {
    if (oldWidget.configs != widget.configs) {
      /// init config data
      List data =
          List<Map<String, dynamic>>.from(widget.configs['HorizonLayout']);
      if (data.isNotEmpty && widget.isShowAppbar && !widget.showNewAppBar) {
        data.removeAt(0);
      }

      /// init vertical layout
      if (widget.configs['VerticalLayout'] != null) {
        Map verticalData =
            Map<String, dynamic>.from(widget.configs['VerticalLayout']);
        verticalData['type'] = 'vertical';
        data.add(verticalData);
      }
      setState(() {
        widgetData = data;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  SliverAppBar renderAppBar() {
    List<dynamic> horizonLayout = widget.configs['HorizonLayout'] ?? [];
    Map logoConfig = horizonLayout.firstWhere((element) => element['layout'] == 'logo',
        orElse: () => Map<String, dynamic>.from({}));
    var config = LogoConfig.fromJson(logoConfig);

    /// customize theme
    // config
    //   ..opacity = 0.9
    //   ..iconBackground = HexColor('DDDDDD')
    //   ..iconColor = HexColor('330000')
    //   ..iconOpacity = 0.8
    //   ..iconRadius = 40
    //   ..iconSize = 24
    //   ..cartIcon = MenuIcon(name: 'cart')
    //   ..showSearch = false
    //   ..showLogo = true
    //   ..showCart = true
    //   ..showMenu = true;

    return SliverAppBar(
      pinned: widget.isPinAppBar,
      snap: true,
      floating: true,
      titleSpacing: 0,
      elevation: 0,
      forceElevated: true,
      backgroundColor: config.color ??
          Theme.of(context).backgroundColor.withOpacity(config.opacity),
      title: PreviewOverlay(
          index: 0,
          config: logoConfig as Map<String, dynamic>?,
          builder: (value) {
            final appModel = Provider.of<AppModel>(context, listen: true);
            return Selector<CartModel, int>(
              selector: (_, cartModel) => cartModel.totalCartQuantity,
              builder: (context, totalCart, child) {
                return Logo(
                  key: value['key'] != null ? Key(value['key']) : UniqueKey(),
                  config: config,
                  logo: appModel.themeConfig.logo,
                  notificationCount:
                      Provider.of<NotificationModel>(context).unreadCount,
                  totalCart: totalCart,
                  onSearch: () =>
                      Navigator.of(context).pushNamed(RouteList.homeSearch),
                  onTapNotifications: () {
                    Navigator.of(context).pushNamed(RouteList.notify);
                  },
                  onCheckout: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Scaffold(
                          backgroundColor: Theme.of(context).backgroundColor,
                          body: const CartScreen(isModal: false),
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  onTapDrawerMenu: () => NavigateTools.onTapOpenDrawerMenu(context),
                );
              },
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.configs == null) return const SizedBox();

    ErrorWidget.builder = (error) {
      if (kReleaseMode) {
        return const SizedBox();
      }
      return Container(
        constraints: const BoxConstraints(minHeight: 150),
        decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        /// Hide error, if you're developer, enable it to fix error it has
        child: Center(
          child: Text('Error in ${error.exceptionAsString()}'),
        ),
      );
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: CustomScrollView(
            cacheExtent: 2000.0,
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(

                onRefresh: () async {
                  await Provider.of<ListBlogModel>(context, listen: false)
                      .getBlogs();

                  // refresh the product request and clean up cache
                  setState(() => cleanCache = true);
                  await Future<void>.delayed(const Duration(milliseconds: 1000));
                  setState(() => cleanCache = false);

                  /// reload app config
                  await Provider.of<AppModel>(context, listen: false)
                      .loadAppConfig();
                },
              ),
               if (widget.showNewAppBar) sliverAppBarWidget,
            //Todo this is App Bar
            //  if (widget.isShowAppbar && !widget.showNewAppBar) renderAppBar(),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var config = widgetData[index];

                    /// if show app bar, the preview should plus +1
                    var previewIndex = widget.isShowAppbar ? index + 1 : index;

                    if (config['type'] != null && config['type'] == 'vertical') {
                      return PreviewOverlay(
                          index: previewIndex,
                          config: config,
                          builder: (value) {
                            return Services().widget.renderVerticalLayout(value);
                          });
                    }

                    return PreviewOverlay(
                      index: previewIndex,
                      config: config,
                      builder: (value) {
                        return DynamicLayout(config: value, cleanCache: cleanCache);
                      },
                    );
                  },
                  childCount: widgetData.length,
                ),
              ),

            ],
          ),
        ),
        const _FakeStatusBar(),
      ],
    );
  }
}

class _FakeStatusBar extends StatelessWidget {
  const _FakeStatusBar();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: const SafeArea(
          bottom: false,
          child: SizedBox(),
        ),
      ),
    );
  }
}
