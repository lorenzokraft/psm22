import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.green.shade800,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(CupertinoIcons.back, color: Colors.white)),
              title: const Text('About Us',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: true,
        ),
        body: Container());
  }
}
