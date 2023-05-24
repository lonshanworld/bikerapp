
import "dart:async";
import "dart:typed_data";

import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/location_controller.dart";
import "package:delivery/views/loading_screen.dart";
import "package:delivery/widgets/loading_widget.dart";
import "package:flutter/material.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

import 'package:get/get.dart';


import "../models/listofplaces_model.dart";

class MapScreen extends StatefulWidget {

  final LatLng shopLatLng;
  final LatLng cusLatLng;
  final String shopaddress;
  final String cusAddress;
  final bool isDropOff;

  MapScreen({
    required this.shopLatLng,
    required this.cusLatLng,
    required this.cusAddress,
    required this.shopaddress,
    required this.isDropOff,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final Completer<GoogleMapController> completer = Completer<GoogleMapController>();
  GoogleMapController? mapController;

  final LocationController _locationController = Get.put(LocationController());
  double curLat = 0;
  double curlong = 0;
  // final TextEditingController _textController = TextEditingController();

  // double bikerlat = 0;
  // double bikerlong = 0;
  bool isloading = true;
  // String placename = "";
  // List<PlaceListModel> placeList = [];
  // bool _showbox = false;
  // late List<LatLng> polypoints = [];
  BitmapDescriptor custommarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor bikermarkerIcon= BitmapDescriptor.defaultMarker;
  BitmapDescriptor shopMarkerIcon = BitmapDescriptor.defaultMarker;


  // Future<void> assignplacevalue(value,{isInitiate = false})async{
  //
  //   Get.dialog(LoadingScreen(), barrierDismissible: false);
  //   Placemark placemarkValue = await _locationController.getplacemark(value.latitude, value.longitude);
  //   lat = value.latitude;
  //   long = value.longitude;
  //   placename = "${placemarkValue.thoroughfare}, ${placemarkValue.subAdministrativeArea}, ${placemarkValue.administrativeArea}";
  //   // if(widget.isDropOff)await getPolyPointFun(
  //   //   LatLng(lat, long),
  //   //   widget.cusLatLng,
  //   // );
  //   if(!isInitiate){
  //     mapController?.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: LatLng(value.latitude,value.longitude),
  //             zoom: 16,
  //           ),
  //         )
  //     );
  //   }
  //   Get.back();
  // }

  //
  // Future<void> getcurlocation({bool isStart = false})async{
  //   // _locationController.getcurLagLong().then((value){
  //   //   assignplacevalue(value,isInitiate: isStart);
  //   //   if(isStart){
  //   //     _initialcameraPosition = CameraPosition(
  //   //       target: LatLng(value.latitude, value.longitude),
  //   //       zoom: 16,
  //   //     );
  //   //   }
  //   // });
  //   //
  //   Position value = await _locationController.getcurLagLong();
  //   await assignplacevalue(value,isInitiate: isStart);
  //   if(isStart){
  //     _initialcameraPosition = CameraPosition(
  //       target: LatLng(value.latitude, value.longitude),
  //       zoom: 16,
  //     );
  //   }
  // }
  // //
  //
  // Future<void> getPermission() async{
  //   // _locationController.getPermission().then((value){
  //   //   print("This is permission value $value");
  //   //   if(value){
  //   //     _locationController.getLocationStream(widget.cusLatLng);
  //   //     getcurlocation(isStart: true);
  //   //   }else{
  //   //     Get.snackbar(
  //   //       "Permission",
  //   //       "Location Permission is denied",
  //   //       borderRadius: 10,
  //   //       backgroundColor: UIConstant.orange.withOpacity(0.2),
  //   //       duration: Duration(seconds: 5),
  //   //     );
  //   //   }
  //   // });
  //
  //   bool value = await _locationController.getPermission();
  //   if(value){
  //     _locationController.getLocationStream(widget.cusLatLng);
  //     await getcurlocation(isStart: true);
  //   }else{
  //     Get.snackbar(
  //       "Permission",
  //       "Location Permission is denied",
  //       borderRadius: 10,
  //       backgroundColor: UIConstant.orange.withOpacity(0.2),
  //       duration: Duration(seconds: 5),
  //     );
  //   }
  // }
  //
  //
  Future<void> getcustomMarker() async{

    Uint8List cusicon = await _locationController.getmarkerIcon("assets/images/cus_icon.png");
    Uint8List shopicon = await _locationController.getmarkerIcon("assets/images/shop_icon.png");
    Uint8List bikericon = await _locationController.getmarkerIcon("assets/images/biker_icon.png");
    custommarkerIcon = BitmapDescriptor.fromBytes(cusicon);
    shopMarkerIcon = BitmapDescriptor.fromBytes(shopicon);
    bikermarkerIcon = BitmapDescriptor.fromBytes(bikericon);

  }


  // Future<void>getPolyPointFun(LatLng firstPosition, LatLng secondPosition)async{
  //   // _locationController.getpolyPointList(
  //   //     LatLng(firstPosition.latitude, firstPosition.longitude),
  //   //     LatLng(secondPosition.latitude, secondPosition.longitude)
  //   // ).then((value) {
  //   //   polypoints = value;
  //   //
  //   // });
  //
  //   List<LatLng> value = await _locationController.getpolyPointList(
  //       LatLng(firstPosition.latitude, firstPosition.longitude),
  //       LatLng(secondPosition.latitude, secondPosition.longitude)
  //   );
  //
  //   polypoints = value;
  //   // setState(() {
  //   //   polypoints = value;
  //   //   isloading = false;
  //   // });
  // }

  getPermission(){
    // bool value = await _locationController.getPermission();
    // Position position = await _locationController.getcurLagLong();
    // if(value){
    //   if(widget.isDropOff){
    //     _locationController.getLocationStream(widget.cusLatLng);
    //   }else{
    //     _locationController.getLocationStream(widget.shopLatLng);
    //   }
    //
    //   _initialcameraPosition =CameraPosition(
    //       target: LatLng(position.latitude, position.longitude),
    //       zoom: 16,
    //   );
    // }else{
    //   Get.snackbar(
    //     "Permission",
    //     "Location Permission is denied",
    //     borderRadius: 10,
    //     backgroundColor: UIConstant.orange.withOpacity(0.2),
    //     duration: Duration(seconds: 5),
    //   );
    // }

    _locationController.getPermission().then((_)async{
      Position position = await _locationController.getcurLagLong();
      // _initialcameraPosition =CameraPosition(
      //   target: LatLng(position.latitude, position.longitude),
      //   zoom: 16,
      // );
       curLat = position.latitude;
       curlong = position.longitude;
      if(widget.isDropOff){
        _locationController.getLocationStream(widget.cusLatLng);
      }else{
        _locationController.getLocationStream(widget.shopLatLng);
      }


    });
  }

  Future<void> initFunc() async{
    await getcustomMarker();
    await getPermission();
  }

  Future<void> makemapcomplete(Completer<GoogleMapController> Cuscompleter)async{
    mapController = await Cuscompleter.future;
  }

  @override
  void initState() {
    super.initState();

    initFunc().then((_) {
      if(mounted){
        Future.delayed(Duration(seconds: 3),(){
          setState(() {
            isloading = false;
          });
        });
      }
    });
  }


  @override
  void dispose() {
    _locationController.stopLocationStream();
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    //
    // final Marker marker1 = Marker(
    //   markerId: MarkerId("biker"),
    //   position: LatLng(lat,long),
    //   draggable: true,
    //   infoWindow: InfoWindow(
    //     title: placename,
    //   ),
    //   onDragEnd: (value){
    //     assignplacevalue(value);
    //   },
    // );

    final Marker shopMarker = Marker(
      markerId: MarkerId("shop"),
      position: LatLng(widget.shopLatLng.latitude, widget.shopLatLng.longitude),
      infoWindow: InfoWindow(
        title: widget.shopaddress,
      ),
      icon: shopMarkerIcon,
      zIndex: 10,
    );

    final Marker cusMarker = Marker(
      markerId: MarkerId("cus"),
      position: LatLng(widget.cusLatLng.latitude,widget.cusLatLng.longitude),
      infoWindow: InfoWindow(
        title: widget.cusAddress,
      ),
      icon:custommarkerIcon,
      zIndex: 10,
    );

    // final Polyline _polyline = Polyline(
    //   polylineId: PolylineId(placename),
    //   color: widget.isDropOff ? Colors.purpleAccent : UIConstant.orange,
    //   points: polypoints,
    //   width: 4,
    //   geodesic: true,
    //   endCap: Cap.roundCap,
    //   startCap: Cap.roundCap,
    // );

    return SafeArea(
      child: Scaffold(
          body: isloading
              ?
          LoadingWidget()
              :
          // widget.isDropOff
          //     ?
          Obx(() {

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GoogleMap(
                    padding: EdgeInsets.all(20),
                    initialCameraPosition:  CameraPosition(
                      target: LatLng(curLat, curlong),
                      zoom: 16,
                    ),
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    // mapType: MapType.hybrid,
                    onMapCreated: (GoogleMapController controller)async{
                      // if(!completer.isCompleted){
                      //   completer.complete(controller);
                      // }
                      // print("...................map created............................");
                      completer.complete(controller);

                      if(_locationController.streamPosition.isNotEmpty){
                        // print("Point is not empty------------------------------");
                        makemapcomplete(completer).then((_) {
                          Future.delayed(Duration(milliseconds: 500),(){
                            if(widget.isDropOff){
                              mapController!.animateCamera(
                                  CameraUpdate.newLatLngBounds(
                                    LatLngBounds(
                                        southwest: LatLng(
                                            _locationController.streamPosition[0].latitude <= widget.cusLatLng.latitude ? _locationController.streamPosition[0].latitude : widget.cusLatLng.latitude,
                                            _locationController.streamPosition[0].longitude <= widget.cusLatLng.longitude ? _locationController.streamPosition[0].longitude : widget.cusLatLng.longitude
                                        ),
                                        northeast: LatLng(
                                            _locationController.streamPosition[0].latitude >= widget.cusLatLng.latitude ? _locationController.streamPosition[0].latitude : widget.cusLatLng.latitude,
                                            _locationController.streamPosition[0].longitude >= widget.cusLatLng.longitude ? _locationController.streamPosition[0].longitude : widget.cusLatLng.longitude
                                        )
                                    ),
                                    50,
                                  )
                              );
                            }else{
                              mapController!.animateCamera(
                                  CameraUpdate.newLatLngBounds(
                                    LatLngBounds(
                                        southwest: LatLng(
                                            _locationController.streamPosition[0].latitude <= widget.shopLatLng.latitude ? _locationController.streamPosition[0].latitude : widget.shopLatLng.latitude,
                                            _locationController.streamPosition[0].longitude <= widget.shopLatLng.longitude ? _locationController.streamPosition[0].longitude : widget.shopLatLng.longitude
                                        ),
                                        northeast: LatLng(
                                            _locationController.streamPosition[0].latitude >= widget.shopLatLng.latitude ? _locationController.streamPosition[0].latitude : widget.shopLatLng.latitude,
                                            _locationController.streamPosition[0].longitude >= widget.shopLatLng.longitude ? _locationController.streamPosition[0].longitude : widget.shopLatLng.longitude
                                        )
                                    ),
                                    50,
                                  )
                              );
                            }
                          });
                        });

                      }else{
                        print("Point is empty--------------------------------");
                      }
                    },
                    markers: <Marker>{
                      Marker(
                        markerId: MarkerId("biker"),
                        position: LatLng(_locationController.streamPosition[0].latitude,_locationController.streamPosition[0].longitude),
                        draggable: true,
                        icon: bikermarkerIcon,
                        infoWindow: InfoWindow(
                          title: _locationController.bikerplaceName.value,
                        ),
                        // onDragEnd: (value){
                        //   assignplacevalue(value);
                        // },
                      ),
                      shopMarker,
                      cusMarker,
                    },
                    polylines: <Polyline>{
                      Polyline(
                        polylineId: PolylineId(_locationController.bikerplaceName.value),
                        color: Colors.grey,
                        points: _locationController.polypointStream,
                        width: 6,
                        geodesic: true,
                        endCap: Cap.roundCap,
                        startCap: Cap.roundCap,
                      ),
                    },
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                        color: UIConstant.pink,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: UIConstant.orange,
                          width: 1,
                        )
                    ),
                    child: Text(
                      _locationController.bikerplaceName.value,
                      style: UIConstant.normal.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 45,
                  left: 10,
                  right: 10,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: UIConstant.pink,
                          foregroundColor: UIConstant.orange,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          })
          //     :
          // Stack(
          //   children: [
          //     Positioned(
          //       top: 0,
          //       bottom: 0,
          //       left: 0,
          //       right: 0,
          //       child: GoogleMap(
          //         padding: EdgeInsets.all(20),
          //         initialCameraPosition:  _initialcameraPosition,
          //         zoomControlsEnabled: false,
          //         // mapType: MapType.hybrid,
          //         onMapCreated: (GoogleMapController controller)async{
          //           if(!completer.isCompleted){
          //             completer.complete(controller);
          //           }
          //           mapController = await completer.future;
          //           mapController?.animateCamera(
          //               CameraUpdate.newLatLngBounds(
          //                 LatLngBounds(
          //                     southwest: LatLng(
          //                         widget.shopLatLng.latitude <= widget.cusLatLng.latitude ? widget.shopLatLng.latitude : widget.cusLatLng.latitude,
          //                         widget.shopLatLng.longitude <= widget.cusLatLng.longitude ? widget.shopLatLng.longitude : widget.cusLatLng.longitude
          //                     ),
          //                     northeast: LatLng(
          //                         widget.shopLatLng.latitude >= widget.cusLatLng.latitude ? widget.shopLatLng.latitude : widget.cusLatLng.latitude,
          //                         widget.shopLatLng.longitude >= widget.cusLatLng.longitude ? widget.shopLatLng.longitude : widget.cusLatLng.longitude
          //                     )
          //                 ),
          //                 50,
          //               )
          //           );
          //         },
          //         onTap: (value){
          //           assignplacevalue(value);
          //         },
          //         markers: <Marker>{
          //           Marker(
          //             markerId: MarkerId("biker"),
          //             position: LatLng(lat,long),
          //             draggable: true,
          //             infoWindow: InfoWindow(
          //               title: placename,
          //             ),
          //             onDragEnd: (value){
          //               assignplacevalue(value);
          //             },
          //           ),
          //           shopMarker,
          //           cusMarker,
          //         },
          //         polylines: <Polyline>{
          //           Polyline(
          //             polylineId: PolylineId(placename),
          //             color: widget.isDropOff ? Colors.purpleAccent : UIConstant.orange,
          //             points: polypoints,
          //             width: 4,
          //             geodesic: true,
          //             endCap: Cap.roundCap,
          //             startCap: Cap.roundCap,
          //           ),
          //         },
          //       ),
          //     ),
          //     Positioned(
          //       bottom: 30,
          //       left: 20,
          //       right: 20,
          //       child: Container(
          //         padding: EdgeInsets.symmetric(
          //           horizontal: 20,
          //           vertical: 10,
          //         ),
          //         decoration: BoxDecoration(
          //             color: UIConstant.pink,
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(10),
          //             ),
          //             border: Border.all(
          //               style: BorderStyle.solid,
          //               color: UIConstant.orange,
          //               width: 1,
          //             )
          //         ),
          //         child: Text(
          //           placename,
          //           style: TextStyle(
          //             color: Colors.black,
          //           ),
          //         ),
          //       ),
          //     ),
          //     Positioned(
          //       top: 45,
          //       left: 10,
          //       right: 20,
          //       child:Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           IconButton(
          //             onPressed: (){
          //               Get.back();
          //             },
          //             icon: Icon(
          //               Icons.arrow_back_ios,
          //               size: 28,
          //               color: UIConstant.orange,
          //             ),
          //           ),
          //           Container(
          //             decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.all(
          //                   Radius.circular(10),
          //                 ),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Color(0xffDDDDDD),
          //                     blurRadius: 6.0,
          //                     spreadRadius: 2.0,
          //                     offset: Offset(0.0, 0.0),
          //                   )
          //                 ]
          //             ),
          //             child: Row(
          //               children: [
          //                 Container(
          //                   padding: EdgeInsets.symmetric(
          //                     horizontal: 10,
          //                     vertical: 0,
          //                   ),
          //                   width : (deviceWidth / 100) * 62,
          //                   child: TextField(
          //                     controller: _textController,
          //                     decoration: InputDecoration(
          //                       border: InputBorder.none,
          //                       hintText: "Enter Address...",
          //                       hintStyle: UIConstant.normal.copyWith(
          //                         color: Colors.grey,
          //                       ),
          //                     ),
          //                     style: UIConstant.normal.copyWith(
          //                       color: Colors.black,
          //                     ),
          //                     onChanged: (value){
          //                       if(value != ""){
          //                         _locationController.getListofplaces(value).then((value) {
          //                           setState(() {
          //                             _showbox = true;
          //                             placeList = value;
          //                           });
          //                         });
          //                       }else{
          //                         setState(() {
          //                           _showbox = false;
          //                         });
          //                       }
          //                     },
          //                   ),
          //                 ),
          //                 IconButton(
          //                   onPressed: (){
          //                     setState(() {
          //                       _textController.clear();
          //                     });
          //                   },
          //                   icon: Icon(Icons.close),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     if(_showbox) Positioned(
          //       top: 90,
          //       left: 40,
          //       right: 40,
          //       bottom: (deviceHeight/100) * 60,
          //       child: ListView.builder(
          //         itemCount: placeList.length,
          //         itemBuilder: (ctx, index){
          //           return Material(
          //             color: Colors.white,
          //             shape: Border(
          //               bottom: BorderSide(
          //                 width: 1,
          //                 color: Colors.grey.shade300,
          //               ),
          //             ),
          //             child: InkWell(
          //               onTap: (){
          //                 _locationController.getplaceDetailfromId(placeList[index].placeId).then((value) {
          //                   mapController?.animateCamera(
          //                       CameraUpdate.newCameraPosition(
          //                         CameraPosition(target: value, zoom: 17),
          //                       )
          //                   );
          //                   assignplacevalue(value);
          //                   setState(() {
          //                     _textController.text = placeList[index].placename;
          //                     _showbox = false;
          //                   });
          //                 });
          //               },
          //               child: Padding(
          //                 padding: EdgeInsets.symmetric(
          //                   vertical: 8,
          //                   horizontal: 10,
          //                 ),
          //                 child: Text(
          //                   placeList[index].placename,
          //                   style: TextStyle(
          //                     color: Colors.black,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //     Positioned(
          //       bottom: 100,
          //       right: 20,
          //       child: ElevatedButton(
          //         onPressed: () {
          //           getcurlocation();
          //         },
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: UIConstant.pink,
          //           shape: CircleBorder(
          //             side: BorderSide(
          //               color: UIConstant.orange,
          //             ),
          //           ),
          //           padding: EdgeInsets.all(10),
          //         ),
          //         child: Icon(
          //           Icons.gps_fixed_outlined,
          //           size: 28,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ),
          //   ],
          // )
      ),
    );
  }
}
