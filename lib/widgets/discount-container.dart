
import 'package:flutter/material.dart';

Widget discountContainer({required String title,required String subTitle , required Color color,required void Function()? onPressed}){

  return Padding(
    padding: const EdgeInsets.only(left: 12.0),
    child: Container(
            height: 180,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0,top: 35,right: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(title ,style: const TextStyle(fontSize: 22,color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 20),
                    child: Text(subTitle ,style: const TextStyle(fontSize: 14,color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white) ,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )
                    )
                  ),
                  onPressed: onPressed, child: const Text('Shop Now',))
                ],
              ),
            ),
          ),
  );

}


Widget bannerContainer({required String image , void Function()? onPressed,required BuildContext context}){

  return Padding(
    padding: const EdgeInsets.only(left: 12.0),
    child: Container(
      padding: const EdgeInsets.all(12),
      height: 200,
      width: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(image)
        )
      ),

    ),
  );

}




Widget dealsContainer({required String title,required String subTitle , required Color color,required void Function()? onPressed}){

  return Padding(
    padding: const EdgeInsets.only(left: 12.0,right: 12.0),
    child: Container(
            height: 175,
            width: double.infinity,
            decoration: BoxDecoration(
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/deals.png',)
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0,top: 20,right: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(title ,style: const TextStyle(fontSize: 18,color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0,bottom: 3),
                    child: Text(subTitle ,style: const TextStyle(fontSize: 14,color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white) ,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )
                    )
                  ),
                  onPressed: onPressed, child: const Text('Shop Now',))
                ],
              ),
            ),
          ),
  );

}
