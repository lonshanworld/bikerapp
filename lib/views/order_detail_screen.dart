
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:sizer/sizer.dart";

import "../constants/uiconstants.dart";
import "../models/order_model.dart";
import "../routehelper.dart";
import "../widgets/loading_widget.dart";
import "../widgets/order_detail_widget.dart";
import "map_screen.dart";

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

    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: (){
            if(widget.hasButton){
              Get.offAllNamed(RouteHelper.getHomePage());
            }else{
              Get.back();
            }
          },
        ),
      ),
      body: isloading
          ?
        const LoadingWidget()
          :
        Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 9.h,
            child: ListView(
              padding: EdgeInsets.only(
                left: 3.h,
                right: 3.h,
                top: 1.5.h,
                bottom: widget.hasButton ? 9.h : 1.5.h,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ref-No: ${_orderDetailModel.refNo} ",
                      style:TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: UIConstant.orange,
                      ),
                    ),
                    CustomButton(
                      verticalPadding:0.5.h,
                      horizontalPadding: 1.5.h,
                      txt: "Transfer to Others",
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
                  height: 17.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          _orderDetailModel.image ?? "",
                        ),
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.5.h),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _orderDetailModel.shopName!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomButton(
                      verticalPadding: 0.5.h,
                      horizontalPadding: 3.h,
                      txt: "View Map",
                      func: (){

                        Get.to(() => MapScreen(
                          shopLatLng: LatLng(_orderDetailModel.shoplat!.toDouble(),_orderDetailModel.shoplong!.toDouble()),
                          cusLatLng: LatLng(_orderDetailModel.cuslat!.toDouble(),_orderDetailModel.cuslong!.toDouble()),
                          shopaddress: _orderDetailModel.shopAddress!,
                          cusAddress: _orderDetailModel.cusAddress!,
                          isDropOff: false,
                        ),
                          transition: Transition.rightToLeftWithFade,
                        );
                      },
                      txtClr: Colors.white,
                      bgClr: Colors.grey,
                      txtsize: 10.sp,
                      rad: 1.h,
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "Customer Info",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.5.h),
                    ),
                  ),
                  padding: EdgeInsets.all(2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _orderDetailModel.phone!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        _orderDetailModel.cusName!,
                        style: TextStyle(
                          fontSize: 10.sp,

                        ),
                      ),
                      Text(
                        "${_orderDetailModel.cusAddress} | Note: ${_orderDetailModel.addressNote}",
                        style: TextStyle(
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Order Detail",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
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
                  height: 2.h,
                ),
                Text(
                  "Order Summary",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  padding: EdgeInsets.all(2.h),
                  decoration: BoxDecoration(
                    color : Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.5.h),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Total",
                            style: TextStyle(
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            "${_orderDetailModel.totalOnlinePrice} MMK",
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Charges",
                            style: TextStyle(
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            "${_orderDetailModel.deliCharges} MMK",
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cash Collect",
                            style: TextStyle(
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            "${_orderDetailModel.totalOnlinePrice! + _orderDetailModel.deliCharges!} MMK",
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if(widget.hasButton)Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(3.h),
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
                  topLeft: Radius.circular(3.h),
                  topRight: Radius.circular(3.h),
                ),
              ),
              child: CustomButton(
                verticalPadding: 1.h,
                horizontalPadding: 0,
                txt: "Pick up",
                func: (){
                  Get.toNamed(RouteHelper.getQrPage(orderId: widget.orderId));
                },
                txtClr: Colors.white,
                bgClr: UIConstant.orange,
                txtsize: 14.sp,
                rad: 1.5.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
