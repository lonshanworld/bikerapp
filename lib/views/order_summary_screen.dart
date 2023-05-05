
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:delivery/widgets/loading_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hand_signature/signature.dart";
import "package:sizer/sizer.dart";
import "../constants/uiconstants.dart";
import "../models/order_model.dart";
import "../widgets/order_detail_widget.dart";


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

  final UserAccountController userAccountController = Get.find<UserAccountController>();
  final OrderController orderController = Get.find<OrderController>();

  OrderDetailModel? _orderDetailModel;
  bool isloading = true;
  List<String> orderItemShopnameList = [];
  String? radioValue;
  List<String> radioValueList = ["Kpay", "Wallet", "Cash"];

  Future assignvalue()async{
    _orderDetailModel = await orderController.getSingleOrderDetail(widget.orderId);
    if(_orderDetailModel!.orderItems!.length > 1){
      for(int a = 0; a < _orderDetailModel!.orderItems!.length; a++){
        if(_orderDetailModel!.shopName != _orderDetailModel!.orderItems![a].shopName){
          if(!orderItemShopnameList.contains(_orderDetailModel!.orderItems![a].shopName)){
            orderItemShopnameList.add(_orderDetailModel!.orderItems![a].shopName!);
          }
        }
      }
    }else{
      if(_orderDetailModel!.shopName != _orderDetailModel!.orderItems![0].shopName){
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

    final control = HandSignatureControl(
      threshold: 3.0,
      smoothRatio: 0.65,
      velocityRange: 2.0,
    );

    final widgetPainter = HandSignature(
      control: control,
      color: Colors.green,
      width: 3.0,
      maxWidth: 3.0,
      type: SignatureDrawType.shape,
    );

    return isloading
        ?
    Scaffold(
      appBar: AppBar(
        title: Text(
          userAccountController.bikermodel[0].fullName!,
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
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: 3.h,
          right: 3.h,
          top: 3.h,
          bottom: 14.h,
        ),
        children: [
          Text(
            "Drop-off Summary",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Order Details",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: [
              if(orderItemShopnameList.isEmpty)for(OrderItem _orderItem in _orderDetailModel!.orderItems!) OrderDetailWidget(
                orderItem: _orderItem,hasMoreShop: false,
              ),
              if(orderItemShopnameList.isNotEmpty)for(OrderItem _orderItem in _orderDetailModel!.orderItems!) OrderDetailWidget(
                orderItem: _orderItem,hasMoreShop: true,
              )
            ],
          ),
          SizedBox(
            height:3.h,
          ),
          Text(
            "Order Summary",
            style: TextStyle(

              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Container(
            padding: EdgeInsets.all(2.h),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
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
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      "${_orderDetailModel!.totalOnlinePrice} MMK",
                      style: TextStyle(
                          fontSize: 12.sp,
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
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      "${_orderDetailModel!.deliCharges} MMK",
                      style: TextStyle(
                          fontSize: 12.sp,
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
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      "${_orderDetailModel!.totalOnlinePrice! + _orderDetailModel!.deliCharges!} MMK",
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            "Payment Options",
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
            child: Column(
              children: [
                for(String item in radioValueList)RadioListTile(
                  dense: true,
                  value: item,
                  title: Text(
                    item,
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                  groupValue: radioValue,
                  activeColor: UIConstant.orange,
                  onChanged: (value){
                    setState(() {
                      radioValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
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
            topLeft: Radius.circular(3.h),
            topRight: Radius.circular(3.h),
          ),
          color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
        ),
        child: CustomButton(
          verticalPadding: 1.h,
          horizontalPadding: 3.h,
          txt: "Confirm",
          func: (){
            showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.h,
                  ),
                  titlePadding: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                    top: 2.h,
                    bottom: 1.h
                  ),
                  actionsPadding:EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                      top: 0,
                      bottom: 1.h
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.h),
                      side: BorderSide(
                        color: UIConstant.orange,
                      )
                  ),
                  backgroundColor:  Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                  title: Text(
                    "Please use E-sign and confirm order.",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(1.h)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: widgetPainter,
                        ),
                        Positioned(
                          top: 1.h,
                          right: 2.h,
                          child: CustomButton(
                              verticalPadding: 1.h,
                              horizontalPadding: 2.h,
                              txt: "Clear Sign",
                              func: (){
                                control.clear();
                              },
                              txtClr: Colors.white,
                              bgClr: UIConstant.orange,
                              txtsize: 10.sp,
                              rad: 0.5.h
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            verticalPadding: 1.h,
                            horizontalPadding: 0,
                            txt: "Cancel",
                            func: (){
                              control.clear();
                              Navigator.of(context).pop();
                            },
                            txtClr: Colors.black,
                            bgClr: UIConstant.pink,
                            txtsize: 10.sp,
                            rad: 1.h,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: CustomButton(
                            verticalPadding: 1.h,
                            horizontalPadding: 0,
                            txt: "Confirm",
                            func: (){
                              Get.offAllNamed(RouteHelper.getHomePage());
                            },
                            txtClr: Colors.white,
                            bgClr: UIConstant.orange,
                            txtsize: 10.sp,
                            rad: 1.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
          txtClr: Colors.white,
          bgClr: Colors.green,
          txtsize: 14.sp,
          rad: 3.h,
        ),
      ),
    );
  }
}
