
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
  // final GeneralController _generalController = Get.put(GeneralController());
  // bool photoError = false;
  String? imageurl;

  _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void>checkPhotoError()async{
    if(widget.currentOrderModel.image == null || widget.currentOrderModel.image == "" || widget.currentOrderModel.image == "null"){
      return ;
    }else{
      http.Response response = await http.get(Uri.parse(widget.currentOrderModel.image!));
      if(response == 200){
        if(mounted){
          setState(() {
            imageurl = widget.currentOrderModel.image;
          });
        }
      }
    }
  }


  @override
  void initState() {
    super.initState();
    checkPhotoError();
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
          color: UIConstant.orange,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: (){
          // print('checking image in current order widget----------------');
          // print(widget.currentOrderModel.image);
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
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.currentOrderModel.cusName!,
                          style: UIConstant.small.copyWith(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          children: [

                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 1,
                                horizontal: 10,
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
                                style: UIConstant.small.copyWith(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.currentOrderModel.phone!,
                              style: UIConstant.small.copyWith(
                                color: UIConstant.secondarytxtClr,
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: (widget.currentOrderModel.orderStatus == "Order Way On") ? Colors.blue : Colors.green,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    child: Text(
                      widget.currentOrderModel.orderStatus!,
                      style: UIConstant.tinytext.copyWith(
                        color: Colors.white,
                      ),
                    ),
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
                  if(imageurl != null)Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      image: DecorationImage(
                          image: NetworkImage(
                            imageurl!,
                          ),
                          fit: BoxFit.cover
                      ),
                    ),
                    height: deviceHeight * 0.15,
                  ),
                  if(imageurl == null)Container(
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
                        "${widget.currentOrderModel.distanceMeter} ${"m".tr}",
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
                          Get.toNamed(RouteHelper.getOrderDetailPage(orderId: widget.currentOrderModel.orderId!, hasButton: true));
                          // Get.toNamed(RouteHelper.getDropOffPage(orderId: widget.currentOrderModel.orderId!));
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
