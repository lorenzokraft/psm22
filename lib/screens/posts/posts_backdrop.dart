import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart'
    show AppModel, Blog, BlogModel, Category, Product;
import '../../widgets/backdrop/backdrop.dart';
import '../../widgets/backdrop/backdrop_menu.dart';
import '../../widgets/blog/blog_list_backdrop.dart';

class BlogsArgument {
  final dynamic cateId;
  final String? cateName;
  final List<Blog>? blogs;
  final dynamic config;

  BlogsArgument({
    this.cateId,
    this.cateName,
    this.blogs,
    this.config,
  });
}

class BlogsPage extends StatefulWidget {
  final List<Blog>? blogs;
  final dynamic categoryId;
  final config;

  const BlogsPage({this.blogs, this.categoryId, this.config});

  @override
  _BlogsPageState createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage>
    with SingleTickerProviderStateMixin {
  dynamic newCategoryId = -1;
  double? minPrice;
  double? maxPrice;
  String? orderBy;
  String? order;
  bool isFiltering = false;
  List<Product> products = [];
  List<Category> categories = [];
  String? errMsg;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      newCategoryId = widget.categoryId;
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );

    if (widget.config != null) {
      onRefresh();
    }
  }

  void onFilter({
    minPrice,
    maxPrice,
    categoryId,
    categoryName,
    tagId,
    attribute,
    currentSelectedTerms,
    listingLocationId,
  }) {
    _controller.forward();

    final blogModel = Provider.of<BlogModel>(context, listen: false);
    newCategoryId = categoryId;
    this.minPrice = minPrice;
    this.maxPrice = maxPrice;
    blogModel.setBlogNewsList(null);
    blogModel.getBlogsList(
      categoryId: categoryId,
      categoryName: categoryName,
      page: 1,
      lang: Provider.of<AppModel>(context, listen: false).langCode,
      orderBy: orderBy,
      order: order,
    );
  }

  void onSort(order) {
    orderBy = 'date';
    this.order = order;
    Provider.of<BlogModel>(context, listen: false).getBlogsList(
      categoryId: newCategoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      lang: Provider.of<AppModel>(context, listen: false).langCode,
      page: 1,
      orderBy: orderBy,
      order: order,
    );
  }

  Future<void> onRefresh() async {
    if (widget.config == null) {
      await Provider.of<BlogModel>(context, listen: false).getBlogsList(
          categoryId: newCategoryId,
          // minPrice: minPrice,
          // maxPrice: maxPrice,
          lang: Provider.of<AppModel>(context, listen: false).langCode,
          page: 1,
          orderBy: orderBy,
          order: order);
    }
  }

  void onLoadMore(page) {
    Provider.of<BlogModel>(context, listen: false).getBlogsList(
        categoryId: newCategoryId,
        // minPrice: minPrice,
        // maxPrice: maxPrice,
        lang: Provider.of<AppModel>(context, listen: false).langCode,
        page: page,
        orderBy: orderBy,
        order: order);
  }

  @override
  Widget build(BuildContext context) {
    final blog = Provider.of<BlogModel>(context);
    final title = blog.categoryName ?? S.of(context).blog;
    final layout = widget.config != null && widget.config['layout'] != null
        ? widget.config['layout']
        : Provider.of<AppModel>(context).productListLayout;
    var _textColor = Colors.white;

    _PostBackdrop backdrop({blogs, isFetching, errMsg, isEnd}) => _PostBackdrop(
          backdrop: Backdrop(
            frontLayer: BlogListBackdrop(
              blogs: blogs,
              onRefresh: onRefresh,
              onLoadMore: onLoadMore,
              isFetching: isFetching,
              errMsg: errMsg,
              isEnd: isEnd,
              layout: layout,
            ),
            backLayer: BackdropMenu(
              onFilter: onFilter,
              showCategory: true,
              showPrice: false,

              /// we need to use the Blog menu data inside Woo/Vendor app
              /// apply for the dynamic Blog on home screen.
              isUseBlog: serverConfig['type'] != 'wordpress',
            ),
            frontTitle: Text(title, style: TextStyle(color: _textColor)),
            backTitle: Text(
              S.of(context).filter,
              style: TextStyle(color: _textColor),
            ),
            controller: _controller,
            onSort: onSort,
          ),
        );

    return ListenableProvider.value(
      value: blog,
      child: Consumer<BlogModel>(builder: (context, value, child) {
        return backdrop(
            blogs: value.blogList,
            isFetching: value.isFetching,
            errMsg: value.errMsg,
            isEnd: value.isEnd);
      }),
    );
  }
}

class _PostBackdrop extends StatelessWidget {
//  final ExpandingBottomSheet expandingBottomSheet;
  final Backdrop backdrop;

  const _PostBackdrop({Key? key, required this.backdrop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        backdrop,
      ],
    );
  }
}
