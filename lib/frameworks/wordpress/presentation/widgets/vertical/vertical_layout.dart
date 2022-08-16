import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../common/constants.dart';
import '../../../../../common/tools.dart';
import '../../../../../modules/dynamic_layout/config/blog_config.dart';
import '../../../../../routes/flux_navigate.dart';
import '../../../../../screens/blog/index.dart';
import '../../../../../services/index.dart';
import '../../../../../widgets/blog/blog_card_view.dart';
import 'vertical_simple_list.dart';

class VerticalViewLayout extends StatefulWidget {
  final BlogConfig config;

  const VerticalViewLayout({required this.config, Key? key}) : super(key: key);

  @override
  _VerticalViewLayoutState createState() => _VerticalViewLayoutState();
}

class _VerticalViewLayoutState extends State<VerticalViewLayout> {
  final Services _service = Services();
  List<Blog> _blogs = [];
  int _page = 0;
  bool canLoad = true;
  BlogCardType get type => widget.config.cardDesign;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    var config = widget.config.toJson();
    _page = _page + 1;
    config['page'] = _page;
    if (!canLoad) return;
    var newBlogs = await _service.api.fetchBlogLayout(config: config);
    if (newBlogs?.isEmpty ?? true) {
      setState(() {
        canLoad = false;
      });
    } else {
      setState(() {
        _blogs = [..._blogs, ...newBlogs!];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthContent = 0.0;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = Tools.isTablet(MediaQuery.of(context));
    final widthScreen = screenSize.width;
    if (widget.config.layout == 'card') {
      widthContent = widthScreen; //one column
    } else if (widget.config.layout == 'columns') {
      widthContent =
          isTablet ? widthScreen / 4 : (widthScreen / 3) - 15; //three columns
    } else {
      //layout is list
      widthContent =
          isTablet ? widthScreen / 3 : (widthScreen / 2) - 20; //two columns
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Wrap(
              children: <Widget>[
                for (var i = 0; i < _blogs.length; i++)
                  widget.config.layout == 'list'
                      ? SimpleListView(
                          item: _blogs[i],
                          type: SimpleListType.backgroundColor,
                          listBlog: _blogs,
                        )
                      : BlogCard(
                          item: _blogs[i],
                          width: widthContent,
                          config: widget.config,
                          onTap: () {
                            if (_blogs[i].imageFeature == '') return;
                            FluxNavigate.pushNamed(
                              RouteList.detailBlog,
                              arguments: BlogDetailArguments(
                                blog: _blogs[i],
                                listBlog: _blogs,
                              ),
                            );
                          },
                        ),
              ],
            ),
          ),
          VisibilityDetector(
            key: const Key('loading_vertical'),
            onVisibilityChanged: (VisibilityInfo info) => _loadProduct(),
            child: (!canLoad)
                ? Container()
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Center(
                      child: Text('Loading'),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
