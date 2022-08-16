import 'package:flutter/material.dart';

class WaitingDialog extends Dialog {
  WaitingDialog({
    String message=""
  }): super(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        const SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: Colors.green,
             valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          )
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(message, style: const TextStyle(
              fontSize: 16
            )),
          ),
        )
      ]),
    ),
  );
}