import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fstore/screens/users/login.dart';
import 'package:fstore/screens/users/registration_screen.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../app.dart';
import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart';
import '../../modules/sms_login/sms_login.dart';
import '../../services/index.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/flux_image.dart';
import '../../widgets/common/login_animation.dart';
import '../../widgets/common/webview.dart';
import '../base_screen.dart';
import 'forgot_password_screen.dart';

typedef LoginSocialFunction = Future<void> Function({
  required Function(User user) success,
  required Function(String) fail,
  BuildContext context,
});

typedef LoginFunction = Future<void> Function({
  required String username,
  required String password,
  required Function(User user) success,
  required Function(String) fail,
});

class LoginScreen extends StatefulWidget {
  final LoginFunction? login;
  final LoginSocialFunction? loginFB;
  final LoginSocialFunction? loginApple;
  final LoginSocialFunction? loginGoogle;
  final VoidCallback? loginSms;

   LoginScreen({this.login, this.loginFB, this.loginApple, this.loginGoogle, this.loginSms});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseScreen<LoginScreen> with TickerProviderStateMixin {

  late AnimationController _loginButtonController;

  final usernameNode = FocusNode();
  final passwordNode = FocusNode();
  late TabController _tabController;

  late var parentContext;
  bool isLoading = false;
  bool isAvailableApple = false;
  bool isActiveAudio = false;

  AudioService get audioPlayerService => injector<AudioService>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loginButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  @override
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

  @override
  void dispose() async {
    _tabController.dispose();
    // email.dispose();
    // password.dispose();
    usernameNode.dispose();
    passwordNode.dispose();
    _loginButtonController.dispose();
    super.dispose();
  }







  @override
  Widget build(BuildContext context) {
    parentContext = context;
    final appModel = Provider.of<AppModel>(context);
    final screenSize = MediaQuery.of(context).size;
    final themeConfig = appModel.themeConfig;

    var forgetPasswordUrl = Config().forgetPassword;

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


    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: AutoHideKeyboard(
          child: Consumer<UserModel>(builder: (context, model, child) {
            return Container(
              alignment: Alignment.center,
              width: screenSize.width / (2 / (screenSize.height / screenSize.width)),
              constraints: const BoxConstraints(maxWidth: 700),
              child: AutofillGroup(
                child: Column(
                  children: <Widget>[
                   Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width/2.5,
                    child: Image.asset('assets/images/app_icon_transparent.png',fit: BoxFit.cover),
                    ),
                    const Text('You everyday, right away',style: TextStyle(color: Colors.black,fontSize: 12)),
                    Padding(
                      padding: const EdgeInsets.only(top:12.0),
                      child: const Text('Login or create an account',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 18.0,bottom: 12),
                      child: Text('Login or create an account to review your rewards and save your detail for fastest experience',textAlign: TextAlign.center, style: TextStyle(fontSize: 15,color: Colors.grey.shade500),),
                    ),

                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.green,
                          indicatorWeight: 3,
                          labelPadding: EdgeInsets.zero,
                          labelColor: Colors.green,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(
                              child: Container(
                                alignment: Alignment.center,
                                height: double.infinity,
                                decoration:  BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text('LOGIN',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15)),
                                  ],
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                alignment: Alignment.center,
                                height: double.infinity,
                                decoration:  BoxDecoration(
                                  color: Colors.white,
                                ),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text('REGISTER',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15)),
                                  ],
                                ),
                              ),
                            ),

                          ]),
                    ),
                    ///Login, register
                    Expanded(
                      child: TabBarView(
                          controller: _tabController,
                          children:  [
                           Login(loginButtonController: _loginButtonController,login: widget.login),
                           RegistrationScreen(),
                            // HomeDelivery(),
                            // StorePickup(),
                          ]),
                    ),

