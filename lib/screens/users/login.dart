import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fstore/app.dart';
import 'package:fstore/common/config.dart';
import 'package:fstore/common/tools/tools.dart';
import 'package:fstore/models/app_model.dart';
import 'package:fstore/models/user_model.dart';
import 'package:fstore/modules/sms_login/sms_login.dart';
import 'package:fstore/screens/users/authentication-page.dart';
import 'package:fstore/services/audio/audio_service.dart';
import 'package:fstore/services/dependency_injection.dart';
import 'package:fstore/services/service_config.dart';
import 'package:fstore/widgets/common/custom_text_field.dart';
import 'package:fstore/widgets/common/login_animation.dart';
import 'package:fstore/widgets/common/webview.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../utils.dart';
import 'forgot_password_screen.dart';

class Login extends StatefulWidget {
   Function? login;
  AnimationController? loginButtonController;
  final LoginSocialFunction? loginFB;
  final LoginSocialFunction? loginApple;
  final LoginSocialFunction? loginGoogle;
  final VoidCallback? loginSms;

   Login({Key? key, this.login,
    this.loginFB,
    this.loginButtonController,
    this.loginApple,
    this.loginGoogle,
    this.loginSms,}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final usernameNode = FocusNode();
  final passwordNode = FocusNode();


  late var parentContext;
  bool isActiveAudio = false;

  bool isLoading = false;
  bool isAvailableApple = false;
  AudioService get audioPlayerService => injector<AudioService>();

  void _loginSMS(context) {
    if (widget.loginSms != null) {
      widget.loginSms!();
      return;
    }
    final supportedPlatforms = [
      'wcfm',
      'dokan',
      'delivery',
      'vendorAdmin',
      'woo',
      'wordpress'
    ].contains(serverConfig['type']);
    if (supportedPlatforms &&
        (kAdvanceConfig['EnableNewSMSLogin'] ?? false)) {
      final model = Provider.of<UserModel>(context, listen: false);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SMSLoginScreen(
            onSuccess: (user) async {
              await model.saveSMSUser(user);
              Navigator.of(context).pop();
              await _welcomeMessage(user);
            },
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pushNamed(RouteList.loginSMS);
  }


  Future _welcomeMessage(user) async {
    // final canPop = ModalRoute.of(context)!.canPop;
    // if (canPop) {
    //   // When not required login
    // print("heloooo i am popping");
    //    Navigator.of(context).pop();
    // } else {
       print("heloooo i am not popping");

      // When required login
      await Navigator.of(App.fluxStoreNavigatorKey.currentContext!).pushReplacementNamed(RouteList.dashboard);
    //}

  }

  void _loginGoogle(context) async {
    await _playAnimation();
    await widget.loginGoogle!(
        success: (user) {
          //hideLoading();
          _stopAnimation();
          _welcomeMessage(user);
        },
        fail: (message) {
          //hideLoading();
          _stopAnimation();
          _failMessage(message);
        },
        context: context);
  }

  Future launchForgetPassworddWebView(String url) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            WebView(url: url, title: S.of(context).resetPassword),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> afterFirstLayout(BuildContext context) async {
    if (audioPlayerService.isStickyAudioWidgetActive) {
      isActiveAudio = true;
      audioPlayerService
        ..pause()
        ..updateStateStickyAudioWidget(false);
    }
    try {
      isAvailableApple =
          (await TheAppleSignIn.isAvailable()) || Config().isBuilder;
      setState(() {});
    } catch (e) {
      printLog('[Login] afterFirstLayout error');
    }
  }


  void launchForgetPasswordURL(String? url) async {
    if (url != null && url != '') {
      /// show as webview
      await launchForgetPassworddWebView(url);
    } else {
      /// show as native
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
      );
    }
  }


  Future _playAnimation() async {
    try {
      print("I am here");
      setState(() {
        isLoading = true;
      });
      await widget.loginButtonController!.forward();
      print("I am here");
    } on TickerCanceled {
      printLog('[_playAnimation] error');
    }
  }
  void _loginFacebook(context) async {
    //showLoading();
    await _playAnimation();
    await widget.loginFB!(
      success: (user) {
        //hideLoading();
        _stopAnimation();
        _welcomeMessage(user);
      },
      fail: (message) {
        //hideLoading();
        _stopAnimation();
        _failMessage(message);
      },
      context: context,
    );
  }

  Future _stopAnimation() async {
    try {
      await widget.loginButtonController!.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      printLog('[_stopAnimation] error');
    }
  }
  void _loginApple(context) async {
    await _playAnimation();
    await widget.loginApple!(
        success: (user) {
          _stopAnimation();
          _welcomeMessage(user);
        },
        fail: (message) {
          _stopAnimation();
          _failMessage(message);
        },
        context: context);
  }


  void _failMessage(String message) {
    /// Showing Error messageSnackBarDemo
    /// Ability so close message
    if (message.isEmpty) return;

    var _message = message;
    if (kReleaseMode) {
      _message = S.of(context).UserNameInCorrect;
    }

    final snackBar = SnackBar(
      content: Text(S.of(context).warning(_message)),
      duration: const Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }





  @override
  Widget build(BuildContext context) {
    parentContext = context;
    final appModel = Provider.of<AppModel>(context);
    final screenSize = MediaQuery.of(context).size;
    final themeConfig = appModel.themeConfig;

    var forgetPasswordUrl = Config().forgetPassword;

    void _login(context) async {
      if (!EmailValidator.validate(email.text)) {
        showSuccessToast(S.of(context).errorEmailFormat);
        // _snackBar(S.of(context).errorEmailFormat);
        return;
      }
      if (password.text.length < 8) {
        showSuccessToast(S.of(context).errorPasswordFormat);
        // _snackBar(S.of(context).errorPasswordFormat);
        return;
      }

        await _playAnimation();

        await widget.login!(username: email.text.trim(), password: password.text.trim(),
          success: (user)  {
             _stopAnimation();
             _welcomeMessage(user);
          },
          fail: (message) {
            _stopAnimation();
            _failMessage(message);
          },
        );

    }


    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0,left: 24,right:24),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
           const SizedBox(height: 20.0),

           CustomTextField(
           key: const Key('loginEmailField'),
           controller: email,
           autofillHints: const [AutofillHints.email],
           showCancelIcon: true,
           autocorrect: false,
           enableSuggestions: false,
           textInputAction: TextInputAction.next,
           keyboardType: TextInputType.emailAddress,
           nextNode: passwordNode,
           decoration: InputDecoration(
             prefixIcon: Icon(Icons.person),
             labelText: S.of(parentContext).enterYourEmail,
             hintText: S.of(parentContext).enterYourEmail,
            // focusedBorder: OutlineInputBorder(),
             //enabledBorder: InputBorder.none,
           ),
         ),
             const SizedBox(height: 20),

             CustomTextField(
           key: const Key('loginPasswordField'),
           autofillHints: const [AutofillHints.password],
           obscureText: true,
           showEyeIcon: true,
           textInputAction: TextInputAction.done,
           controller: password,
           focusNode: passwordNode,
           decoration: InputDecoration(
             prefixIcon: Icon(Icons.remove_red_eye_rounded),
             labelText: S.of(parentContext).password,
             hintText: S.of(parentContext).enterYourPassword,
             //focusedBorder: InputBorder.none,
             //enabledBorder: InputBorder.none
           ),
         ),
             const SizedBox(height: 20),
             if (kLoginSetting['isResetPasswordSupported'] != true)
               const SizedBox(height: 50.0),
             StaggerAnimation(
               key: const Key('loginSubmitButton'),
               titleButton: 'Login',
               buttonController: widget.loginButtonController!.view
               as AnimationController,
               onTap: () {
                 if (!isLoading) {
                   _login(context);
                 }
               },
             ),
             TextButton(
                 onPressed: (){},
                 child: const Text('FORGOT PASSWORD?',style: TextStyle(color: Colors.black))),
             const SizedBox(height: 10),
             //const Text('Or Continue with',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
             const SizedBox(height: 20),
            //  GestureDetector(
            //   onTap: () {},
            //   child: Card(
            //     elevation: 2,
            //     child: Container(
            //       height: 50,
            //       decoration: BoxDecoration(
            //           color: Colors.grey.shade50,
            //           borderRadius: BorderRadius.circular(12)),
            //       width: MediaQuery.of(context).size.width / 1.5,
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //         child: Row(
            //           children: [
            //             IconButton(onPressed: () {}, icon: const Icon(Icons.facebook,color: Colors.blue)),
            //             const Text('CONTINUE WITH FACEBOOK',
            //                 style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),





            // if ((kLoginSetting['isResetPasswordSupported'] ?? false))
            //   Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 12.0),
            //     child: GestureDetector(
            //       onTap: () {
            //         launchForgetPasswordURL(forgetPasswordUrl);
            //       },
            //       behavior: HitTestBehavior.opaque,
            //       child: Padding(
            //         padding: const EdgeInsets.all(12.0),
            //         child: Text(
            //           S.of(context).resetPassword,
            //           style: TextStyle(
            //             color: Theme.of(context).primaryColor,
            //             decoration: TextDecoration.underline,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // Stack(
            //   alignment: AlignmentDirectional.center,
            //   children: <Widget>[
            //     SizedBox(
            //         height: 50.0,
            //         width: 200.0,
            //         child: Divider(color: Colors.grey.shade300)),
            //     Container(
            //         height: 30,
            //         width: 40,
            //         color: Theme.of(context).backgroundColor),
            //     if (kLoginSetting['showFacebook'] ||
            //         kLoginSetting['showSMSLogin'] ||
            //         kLoginSetting['showGoogleLogin'] ||
            //         kLoginSetting['showAppleLogin'])
            //       Text(
            //         S.of(context).or,
            //         style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            //       )
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     if (kLoginSetting['showAppleLogin'] && isAvailableApple)
            //       InkWell(
            //         onTap: () => _loginApple(context),
            //         child: Container(
            //           padding: const EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(40),
            //             color: Colors.black87,
            //           ),
            //           child: Image.asset(
            //             'assets/icons/logins/apple.png',
            //             width: 26,
            //             height: 26,
            //           ),
            //         ),
            //       ),
            //     if (kLoginSetting['showFacebook'])
            //       InkWell(
            //         onTap: () => _loginFacebook(context),
            //         child: Container(
            //           padding: const EdgeInsets.all(8),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(40),
            //             color: const Color(0xFF4267B2),
            //           ),
            //           child: const Icon(
            //             Icons.facebook_rounded,
            //             color: Colors.white,
            //             size: 34.0,
            //           ),
            //         ),
            //       ),
            //     if (kLoginSetting['showGoogleLogin'])
            //       InkWell(
            //         onTap: () => _loginGoogle(context),
            //         child: Container(
            //           padding: const EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(40),
            //             color: Colors.grey.shade300,
            //           ),
            //           child: Image.asset(
            //             'assets/icons/logins/google.png',
            //             width: 28,
            //             height: 28,
            //           ),
            //         ),
            //       ),
            //     if (kLoginSetting['showSMSLogin'])
            //       InkWell(
            //         onTap: () => _loginSMS(context),
            //         child: Container(
            //           padding: const EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(40),
            //             color: Colors.lightBlue.shade50,
            //           ),
            //           child: Image.asset(
            //             'assets/icons/logins/sms.png',
            //             width: 28,
            //             height: 28,
            //           ),
            //         ),
            //       ),
            //   ],
            // ),
            // const SizedBox(height: 30.0),
            // Column(
            //   children: <Widget>[
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         Text(S.of(context).dontHaveAccount),
            //         GestureDetector(
            //           onTap: () {
            //             if (kAdvanceConfig['EnableMembershipUltimate'] == true) {
            //               Navigator.of(context)
            //                   .pushNamed(RouteList.memberShipUltimatePlans);
            //             } else if (kAdvanceConfig['EnablePaidMembershipPro'] ==
            //                 true) {
            //               Navigator.of(context)
            //                   .pushNamed(RouteList.paidMemberShipProPlans);
            //             } else {
            //               Navigator.of(context).pushNamed(RouteList.register);
            //             }
            //           },
            //           child: Text(
            //             ' ${S.of(context).signup}',
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               color: Theme.of(context).primaryColor,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // )
          ],
         ),
      ),
    );


  }
}
