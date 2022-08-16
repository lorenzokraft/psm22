import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../../common/config.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show Store, User;
import 'chat_arguments.dart';
import 'chat_mixin.dart';
import 'scale_animation_mixin.dart';
import 'smartchat.dart';

class VendorChat extends StatefulWidget {
  final Store? store;
  final User? user;

  const VendorChat({this.store, this.user});

  @override
  _VendorChatState createState() => _VendorChatState();
}

class _VendorChatState extends State<VendorChat>
    with ChatMixin, ScaleAnimationMixin, SingleTickerProviderStateMixin {
  Store? get store => widget.store;

  User? get user => widget.user;

  bool get showAdminChat => store == null || store?.phone == null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      options = getSmartChatOptions();
    });
  }

  List<Map> getSmartChatOptions() {
    final _options = [];
    if (showAdminChat) return Configurations.smartChat;
    if (isNotBlank(store!.email) && isNotBlank(store!.name) && user != null) {
      _options.add({
        'app': 'store',
        'description': S.of(context).chatWithStoreOwner,
        'iconData': Icons.home_work_outlined,
      });
    }
    if (store!.socials != null && store!.socials!['facebook'] != null) {
      _options.add({
        'app': store!.socials!['facebook']!.contains('http')
            ? store!.socials!['facebook']
            : 'https://m.me/${store!.socials!["facebook"]}',
        'description': S.of(context).chatViaFacebook,
        'iconData': Icons.facebook
      });
    }
    if (isNotBlank(store!.phone)) {
      _options.add({
        'app': 'https://wa.me/${store!.phone}',
        'description': store!.phone,
        'iconData': Icons.chat,
      });
      _options.add({
        'app': 'tel:${store!.phone}',
        'description': store!.phone,
        'iconData': Icons.phone,
      });
      _options.add({
        'app': 'sms://${store!.phone}',
        'description': store!.phone,
        'iconData': Icons.sms,
      });
    }
    return List<Map>.from(_options);
  }

  @override
  Widget build(BuildContext context) {
    if (showAdminChat) {
      return const SmartChat();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ScaleTransition(
        scale: scaleAnimation,
        alignment: Alignment.center,
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Theme.of(context).backgroundColor,
          onPressed: () async {
            if (scaleAnimationController.isCompleted) {
              Future.delayed(Duration.zero, scaleAnimationController.reverse);
              await Future.delayed(const Duration(milliseconds: 80), () {});
              await showActionSheet(
                context: context,
                storeArguments: ChatArguments(
                  senderUser: user,
                  receiverEmail: store!.chatEmail,
                  receiverName: store!.name,
                ),
              );
              await scaleAnimationController.forward();
            }
          },
          child: Icon(
            CupertinoIcons.conversation_bubble,
            color: Theme.of(context).primaryColor,
            size: 32,
          ),
        ),
      ),
    );
  }

  @override
  TickerProvider get vsync => this;
}
