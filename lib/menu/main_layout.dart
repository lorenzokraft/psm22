import 'dart:async';

import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../common/tools.dart';

class MainLayout extends StatefulWidget {
  final Widget? menu;
  final Widget? content;

  const MainLayout({
    Key? key,
    this.menu,
    this.content,
  }) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  bool showMenu = false;
  bool isFirstRun = false;

  Duration duration = const Duration(milliseconds: 600);

  bool get isBigScreen => isDisplayDesktop(context);

  StreamSubscription? _subOpenCustomDrawer;
  StreamSubscription? _subCloseCustomDrawer;
  StreamSubscription? _subSwitchStateCustomDrawer;

  @override
  void initState() {
    super.initState();
    _subOpenCustomDrawer = eventBus.on<EventOpenCustomDrawer>().listen((event) {
      if (!showMenu) {
        setState(() {
          showMenu = true;
        });
      }
    });
    _subCloseCustomDrawer =
        eventBus.on<EventCloseCustomDrawer>().listen((event) {
      if (showMenu) {
        setState(() {
          showMenu = false;
        });
      }
    });
    _subSwitchStateCustomDrawer =
        eventBus.on<EventSwitchStateCustomDrawer>().listen((event) {
      if (showMenu) {
        eventBus.fire(const EventCloseCustomDrawer());
      } else {
        eventBus.fire(const EventOpenCustomDrawer());
      }
    });
  }

  void initLayout() {
    if (!isFirstRun) {
      if (isDisplayDesktop(context)) {
        showMenu = true;
        isFirstRun = true;
      }
    }
  }

  @override
  void dispose() {
    _subOpenCustomDrawer?.cancel();
    _subCloseCustomDrawer?.cancel();
    _subSwitchStateCustomDrawer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = 0.0;
    initLayout();
    if (isDisplayDesktop(context)) {
      if (showMenu) {
        width = kSizeLeftMenu;
      } else {
        width = 0;
      }
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedContainer(
              width: width,
              curve: Curves.easeInOutQuint,
              duration: duration,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(bottom: 32),
              color: Theme.of(context).primaryColorLight.withOpacity(0.7),
              child: OverflowBox(
                maxWidth: kSizeLeftMenu,
                maxHeight: 1000,
                alignment:
                    context.isRtl ? Alignment.topLeft : Alignment.topRight,
                child: widget.menu,
              ),
            ),
            Expanded(
              child: widget.content!,
            )
          ],
        ),
      ),
    );
  }
}
