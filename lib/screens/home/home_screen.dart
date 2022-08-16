import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/app_model.dart';
import '../../modules/dynamic_layout/index.dart';
import '../../services/index.dart';
import '../../utils.dart';
import '../../widgets/home/index.dart';
import '../../widgets/home/preview_reload.dart';
import '../../widgets/home/wrap_status_bar.dart';
import '../base_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends BaseScreen<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    printLog('[Home] dispose');
    super.dispose();
  }

  @override
  void initState() {
    printLog('[Home] initState');
    super.initState();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    /// init dynamic link
    if (!kIsWeb) {
      Services().firebase.initDynamicLinkService(context);
    }
  }

  alertDialogPop() {

    // set up the AlertDialog
    showDialog(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            //title: Text("My title"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Padding(
                  padding: EdgeInsets.only(top:10),
                  child: Row(
                    children: [
                      Text('Are you sure?',
                          style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 15)),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top:10),
                  child: Row(
                    children: [
                      Text('Do you want to exit an App',
                          style:TextStyle(color:Colors.black,fontSize: 13)),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed:() {
                            Navigator.of(dialogContext).pop();
                          },
                          child:   const Text('No',style: TextStyle(color: Colors.blue))
                      ),

                      TextButton(
                          onPressed:() {
                            SystemNavigator.pop();
                          },
                          child:   const Text('Yes',style: TextStyle(color: Colors.blue))
                      ),

                    ],
                  ),
                ),

              ],
            ),


          );

        }


    ); }

  @override
  Widget build(BuildContext context) {
   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent, // status bar color
    ));

    super.build(context);
    printLog('[Home] build');
    return WillPopScope(
      onWillPop: ()async{
        showSuccessToast('ok kro');
        return alertDialogPop();

      },
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          if (value.appConfig == null) {
            return kLoadingWidget(context);
          }

          return PreviewReload(
            configs: value.appConfig!.jsonData,
            builder: (json) {
              var isStickyHeader = value.appConfig!.settings.stickyHeader;
              var appConfig = AppConfig.fromJson(json);
              final horizontalLayoutList = List.from(json['HorizonLayout']);
              final isShowAppbar = horizontalLayoutList.isNotEmpty &&
                  horizontalLayoutList.first['layout'] == 'logo';

              return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: Stack(
                children: <Widget>[
                  if (appConfig.background != null)
                    isStickyHeader
                        ? SafeArea(
                            child: HomeBackground(config: appConfig.background),
                          )
                        : HomeBackground(config: appConfig.background),
                  HomeLayout(
                    isPinAppBar: isStickyHeader,
                    isShowAppbar: isShowAppbar,
                    showNewAppBar: appConfig.appBar?.shouldShowOn(RouteList.home) ?? false,
                    configs: json,
                    key: UniqueKey(),
                  ),
                  if (Config().isBuilder) const WrapStatusBar(),
                ],
              ),
              );
            },
          );
        },
      ),
    );
  }
}
