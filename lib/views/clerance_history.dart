
import 'package:delivery/constants/uiconstants.dart';
import 'package:delivery/controllers/clearance_controller.dart';
import 'package:delivery/views/clerance_history_detail.dart';
import 'package:delivery/widgets/customButton_widget.dart';
import 'package:delivery/widgets/no_item_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../models/clearance_history_model.dart';
import '../widgets/loading_widget.dart';

class ClearanceHistory extends StatefulWidget {
  const ClearanceHistory({Key? key}) : super(key: key);

  @override
  State<ClearanceHistory> createState() => _ClearanceHistoryState();
}

class _ClearanceHistoryState extends State<ClearanceHistory> {

  final ClearanceController clearanceController = Get.find<ClearanceController>();
  List<ClearanceHistoryModel> clearanceHistoryList = [];

  bool isloading = true;

  Future assignData()async{
    clearanceHistoryList = await clearanceController.getClearanceHistory();
    setState(() {
      isloading = false;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assignData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clerance History"),
      ),
      body: isloading
          ?
      LoadingWidget()
          :
      (clearanceHistoryList.isEmpty)
          ?
      ListView(
        children: [
          SizedBox(
            height: 2.h,
          ),
          NoItemListWidget(txt: "There is no item in clearance history."),
        ],
      )
          :
      ListView.builder(
        padding: EdgeInsets.all(1.5.h),
        itemCount: clearanceHistoryList.length,
        itemBuilder: (context, index) {
          final data = clearanceHistoryList[index];
          return Card(
            child: Container(
              margin: EdgeInsets.only(
                  left: 20, right: 10, top: 20, bottom: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Payment Date : ${data.date}",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Text(
                        "Zone : ${data.zoneName}",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Total Qrder Qty ",
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Total Distance ",
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Total Cash Collect ",
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.totalOrderQty.toString(),
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          data.totalDistanceMeter.toString(),
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          data.totalCashCollect.toString(),
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    verticalPadding: 3.h,
                    horizontalPadding: 14.h,
                    txt: "Clearance Detail",
                    func: (){
                      Get.to(() => ClearanceHistoryDetails(data: data));
                    },
                    txtClr: Colors.white,
                    bgClr: UIConstant.orange,
                    txtsize: 14.sp,
                    rad: 3.h,
                  ),
                ],
              ),
            ),
          );
        },
      )
    );
  }
}
