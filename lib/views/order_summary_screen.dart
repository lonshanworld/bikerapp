
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
        ?
    Scaffold(
      appBar: AppBar(
        title: Text(
          userAccountController.bikermodel[0].fullName!,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 28,
          ),
          onPressed: () {
            // Get.offAllNamed("/home");
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
            Icons.arrow_back_ios,
            size: 28,
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
                "Drop-off Summary",
                style: UIConstant.minititle,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Order Details",
                style: UIConstant.normal.copyWith(
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
                height: 20,
              ),
              Text(
                "Order Summary",
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
                  color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
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
                          "${_orderDetailModel!.totalOnlinePrice} MMK",
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
                          "Delivery Charges",
                          style: UIConstant.small,
                        ),
                        Text(
                          "${_orderDetailModel!.deliCharges} MMK",
                          style: UIConstant.small.copyWith(
                            fontWeight: FontWeight.bold
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
                          "Cash Collect",
                          style: UIConstant.small,
                        ),
                        Text(
                          "${_orderDetailModel!.totalOnlinePrice! + _orderDetailModel!.deliCharges!} MMK",
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
              Text(
                "Payment Options",
                style: UIConstant.normal.copyWith(
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
                child: Column(
                  children: [
                    for(String item in radioValueList)RadioListTile(
                      dense: true,
                      value: item,
                      title: Text(
                        item,
                        style: UIConstant.normal,
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
                height: 20,
              ),
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
          color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
        ),
        child: CustomButton(
          verticalPadding: 10,
          horizontalPadding: 20,
          txt: "Confirm",
          func: (){
            showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  titlePadding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 15,
                    bottom: 10,
                  ),
                  actionsPadding:EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 0,
                      bottom: 10,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: UIConstant.orange,
                      )
                  ),
                  backgroundColor:  Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
                  title: Text(
                    "Please use E-sign and confirm order.",
                    style: UIConstant.minititle,
                  ),
                  content: Container(
                    height: deviceHeight / 2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          top: 10,
                          right: 15,
                          child: CustomButton(
                              verticalPadding: 10,
                              horizontalPadding: 15,
                              txt: "Clear Sign",
                              func: (){
                                control.clear();
                              },
                              txtClr: Colors.white,
                              bgClr: UIConstant.orange,
                              txtsize: 10,
                              rad: 5,
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
                            verticalPadding: 10,
                            horizontalPadding: 0,
                            txt: "Cancel",
                            func: (){
                              control.clear();
                              Navigator.of(context).pop();
                            },
                            txtClr: Colors.black,
                            bgClr: UIConstant.pink,
                            txtsize: 10,
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
                            txt: "Confirm",
                            func: (){
                              Get.offAllNamed(RouteHelper.getHomePage());
                            },
                            txtClr: Colors.white,
                            bgClr: UIConstant.orange,
                            txtsize: 10,
                            rad: 10,
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
          txtsize: 16,
          rad: 20,
        ),
      ),
    );
  }
}
