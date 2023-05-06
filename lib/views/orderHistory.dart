
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/models/order_model.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/widgets/loading_widget.dart";
import "package:delivery/widgets/no_item_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";

import "order_detail_screen.dart";

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {

  final OrderController orderController = Get.find<OrderController>();

  List<OrderDetailModel> orderHistoryList = [];
  bool _isloading = true;

  String changeDateFormat(DateTime txt){
    String newtxt = DateFormat('y-MMM-d, ').add_jm().format(txt);
    return newtxt;
  }

  Color getcolor(String txt){
    String newString = txt.toLowerCase();
    late Color clr;
    switch(newString){
      case "order way on" :
        clr = Colors.blue;
        break;
      case "biker picked up" :
        clr = UIConstant.orange;
        break;
      case "order done" :
        clr = Colors.greenAccent;
        break;
      case "order cancelled" :
        clr = Colors.redAccent;
        break;
      default :
        clr = Colors.grey;
        break;
    }
    return clr;
  }

  @override
  void initState() {
    super.initState();
    orderController.getCurrentOrderList().then((value){
      orderHistoryList = value;
      setState(() {
        _isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: (){
            Get.offAllNamed("/home");
          },
        ),
      ),
      body: _isloading
          ?
        LoadingWidget()
          :
        (orderHistoryList.isEmpty)
          ?
        ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            NoItemListWidget(txt: "There is no item in order history"),
          ],
        )
          :
        ListView.builder(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          itemCount: orderHistoryList.length,
          itemBuilder: (ctx,index){
            OrderDetailModel _item = orderHistoryList[index];
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                onTap: (){
                  // _generalController.getOrderDetails(_item.orderId).then((value){
                  //   Get.to(()=> OrderDetailScreen(
                  //     bikername:  _generalController.bikerModel[0].fullName,
                  //     orderDetailModel: value,
                  //     hasButton: false,
                  //   ));
                  // });
                  Get.offNamed(RouteHelper.getOrderDetailPage(
                    orderId: _item.orderId!,
                    hasButton: false,
                  ));
                },
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(15),

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _item.cusName!,
                            style: UIConstant.normal.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: getcolor(_item.orderStatus!),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 15,
                            ),
                            child: Text(
                              _item.orderStatus!,
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _item.phone!,
                            style: UIConstant.normal.copyWith(
                              color: UIConstant.secondarytxtClr,
                            ),
                          ),
                          Text(
                            changeDateFormat(_item.orderDate!),
                            style: UIConstant.tinytext.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}
