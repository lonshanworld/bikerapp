
import 'dart:async';
import 'dart:typed_data';

import 'package:delivery/controllers/order_controller.dart';
import 'package:delivery/controllers/useraccount_controller.dart';
import 'package:delivery/models/order_model.dart';
import 'package:delivery/routehelper.dart';
import 'package:delivery/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:get/get.dart";


import '../constants/uiconstants.dart';
import '../controllers/location_controller.dart';
import '../widgets/customButton_widget.dart';
import 'chat_screen.dart';
import 'map_screen.dart';


class DropOffScreen extends StatefulWidget {

  final String orderId;

  const DropOffScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<DropOffScreen> createState() => _DropOffScreenState();
}

class _DropOffScreenState extends State<DropOffScreen>  with SingleTickerProviderStateMixin{

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GoogleMapController? mapController;
  // CameraPosition _initialcameraPosition = CameraPosition(
  //     target: LatLng(0, 0),
  //     zoom: 16
  // );
  final OrderController orderController = Get.find<OrderController>();
  final LocationController _locationController = Get.put(LocationController());
  final UserAccountController userAccountController = Get.find<UserAccountController>();

  bool isloading = true;
  double curlat = 0;
  double curlong = 0;
  String curplacename = "";
  late List<LatLng> polypoints = [];
  BitmapDescriptor custommarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor bikermarkerIcon= BitmapDescriptor.defaultMarker;
  BitmapDescriptor shopMarkerIcon = BitmapDescriptor.defaultMarker;
  OrderDetailModel? orderDetailModel;

  AnimationController? anicontroller;
  CurvedAnimation? curvedAnimation;


  _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  getCurrentLocation(){
    // await _locationController.getPermission().then((value){
    //   if(value){
    //     _locationController.getcurLagLong().then((_location){
    //       _locationController.getplacemark(_location.latitude, _location.longitude).then((txtplace)async{
    //         // setState(() {
    //         //   curlat = _location.latitude;
    //         //   curlong = _location.longitude;
    //         //   curplacename = "${txtplace.thoroughfare}, ${txtplace.subAdministrativeArea}, ${txtplace.administrativeArea}";
    //         //   _initialcameraPosition = CameraPosition(
    //         //     target: LatLng(curlat, curlong),
    //         //   );
    //         // });
    //         curlat = _location.latitude;
    //         curlong = _location.longitude;
    //         curplacename = "${txtplace.thoroughfare}, ${txtplace.subAdministrativeArea}, ${txtplace.administrativeArea}";
    //         _initialcameraPosition = CameraPosition(
    //           target: LatLng(curlat, curlong),
    //           zoom: 16
    //         );
    //
    //         getPolypoints();
    //       });
    //     });
    //   }else{
    //     Get.snackbar(
    //       "Permission",
    //       "Location Permission is denied",
    //       borderRadius: 10,
    //       backgroundColor: UIConstant.orange.withOpacity(0.2),
    //       duration: const Duration(seconds: 5),
    //     );
    //   }
    // });

    // bool value = await _locationController.getPermission();
    // if(value){
    //   Position _location = await _locationController.getcurLagLong();
    //   Placemark txtplace = await _locationController.getplacemark(_location.latitude, _location.longitude);
    //   curlat = _location.latitude;
    //   curlong = _location.longitude;
    //   curplacename = "${txtplace.thoroughfare}, ${txtplace.subAdministrativeArea}, ${txtplace.administrativeArea}";
    //   _initialcameraPosition = CameraPosition(
    //       target: LatLng(curlat, curlong),
    //       zoom: 16
    //   );
    //   await getPolypoints();
    // }else{
    //   Get.snackbar(
    //     "Permission",
    //     "Location Permission is denied",
    //     borderRadius: 10,
    //     backgroundColor: UIConstant.orange.withOpacity(0.2),
    //     duration: const Duration(seconds: 5),
    //   );
    // }

    _locationController.getPermission().then((_)async{
      Position _location = await _locationController.getcurLagLong();
      Placemark txtplace = await _locationController.getplacemark(_location.latitude, _location.longitude);
      curlat = _location.latitude;
      curlong = _location.longitude;
      curplacename = "${txtplace.thoroughfare}, ${txtplace.subAdministrativeArea}, ${txtplace.administrativeArea}";
      await getPolypoints();
    });
  }

  Future<void> getPolypoints()async{
    // _locationController.getpolyPointList(LatLng(curlat, curlong), LatLng(orderDetailModel!.cuslat!.toDouble(), orderDetailModel!.cuslong!.toDouble())).then((value)async{
    //   print("This is from drop off screen............................");
    //   print(LatLng(curlat, curlong));
    //   print(value);
    //
    //   polypoints = value;
    //   if(mounted){
    //     setState(() {
    //       isloading = false;
    //     });
    //   }
    // });

    polypoints = await _locationController.getpolyPointList(LatLng(curlat, curlong), LatLng(orderDetailModel!.cuslat!.toDouble(), orderDetailModel!.cuslong!.toDouble()));
  }

