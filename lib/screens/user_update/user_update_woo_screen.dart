import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart' show printLog;
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/entities/user.dart';
import '../../models/user_model.dart';
import '../../services/index.dart';
import 'user_update_model.dart';

class UserUpdateWooScreen extends StatefulWidget {
  @override
  _UserUpdateScreenState createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateWooScreen> {
  String? avatar;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false);
    return ChangeNotifierProvider<UserUpdateModel>(
      create: (_) => UserUpdateModel(user.user),
      lazy: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: Consumer<UserUpdateModel>(
          builder: (_, model, __) => ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            onPressed: () {
              model.updateProfile().then((value) {
                if (value == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Update failed!'),
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Update Successfully!'),
                    duration: Duration(seconds: 2),
                  ));
                  if (Config().isListingType) {
                    user.user =
                        User.fromListingJson(value as Map<String, dynamic>);
                  } else {
                    user.user = User.fromAuthUser(
                        value as Map<String, dynamic>, user.user!.cookie);
                  }

                  user.setUser(user.user);
                  Future.delayed(const Duration(seconds: 2)).then((value) {
                    if (mounted) {
                      try {
                        final navigator = Navigator.of(context);
                        if (navigator.canPop()) {
                          navigator.pop();
                        }
                      } catch (err) {
                        printLog(err);
                      }
                    }
                  });
                }
              });
            },
            child: Text(
              S.of(context).update,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: GestureDetector(
          onTap: () {
            Tools.hideKeyboard(context);
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Consumer<UserUpdateModel>(
                    builder: (_, model, __) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.elliptical(100, 10),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 2),
                                      blurRadius: 8)
                                ]),
                            child: model.avatar == null ||
                                    (model.avatar is String &&
                                        model.avatar.isEmpty)
                                ? Container()
                                : (model.avatar is Asset)
                                    ? AssetThumb(
                                        asset: model.avatar,
                                        height: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20)
                                            .toInt(),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width
                                            .toInt(),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: model.avatar,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  color: Theme.of(context).primaryColorLight),
                              child: model.avatar == null ||
                                      (model.avatar is String &&
                                          model.avatar.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 120,
                                    )
                                  : (model.avatar is Asset)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(150),
                                          child: AssetThumb(
                                              asset: model.avatar,
                                              width: 150,
                                              height: 150),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(150),
                                          child: CachedNetworkImage(
                                            imageUrl: model.avatar,
                                            fit: BoxFit.cover,
                                            width: 150,
                                            height: 150,
                                          ),
                                        ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  color: Theme.of(context).primaryColorLight),
                              child: IconButton(
                                onPressed: model.selectImage,
                                icon: const Icon(Icons.camera_alt),
                              ),
                            ),
                          ),
                          SafeArea(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(left: 10),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 8),
                                Text(S.of(context).email,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                Consumer<UserUpdateModel>(
                                  builder: (_, model, __) => TextField(
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    controller: model.userEmail,
                                    enabled: false,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(S.of(context).displayName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          width: 1.5)),
                                  child: Consumer<UserUpdateModel>(
                                    builder: (_, model, __) => TextField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      controller: model.userDisplayName,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(S.of(context).firstName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          width: 1.5)),
                                  child: Consumer<UserUpdateModel>(
                                    builder: (_, model, __) => TextField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      controller: model.userFirstName,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(S.of(context).lastName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          width: 1.5)),
                                  child: Consumer<UserUpdateModel>(
                                    builder: (_, model, __) => TextField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      controller: model.userLastName,
                                    ),
                                  ),
                                ),
                                if (!Config().isListingType) ...[
                                  const SizedBox(height: 16),
                                  Text(S.of(context).streetName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingAddress1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).streetNameBlock,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingAddress2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).city,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingCity,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).stateProvince,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingState,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).country,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingCountry,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).zipCode,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingPostcode,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).streetNameApartment,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingCompany,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Consumer<UserUpdateModel>(
                builder: (_, model, __) =>
                    model.state == UserUpdateState.loading
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.black.withOpacity(0.5),
                            child: const Center(
                              child: SpinKitCircle(
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          )
                        : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
