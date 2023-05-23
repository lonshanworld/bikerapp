
import "dart:async";

import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/noti_controller.dart";
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:delivery/widgets/loading_widget.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";

import "package:get/get.dart";
import "package:qr_flutter/qr_flutter.dart";

import "../models/order_model.dart";
import "../widgets/qr_shop_widget.dart";
import "loading_screen.dart";


class QRscreen extends StatefulWidget {

  final String orderId;
  // final List<String> orderListName;

  const QRscreen({
    Key? key,
    required this.orderId,
    // required this.orderListName
  }) : super(key: key);

  @override
  State<QRscreen> createState() => _QRscreenState();
}

class _QRscreenState extends State<QRscreen> {

  final OrderController orderController = Get.find<OrderController>();
  final NotiController notiController = Get.find<NotiController>();
  final UserAccountController userAccountController = Get.find<UserAccountController>();
  late StreamSubscription<RemoteMessage> streamSubscription;

  bool isloading = true;
  OrderDetailModel? orderDetailModel;
  List<String> orderItemShopnameList = [];
  List<bool> pickupFlaglist=[];

  Future<void> assignOrderdetail()async{
    orderItemShopnameList.clear();
    pickupFlaglist.clear();

    orderDetailModel = await orderController.getSingleOrderDetail(widget.orderId);
    if(orderDetailModel!.orderItems!.length > 1){
      for(int a = 0; a < orderDetailModel!.orderItems!.length; a++){
        if(orderDetailModel!.shopName != orderDetailModel!.orderItems![a].shopName){
          if(!orderItemShopnameList.contains(orderDetailModel!.orderItems![a].shopName)){
            orderItemShopnameList.add(orderDetailModel!.orderItems![a].shopName!);
          }
        }
      }
    }else{
      if(orderDetailModel!.shopName != orderDetailModel!.orderItems![0].shopName){
        orderItemShopnameList.add(orderDetailModel!.orderItems![0].shopName!);
      }
    }
    for(OrderItem item in orderDetailModel!.orderItems!){
      pickupFlaglist.add(item.pickupFlag!);
    }
    setState(() {
      isloading = false;
    });
  }

  notimsg(){
    streamSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message)async{
      notiController.showNotiwithoutFunc(
        remoteMessage: message,
      );
      print("This is noti from qr screen");
      print(message.notification!.title);
      if(mounted){
        setState(() {
          isloading = true;
          assignOrderdetail();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    notimsg();
    assignOrderdetail();
  }


  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(userAccountController.bikermodel[0].fullName!),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 24,
          ),
          onPressed: () {
            // Get.offAllNamed("/home");
            Get.back();
          },
        ),
      ),
      body: isloading
          ?
      LoadingWidget()
          :
      RefreshIndicator(
        onRefresh: () async{
          setState(() {
            isloading = true;
            assignOrderdetail();
          });
        },
        color: UIConstant.orange,
        child: Center(
          child: SizedBox(
            width: deviceWidth > 500 ? deviceWidth * 0.85 : deviceWidth,
            child: ListView(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 120,
                left: 20,
                right: 20,
              ),
              children: [
                Text(
                  "qrscan".tr,
                  style: UIConstant.minititle,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: QrImage(
                    data: "${orderDetailModel!.orderId}|${orderDetailModel!.cusId}",
                    version: QrVersions.auto,
                    size: 250,
                    // embeddedImage: NetworkImage("https://media.istockphoto.com/id/1194465593/photo/young-japanese-woman-looking-confident.jpg?s=1024x1024&w=is&k=20&c=4hVpkslRGJNtl2cMKlrBul-h3gcSXncwkGYAg3LGqlg="),
                    // embeddedImageStyle: QrEmbeddedImageStyle(
                    //   size: Size(80, 80),
                    // ),
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                    errorStateBuilder: (cxt, err) {
                      return const Center(
                        child: Text(
                          "Uh oh! Something went wrong...",
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  "shops".tr,
                  style: UIConstant.normal.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if(orderItemShopnameList.isNotEmpty)Column(
                  children: List.generate(
                    orderDetailModel!.orderItems!.length,
                        (index) => QrShopWidget(
                      name: orderDetailModel!.orderItems![index].itemName!,
                      pickUp: orderDetailModel!.orderItems![index].pickupFlag!,
                    ),
                  ),
                ),
                if(orderItemShopnameList.isEmpty)QrShopWidget(
                    name: orderDetailModel!.shopName!,
                    pickUp: orderDetailModel!.orderItems![0].pickupFlag!
                ),
              ],
            ),
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
          color: UIConstant.bgWhite,
          // boxShadow: [
          //   BoxShadow(
          //     color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
          //     blurRadius: 4.0,
          //     spreadRadius: 1.0,
          //     offset: Offset(0.0, 0.0),
          //   ),
          // ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight:  Radius.circular(20),
          )
        ),
        child: CustomButton(
            verticalPadding: 10,
            horizontalPadding: 20,
            txt: "confirm".tr,
            func: ()async{
              if(!pickupFlaglist.contains(false)){
                Get.dialog(const LoadingScreen(), barrierDismissible: false);
                await orderController.bikerPickup(widget.orderId);
                Get.back();
                Get.toNamed(RouteHelper.getDropOffPage(orderId: widget.orderId));
              }
            },
            txtClr: Colors.white,
            bgClr: pickupFlaglist.contains(false) ? Colors.grey : Colors.green,
            txtsize: 16,
            rad: 20,
        ),
      ),
    );
  }
}