  Future getcustomMarker()async{
    // await _locationController.getmarkerIcon().then((icon){
    //   setState(() {
    //     custommarkerIcon = BitmapDescriptor.fromBytes(icon);
    //   });
    // });

    Uint8List cusicon = await _locationController.getmarkerIcon("assets/images/cus_icon.png");
    Uint8List shopicon = await _locationController.getmarkerIcon("assets/images/shop_icon.png");
    Uint8List bikericon = await _locationController.getmarkerIcon("assets/images/biker_icon.png");
    custommarkerIcon = BitmapDescriptor.fromBytes(cusicon);
    shopMarkerIcon = BitmapDescriptor.fromBytes(shopicon);
    bikermarkerIcon = BitmapDescriptor.fromBytes(bikericon);
  }

  Future<void> assignOrder()async{
    // await orderController.getSingleOrderDetail(widget.orderId).then((value) async{
    //   orderDetailModel = value;
    //   await getcustomMarker();
    //   await getCurrentLocation();
    // });

    orderDetailModel = await orderController.getSingleOrderDetail(widget.orderId);
    await getCurrentLocation();
    await getcustomMarker();

  }

  Future<void>makemapcomplete(Completer<GoogleMapController> Cuscompleter)async{
    mapController = await Cuscompleter.future;
  }

