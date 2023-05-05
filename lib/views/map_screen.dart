
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/location_controller.dart";
import "package:delivery/views/loading_screen.dart";
import "package:delivery/widgets/loading_widget.dart";
import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

import 'package:get/get.dart';
import "package:sizer/sizer.dart";

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

  GoogleMapController? _controller;
  late CameraPosition _initialcameraPosition;
  final LocationController _locationController = Get.find<LocationController>();
  final TextEditingController _textController = TextEditingController();

  double lat = 0;
  double long = 0;
  bool isloading = true;
  String placename = "";
  List<PlaceListModel> placeList = [];
  bool _showbox = false;
  late List<LatLng> polypoints = [];
  BitmapDescriptor custommarkerIcon = BitmapDescriptor.defaultMarker;


  void assignplacevalue(value,{isInitiate = false}){
    Get.dialog(LoadingScreen(), barrierDismissible: false);
    _locationController.getplacemark(value.latitude, value.longitude).then((_placemark){
      setState(() {
        lat = value.latitude;
        long = value.longitude;
        placename = "${_placemark.thoroughfare}, ${_placemark.subAdministrativeArea}, ${_placemark.administrativeArea}";
        if(widget.isDropOff)getPolyPointFun(
          LatLng(lat, long),
          widget.cusLatLng,
        );
      });

      if(!isInitiate){
        _controller?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(value.latitude,value.longitude),
                zoom: 16,
              ),
            )
        );
      }
      Get.back();
    });
  }


  void getcurlocation({bool isStart = false}){
    _locationController.getcurLagLong().then((value){
      assignplacevalue(value,isInitiate: isStart);
    });
  }
  //

  void getPermission(){
    _locationController.getPermission().then((value){
      print("This is permission value $value");
      if(value){
        _locationController.getLocationStream();
        getcurlocation(isStart: true);
      }else{
        Get.snackbar(
          "Permission",
          "Location Permission is denied",
          borderRadius: 10,
          backgroundColor: UIConstant.orange.withOpacity(0.2),
          duration: Duration(seconds: 5),
        );
      }
    });
  }


  void getcustomMarker(){
    _locationController.getmarkerIcon().then((icon){
      setState(() {
        custommarkerIcon = BitmapDescriptor.fromBytes(icon);
      });
    });
  }


  getPolyPointFun(LatLng firstPosition, LatLng secondPosition){
    _locationController.getpolyPointList(
        LatLng(firstPosition.latitude, firstPosition.longitude),
        LatLng(secondPosition.latitude, secondPosition.longitude)
    ).then((value) {
      setState(() {
        polypoints = value;
      });
    });
    // setState(() {
    //   polypoints = value;
    //   isloading = false;
    // });
  }


  @override
  void initState() {
    super.initState();
    getcustomMarker();
    getPermission();
    _initialcameraPosition = CameraPosition(
      target: widget.shopLatLng,
    );

    if(!widget.isDropOff){
      getPolyPointFun(
        // LatLng(widget.shopLatLng.latitude, widget.shopLatLng.longitude),
        // LatLng(widget.cusLatLng.latitude,widget.cusLatLng.longitude),
        widget.shopLatLng,
        widget.cusLatLng,
      );
    }
    setState(() {
      isloading = false;
    });
  }


  @override
  void dispose() {
    _locationController.stopLocationStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Marker marker1 = Marker(
      markerId: MarkerId("1"),
      position: LatLng(lat,long),
      draggable: true,
      infoWindow: InfoWindow(
        title: placename,
      ),
      onDragEnd: (value){
        assignplacevalue(value);
      },
    );

    final Marker shopMarker = Marker(
      markerId: MarkerId("shop"),
      position: LatLng(widget.shopLatLng.latitude, widget.shopLatLng.longitude),
      infoWindow: InfoWindow(
        title: widget.shopaddress,
      ),
      icon: custommarkerIcon,
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

    final Polyline _polyline = Polyline(
      polylineId: PolylineId(placename),
      color: widget.isDropOff ? Colors.purpleAccent : UIConstant.orange,
      points: polypoints,
      width: 8,
      geodesic: true,
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
    );

    return Scaffold(
        body: isloading
            ?
        LoadingWidget()
            :
        widget.isDropOff
            ?
        Obx(() {
          lat = _locationController.streamPosition[0].latitude;
          long = _locationController.streamPosition[0].longitude;
          _locationController.getpolyPointList(LatLng(lat, long), widget.cusLatLng).then((value){
            _locationController.getplacemark(lat, long).then((_placemark){
              setState(() {
                polypoints = value;
                placename = "${_placemark.thoroughfare}, ${_placemark.subAdministrativeArea}, ${_placemark.administrativeArea}";
              });
            });
          });
          return Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: GoogleMap(
                  padding: EdgeInsets.all(3.h),
                  initialCameraPosition:  _initialcameraPosition,
                  zoomControlsEnabled: false,
                  // mapType: MapType.hybrid,
                  onMapCreated: (GoogleMapController controller){
                    setState(() {
                      _controller = controller;
                    });
                    _controller?.animateCamera(
                        CameraUpdate.newLatLngBounds(
                          LatLngBounds(
                              southwest: LatLng(
                                  widget.shopLatLng.latitude <= widget.cusLatLng.latitude ? widget.shopLatLng.latitude : widget.cusLatLng.latitude,
                                  widget.shopLatLng.longitude <= widget.cusLatLng.longitude ? widget.shopLatLng.longitude : widget.cusLatLng.longitude
                              ),
                              northeast: LatLng(
                                  widget.shopLatLng.latitude >= widget.cusLatLng.latitude ? widget.shopLatLng.latitude : widget.cusLatLng.latitude,
                                  widget.shopLatLng.longitude >= widget.cusLatLng.longitude ? widget.shopLatLng.longitude : widget.cusLatLng.longitude
                              )
                          ),
                          50,
                        )
                    );
                  },

                  markers: <Marker>{
                    marker1,
                    shopMarker,
                    cusMarker,
                  },
                  polylines: <Polyline>{
                    _polyline,
                  },
                ),
              ),
              Positioned(
                bottom: 4.h,
                left: 3.h,
                right: 3.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.h,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                      color: UIConstant.pink,
                      borderRadius: BorderRadius.all(
                        Radius.circular(1.5.h),
                      ),
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: UIConstant.orange,
                        width: 1,
                      )
                  ),
                  child: Text(
                    placename,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6.h,
                left: 1.5.h,
                right: 1.5.h,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: (){
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30.sp,
                        color: UIConstant.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        })
            :
        Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: GoogleMap(
                padding: EdgeInsets.all(3.h),
                initialCameraPosition:  _initialcameraPosition,
                zoomControlsEnabled: false,
                // mapType: MapType.hybrid,
                onMapCreated: (GoogleMapController controller){
                  setState(() {
                    _controller = controller;
                  });
                  _controller?.animateCamera(
                      CameraUpdate.newLatLngBounds(
                        LatLngBounds(
                            southwest: LatLng(
                                widget.shopLatLng.latitude <= widget.cusLatLng.latitude ? widget.shopLatLng.latitude : widget.cusLatLng.latitude,
                                widget.shopLatLng.longitude <= widget.cusLatLng.longitude ? widget.shopLatLng.longitude : widget.cusLatLng.longitude
                            ),
                            northeast: LatLng(
                                widget.shopLatLng.latitude >= widget.cusLatLng.latitude ? widget.shopLatLng.latitude : widget.cusLatLng.latitude,
                                widget.shopLatLng.longitude >= widget.cusLatLng.longitude ? widget.shopLatLng.longitude : widget.cusLatLng.longitude
                            )
                        ),
                        50,
                      )
                  );
                },
                onTap: (value){
                  assignplacevalue(value);
                },
                markers: <Marker>{
                  marker1,
                  shopMarker,
                  cusMarker,
                },
                polylines: <Polyline>{
                  _polyline,
                },
              ),
            ),
            Positioned(
              bottom: 4.h,
              left: 3.h,
              right: 3.h,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.h,
                  vertical: 1.5.h,
                ),
                decoration: BoxDecoration(
                    color: UIConstant.pink,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.5.h),
                    ),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: UIConstant.orange,
                      width: 1,
                    )
                ),
                child: Text(
                  placename,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 6.h,
              left: 1.5.h,
              right: 2.h,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: (){
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.sp,
                      color: UIConstant.orange,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(1.5.h),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffDDDDDD),
                            blurRadius: 6.0,
                            spreadRadius: 2.0,
                            offset: Offset(0.0, 0.0),
                          )
                        ]
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.5.h,
                            vertical: 0,
                          ),
                          width : 62.w,
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Address...",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                            onChanged: (value){
                              if(value != ""){
                                _locationController.getListofplaces(value).then((value) {
                                  setState(() {
                                    _showbox = true;
                                    placeList = value;
                                  });
                                });
                              }else{
                                setState(() {
                                  _showbox = false;
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            setState(() {
                              _textController.clear();
                            });
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if(_showbox) Positioned(
              top: 14.h,
              left: 6.h,
              right: 6.h,
              bottom: 30.h,
              child: ListView.builder(
                itemCount: placeList.length,
                itemBuilder: (ctx, index){
                  return Material(
                    color: Colors.white,
                    shape: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: InkWell(
                      onTap: (){
                        _locationController.getplaceDetailfromId(placeList[index].placeId).then((value) {
                          _controller?.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(target: value, zoom: 17),
                              )
                          );
                          assignplacevalue(value);
                          setState(() {
                            _textController.text = placeList[index].placename;
                            _showbox = false;
                          });
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 1.h,
                          horizontal: 1.5.h,
                        ),
                        child: Text(
                          placeList[index].placename,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 14.h,
              right: 3.h,
              child: ElevatedButton(
                onPressed: () {
                  getcurlocation();
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: UIConstant.orange,
                  shape: CircleBorder(
                    side: BorderSide.none,
                  ),
                  padding: EdgeInsets.all(1.5.h),
                ),
                child: Icon(
                  Icons.gps_fixed_outlined,
                  size: 28.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        )
    );
  }
}
