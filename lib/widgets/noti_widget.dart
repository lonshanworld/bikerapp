
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/routehelper.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../views/loading_screen.dart";
import "customButton_widget.dart";


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
    final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
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
          Radius.circular(10),
        ),
        color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
      ),
      child: AnimatedSize(
        curve: Curves.easeInOutCubic,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
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
                              style: UIConstant.normal.copyWith(
                                overflow: TextOverflow.ellipsis,
                                color: UIConstant.orange,
                              ),
                            ),
                          ),
                          Text(
                            "( ${widget.distance} m )",
                            style: UIConstant.small.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Earn : ${widget.earning} MMK ",
                        style: UIConstant.small.copyWith(
                          color: UIConstant.secondarytxtClr,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
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
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            if(showDetail)Divider(
              height: 10,
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
                      style: UIConstant.small.copyWith(
                        fontWeight: FontWeight.bold,
                        color: UIConstant.orange,
                      ),
                    ),
                    Text(
                      "New Order",
                      style: UIConstant.normal,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    image: DecorationImage(
                        image: NetworkImage(
                          widget.photo,
                        ),
                        fit: BoxFit.cover
                    ),
                  ),
                  height: deviceHeight / 12,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.shopName,
                        style: UIConstant.small,
                      ),
                    ),
                    Text(
                      "${widget.distance} m",
                      style: UIConstant.small,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Your Earn : ${widget.earning} MMK",
                    style: UIConstant.normal.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomButton(
                  verticalPadding: 10,
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
                  txtsize: 14,
                  rad: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