  @override
  void initState() {
    super.initState();
    anicontroller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
      reverseDuration: Duration(milliseconds: 500),
      animationBehavior: AnimationBehavior.preserve,
    );
    curvedAnimation = CurvedAnimation(
      parent: anicontroller!,
      curve: Curves.bounceIn,
      reverseCurve: Curves.bounceOut,
    );
    assignOrder().then((_){
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
    mapController?.dispose();
    _locationController.stopLocationStream();
    anicontroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    late Marker marker1 = Marker(
      markerId: MarkerId("biker"),
      position: LatLng(curlat,curlong),
      draggable: false,
      icon:bikermarkerIcon,
      infoWindow: InfoWindow(
        title: curplacename,
      ),
    );

    late Marker shopMarker = Marker(
      markerId: MarkerId("shop"),
      position: LatLng(orderDetailModel!.shoplat!.toDouble(), orderDetailModel!.shoplong!.toDouble()),
      infoWindow: InfoWindow(
        title: "${orderDetailModel!.shopName} ,${orderDetailModel!.shopAddress}",
      ),
      icon: shopMarkerIcon,
      zIndex: 10,
    );

    late Marker cusMarker = Marker(
      markerId: MarkerId("cus"),
      position: LatLng(orderDetailModel!.cuslat!.toDouble(), orderDetailModel!.cuslong!.toDouble()),
      infoWindow: InfoWindow(
        title: orderDetailModel!.cusAddress,
      ),
      icon:custommarkerIcon,
      zIndex: 10,
    );

    late Polyline _polyline = Polyline(
      polylineId: PolylineId("1"),
      color: Colors.grey,
      points: polypoints,
      width: 6,
      geodesic: true,
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
    );


    return isloading
        ?
      Scaffold(
        appBar: AppBar(
          title: Text(
            userAccountController.bikermodel[0].fullName!,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 24,
            ),
            onPressed: (){
              // Get.offAllNamed(RouteHelper.getHomePage());
              Get.back();
            },
          ),
        ),
        body: LoadingWidget(),
      )
        :
      Scaffold(
        appBar: AppBar(
          title: Text(
            userAccountController.bikermodel[0].fullName!,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 24,
            ),
            onPressed: (){
              // Get.offAllNamed(RouteHelper.getHomePage());
              Get.back();
            },
          ),
        ),
        body: Center(
          child: SizedBox(
            width: deviceWidth > 500 ? deviceWidth * 0.85 : deviceWidth,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "cusmap".tr,
                      style: UIConstant.normal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomButton(
                      verticalPadding: 5,
                      horizontalPadding: 20,
                      txt: "askhelp".tr,
                      func: (){

                      },
                      txtClr: Colors.white,
                      bgClr: UIConstant.orange,
                      txtsize: 12,
                      rad: 5,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  height: deviceHeight / 2,
                  child:  GoogleMap(
                    initialCameraPosition:  CameraPosition(
                        target: LatLng(curlat, curlong),
                        zoom: 16
                    ),
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,

                    onMapCreated: (GoogleMapController controller)async{
                      // setState(() {
                      //   _controller = controller;
                      // });
                      // controller.animateCamera(
                      //     CameraUpdate.newLatLngBounds(
                      //       LatLngBounds(
                      //           southwest: LatLng(
                      //             curlat <= orderDetailModel!.cuslat!.toDouble() ? curlat : orderDetailModel!.cuslat!.toDouble(),
                      //             curlong <= orderDetailModel!.cuslong!.toDouble() ? curlong : orderDetailModel!.cuslong!.toDouble(),
                      //           ),
                      //           northeast: LatLng(
                      //             curlat >= orderDetailModel!.cuslat!.toDouble() ? curlat : orderDetailModel!.cuslat!.toDouble(),
                      //             curlong >= orderDetailModel!.cuslong!.toDouble() ? curlong : orderDetailModel!.cuslong!.toDouble(),
                      //           )
                      //       ),
                      //       80,
                      //     )
                      // );
                      // if(!_controller.isCompleted){
                      //
                      // }
                      _controller.complete(controller);

                      makemapcomplete(_controller).then((_){
                        Future.delayed(Duration(seconds: 1),(){
                          mapController!.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                LatLngBounds(
                                    southwest: LatLng(
                                      curlat <= orderDetailModel!.cuslat!.toDouble() ? curlat : orderDetailModel!.cuslat!.toDouble(),
                                      curlong <= orderDetailModel!.cuslong!.toDouble() ? curlong : orderDetailModel!.cuslong!.toDouble(),
                                    ),
                                    northeast: LatLng(
                                      curlat >= orderDetailModel!.cuslat!.toDouble() ? curlat : orderDetailModel!.cuslat!.toDouble(),
                                      curlong >= orderDetailModel!.cuslong!.toDouble() ? curlong : orderDetailModel!.cuslong!.toDouble(),
                                    )
                                ),
                                80,
                              )
                          );
                        });
                      });
                      // print("Completer value ${_controller.isCompleted}");
                      // print(_controller.future);


                    },
                    markers: <Marker>{
                      marker1,
                      shopMarker,
                      cusMarker,
                    },
                    polylines: <Polyline>{
                      _polyline,
                    },
                    onLongPress: (_){
                      mapController?.dispose();
                      Get.to(() => MapScreen(
                          shopLatLng: LatLng(orderDetailModel!.shoplat!.toDouble(),orderDetailModel!.shoplong!.toDouble()),
                          cusLatLng: LatLng(orderDetailModel!.cuslat!.toDouble(),orderDetailModel!.cuslong!.toDouble()),
                          cusAddress: orderDetailModel!.cusAddress!,
                          shopaddress: orderDetailModel!.shopAddress!,
                          isDropOff: true
                      ));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderDetailModel!.phone!,
                      style: UIConstant.normal.copyWith(
                        fontWeight: FontWeight.bold,
                        color: UIConstant.orange,
                      ),
                    ),
                    CustomButton(
                      verticalPadding: 5,
                      horizontalPadding: 20,
                      txt: "viewmap".tr,
                      func: (){
                        mapController?.dispose();
                        Get.to(() => MapScreen(
                            shopLatLng: LatLng(orderDetailModel!.shoplat!.toDouble(),orderDetailModel!.shoplong!.toDouble()),
                            cusLatLng: LatLng(orderDetailModel!.cuslat!.toDouble(),orderDetailModel!.cuslong!.toDouble()),
                            cusAddress: orderDetailModel!.cusAddress!,
                            shopaddress: orderDetailModel!.shopAddress!,
                            isDropOff: true
                        ));
                      },
                      txtClr: Colors.white,
                      bgClr: Colors.grey.shade600,
                      txtsize: 12,
                      rad: 5,
                    ),
                  ],
                ),
                Text(
                  orderDetailModel!.cusName!,
                  style: UIConstant.small.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  orderDetailModel!.cusAddress!,
                  style: UIConstant.small,
                ),
                SizedBox(
                  height: 10,
                ),
                // CustomButton(
                //   verticalPadding: 5,
                //   horizontalPadding: 0,
                //   txt: "call".tr,
                //   func: (){
                //     _makePhoneCall(orderDetailModel!.phone!);
                //   },
                //   txtClr: Colors.white,
                //   bgClr: UIConstant.orange,
                //   txtsize: 12,
                //   rad: 5,
                // ),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        verticalPadding: 5,
                        horizontalPadding: 0,
                        txt: "call".tr,
                        func: (){
                          _makePhoneCall(orderDetailModel!.phone!);
                        },
                        txtClr: Colors.white,
                        bgClr: UIConstant.orange,
                        txtsize: 12,
                        rad: 5,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: CustomButton(
                        verticalPadding: 5,
                        horizontalPadding: 0,
                        txt: "Chat",
                        func: (){
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            transitionAnimationController: anicontroller,
                            isScrollControlled: true,
                            context: context,
                            builder: (ctx){
                              return Container(
                                height: MediaQuery.of(context).size.height - 70,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  child: ChatScreen(),
                                ),
                              );
                            },);
                        },
                        txtClr: Colors.white,
                        bgClr: UIConstant.orange,
                        txtsize: 12,
                        rad: 5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 25,
            right: 25,
          ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            color:  Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
          ),
          child: CustomButton(
            verticalPadding: 10,
            horizontalPadding: 20,
            txt: "dropoff".tr,
            func: (){
              Get.toNamed(RouteHelper.getOrderSummaryPage(orderId: widget.orderId));
            },
            txtClr: Colors.white,
            bgClr: UIConstant.orange,
            txtsize: 16,
            rad: 20,
          ),
        ),
      );

  }
}
