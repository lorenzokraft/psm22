import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fstore/models/app_model.dart';
import 'package:fstore/models/cart/cart_base.dart';
import 'package:fstore/models/point_model.dart';
import 'package:fstore/modules/vendor_on_boarding/screen_index.dart';
import 'package:fstore/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../common/config.dart';
import '../common/constants.dart';
import '../generated/l10n.dart';
import '../services/index.dart';
import 'entities/user.dart';

abstract class UserModelDelegate {
  void onLoaded(User? user);

  void onLoggedIn(User user);

  void onLogout(User? user);
}

class UserModel with ChangeNotifier {
  UserModel();

  final _storage = injector<LocalStorage>();

  final Services _service = Services();
  User? user;
  bool loggedIn = false;
  bool loading = false;
  UserModelDelegate? delegate;

  void updateUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  Future<String?> submitForgotPassword(
      {String? forgotPwLink, Map<String, dynamic>? data}) async {
    return await _service.api
        .submitForgotPassword(forgotPwLink: forgotPwLink, data: data);
  }

  /// Login by apple, This function only test on iPhone
  Future<void> loginApple({Function? success, Function? fail, context}) async {
    try {
      final result = await apple.TheAppleSignIn.performRequests([
        const apple.AppleIdRequest(
            requestedScopes: [apple.Scope.email, apple.Scope.fullName])
      ]);

      switch (result.status) {
        case apple.AuthorizationStatus.authorized:
          {
            user = await _service.api.loginApple(
                token: String.fromCharCodes(result.credential!.identityToken!));

            Services().firebase.loginFirebaseApple(
                  authorizationCode: result.credential!.authorizationCode!,
                  identityToken: result.credential!.identityToken!,
                );

            await saveUser(user);
            success!(user);

            notifyListeners();
          }
          break;

        case apple.AuthorizationStatus.error:
          fail!(S.of(context).error(result.error!));
          break;
        case apple.AuthorizationStatus.cancelled:
          fail!(S.of(context).loginCanceled);
          break;
      }
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  /// Login by Firebase phone
  Future<void> loginFirebaseSMS(
      {String? phoneNumber,
      required Function success,
      Function? fail,
      context}) async {
    try {
      user = await _service.api.loginSMS(token: phoneNumber);
      await saveUser(user);
      success(user);

      notifyListeners();
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  /// Login by Facebook
  Future<void> loginFB({Function? success, Function? fail, context}) async {
    try {
      final result = await FacebookAuth.instance.login();

      print("---------------------------------------------------------------------------");
      print(result.status);
      print("---------------------------------------------------------------------------");

      switch (result.status) {
        case LoginStatus.success:
          final accessToken = await FacebookAuth.instance.accessToken;
          print(accessToken?.token);

          Services().firebase.loginFirebaseFacebook(token: accessToken!.token);

          user = await _service.api.loginFacebook(token: accessToken.token);

          await saveUser(user);
          success!(user);
          break;
        case LoginStatus.cancelled:
          fail!(S.of(context).loginCanceled);
          break;
        default:
          fail!(result.message);
          break;
      }
      notifyListeners();
    } catch (err) {
      print("------------------------------------------------");
      print("i am here");
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
      print("------------------------------------------------");
    }
  }


  // Future<void> loginGoogle({Function? success, Function? fail, context}) async {
  //   try {
  //     var googleSignIn = GoogleSignIn(scopes: ['email']);
  //
  //     /// Need to disconnect or cannot login with another account.
  //     await googleSignIn.disconnect();
  //
  //     var res = await googleSignIn.signIn();
  //
  //     if (res == null) {
  //       fail!(S.of(context).loginCanceled);
  //     } else {
  //       var auth = await res.authentication;
  //       print("Shahzaib");
  //       print(res);
  //       print(auth.accessToken);
  //       print("Shahzaib");
  //       Services().firebase.loginFirebaseGoogle(token: auth.accessToken);
  //       user = await _service.api.loginGoogle(token:auth.accessToken);
  //       print(user?.toJson());
  //
  //       await saveUser(user);
  //       success!(user);
  //       notifyListeners();
  //     }
  //   } catch (err, trace) {
  //     printLog(trace);
  //     printLog(err);
  //     fail!(S.of(context).loginErrorServiceProvider(err.toString()));
  //   }
  // }



  Future<void> loginGoogle({Function? success, Function? fail, context}) async {

    void _snackBar(String text) {
      showSuccessToast(text);
      // if (mounted) {
      //   final snackBar = SnackBar(
      //     content: Text(text),
      //     duration: const Duration(seconds: 10),
      //     action: SnackBarAction(
      //       label: S.of(context).close,
      //       onPressed: () {
      //         // Some code to undo the change.
      //       },
      //     ),
      //   );
      //   // ignore: deprecated_member_use
      //   _scaffoldKey.currentState!.showSnackBar(snackBar);
      // }
    }
    void _welcomeDiaLog(User user) {
      Provider.of<CartModel>(context, listen: false).setUser(user);
      Provider.of<PointModel>(context, listen: false).getMyPoint(user.cookie);
      final model = Provider.of<UserModel>(context, listen: false);

      /// Show VendorOnBoarding.
      if (kVendorConfig['VendorRegister'] == true &&
          Provider.of<AppModel>(context, listen: false).vendorType == VendorType.multi && user.isVender) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => VendorOnBoarding(
          user: user,
          onFinish: () {
            model.getUser();
            var email = user.email;
            _snackBar(S.of(ctx).welcome + ' $email!');
            var routeFound = false;
            var routeNames = [RouteList.dashboard, RouteList.productDetail];
            Navigator.popUntil(ctx, (route) {
              if (routeNames.any((element) => route.settings.name?.contains(element) ?? false)) {
                routeFound = true;
              }
              return routeFound || route.isFirst;
            });

            if (!routeFound) {
              //print("helooooooooooooooooooooooooooooooooooooooooooo");
              Navigator.of(ctx).pushReplacementNamed(RouteList.dashboard);
            }
          },
        ),
        ),
        );
        return;
      }

      var email = user.email;
      _snackBar(S.of(context).welcome + ' $email!');
      if (kLoginSetting['IsRequiredLogin'] ?? false) {
        Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
        return;
      }
      var routeFound = false;
      var routeNames = [RouteList.dashboard, RouteList.productDetail];
      Navigator.popUntil(context, (route) {
        if (routeNames.any((element) => route.settings.name?.contains(element) ?? false)) {
          routeFound = true;
        }
        return routeFound || route.isFirst;
      });

      if (!routeFound) {
        // Navigator.of(context , rootNavigator: true).pushReplacementNamed(RouteList.dashboard);
        Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
      }
    }

    try {
      GoogleSignIn  _googleSignIn = GoogleSignIn(scopes: ['email']);
      var res = await _googleSignIn.signIn();
      print("Responseme");
      print(res);
      if (res == null) {
        fail!(S.of(context).loginCanceled);
      } else {
        var auth = await res.authentication;
        Services().firebase.loginFirebaseGoogle(token: auth.accessToken);
        try{
          user = await _service.api.login(username: res.email,password: "12345678");
        }
        catch(e){
          print(e);
        }

        if(user!=null){
          success!(_welcomeDiaLog(user!));
          notifyListeners();
        }
        else{
          await Provider.of<UserModel>(context, listen: false).createUser(
            username: res.email,
            password: '12345678',
            firstName: res.displayName,
            // lastName: lastName,
            phoneNumber: '12345378',
            success: _welcomeDiaLog,
            fail: _snackBar,
          );
        }

      }
    } catch (err, trace) {
      printLog(trace);
      printLog(err);
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }






  Future<void> saveUser(User? user) async {
    try {
      if (Services().firebase.isEnabled &&
          kFluxStoreMV.contains(serverConfig['type'])) {
        Services().firebase.saveUserToFirestore(user: user);
      }

      // save to Preference
      var prefs = injector<SharedPreferences>();
      await prefs.setBool(LocalStorageKey.loggedIn, true);
      loggedIn = true;


      // save the user Info as local storage
      await _storage.setItem(kLocalKey['userInfo']!, user);

      delegate?.onLoaded(user);
    } catch (err) {
      printLog(err);
    }
  }

  Future<void> saveSMSUser(User? user) async {
    if (user != null) {
      this.user = user;
      await saveUser(user);
    }
  }

  Future<void> getUser() async {
    try {
      final json = _storage.getItem(kLocalKey['userInfo']!);
      if (json != null) {
        user = User.fromLocalJson(json);
        loggedIn = true;
        final userInfo = await _service.api.getUserInfo(user!.cookie);
        if (userInfo != null) {
          userInfo.isSocial = user!.isSocial;
          user = userInfo;
        }
        delegate?.onLoaded(user);
        notifyListeners();
      } else {
        if (kPaymentConfig['GuestCheckout'] == true) {
          delegate?.onLoaded(User()..cookie = _getGenerateCookie());
        }
        notifyListeners();
      }
    } catch (err) {
      printLog(err);
    }
  }

  void setLoading(bool isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  Future<void> setUser(User? user) async {
    if (user != null) {
      this.user = user;
      await saveUser(user);
      notifyListeners();
    }
  }

  Future<void> createUser({
    String? username,
    String? password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    bool? isVendor,
    required Function success,
    Function? fail,
  }) async {
    try {
      loading = true;
      notifyListeners();
      Services().firebase.createUserWithEmailAndPassword(
          email: username!, password: password!);

      user = await _service.api.createUser(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        phoneNumber: phoneNumber,
        isVendor: isVendor ?? false,
      );
      await saveUser(user);
      success(user);

      loading = false;
      notifyListeners();
    } catch (err) {
      fail!(err.toString());
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    Services().firebase.signOut();

    await FacebookAuth.instance.logOut();

    delegate?.onLogout(user);
    user = null;
    loggedIn = false;
    final prefs = injector<SharedPreferences>();
    await prefs.setBool(LocalStorageKey.loggedIn, false);

    /// Delay needed because memory cannot be accessed too fast
    await Future.delayed(const Duration(milliseconds: 500), () {});

    try {
      await _storage.clear();

      await _service.api.logout();
    } catch (err) {
      printLog(err);
    }
    notifyListeners();
  }

  Future<void> login({
    required String username,
    required String password,
    required Function(User user) success,
    required Function(String message) fail,
  }) async {
    try {
      loading = true;
      notifyListeners();
      user = await _service.api.login(
        username: username,
        password: password,
      );

      Services()
          .firebase
          .loginFirebaseEmail(email: username, password: password);

      if (user == null) {
        throw 'Something went wrong!!!';
      }
      await saveUser(user);
      success(user!);
      loading = false;
      notifyListeners();
    } catch (err) {
      loading = false;
      fail(err.toString());
      notifyListeners();
    }
  }

  /// Use for generate fake cookie for guest check out
  String _getGenerateCookie() {
    final storage = injector<LocalStorage>();
    var cookie = storage.getItem(LocalStorageKey.userCookie);
    cookie ??=
        ('OCSESSID=' + randomNumeric(30) + '; PHPSESSID=' + randomNumeric(30));
    storage.setItem(LocalStorageKey.userCookie, cookie);
    return cookie;
  }
}
