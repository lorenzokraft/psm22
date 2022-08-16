import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:fwfh_cached_network_image/fwfh_cached_network_image.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_url_launcher/fwfh_url_launcher.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

class HtmlWidget extends StatelessWidget {
  final String html;
  final TextStyle? textStyle;

  const HtmlWidget(this.html, {Key? key, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _textStyle = textStyle ?? Theme.of(context).textTheme.bodyText1;
    var _html = html.replaceAll('src="//', 'src="https://');

    return core.HtmlWidget(
      _html,
      textStyle: _textStyle,
      factoryBuilder: MyWidgetFactory.new,
    );
  }
}

class MyWidgetFactory extends core.WidgetFactory
    with
        WebViewFactory,
        CachedNetworkImageFactory,
        UrlLauncherFactory,
        ChewieFactory,
        SvgFactory {
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;
}
