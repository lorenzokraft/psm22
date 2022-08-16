import 'package:flutter/material.dart';
import 'package:fstore/screens/map/Home-delivery.dart';
import 'package:fstore/services/services.dart';
import 'package:fstore/widgets/discount-container.dart';
import 'package:fstore/widgets/product/product_simple_view.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/app_model.dart';
import '../../models/category_model.dart';
import '../../models/filter_attribute_model.dart';
import '../../models/filter_tags_model.dart';
import '../../models/index.dart';
import '../../models/search_model.dart';
import '../../models/user_model.dart';
import '../common/app_bar_mixin.dart';
import '../map/Base-delivery-mode.dart';
import 'widgets/filters/filter_search.dart';
import 'widgets/recent/recent_search_custom.dart';
import 'widgets/search_box.dart';
import 'widgets/search_results_custom.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatefulWidget {
  final isModal;

  const SearchScreen({Key? key, this.isModal}) : super(key: key);

  @override
  _StateSearchScreen createState() => _StateSearchScreen();
}

class _StateSearchScreen extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen>, AppBarMixin {
  @override
  bool get wantKeepAlive => true;

  final _searchFieldNode = FocusNode();
  final _searchFieldController = TextEditingController();

  bool isVisibleSearch = false;
  bool _showResult = false;
  List<String>? _suggestSearch;
  List<Product> products=[];




  SearchModel get _searchModel =>
      Provider.of<SearchModel>(context, listen: false);

  String get _searchKeyword => _searchFieldController.text;

  List<String> get suggestSearch =>
      _suggestSearch
          ?.where((s) => s.toLowerCase().contains(_searchKeyword.toLowerCase()))
          .toList() ??
      <String>[];

  void _onFocusChange() {
    if (_searchKeyword.isEmpty && !_searchFieldNode.hasFocus) {
      _showResult = false;
    } else {
      _showResult = !_searchFieldNode.hasFocus;
    }

    // Delayed keyboard hide and show
    Future.delayed(const Duration(milliseconds: 120), () {
      setState(() {
        isVisibleSearch = _searchFieldNode.hasFocus;
      });
    });
  }


  Future<List<Product>?> getProductsByCategoryId() async {
    try {
      products = (await Services().api.fetchProductsByCategory(
            categoryId: 'Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzQwNTQwNzM2NzQxMA==',
            page: 1,
          ))!;
      setState(() {});

    } catch (e) {
    return [];
    }
  }





  @override
  void initState() {
    super.initState();
    printLog('[SearchScreen] initState');
    _searchFieldNode.addListener(_onFocusChange);
    getProductsByCategoryId();
  }

  @override
  void dispose() {
    printLog('[SearchScreen] dispose');
    _searchFieldNode.dispose();
    _searchFieldController.dispose();
    super.dispose();
  }

