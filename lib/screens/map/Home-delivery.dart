import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fstore/common/constants.dart';
import 'package:fstore/widgets/common/custom_text_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:places_service/places_service.dart';

import '../../modules/dynamic_layout/dynamic_layout.dart';



String address='';
class HomeDelivery extends StatefulWidget {

  HomeDelivery({Key? key}) : super(key: key);

  @override
  State<HomeDelivery> createState() => _HomeDeliveryState();
}

class _HomeDeliveryState extends State<HomeDelivery> {

  CameraPosition? _cameraPosition;
  Position? _position;
  Set<Marker> _markers = Set.of([]);
  late GoogleMapController _mapController;
  List <Placemark>? plackmark;
  String country="";
  TextEditingController text=TextEditingController();
  List <Placemark>? placeMark;
  late Position userLocation;
  PlacesService  _placesService= PlacesService();
  List<PlacesAutoCompleteResult>  _autoCompleteResult=[];
  PlacesDetails? placeDetails;
  bool? isLoading;

  String city='';
  var currentLocation;

  void _getLocation() async {

    currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userLocation=currentLocation;
    _position = Position(longitude: userLocation.longitude, latitude: userLocation.latitude , timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);

    setState(() {});
    if(_position!=null) {
      var placeMarks = await placemarkFromCoordinates(userLocation.latitude,userLocation.longitude);
      _setMarker(_position!.latitude,_position!.longitude,location: '${placeMarks[0].locality!} ' +  placeMarks[0].subLocality! );
    }
    await _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_position!.latitude,_position!.longitude),
            zoom: 17,
          ),
        )
    );

    await convertToAddress(_position!.latitude, _position!.longitude, 'AIzaSyASi12QH3ci1x8JCZn7mNio8y0P2pBV3wo');

    //
    // var placeMarks = await placemarkFromCoordinates(userLocation.latitude,userLocation.longitude);
    // print("Location");
    // print(placeMarks[0].locality!);
    // print(placeMarks[0].subLocality!);
    // print(placeMarks[0].street!);
    // print(placeMarks[0].name!);
    // print(placeMarks[0].country!);
    // print(placeMarks[0].subAdministrativeArea!);
    // print(placeMarks[0].administrativeArea!);
    // print(placeMarks[0].subThoroughfare!);
    // print(placeMarks[0].thoroughfare!);
    // print("Location");
    // address='${placeMarks[0].subLocality!} ' + ' ${placeMarks[0].locality!}' + ' ${placeMarks[0].country!}';
    setState(() {});
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    _placesService.initialize(apiKey: 'AIzaSyASi12QH3ci1x8JCZn7mNio8y0P2pBV3wo');
  }

  void _setMarker(lat,lng,{String location=''}) async {
    _markers.add(Marker(
      infoWindow: InfoWindow(title: 'Delivery to : ',snippet: location),
      markerId: MarkerId('marker'),
      position: LatLng(lat,lng),
    ));
    setState(() {});
  }


  Future  convertToAddress(double lat, double long, String apikey) async {
    var dio = Dio();  //initilize dio package
    var apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey';

    var response = await dio.get(apiUrl); //send get request to API URL

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
          print(data['results'][0]['formatted_address']);

          //showCustomSnackBar(address,isError: false);//get the address
          //you can use the JSON data to get address in your own format
          setState(() {
            //refresh UI
          }

          );

        }

      }
      else{

        print(data['error_message']);

      }

    }
    else{

      print('error while fetching geoconding data');

    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Stack(
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height/1.8,
              child: GoogleMap(
                cameraTargetBounds: CameraTargetBounds(
                  LatLngBounds(
                    northeast: LatLng(25.3462, 55.4211),
                    southwest: LatLng(23.4241, 53.8478),
                  ),
                ),
                markers: _markers,
                mapType: MapType.normal,
                //  myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(_position?.latitude??22.735110,_position?.longitude??75.917380),
                  zoom: 17,
                ),
                onMapCreated: (GoogleMapController mapController) {
                  _mapController = mapController;
                },
                zoomControlsEnabled: true,
                onCameraMove: (CameraPosition cameraPosition) async {
                  _cameraPosition=cameraPosition;
                  _setMarker(_cameraPosition!.target.latitude,_cameraPosition!.target.longitude);

                  await convertToAddress(_cameraPosition!.target.latitude, _cameraPosition!.target.longitude, "AIzaSyASi12QH3ci1x8JCZn7mNio8y0P2pBV3wo");
                  //address='${placeMark![0].subLocality!} ' + ' ${placeMark![0].locality!} ' + '  ${placeMark![0].country!}';

                },
                // onCameraMoveStarted: () {
                //
                // },
                // onCameraIdle: () async {
                //    print("cameraIdle");
                //    _setMarker(_cameraPosition!.target.latitude,_cameraPosition!.target.longitude,);
                //
                //    // setState(() {
                //    //   _markers.add(Marker(markerId: const MarkerId('marker'),position: _cameraPosition!.target,));
                //    // });
                //    await convertToAddress(_cameraPosition!.target.latitude, _cameraPosition!.target.longitude, "AIzaSyASi12QH3ci1x8JCZn7mNio8y0P2pBV3wo");
                //
                //   plackmark= await placemarkFromCoordinates(_cameraPosition!.target.latitude, _cameraPosition!.target.longitude);
                //   address="${plackmark!.first.subLocality}${plackmark!.first.locality}";
                // },
              ),
            ),
            Positioned(
              bottom: 5,
              left: 12,
              child: Container(
                color: Colors.white,
                height: 50,
                width: 40,
                child:  IconButton(onPressed: () async{
                  await _mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                      bearing: 0,
                      target: LatLng(_position!.latitude,_position!.longitude,),
                      zoom: 17.0,
                    ),
                  ));
                } ,icon: Icon(Icons.gps_fixed_sharp)),
              ),
            ),
            isLoading==false ? const Padding(
              padding: EdgeInsets.only(top:80.0),
              child: Center(child: CircularProgressIndicator()),
            ):
            _autoCompleteResult.isNotEmpty ?
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0,top: 50),
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height/3,
                  color: Colors.white,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:_autoCompleteResult.length,
                      itemBuilder: (context,index){
                        print(_autoCompleteResult[index].toJson());
                        return Column(
                          children: [
                            ListTile(
                              title: Text(_autoCompleteResult[index].description??""),
                              onTap: () async {
                                text.clear();
                                var locations = await locationFromAddress(_autoCompleteResult[index].description.toString());
                                if(locations.isNotEmpty) {
                                  await _mapController.animateCamera(CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                          zoom: 17,
                                          target: LatLng(locations[0].latitude,locations[0].longitude))));
                                  _setMarker(locations[0].latitude,locations[0].longitude,location: _autoCompleteResult[index].description.toString());
                                }
                                address =_autoCompleteResult[index].description.toString();
                                _autoCompleteResult.clear();
                                setState(() {});
                              },
                            ),
                            Divider(thickness: 1,color: Colors.grey.shade300,),
                          ],
                        );
                      }),
                ),
              ),
            ): const SizedBox(),
            ///location search textfield
            Padding(
              padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.02,left:MediaQuery.of(context).size.width*0.02,right: MediaQuery.of(context).size.width*0.02),
              child: Container(
                height: MediaQuery.of(context).size.height/17,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0)
                ),
                child: CustomTextField(
                  controller: text,
                  onChanged: (value)async{
                    if(value.isNotEmpty){
                      isLoading=false;
                      setState(() {});
                      final autoCompleteSuggestions = await _placesService.getAutoComplete(value);
                      _autoCompleteResult = autoCompleteSuggestions;
                      if(_autoCompleteResult.isNotEmpty)
                        isLoading=true;
                      setState(() {});
                    }
                    else {
                      _autoCompleteResult.clear();
                    }
                    setState(() {});
                  },
                  decoration:  InputDecoration(
                      prefixIcon: IconButton(
                          onPressed:() async{

                          } , icon: const Icon(Icons.search)),
                      hintText: 'Search Location',
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none
                  ),
                ),
              ),
            ),



          ],
        ),

        Expanded(
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            elevation: 20.0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height/7,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0,left: 10),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children:  [
                        const Icon(Icons.location_on_sharp,color: Colors.green),
                        const SizedBox(width: 10),
                        Text(address ,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                              RouteList.dashboard, (Route<dynamic> route) => true);
                        },
                        child: const Text('Continue',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold))),
                  )
                ],
              ),
            ),
          ),
        ),


      ],
    );
  }
}