                   //  const SizedBox(height: 20.0),
                   //  Padding(
                   //   padding: const EdgeInsets.all(8.0),
                   //   child: Column(
                   //      children: [
                   //
                   //
                   //     Row(
                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   //     children:  [
                   //     const Text('Sign In',style: TextStyle(decoration: TextDecoration.underline)),
                   //     InkWell(
                   //         onTap: (){
                   //           Navigator.pushReplacementNamed(context, RouteList.register);
                   //         },
                   //         child: const Text('Create an Account')),
                   //   ]),
                   //      const SizedBox(height: 20.0),
                   //      CustomTextField(
                   //      key: const Key('loginEmailField'),
                   //      controller: email,
                   //      autofillHints: const [AutofillHints.email],
                   //      showCancelIcon: true,
                   //      autocorrect: false,
                   //      enableSuggestions: false,
                   //      textInputAction: TextInputAction.next,
                   //      keyboardType: TextInputType.emailAddress,
                   //      nextNode: passwordNode,
                   //      decoration: InputDecoration(
                   //        labelText: S.of(parentContext).enterYourEmail,
                   //        hintText: S.of(parentContext).enterYourEmail,
                   //         fillColor:const Color(0xffEBEEEC),
                   //        filled: true,
                   //        focusedBorder: InputBorder.none,
                   //        enabledBorder: InputBorder.none
                   //      ),
                   //    ),
                   //        const SizedBox(height: 20),
                   //        CustomTextField(
                   //      key: const Key('loginPasswordField'),
                   //      autofillHints: const [AutofillHints.password],
                   //      obscureText: true,
                   //      showEyeIcon: true,
                   //      textInputAction: TextInputAction.done,
                   //      controller: password,
                   //      focusNode: passwordNode,
                   //      decoration: InputDecoration(
                   //        labelText: S.of(parentContext).password,
                   //        hintText: S.of(parentContext).enterYourPassword,
                   //        fillColor:const Color(0xffEBEEEC),
                   //        filled: true,
                   //        focusedBorder: InputBorder.none,
                   //        enabledBorder: InputBorder.none
                   //      ),
                   //    ),
                   //         const SizedBox(height: 50),
                   //        Row(
                   //          children: [
                   //            TextButton(
                   //                onPressed: (){},
                   //                child: const Text('Forget Password?')),
                   //          ],
                   //        ),
                   //
                   //        const SizedBox(height: 20),
                   //        if (kLoginSetting['isResetPasswordSupported'] != true)
                   //          const SizedBox(height: 50.0),
                   //        StaggerAnimation(
                   //          key: const Key('loginSubmitButton'),
                   //          titleButton: S.of(context).signInWithEmail,
                   //          buttonController: _loginButtonController.view
                   //          as AnimationController,
                   //          onTap: () {
                   //            if (!isLoading) {
                   //              _login(context);
                   //            }
                   //          },
                   //        ),
                   //
                   //        const SizedBox(height: 80),
                   //        const Text('Or continue with',style: TextStyle(fontWeight: FontWeight.bold)),
                   //        const SizedBox(height: 20),
                   //        SizedBox(
                   //          width: MediaQuery.of(context).size.width/2.5,
                   //          child: Row(
                   //            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   //            children: [
                   //              Image.asset('assets/images/google.png',width: 50,height: 50),
                   //              Image.asset('assets/images/facebook.png',width: 40,height: 40),
                   //              Image.asset('assets/images/apple.png',width: 40,height: 40),
                   //            ],),
                   //        ),
                   //
                   //
                   //
                   //      ],
                   //    ),
                   // ),

                    // if ((kLoginSetting['isResetPasswordSupported'] ?? false))
                    //   Padding(
                    //     padding:
                    //         const EdgeInsets.symmetric(vertical: 12.0),
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
                    //         child:
                    //             Divider(color: Colors.grey.shade300)),
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
                    //         style: TextStyle(
                    //             fontSize: 12,
                    //             color: Colors.grey.shade400),
                    //       )
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: <Widget>[
                    //     if (kLoginSetting['showAppleLogin'] &&
                    //         isAvailableApple)
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
                    //             if (kAdvanceConfig[
                    //                     'EnableMembershipUltimate'] ==
                    //                 true) {
                    //               Navigator.of(context).pushNamed(
                    //                   RouteList
                    //                       .memberShipUltimatePlans);
                    //             } else if (kAdvanceConfig[
                    //                     'EnablePaidMembershipPro'] ==
                    //                 true) {
                    //               Navigator.of(context).pushNamed(
                    //                   RouteList.paidMemberShipProPlans);
                    //             } else {
                    //               Navigator.of(context)
                    //                   .pushNamed(RouteList.register);
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
          }),
        ),
      ),
    );
  }

  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
            child: Container(
          padding: const EdgeInsets.all(50.0),
          child: kLoadingWidget(context),
        ));
      },
    );
  }

  void hideLoading() {
    Navigator.of(context).pop();
  }
}