  void _onSearchTextChange(String value) {
    if (value.isEmpty) {
      _showResult = false;
      setState(() {});
      return;
    }
    if (_searchFieldNode.hasFocus) {
      if (suggestSearch.isEmpty) {
        final _userId = Provider.of<UserModel>(context, listen: false).user?.id;
        setState(() {
          _showResult = true;
          _searchModel.loadProduct(name: value, userId: _userId);
        });
      } else {
        setState(() {
          _showResult = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getProductsByCategoryId();

    printLog('[SearchScreen] build');
    super.build(context);
    _suggestSearch = Provider.of<AppModel>(context).appConfig!.searchSuggestion ?? [''];
    final screenSize = MediaQuery.of(context).size;
    // double widthSearchBox =
    //     screenSize.width / (2 / (screenSize.height / screenSize.width));
    final _userId = Provider.of<UserModel>(context, listen: false).user?.id;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      // appBar: _renderAppbar(screenSize),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: (){
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
                          padding: const EdgeInsets.only(top:4.0,bottom: 4.0),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width*0.93,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0XFFF0F0F0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(Icons.search,size: 22),
                                ),
                                SizedBox(width: 10),
                                Text('What are you looking for?',
                                  style: TextStyle(color: Colors.grey.shade500,fontSize: 15),),
                              ],),


                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context , rootNavigator: true).pushReplacement(
                      MaterialPageRoute(builder: (context) => BaseDeliveryMode(fromHome: true)));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(0.0, 5)
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Row(
                            children:  [
                              const Icon(Icons.location_on_rounded,color: Colors.white),
                              const SizedBox(width: 5),
                              Container(
                                  width: 250,
                                  child: Text(address,style: const TextStyle(color: Colors.white,fontSize: 10))),
                            ],
                          ),
                          const Text('CHANGE',style: TextStyle(color:Colors.white))
                        ],
                      ),
                    ),
                  ),
                ),
              ),

             // _renderHeader(),
              // SearchBox(
              //   // width: widthSearchBox,
              //   controller: _searchFieldController,
              //   focusNode: _searchFieldNode,
              //   onChanged: _onSearchTextChange,
              //   onSubmitted: _onSubmit,
              //   onCancel: () {
              //     setState(() {
              //       isVisibleSearch = false;
              //     });
              //   },
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child: SizedBox(
                    height: 32,
                    child: FilterSearch(
                      onChange: (searchFilter) {
                        _searchModel.searchByFilter(
                          searchFilter,
                          _searchKeyword,
                          userId: _userId,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              dealsContainer(title: 'Upto 40% discount',color: const Color(0xff11A551),subTitle: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',onPressed: (){}),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text('Food Deals of the Day',style: TextStyle(fontWeight: FontWeight.w600,fontSize:14)),
              ),
              SizedBox(height: 20),
              products.isEmpty ? Center(child: CircularProgressIndicator()) :
              ///deals data
              SizedBox(
                height: 271,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics:const  BouncingScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context,index){
                    return ProductSimpleView(
                      item: products[index],
                      type: SimpleType.backgroundColor,
                      enableBackgroundColor: false,
                    );
                  },
                ),
              ),


              // FutureBuilder<List<Product>?>(
              //   future: getProductsByCategoryId(),
              //   builder: (context, snapshot) {
              //     var length = snapshot.data?.length ?? 0;
              //     if (snapshot.hasData) {
              //       return Column(
              //         children: List.generate(
              //           length,
              //               (index) => ProductSimpleView(
              //             item: snapshot.data![index],
              //             type: SimpleType.backgroundColor,
              //             enableBackgroundColor: false,
              //           ),
              //         ),
              //       );
              //     }
              //     return Column(
              //       children: List.generate(
              //           length,
              //               (index) => ProductSimpleView(
              //               item: Product.empty(index.toString()),
              //               type: SimpleType.backgroundColor,
              //               enableBackgroundColor: false)),
              //     );
              //   },
              // ),

              // Container(
              //   height: 100,
              //   child: Builder(builder: (context) {
              //   return  FutureBuilder<List<Product>?>(
              //       future: getProductsByCategoryId(),
              //       builder: (context, snapshot) {
              //         var length = snapshot.data?.length ?? 0;
              //         print(snapshot.data!.toList());
              //         if (snapshot.hasData) {
              //           return Column(
              //             children: List.generate(
              //               length,
              //               (index) => ProductSimpleView(
              //                 item: snapshot.data![index],
              //                 type: SimpleType.backgroundColor,
              //                 enableBackgroundColor: false,
              //               ),
              //             ),
              //           );
              //         }
              //         return Column(
              //           children: List.generate(
              //             length,
              //             (index) => ProductSimpleView(
              //               item: Product.empty(index.toString()),
              //               type: SimpleType.backgroundColor,
              //               enableBackgroundColor: false,
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //
              //
              //   }),
              // ),



              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                reverseDuration: const Duration(milliseconds: 300),
                child: _showResult
                    ? buildResult()
                    : Align(
                        alignment: Alignment.topCenter,
                        child: Consumer<FilterTagModel>(
                          builder: (context, tagModel, child) {
                            return Consumer<CategoryModel>(
                              builder: (context, categoryModel, child) {
                                return Consumer<FilterAttributeModel>(
                                  builder: (context, attributeModel, child) {
                                    if (tagModel.isLoading ||
                                        categoryModel.isLoading ||
                                        attributeModel.isLoading) {
                                      return kLoadingWidget(context);
                                    }
                                    ///you haven't searched for items yet....
                                    var child = _buildRecentSearch();

                                    if (_searchFieldNode.hasFocus &&
                                        suggestSearch.isNotEmpty) {
                                      child = _buildSuggestions();
                                    }

                                    return child;
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? _renderAppbar(Size screenSize) {
    if (widget.isModal != null) {
      return AppBar(
        elevation: 0.1,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          S.of(context).search,
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        leading: Navigator.of(context).canPop()
            ? Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
              )
            : const SizedBox(),
      );
    }
    if (showAppBar(RouteList.search)) {
      return appBarWidget;
    }
    return null;
  }

  Widget _renderHeader() {
    final screenSize = MediaQuery.of(context).size;
    Widget _headerContent = const SizedBox(height: 10.0);
    if (widget.isModal == null) {
      _headerContent = AnimatedContainer(
        height: isVisibleSearch ? 0.1 : 58,
        padding: const EdgeInsets.only(
          left: 10,
          top: 10,
          bottom: 10,
        ),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              S.of(context).search,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: screenSize.width / (2 / (screenSize.height / screenSize.width)),
      child: _headerContent,
    );
  }

  Widget _buildRecentSearch() {
    return RecentSearchesCustom(onTap: _onSubmit);
  }

  Widget _buildSuggestions() {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Theme.of(context).primaryColorLight,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        itemCount: suggestSearch.length,
        itemBuilder: (_, index) {
          final keyword = suggestSearch[index];
          return GestureDetector(
            onTap: () => _onSubmit(keyword),
            child: ListTile(
              title: Text(keyword),
            ),
          );
        },
      ),
    );
  }

  Widget buildResult() {
    return SearchResultsCustom(
      name: _searchKeyword,
    );
  }

  void _onSubmit(String name) {
    _searchFieldController.text = name;
    final _userId = Provider.of<UserModel>(context, listen: false).user?.id;
    setState(() {
      _showResult = true;
      _searchModel.loadProduct(name: name, userId: _userId);
    });
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
