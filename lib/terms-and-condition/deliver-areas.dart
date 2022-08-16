import 'package:flutter/material.dart';

class DeliverAreas extends StatefulWidget {
  const DeliverAreas({Key? key}) : super(key: key);

  @override
  State<DeliverAreas> createState() => _DeliverAreasState();
}

class _DeliverAreasState extends State<DeliverAreas> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SafeArea(child: Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Delivery Areas',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: Colors.grey.shade500),
              columnWidths: {
                0: FractionColumnWidth(0.16),
                1: FractionColumnWidth(0.6),
                2: FractionColumnWidth(0.25),
              },
              children: [


                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text("S.No",textScaleFactor: 1.3,style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text("Area Address",textScaleFactor: 1.3,style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text("State",textScaleFactor: 1.3,style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("1",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Beside Ibrahimi Palace Restaurant, Karama",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Dubai",textScaleFactor: 1.2),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("2",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Behind Sahara Center (Dubai Bound), Al Nahda",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Dubai",textScaleFactor: 1.2),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("3",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Opposite Bohri Masjid, Naif, Deira",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Dubai",textScaleFactor: 1.2),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("4",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Behind Centro, Barsha 1",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Dubai",textScaleFactor: 1.2),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("5",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Behind Sharjah Islamic Museum, Mujarrah",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Sharjah",textScaleFactor: 1.2),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("6",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Al Nahda",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Sharjah",textScaleFactor: 1.2),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("7",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Opposite Etisalat, Abu Shagarah",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Sharjah",textScaleFactor: 1.2),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("8",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Opposite Honda Showroom, Al Rashidiya 3",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Ajman",textScaleFactor: 1.2),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("9",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Nakheel",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("	Ras Al Khaimah",textScaleFactor: 1.2),
                      ),
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("10",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Behind Lulu Hypermarket, Sanaiya",textScaleFactor: 1.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("Al Ain",textScaleFactor: 1.2),
                      ),
                    ]
                ),


            ],),
          ],
        ),
      ),
    ));
  }
}
