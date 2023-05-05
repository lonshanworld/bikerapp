
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/routehelper.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../views/loading_screen.dart";
import "customButton_widget.dart";
import 'package:sizer/sizer.dart';


class NotiWidget extends StatefulWidget {
  final String orderBody;
  final String orderNo;
  final String orderId;
  final int earning;
  final String shopName;
  final double distance;
  final String photo;
  final VoidCallback func;

  NotiWidget({
    required this.orderBody,
    required this.orderNo,
    required this.orderId,
    required this.earning,
    required this.shopName,
    required this.distance,
    required this.photo,
    required this.func,
});

  @override
  State<NotiWidget> createState() => _NotiWidgetState();
}

class _NotiWidgetState extends State<NotiWidget> with SingleTickerProviderStateMixin{
  
  final OrderController orderController = Get.find<OrderController>();
  
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool showDetail = false;

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500)
    );
    _animation = Tween<double>(
        begin: 0,
        end: 0.5
    ).animate(_animationController);
  }

  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 3.h,
        vertical: 1.h,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(1.h),
        ),
        color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
      ),
      child: AnimatedSize(
        curve: Curves.easeInOutCubic,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 2.h,
            vertical: 1.h,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.shopName,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13.sp,
                                color: UIConstant.orange,
                              ),
                            ),
                          ),
                          Text(
                            "( ${widget.distance} m )",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Earn : ${widget.earning} MMK ",
                        style: TextStyle(
                          color: UIConstant.secondarytxtClr,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 1.h,
                ),
                RotationTransition(
                  turns: _animation,
                  child: IconButton(
                    onPressed: (){
                      setState(() {
                        showDetail = !showDetail;
                      });
                      if(showDetail){
                        _animationController.forward();
                      }else{
                        _animationController.reverse();
                      }
                    },
                    icon: Icon(
                      Icons.arrow_drop_up,
                      size: 30.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            if(showDetail)Divider(
              height: 1.h,
              color: UIConstant.orange,
            ),
            if(showDetail)ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.orderBody,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: UIConstant.orange,
                      ),
                    ),
                    Text(
                      "New Order",
                      style: TextStyle(
                        fontSize: 12.sp
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.h),
                    ),
                    image: DecorationImage(
                        image: NetworkImage(
                          widget.photo,
                        ),
                        fit: BoxFit.cover
                    ),
                  ),
                  height: 14.h,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.shopName,
                        style: TextStyle(
                          fontSize: 12.sp
                        ),
                      ),
                    ),
                    Text(
                      "${widget.distance} m",
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Your Earn : ${widget.earning} MMK",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomButton(
                  verticalPadding: 1.h,
                  horizontalPadding: 0,
                  txt: "Accept",
                  func: ()async{

                    Get.dialog(const LoadingScreen(), barrierDismissible: false);
                    await orderController.acceptOrder(widget.orderId);
                    // // Get.to(()=>OrderDetailScreen(refNO: widget.orderNo,orderId: widget.orderId,bikername: generalController.bikerModel[0].fullName,));
                    // _generalController.getOrderDetails(widget.orderId).then((value){
                    //   Get.to(()=> OrderDetailScreen(
                    //       bikername:  _generalController.bikerModel[0].fullName,
                    //       orderDetailModel: value,
                    //       hasButton: true,
                    //   ));
                    // });
                    Get.back();
                    Get.toNamed(RouteHelper.getOrderDetailPage(orderId: widget.orderId, hasButton: true));
                    widget.func();
                    // _generalController.getCurrentOrder();
                  },
                  txtClr: Colors.white,
                  bgClr: Color.fromRGBO(44, 193, 156, 1),
                  txtsize: 12.sp,
                  rad: 1.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
