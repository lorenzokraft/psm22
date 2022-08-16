import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/index.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green.shade800,
        leading:IconButton(onPressed: () => Navigator.of(context).pop() , icon: Icon(CupertinoIcons.back,color: Colors.white)),
        title: const Text('About Us',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('We are a chain of Pakistani Super Markets in United Arab Emirates, bringing more than 100 of Pakistani brands, fruits, vegetables, meat, bakery products, cultural items, clothes, sports items and much more'),
      ),
    );
  }
}
