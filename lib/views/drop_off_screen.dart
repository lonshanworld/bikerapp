
import 'package:delivery/controllers/order_controller.dart';
import 'package:delivery/controllers/useraccount_controller.dart';
import 'package:delivery/models/order_model.dart';
import 'package:delivery/routehelper.dart';
import 'package:delivery/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:get/get.dart";


import '../constants/uiconstants.dart';
import '../controllers/location_controller.dart';
import '../widgets/customButton_widget.dart';
import 'map_screen.dart';
import 'order_summary_screen.dart';

class DropOffScreen extends StatefulWidget {

  final String orderId;

  const DropOffScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<DropOffScreen> createState() => _DropOffScreenState();
}

class _DropOffScreenState extends State<DropOffScreen> {

  GoogleMapController? _controller;
  late CameraPosition _initialcameraPosition;
  final OrderController orderController = Get.find<OrderController>();
  final LocationController _locationController = Get.find<LocationController>();
  final UserAccountController userAccountController = Get.find<UserAccountController>();

  bool isloading = true;
  double curlat = 0;
  double curlong = 0;
  String curplacename = "";
  late List<LatLng> polypoints = [];
  BitmapDescriptor custommarkerIcon = BitmapDescriptor.defaultMarker;
  OrderDetailModel? orderDetailModel;


  _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future getCurrentLocation()async{
    await _locationController.getPermission().then((value){
      if(value){

        _locationController.getcurLagLong().then((_location){
          _locationController.getplacemark(_location.latitude, _location.longitude).then((txtplace){
            setState(() {
              curlat = _location.latitude;
              curlong = _location.longitude;
              curplacename = "${txtplace.thoroughfare}, ${txtplace.subAdministrativeArea}, ${txtplace.administrativeArea}";
              _initialcameraPosition = CameraPosition(
                target: LatLng(curlat, curlong),
              );
            });

            getPolypoints();
          });
        });
      }else{
        Get.snackbar(
          "Permission",
          "Location Permission is denied",
          borderRadius: 10,
          backgroundColor: UIConstant.orange.withOpacity(0.2),
          duration: const Duration(seconds: 5),
        );
      }
    });
  }

  void getPolypoints(){
    _locationController.getpolyPointList(LatLng(curlat, curlong), LatLng(orderDetailModel!.cuslat!.toDouble(), orderDetailModel!.cuslong!.toDouble())).then((value){
      print("This is from drop off screen............................");
      print(LatLng(curlat, curlong));
      print(value);

      setState(() {
        polypoints = value;

        isloading = false;
      });
    });
  }

  Future getcustomMarker()async{
    await _locationController.getmarkerIcon().then((icon){
      setState(() {
        custommarkerIcon = BitmapDescriptor.fromBytes(icon);
      });
    });
  }

  Future assignOrder()async{
    await orderController.getSingleOrderDetail(widget.orderId).then((value) async{
      orderDetailModel = value;
      await getcustomMarker();
      await getCurrentLocation();
    });

  }

  @override
  void initState() {
    super.initState();
    assignOrder();
  }

  @override
  Widget build(BuildContext context) {

    late Marker marker1 = Marker(
      markerId: MarkerId("1"),
      position: LatLng(curlat,curlong),
      draggable: false,
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
      icon: custommarkerIcon,
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
      color: UIConstant.orange,
      points: polypoints,
      width: 8,
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
            ),
            onPressed: (){
              Get.offAllNamed(RouteHelper.getHomePage());
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
            ),
            onPressed: (){
              Get.offAllNamed(RouteHelper.getHomePage());
            },
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 3.h,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Customer Map",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomButton(
                  verticalPadding: 0.5.h,
                  horizontalPadding: 3.h,
                  txt: "Ask for Help",
                  func: (){

                  },
                  txtClr: Colors.white,
                  bgClr: UIConstant.orange,
                  txtsize: 10.sp,
                  rad: 1.h,
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(1.5.h),
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
              height: 50.h,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(1.5.h),
                ),
                child: GoogleMap(
                  initialCameraPosition: _initialcameraPosition,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller){
                    setState(() {
                      _controller = controller;
                    });
                    _controller?.animateCamera(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderDetailModel!.phone!,
                  style: TextStyle(
                    color: UIConstant.orange,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold
                  ),
                ),
                CustomButton(
                  verticalPadding: 0.5.h,
                  horizontalPadding: 3.h,
                  txt: "View large map",
                  func: (){
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
                  txtsize: 10.sp,
                  rad: 1.h,
                ),
              ],
            ),
            Text(
              orderDetailModel!.cusName!,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              orderDetailModel!.cusAddress!,
              style: TextStyle(
                fontSize: 10.sp,
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            CustomButton(
              verticalPadding: 1.h,
              horizontalPadding: 0,
              txt: "Call",
              func: (){
                _makePhoneCall(orderDetailModel!.phone!);
              },
              txtClr: Colors.white,
              bgClr: UIConstant.orange,
              txtsize: 12.sp,
              rad: 1.h,
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: CustomButton(
            //         verticalPadding: 1.5.h,
            //         horizontalPadding: 0,
            //         txt: "Call",
            //         func: (){
            //           _makePhoneCall(orderDetailModel!.phone!);
            //         },
            //         txtClr: Colors.white,
            //         bgClr: UIConstant.orange,
            //         txtsize: 12.sp,
            //         rad: 1.h,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 2.h,
            //     ),
            //     Expanded(
            //       child: CustomButton(
            //         verticalPadding: 1.5.h,
            //         horizontalPadding: 0,
            //         txt: "Chat",
            //         func: (){
            //
            //         },
            //         txtClr: Colors.white,
            //         bgClr: UIConstant.orange,
            //         txtsize: 12.sp,
            //         rad: 1.h,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        bottomSheet: Container(
          padding: EdgeInsets.only(
            top: 2.5.h,
            bottom: 2.5.h,
            left: 3.h,
            right: 3.h,
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
              topRight: Radius.circular(3.h),
              topLeft: Radius.circular(3.h),
            ),
            color:  Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
          ),
          child: CustomButton(
            verticalPadding: 1.h,
            horizontalPadding: 3.h,
            txt: "Drop off",
            func: (){
              Get.toNamed(RouteHelper.getOrderSummaryPage(orderId: widget.orderId));
            },
            txtClr: Colors.white,
            bgClr: UIConstant.orange,
            txtsize: 14.sp,
            rad: 3.h,
          ),
        ),
      );

  }
}
