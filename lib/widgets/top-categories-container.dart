import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget topCategoriesContainer({required String text,required Color color}){
  return Padding(
    padding: const EdgeInsets.only(left: 12.0),
    child: Container(
      alignment: Alignment.center,
      height: 95,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/categories/dairy.svg'),
          SizedBox(height: 5.0),
          Text(text,style: TextStyle()),
        ],
      ),
    ),
  );
}