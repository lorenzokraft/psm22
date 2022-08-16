import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/config.dart';

class LoadingBody extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingBody({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.green.shade700,
      ),
    );
    return Stack(
      children: [
        child,
        Visibility(
          visible: isLoading,
          child: Center(
            child: Container(
              color: Colors.black45,
              child: kLoadingWidget(context),
            ),
          ),
        )
      ],
    );
  }
}
