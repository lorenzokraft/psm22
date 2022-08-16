import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

showSuccessToast(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,timeInSecForIosWeb: 3);
}