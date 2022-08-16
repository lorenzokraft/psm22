import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fstore/app.dart';
import 'package:fstore/common/constants.dart';
import 'package:fstore/generated/l10n.dart';
import 'package:inspireui/utils/logs.dart';

import '../../common/config.dart';



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




class AuthenticationPage extends StatefulWidget {
  final LoginFunction? login;
  final LoginSocialFunction? loginFB;
  final LoginSocialFunction? loginApple;
  final LoginSocialFunction? loginGoogle;
  final VoidCallback? loginSms;

   AuthenticationPage({Key? key, this.login,
     this.loginFB,
     this.loginApple,
     this.loginGoogle,
     this.loginSms,}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>   with TickerProviderStateMixin {


  late AnimationController _loginButtonController;
  bool isLoading = false;


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



  void _loginGoogle(context) async {
    await widget.loginGoogle!(
        success: (user) {
          //hideLoading();
          _welcomeMessage(user);
        },
        fail: (message) {
          //hideLoading();
          _failMessage(message);
        },
        context: context);
  }


  Future _welcomeMessage(user) async {
    final canPop = ModalRoute.of(context)!.canPop;
    if (canPop) {
      // When not required login
      Navigator.of(context).pop();
    } else {
      // When required login
      await Navigator.of(App.fluxStoreNavigatorKey.currentContext!)
          .pushReplacementNamed(RouteList.dashboard);
    }
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



  Future _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {
      printLog('[_playAnimation] error');
    }
  }

  Future _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      printLog('[_stopAnimation] error');
    }
  }



  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        title: const Text('Login',style: TextStyle(color: Colors.grey)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              width: MediaQuery.of(context).size.width/1.8,
              child: Image.asset('assets/images/app_icon_transparent.png',fit: BoxFit.cover),
            ),
            const Text('Login or create an account',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
             Padding(
              padding: const EdgeInsets.only(top: 18.0,bottom: 12),
              child: Text('Login or create an account to review your rewards and save your detail for fastest experience',textAlign: TextAlign.center, style: TextStyle(fontSize: 15,color: Colors.grey.shade500),),
            ),
            if (kLoginSetting['showFacebook'])
            authenticationButton(context,'CONTINUE WITH FACEBOOK',const Icon(Icons.facebook,color: Colors.blue),(){
              _loginFacebook(context);
            }),
            if (kLoginSetting['showGoogleLogin'])
            Padding(
              padding: const EdgeInsets.only(top:18.0,bottom: 18),
              child: GestureDetector(
                onTap: (){
                  _loginGoogle(context);
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    width: MediaQuery.of(context).size.width/1.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          SizedBox(width: 12,),
                          Image.asset('assets/icons/logins/google.png',width: 20,height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 35.0),
                            child: Text("CONTINUE WITH GOOGLE",style: TextStyle(fontWeight: FontWeight.bold)),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            authenticationButton(context,'CONTINUE WITH EMAIL', const Icon(Icons.email,color: Colors.grey),(){
                Navigator.of(App.fluxStoreNavigatorKey.currentContext!,
                ).pushNamed(RouteList.login);
            }),

            

            
          ],
        ),
      ),
    );
  }
}


Widget authenticationButton(context,String title, Icon icon,void Function()? onTap ){
  return GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 2,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12)
        ),
        width: MediaQuery.of(context).size.width/1.3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              IconButton(onPressed: (){}, icon: icon),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(title,style: TextStyle(fontWeight: FontWeight.bold)),
              ),

            ],
          ),
        ),
      ),
    ),
  );

}
