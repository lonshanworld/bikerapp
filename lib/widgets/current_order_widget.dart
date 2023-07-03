
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/models/order_model.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:url_launcher/url_launcher.dart";
import "package:http/http.dart" as http;


class CurrentOrderWidget extends StatefulWidget {

  final OrderDetailModel currentOrderModel;

  const CurrentOrderWidget({
    Key? key,
    required this.currentOrderModel,
  }) : super(key: key);

  @override
  State<CurrentOrderWidget> createState() => _CurrentOrderWidgetState();
}

class _CurrentOrderWidgetState extends State<CurrentOrderWidget> {

  bool showDetail = false;
  bool showdefaultimage = false;
  // final GeneralController _generalController = Get.put(GeneralController());
  // bool photoError = false;

  _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {

    // final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return Container(
      padding: EdgeInsets.symmetric(
        // left: 15,
        // right: 15,
       vertical: 10,
      ),
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark :UIConstant.bgWhite,
        border: Border.all(
          width: 1,
          color: Theme.of(context).brightness == Brightness.dark ? UIConstant.orange : UIConstant.pink,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: (){
          // print('checking image in current order widget----------------');
          print(widget.currentOrderModel.image);
          setState(() {
            showDetail = !showDetail;
          });
        },
        child: AnimatedSize(
          curve: Curves.easeInOutCubic,
          duration: Duration(milliseconds: 500),
          reverseDuration: Duration(milliseconds: 500),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children:[
              Row(
                children: [
                  ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: UIConstant.pink,
                      shape: CircleBorder(
                        side: BorderSide.none,
                      ),
                      padding: EdgeInsets.all(10),
                      minimumSize: Size(0, 0),
                      elevation: 0,
                    ),
                    onPressed: (){
                      _makePhoneCall(widget.currentOrderModel.phone!);
                    },
                    child: Icon(
                      Icons.phone,
                      size: 24,
                      color: UIConstant.orange,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.currentOrderModel.cusName!,
                          style: UIConstant.normal.copyWith(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          widget.currentOrderModel.phone!,
                          style: UIConstant.small.copyWith(
                            color: UIConstant.secondarytxtClr,
                          ),
                        ),
                        // Row(
                        //   children: [
                        //
                        //
                        //     SizedBox(
                        //       width: 5,
                        //     ),
                        //
                        //
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 6,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          "Ref : ${widget.currentOrderModel.refNo}",
                          style: UIConstant.normal.copyWith(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        widget.currentOrderModel.orderStatus!,
                        style: UIConstant.small.copyWith(
                          color:  (widget.currentOrderModel.orderStatus!.trim().toLowerCase() == "order way on") ? Colors.blue : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if(showDetail)ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Divider(
                    color: Colors.grey,
                    height: 15,
                  ),
                  if(!showdefaultimage && (widget.currentOrderModel.image != null && widget.currentOrderModel.image != ""))Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      image: DecorationImage(
                        onError: (object,stacktrace){
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                          //   print("this is inside addpostframecallback.......................");
                          //   setState(() {
                          //     showdefaultimage = true;
                          //   });
                          // });
                          Future.delayed(Duration(milliseconds: 500),(){
                            if(mounted){
                              setState(() {
                                showdefaultimage = !showdefaultimage;
                              });
                            }
                          });
                        },
                          image: NetworkImage(
                            widget.currentOrderModel.image!,
                          ),
                          fit: BoxFit.cover
                      ),
                    ),
                    height: deviceHeight * 0.15,
                  ),
                  if(showdefaultimage || widget.currentOrderModel.image == null || widget.currentOrderModel.image == "")Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/images/biker_icon.png",
                          ),
                          fit: BoxFit.contain
                      ),
                    ),
                    height: deviceHeight * 0.15,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.currentOrderModel.shopName ?? "",
                          style: UIConstant.normal.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "${widget.currentOrderModel.distanceMeter} ${"km".tr}",
                        style: UIConstant.small,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      verticalPadding: 10,
                      horizontalPadding: 0,
                      txt: "${"order".tr}${"detail".tr}",
                      func: (){
                        // // _generalController.getCurrentOrder();
                        // _generalController.getOrderDetails(widget.currentOrderModel.orderId).then((value){
                        //   // Get.to(()=> OrderDetailScreen(
                        //   //   bikername:  _generalController.bikerModel[0].fullName,
                        //   //   orderDetailModel: value,
                        //   // ));
                        //   // Get.to(()=>DropOffScreen(
                        //   //   orderDetailModel: value,
                        //   //   bikerName: _generalController.bikerModel[0].fullName,
                        //   // ));
                        //
                        //   if(widget.currentOrderModel.orderStatus == "Biker Picked up"){
                        //     Get.to(()=>DropOffScreen(
                        //       orderDetailModel: value,
                        //       bikerName: _generalController.bikerModel[0].fullName,
                        //     ));
                        //   }else{
                        //     Get.to(()=> OrderDetailScreen(
                        //       bikername:  _generalController.bikerModel[0].fullName,
                        //       ordercode: widget.currentOrderModel.orderId,
                        //       hasButton: true,
                        //     ));
                        //   }
                        // });
                        if(widget.currentOrderModel.orderStatus == "Biker Picked up"){
                          // Get.to(()=>DropOffScreen(
                          //   orderDetailModel: value,
                          //   bikerName: _generalController.bikerModel[0].fullName,
                          // ));
                          Get.toNamed(RouteHelper.getDropOffPage(orderId: widget.currentOrderModel.orderId!));
                        }else{
                          // Get.to(()=> OrderDetailScreen(
                          //   bikername:  _generalController.bikerModel[0].fullName,
                          //   orderId: widget.currentOrderModel.orderId,
                          //   hasButton: true,
                          // ));
                          // Get.toNamed(RouteHelper.getDropOffPage(orderId: widget.currentOrderModel.orderId!));
                          // Get.toNamed(RouteHelper.getOrderSummaryPage(orderId: widget.currentOrderModel.orderId!));

                          Get.toNamed(RouteHelper.getOrderDetailPage(orderId: widget.currentOrderModel.orderId!, hasButton: true));
                        }
                      },
                      txtClr: UIConstant.orange,
                      bgClr: UIConstant.pink,
                      txtsize: 14,
                      rad: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
