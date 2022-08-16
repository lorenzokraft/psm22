import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fstore/widgets/common/custom_text_field.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  Function(String address,String country,String latilute,String longitude)? okTap;
  Position? position;
  MapScreen({Key? key,this.position,this.okTap}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  CameraPosition? _cameraPosition;
  Position _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  Set<Marker> _markers = Set.of([]);
  late GoogleMapController _mapController;
  List <Placemark>? plackmark;
  String address="";
  String country="";
  TextEditingController text=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _position = Position(longitude: 71.5249, latitude: 71.5249, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
    _setMarker();
  }

  convertToAddress(double lat, double long, String apikey) async {
    Dio dio = Dio();  //initilize dio package
    String apiurl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey';

    var response = await dio.get(apiurl); //send get request to API URL

    print(response.data);

    if(response.statusCode == 200){ //if connection is successful
      Map data = response.data; //get response data
      if(data['status'] == 'OK'){ //if status is "OK" returned from REST API
        if(data['results'].length > 0){ //if there is atleast one address
          Map firstResult = data['results'][0]; //select the first address
          address = firstResult['formatted_address'];
          var list=address.split(',');
          print('this is country name');
          print(list.last);
          country = list.last.trim();
          print(firstResult['geometry']['location']);


          //showCustomSnackBar(address,isError: false);//get the address

          //you can use the JSON data to get address in your own format
          setState(() {
            //refresh UI
          });
        }
      }else{
        print(data["error_message"]);
      }
    }else{
      print("error while fetching geoconding data");
    }
  }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          GoogleMap(
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(_position.latitude,_position.longitude),
              zoom: 5,
            ),
            onMapCreated: (GoogleMapController mapController) {
              _mapController = mapController;

            },
            zoomControlsEnabled: false,
            onCameraMove: (CameraPosition cameraPosition) async {
              _cameraPosition=cameraPosition;
              setState(() {
                _markers.add(Marker(markerId: const MarkerId('marker'),position: _cameraPosition!.target,));
              });
            },
            onCameraMoveStarted: () {

            },
            onCameraIdle: () async {
              print("cameraIdle");
              //plackmark= await placemarkFromCoordinates(_cameraPosition!.target.latitude, _cameraPosition!.target.longitude);
              //address="${plackmark!.first.subLocality}${plackmark!.first.locality}";
              await convertToAddress(_cameraPosition!.target.latitude, _cameraPosition!.target.longitude, "AIzaSyASi12QH3ci1x8JCZn7mNio8y0P2pBV3wo");
            },
          ),
          // Positioned(
          //     top: 40,
          //     child: Row(
          //       children: [
          //         Icon(Icons.location_on_sharp),
          //         SizedBox(width: 5,),
          //         Text(address),
          //       ],
          //     )
          // ),
          // Positioned(
          //   top: MediaQuery.of(context).size.height*0.03,
          //   left: MediaQuery.of(context).size.width*0.05,
          //   right: MediaQuery.of(context).size.width*0.05,
          //   child: Container(
          //     height: 50,
          //     decoration: BoxDecoration(
          //       color: Colors.red,
          //       borderRadius: BorderRadius.circular(12.0)
          //     ),
          //     child: CustomTextField(
          //       textInputAction: TextInputAction.done,
          //       controller: text,
          //       decoration:  InputDecoration(
          //           prefixIcon: IconButton(onPressed:() async{
          //             List<Location> locations = await locationFromAddress(text.text);
          //             _position = Position(longitude: locations[0].latitude, latitude: locations[0].longitude, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
          //             _setMarker();
          //             setState(() {});
          //
          //             print(locations[0].latitude);
          //             print(locations[0].longitude);
          //           } , icon: Icon(Icons.search)),
          //           labelText: 'Search Location',
          //           fillColor: Colors.white,
          //           filled: true,
          //           focusedBorder: InputBorder.none,
          //           enabledBorder: InputBorder.none
          //       ),
          //     ),
          //   ),
          // ),

          // Positioned(
          //   bottom: MediaQuery.of(context).size.height*0.03,
          //   left: MediaQuery.of(context).size.width*0.35,
          //   right: MediaQuery.of(context).size.width*0.35,
          //
          //   //right: MediaQuery.of(context).size.height*0.25,
          //   child: TextButton(
          //     onPressed: () async{
          //       if(_cameraPosition==null){
          //         widget.okTap!(address,country,widget.position!.latitude.toString(),widget.position!.longitude.toString());
          //        Navigator.of(context).pop();
          //
          //        // Get.back();
          //       }
          //       else{
          //         //plackmark= await placemarkFromCoordinates(_cameraPosition!.target.latitude, _cameraPosition!.target.longitude);
          //         //address="${plackmark!.first.subLocality} ${plackmark!.first.locality}";
          //         print("address"+address);
          //         print("country"+country);
          //         widget.okTap!(address,country,_cameraPosition!.target.latitude.toString(),_cameraPosition!.target.longitude.toString(),);
          //         Navigator.of(context).pop();
          //
          //       }
          //
          //     },
          //
          //     style: ButtonStyle(
          //          backgroundColor: MaterialStateProperty.all(Colors.red)
          //     ),
          //     child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          //       Text("Ok", textAlign: TextAlign.center,style: TextStyle(color: Colors.green)),
          //     ]),
          //   ),
          // ),


        ],
      ),
    );
  }
  void _setMarker() async {
    // Uint8List destinationImageData = await convertAssetToUnit8List(
    //   'assets/',
    // );
    plackmark= await placemarkFromCoordinates(_position.latitude, _position.longitude);
    address="${plackmark!.first.subLocality} ${plackmark!.first.locality}";
    country= "${plackmark!.first.country}";
    _markers.add(Marker(
      markerId: MarkerId('marker'),
      position: LatLng(_position.latitude,_position.longitude),
      //icon: BitmapDescriptor.fromBytes(destinationImageData),
    ));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }
}
