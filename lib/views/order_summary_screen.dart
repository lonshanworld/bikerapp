import "package:delivery/controllers/order_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:delivery/widgets/loading_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hand_signature/signature.dart";
import "../constants/uiconstants.dart";
import "../models/order_model.dart";
import "../widgets/order_detail_widget.dart";
import "loading_screen.dart";

class OrderSummaryScreen extends StatefulWidget {
  final String orderId;

  const OrderSummaryScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  final UserAccountController userAccountController =
      Get.find<UserAccountController>();
  final OrderController orderController = Get.find<OrderController>();

  OrderDetailModel? _orderDetailModel;
  bool isloading = true;
  List<String> orderItemShopnameList = [];
  String? radioValue;
  List<String> radioValueList = ["Kpay", "Wallet", "Cash"];


  Future assignvalue() async {
    _orderDetailModel =
        await orderController.getSingleOrderDetail(widget.orderId);
    if (_orderDetailModel!.orderItems!.length > 1) {
      for (int a = 0; a < _orderDetailModel!.orderItems!.length; a++) {
        if (_orderDetailModel!.shopName !=
            _orderDetailModel!.orderItems![a].shopName) {
          if (!orderItemShopnameList
              .contains(_orderDetailModel!.orderItems![a].shopName)) {
            orderItemShopnameList
                .add(_orderDetailModel!.orderItems![a].shopName!);
          }
        }
      }
    } else {
      if (_orderDetailModel!.shopName !=
          _orderDetailModel!.orderItems![0].shopName) {
        orderItemShopnameList.add(_orderDetailModel!.orderItems![0].shopName!);
      }
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    assignvalue();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    final control = HandSignatureControl(
      threshold: 3.0,
      smoothRatio: 0.65,
      velocityRange: 2.0,
    );

    final widgetPainter = HandSignature(
      control: control,
      color: UIConstant.orange,
      width: 3.0,
      maxWidth: 3.0,
      type: SignatureDrawType.shape,
    );

    return isloading
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                userAccountController.bikermodel[0].fullName!,
              ),
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
            body: LoadingWidget(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                userAccountController.bikermodel[0].fullName!,
              ),
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
            body: Center(
              child: SizedBox(
                width: deviceWidth > 500 ? deviceWidth * 0.85 : deviceWidth,
                height: deviceHeight,
                child: ListView(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 100,
                  ),
                  children: [
                    Text(
                      "dropoffsummary".tr,
                      style: UIConstant.minititle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${"order".tr} ${"detail".tr}",
                      style: UIConstant.normal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: [
                        if (orderItemShopnameList.isEmpty)
                          for (OrderItem _orderItem
                              in _orderDetailModel!.orderItems!)
                            OrderDetailWidget(
                              orderItem: _orderItem,
                              hasMoreShop: false,
                            ),
                        if (orderItemShopnameList.isNotEmpty)
                          for (OrderItem _orderItem
                              in _orderDetailModel!.orderItems!)
                            OrderDetailWidget(
                              orderItem: _orderItem,
                              hasMoreShop: true,
                            )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "ordersummary".tr,
                      style: UIConstant.normal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? UIConstant.bgDark
                            : UIConstant.bgWhite,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ordertotal".tr,
                                style: UIConstant.small,
                              ),
                              Text(
                                "${_orderDetailModel!.totalOnlinePrice} ${"mmk".tr}",
                                style: UIConstant.small.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "deliverycharges".tr,
                                style: UIConstant.small,
                              ),
                              Text(
                                "${_orderDetailModel!.deliCharges} ${"mmk".tr}",
                                style: UIConstant.small
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "cashcollected".tr,
                                style: UIConstant.small,
                              ),
                              Text(
                                "${_orderDetailModel!.totalOnlinePrice! + _orderDetailModel!.deliCharges!} ${"mmk".tr}",
                                style: UIConstant.small.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "vat".tr,
                                style: UIConstant.small,
                              ),
                              Text(
                                "${_orderDetailModel!.tax} ${"mmk".tr}",
                                style: UIConstant.small.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Text(
                    //   "Payment Options",
                    //   style: UIConstant.normal.copyWith(
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                    //     borderRadius: BorderRadius.all(
                    //       Radius.circular(10),
                    //     ),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       for(String item in radioValueList)RadioListTile(
                    //         dense: true,
                    //         value: item,
                    //         title: Text(
                    //           item,
                    //           style: UIConstant.normal,
                    //         ),
                    //         groupValue: radioValue,
                    //         activeColor: UIConstant.orange,
                    //         onChanged: (value){
                    //           setState(() {
                    //             radioValue = value;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                  ],
                ),
              ),
            ),
            bottomSheet: Container(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
                left: 20,
                right: 20,
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
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Theme.of(context).brightness == Brightness.dark
                    ? UIConstant.bgDark
                    : UIConstant.bgWhite,
              ),
              child: CustomButton(
                verticalPadding: 10,
                horizontalPadding: 20,
                txt: "confirm".tr,
                func: () {
                  // showDialog(
                  //   barrierDismissible: false,
                  //   context: context,
                  //   builder: (BuildContext context){
                  //     return AlertDialog(
                  //       contentPadding: EdgeInsets.symmetric(
                  //         horizontal: 15,
                  //         vertical: 10,
                  //       ),
                  //       titlePadding: EdgeInsets.only(
                  //         left: 15,
                  //         right: 15,
                  //         top: 15,
                  //         bottom: 10,
                  //       ),
                  //       actionsPadding:EdgeInsets.only(
                  //           left: 15,
                  //           right: 15,
                  //           top: 0,
                  //           bottom: 10,
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(15),
                  //           side: BorderSide(
                  //             color: UIConstant.orange,
                  //           )
                  //       ),
                  //       backgroundColor:  Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                  //       title: Text(
                  //         "useEsignandconfirmorder".tr,
                  //         style: UIConstant.minititle,
                  //       ),
                  //       content: Container(
                  //         height: deviceHeight / 2,
                  //         decoration: BoxDecoration(
                  //           color: Theme.of(context).primaryColor,
                  //           borderRadius: BorderRadius.all(Radius.circular(10)),
                  //         ),
                  //         child: Stack(
                  //           children: [
                  //             Positioned(
                  //               top: 0,
                  //               bottom: 0,
                  //               left: 0,
                  //               right: 0,
                  //               child: widgetPainter,
                  //             ),
                  //             Positioned(
                  //               top: 10,
                  //               right: 15,
                  //               child: CustomButton(
                  //                   verticalPadding: 10,
                  //                   horizontalPadding: 15,
                  //                   txt: "clearsign".tr,
                  //                   func: (){
                  //                     control.clear();
                  //                   },
                  //                   txtClr: Colors.white,
                  //                   bgClr: UIConstant.orange,
                  //                   txtsize: 10,
                  //                   rad: 5,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       actions: [
                  //         Row(
                  //           children: [
                  //             Expanded(
                  //               child: CustomButton(
                  //                 verticalPadding: 10,
                  //                 horizontalPadding: 0,
                  //                 txt: "cancel".tr,
                  //                 func: (){
                  //                   control.clear();
                  //                   Navigator.of(context).pop();
                  //                 },
                  //                 txtClr: Colors.black,
                  //                 bgClr: UIConstant.pink,
                  //                 txtsize: 10,
                  //                 rad: 10,
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               width: 20,
                  //             ),
                  //             Expanded(
                  //               child: CustomButton(
                  //                 verticalPadding: 10,
                  //                 horizontalPadding: 0,
                  //                 txt: "confirm".tr,
                  //                 func: (){
                  //
                  //                   // for e-sign
                  //                   Get.dialog(LoadingScreen(), barrierDismissible: false);
                  //                   orderController.bikerDropOff(_orderDetailModel!.orderId!).then((_){
                  //                     Get.back();
                  //                     Get.offAllNamed(RouteHelper.getHomePage());
                  //                   });
                  //                 },
                  //                 txtClr: Colors.white,
                  //                 bgClr: UIConstant.orange,
                  //                 txtsize: 10,
                  //                 rad: 10,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierColor: Colors.black54.withOpacity(0.6),
                    transitionDuration: Duration(milliseconds: 500) ,
                    pageBuilder: (ctx, primaryani, secondaryani) {
                      return WillPopScope(
                        onWillPop: () async => true,
                        child: SafeArea(
                          child: Container(
                            width: deviceWidth,
                            height: deviceHeight,
                            margin: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                color: UIConstant.orange,
                                width: 2,
                              )
                            ),
                            child:  ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: Scaffold(
                                backgroundColor: Theme.of(context).brightness == Brightness.light ? UIConstant.bgDark : UIConstant.bgWhite,
                                appBar: AppBar(
                                  backgroundColor: Theme.of(context).brightness == Brightness.light ? UIConstant.bgDark : UIConstant.bgWhite,
                                  centerTitle: true,
                                  automaticallyImplyLeading: false,
                                  title: Text(
                                    "useEsignandconfirmorder".tr,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: UIConstant.minititle.copyWith(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                                body:  Stack(
                                  children: [
                                    Positioned(
                                      top: -20,
                                      bottom: 60,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: widgetPainter,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 20,
                                      child: CustomButton(
                                        verticalPadding: 10,
                                        horizontalPadding: 15,
                                        txt: "clearsign".tr,
                                        func: (){
                                          control.clear();
                                        },
                                        txtClr: Colors.white,
                                        bgClr: UIConstant.orange,
                                        txtsize: 12,
                                        rad: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                bottomSheet: Container(
                                  color: Theme.of(context).brightness == Brightness.light ? UIConstant.bgDark : UIConstant.bgWhite,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          verticalPadding: 10,
                                          horizontalPadding: 0,
                                          txt: "cancel".tr,
                                          func: (){
                                            control.clear();
                                            Navigator.of(ctx).pop();
                                          },
                                          txtClr: Colors.black,
                                          bgClr: UIConstant.pink,
                                          txtsize: 12,
                                          rad: 10,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          verticalPadding: 10,
                                          horizontalPadding: 0,
                                          txt: "confirm".tr,
                                          func: (){

                                            // for e-sign
                                            Get.dialog(LoadingScreen(), barrierDismissible: false);
                                            orderController.bikerDropOff(_orderDetailModel!.orderId!).then((_){
                                              Get.back();
                                              Get.offAllNamed(RouteHelper.getHomePage());
                                            });
                                          },
                                          txtClr: Colors.white,
                                          bgClr: UIConstant.orange,
                                          txtsize: 12,
                                          rad: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ),
                      );
                    },
                  );
                },
                txtClr: Colors.white,
                bgClr: Colors.green,
                txtsize: 16,
                rad: 20,
              ),
            ),
          );
  }
}
