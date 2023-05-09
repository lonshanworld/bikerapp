
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

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

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double oneUnitWidth = deviceWidth / 360;
    final double oneUnitHeight = deviceHeight/772;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 28,
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
            bottom: 70,
            child: Center(
              child: SizedBox(
                width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
                child: ListView(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: widget.hasButton ? 70 : 10,
                  ),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ref-No: ${_orderDetailModel.refNo} ",
                          style: UIConstant.minititle.copyWith(
                            color: UIConstant.orange,
                          ),
                        ),
                        CustomButton(
                          verticalPadding: 5,
                          horizontalPadding: 10,
                          txt: "Transfer to Others",
                          func: (){

                          },
                          txtClr: Colors.white,
                          bgClr: UIConstant.orange,
                          txtsize: 10,
                          rad: 5,
                        ),
                      ],
                    ),
                    Container(
                      height: deviceHeight / 17,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              _orderDetailModel.image ?? "",
                            ),
                            fit: BoxFit.cover
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
                          style: UIConstant.normal.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomButton(
                          verticalPadding: 5,
                          horizontalPadding: 20,
                          txt: "View Map",
                          func: (){

                            Get.to(() => MapScreen(
                              shopLatLng: LatLng(_orderDetailModel.shoplat!.toDouble(),_orderDetailModel.shoplong!.toDouble()),
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
                      "Customer Info",
                      style: UIConstant.normal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                            style: UIConstant.small.copyWith(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _orderDetailModel.cusName!,
                            style: UIConstant.small,
                          ),
                          Text(
                            "${_orderDetailModel.cusAddress} | Note: ${_orderDetailModel.addressNote}",
                            style: UIConstant.tinytext,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Order Detail",
                      style: UIConstant.normal.copyWith(
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
                      height: 15,
                    ),
                    Text(
                      "Order Summary",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order Total",
                                style: UIConstant.small,
                              ),
                              Text(
                                "${_orderDetailModel.totalOnlinePrice} MMK",
                                style: UIConstant.small.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delivery Charges",
                                style: UIConstant.small,
                              ),
                              Text(
                                "${_orderDetailModel.deliCharges} MMK",
                                style: UIConstant.small.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Cash Collect",
                                style: UIConstant.small,
                              ),
                              Text(
                                "${_orderDetailModel.totalOnlinePrice! + _orderDetailModel.deliCharges!} MMK",
                                style: UIConstant.small.copyWith(
                                  fontWeight: FontWeight.bold,
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
            ),
          ),
          if(widget.hasButton)Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
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
        ],
      ),
    );
  }
}
