import 'package:flutter/material.dart';

class OurBranches extends StatefulWidget {
  const OurBranches({Key? key}) : super(key: key);

  @override
  State<OurBranches> createState() => _OurBranchesState();
}

class _OurBranchesState extends State<OurBranches> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green.shade700,
            title: Text('Our Branches',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                SizedBox(height: h * 0.04,),
                Image.asset('assets/Dubai.png',width: w * 0.28,),
                SizedBox(height: 7),
                Text('Dubai',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),

                SizedBox(height: h * 0.015,),
                Image.asset('assets/Sharjah.png',width: w * 0.28,),
                Text('Sharjah',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),

                SizedBox(height: h * 0.015),
                Image.asset('assets/Ajman.png',width: w * 0.28),
                SizedBox(height: 7),
                Text('Ajman',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),

              ],
            ),
          ),
        ),
    );
  }
}
