import 'package:flutter/material.dart';

Widget categoryContainer({required String text,required Color color ,required void Function() onTap ,required BuildContext context}){
 return   GestureDetector(
   onTap: onTap,
   child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width/3.3,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color,
              ),
              child: Text(text,style: const TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold))
            ),
 );
}