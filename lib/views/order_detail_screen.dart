
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/utils/change_num_format.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:intl/intl.dart";

import "../constants/uiconstants.dart";
import "../models/order_model.dart";
import "../routehelper.dart";
import "../widgets/loading_widget.dart";
import "../widgets/order_detail_widget.dart";
import "map_screen.dart";
import "package:http/http.dart" as http;

class OrderDetailScreen extends StatefulWidget {

  final String orderId;
  final bool hasButton;

  OrderDetailScreen({
    required this.orderId,
    required this.hasButton,
});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {

  final OrderController orderController = Get.find<OrderController>();
  late OrderDetailModel _orderDetailModel;

  // bool _isloading = true;
  List<String> orderItemShopnameList = [];
  bool isloading = true;
  bool showdefaultimage = false;

  Future<void> assignvalue() async{
    _orderDetailModel = await orderController.getSingleOrderDetail(widget.orderId);
    if(_orderDetailModel.orderItems!.length > 1){
      for(int a = 0; a < _orderDetailModel.orderItems!.length; a++){
        if(_orderDetailModel.shopName != _orderDetailModel.orderItems![a].shopName){
          if(!orderItemShopnameList.contains(_orderDetailModel.orderItems![a].shopName)){
            orderItemShopnameList.add(_orderDetailModel.orderItems![a].shopName!);
          }
        }
      }
    }else{
      if(_orderDetailModel.shopName != _orderDetailModel.orderItems![0].shopName){
        orderItemShopnameList.add(_orderDetailModel.orderItems![0].shopName!);
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

    // final numformat = NumberFormat("#,##0", "en_US");
    
    Widget pricerowitem({required String name, required num price}){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: UIConstant.normal,
          ),
          Text(
            "${changeNumberFormat(price)} ${"mmk".tr}",
            style: UIConstant.normal.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${"order".tr} ${"detail".tr}",
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 24,
          ),
          onPressed: (){
            // if(widget.hasButton){
            //   Get.offAllNamed(RouteHelper.getHomePage());
            // }else{
            //   Get.back();
            // }
            Get.back();
          },
        ),
      ),
      body: isloading
          ?
        const LoadingWidget()
          :
      Center(
        child: SizedBox(
          width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
          child: ListView(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: widget.hasButton ? 120 : 20,
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ref-No: ${_orderDetailModel.refNo} ",
                    style: UIConstant.title.copyWith(
                      color: UIConstant.orange,
                    ),
                  ),
                  // CustomButton(
                  //   verticalPadding: 5,
                  //   horizontalPadding: 10,
                  //   txt: "transfertoother".tr,
                  //   func: (){
                  //
                  //   },
                  //   txtClr: Colors.white,
                  //   bgClr: UIConstant.orange,
                  //   txtsize: 10,
                  //   rad: 5,
                  // ),
                ],
              ),
              if(!showdefaultimage && (_orderDetailModel.image != null && _orderDetailModel.image != ""))Container(
                height: deviceHeight * 0.22,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      onError: (object, stacktrace){
                        Future.delayed(Duration(seconds: 1),(){
                          if(mounted){
                            setState(() {
                              showdefaultimage = true;
                            });
                          }
                        });
                      },
                      image: NetworkImage(
                        _orderDetailModel.image!,
                      ),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              if(showdefaultimage || _orderDetailModel.image == null || _orderDetailModel.image == "")Container(
                height: deviceHeight * 0.22,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/biker_icon.png",
                      ),
                      fit: BoxFit.contain
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _orderDetailModel.shopName!,
                    style: UIConstant.minititle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomButton(
                    verticalPadding: 5,
                    horizontalPadding: 20,
                    txt: "viewmap".tr,
                    func: (){

                      Get.to(() => MapScreen(
                        shopLatLng: LatLng(_orderDetailModel.shoplat!.toDouble(),_orderDetailModel.shoplong!.toDouble()),
                        // shopLatLng: LatLng(16.782759,	96.14413),
                        cusLatLng: LatLng(_orderDetailModel.cuslat!.toDouble(),_orderDetailModel.cuslong!.toDouble()),
                        shopaddress: _orderDetailModel.shopAddress!,
                        cusAddress: _orderDetailModel.cusAddress!,
                        isDropOff: false,
                      ),
                        transition: Transition.rightToLeft,
                      );
                    },
                    txtClr: Colors.white,
                    bgClr: Colors.grey,
                    txtsize: 10,
                    rad: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "cusinfo".tr,
                style: UIConstant.minititle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _orderDetailModel.phone!,
                      style: UIConstant.normal.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _orderDetailModel.cusName!,
                      style: UIConstant.normal,
                    ),
                    Text(
                      "${_orderDetailModel.cusAddress}",
                      style: UIConstant.normal,
                    ),
                    Text(
                      "${"note".tr}: ${_orderDetailModel.addressNote}",
                      style: UIConstant.normal,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "shopinfo".tr,
                style: UIConstant.minititle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _orderDetailModel.shopName!,
                      style: UIConstant.normal.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${_orderDetailModel.shopAddress}",
                      style: UIConstant.normal,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "${"order".tr} ${"detail".tr}",
                style: UIConstant.minititle,
              ),
              // ListView.builder(
              //   itemCount: _orderDetailModel.orderItems.length,
              //   itemBuilder: (ctx,index){
              //     return OrderDetailWidget(orderItem: _orderDetailModel.orderItems[index]);
              //   },
              // ),
              Column(
                children: [
                  if(orderItemShopnameList.isEmpty)for(OrderItem _orderItem in _orderDetailModel.orderItems!) OrderDetailWidget(
                    orderItem: _orderItem,hasMoreShop: false,
                  ),
                  if(orderItemShopnameList.isNotEmpty)for(OrderItem _orderItem in _orderDetailModel.orderItems!) OrderDetailWidget(
                    orderItem: _orderItem,hasMoreShop: true,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "ordersummary".tr,
                style: UIConstant.minititle,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color : Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "${"order".tr} ${"total".tr}",
                    //       style: UIConstant.normal,
                    //     ),
                    //     Text(
                    //       "${_orderDetailModel.totalOnlinePrice} ${"mmk".tr}",
                    //       style: UIConstant.normal.copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    pricerowitem(name: "${"order".tr} ${"total".tr}", price: _orderDetailModel.totalPrice!),
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "deliverycharges".tr,
                    //       style: UIConstant.normal,
                    //     ),
                    //     Text(
                    //       "${_orderDetailModel.deliCharges} ${"mmk".tr}",
                    //       style: UIConstant.normal.copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    pricerowitem(name: "Discount", price: _orderDetailModel.discountAmount!),
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "cashcollected".tr,
                    //       style: UIConstant.normal,
                    //     ),
                    //     Text(
                    //       "${_orderDetailModel.totalOnlinePrice! + _orderDetailModel.deliCharges!} ${"mmk".tr}",
                    //       style: UIConstant.normal.copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    pricerowitem(name: "Net Total", price: _orderDetailModel.totalOnlinePrice!),
                    SizedBox(
                      height: 10,
                    ),
                    pricerowitem(name: "Container Charges", price: _orderDetailModel.containerCharges!),
                    SizedBox(
                      height: 10,
                    ),
                    if(_orderDetailModel.paymentType?.toLowerCase() == "credit")pricerowitem(
                      name: "Credit Charges",
                      price: _orderDetailModel.creditCharges!,
                    ),
                    if(_orderDetailModel.paymentType?.toLowerCase() == "credit")SizedBox(
                      height: 10,
                    ),
                    if(_orderDetailModel.promotAmt! > 0 )pricerowitem(
                      name: "Promo Amt",
                      price: _orderDetailModel.promotAmt!,
                    ),
                    if(_orderDetailModel.promotAmt! > 0 )SizedBox(
                      height: 10,
                    ),
                    pricerowitem(name: "vat".tr, price: _orderDetailModel.tax!),
                    SizedBox(
                      height: 10,
                    ),
                    pricerowitem(name: "Delivery Charges", price: _orderDetailModel.deliCharges!),
                    SizedBox(
                      height: 10,
                    ),
                    if(_orderDetailModel.tipsMoney! > 0 )pricerowitem(
                      name: "Sub Total",
                      price: _orderDetailModel.subTotal!,
                    ),
                    if(_orderDetailModel.tipsMoney! > 0 )SizedBox(
                      height: 10,
                    ),
                    if(_orderDetailModel.tipsMoney! > 0 )pricerowitem(
                      name: "Tips",
                      price: _orderDetailModel.tipsMoney!,
                    ),
                    if(_orderDetailModel.tipsMoney! > 0 )SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "vat".tr,
                    //       style: UIConstant.normal,
                    //     ),
                    //     Text(
                    //       "${_orderDetailModel.tax} ${"mmk".tr}",
                    //       style: UIConstant.normal.copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: UIConstant.minititle,
                          ),
                          Text(
                            "${changeNumberFormat(_orderDetailModel.grandTotal!)} ${"mmk".tr}",
                            style: UIConstant.minititle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Visibility(
        visible: widget.hasButton,
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:  Colors.black38,
                blurRadius: 6.0,
                spreadRadius: 2.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
            color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: CustomButton(
            verticalPadding: 10,
            horizontalPadding: 0,
            txt: "Pick up",
            func: (){
              Get.toNamed(RouteHelper.getQrPage(orderId: widget.orderId));
            },
            txtClr: Colors.white,
            bgClr: UIConstant.orange,
            txtsize: 16,
            rad: 10,
          ),
        ),
      ),
      // Stack(
      //   children: [
      //     Positioned(
      //       top: 0,
      //       left: 0,
      //       right: 0,
      //       bottom: 70,
      //       child: Center(
      //         child: ,
      //       ),
      //     ),
      //     if(widget.hasButton)Positioned(
      //       bottom: 0,
      //       left: 0,
      //       right: 0,
      //       child: ,
      //     ),
      //   ],
      // ),
    );
  }
}
