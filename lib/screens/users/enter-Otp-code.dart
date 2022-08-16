import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils.dart';
const _timer = 120;

class EnterCode extends StatefulWidget {
  Function(bool)? isVerified;
  String? firstName, emailAddress, phoneNumber, password;
  bool isVendor = false;
  EnterCode({Key? key,this.isVerified,this.firstName,this.emailAddress,this.phoneNumber,this.password,this.isVendor=false}) : super(key: key);
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  String? _verificationId;

  final _auth = FirebaseAuth.instance;
  TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyNumber("+${widget.phoneNumber}", context);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 90),
              child: Column(
                children: [
                  SizedBox(height: 50,),

                  Image.asset('assets/images/app_icon_transparent.png',height: 165),

                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text("OTP Code",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 18),
                  Text(
                    "Enter the code we sent you on the provided phone number.",
                    textAlign: TextAlign.center,
                  ),
                 SizedBox(height: 38),
                  TextField(
                    keyboardType:  TextInputType.phone,
                    textAlign: TextAlign.center,
                    controller: _codeController,
                    decoration: InputDecoration(
                      hintText: 'Enter Pin Code',
                    ),
                  ),
              SizedBox(height: 28),

                    ///Submit
                    GestureDetector(
                      //onTap: matchOtp,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width/1.24,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Material(
                            color: Colors.red,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(2.0)),
                            elevation: 0,
                            child: MaterialButton(
                              key: null,
                              minWidth: 200.0,
                              elevation: 0.0,
                              height: 42.0,
                              onPressed: () {
                                matchOtp();
                              },
                              child: Text('Submit',
                                style: TextStyle(fontSize: 15,color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 15),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                         "Didn\'t receive code?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future verifyNumber(String phoneNumber, BuildContext context) async {
    print("hello i a here");
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      codeSent: (String verificationId, [int? forceCodeResend])  {
        print("hey code sent");
        _verificationId = verificationId;
        showSuccessToast("Code Send Successfully",);
        print("hey code sent");
      },
      timeout:  Duration(seconds: _timer),
      verificationCompleted: (AuthCredential credential) async {
        showSuccessToast("verification completed",);
       // FocusScope.of(context).requestFocus(FocusNode());
      //  Navigator.of(context).pop(true);
      },
      verificationFailed: (FirebaseAuthException exception) {
        print("shahzaib");
        showSuccessToast('${exception.message}');
        print('${exception.message}');
        print("shahzaib");

      },
    );
  }

  Future<bool> signInWithOTP(smsCode, verId) async {
    if(verId==null) return false;
    final credentials =
    PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);

      final result = await _auth.signInWithCredential(credentials);
      Navigator.pop(context,true);
      if (result.user != null) {
        // showSuccessToast("Verifed Successfully");
        }
      else{
        print("error");

      }
      return false;
  }

  void matchOtp() async {
    print("matching");
    if (await signInWithOTP(_codeController.text, _verificationId)) {
      /// Restore State of Guest User;
      /// ----------------------------
      ///
    }
  }
}
