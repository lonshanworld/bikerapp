
import 'package:delivery/constants/uiconstants.dart';
import 'package:delivery/controllers/clearance_controller.dart';
import 'package:delivery/views/clerance_history_detail.dart';
import 'package:delivery/widgets/customButton_widget.dart';
import 'package:delivery/widgets/no_item_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

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

    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Clerance History"),
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
      body: isloading
          ?
      LoadingWidget()
          :
      // (clearanceHistoryList.isEmpty)
      //     ?
      Center(
        child: SizedBox(
          width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              if(clearanceHistoryList.isEmpty)NoItemListWidget(txt: "There is no item in clearance history."),
              if(clearanceHistoryList.isNotEmpty)for(ClearanceHistoryModel data in clearanceHistoryList) Card(
                child: Container(
                  margin: EdgeInsets.only(
                      left: 20, right: 10, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Payment Date : ${data.date}",
                            style: UIConstant.minititle,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Zone : ${data.zoneName}",
                            style: UIConstant.normal.copyWith(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Total Qrder Qty ",
                              style: UIConstant.small.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Total Distance ",
                              style: UIConstant.small.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Total Cash Collect ",
                              style: UIConstant.small.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.totalOrderQty.toString(),
                              style: UIConstant.title.copyWith(
                                  color: Colors.redAccent
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data.totalDistanceMeter.toString(),
                              style: UIConstant.title.copyWith(
                                  color: Colors.redAccent
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              data.totalCashCollect.toString(),
                              style: UIConstant.title.copyWith(
                                  color: Colors.redAccent
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              verticalPadding: 10,
                              horizontalPadding: 0,
                              txt: "Clearance Detail",
                              func: (){
                                Get.to(() => ClearanceHistoryDetails(data: data));
                              },
                              txtClr: Colors.white,
                              bgClr: UIConstant.orange,
                              txtsize: 16,
                              rad: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
      //     :
      // ListView.builder(
      //   padding: EdgeInsets.all(10),
      //   itemCount: clearanceHistoryList.length,
      //   itemBuilder: (context, index) {
      //     ClearanceHistoryModel data = clearanceHistoryList[index];
      //     return Card(
      //       child: Container(
      //         margin: EdgeInsets.only(
      //             left: 20, right: 10, top: 20, bottom: 20),
      //         child: Column(
      //           children: [
      //             Row(
      //               children: [
      //                 Text(
      //                   "Payment Date : ${data.date}",
      //                   style: UIConstant.minititle,
      //                 ),
      //               ],
      //             ),
      //             SizedBox(height: 10),
      //             Row(
      //               children: [
      //                 Text(
      //                   "Zone : ${data.zoneName}",
      //                   style: UIConstant.normal.copyWith(
      //                     fontWeight: FontWeight.bold
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(height: 10),
      //             Row(
      //               children: [
      //                 Expanded(
      //                   child: Text(
      //                     "Total Qrder Qty ",
      //                     style: UIConstant.small.copyWith(
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //                 Expanded(
      //                   child: Text(
      //                     "Total Distance ",
      //                     style: UIConstant.small.copyWith(
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //                 Expanded(
      //                   child: Text(
      //                     "Total Cash Collect ",
      //                     style: UIConstant.small.copyWith(
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(height: 10),
      //             Row(
      //               children: [
      //                 Expanded(
      //                   child: Text(
      //                     data.totalOrderQty.toString(),
      //                     style: UIConstant.title.copyWith(
      //                       color: Colors.redAccent
      //                     ),
      //                   ),
      //                 ),
      //                 Expanded(
      //                   child: Text(
      //                     data.totalDistanceMeter.toString(),
      //                     style: UIConstant.title.copyWith(
      //                         color: Colors.redAccent
      //                     ),
      //                   ),
      //                 ),
      //                 Expanded(
      //                   child: Text(
      //                     data.totalCashCollect.toString(),
      //                     style: UIConstant.title.copyWith(
      //                         color: Colors.redAccent
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             Row(
      //               children: [
      //                 Expanded(
      //                   child: CustomButton(
      //                     verticalPadding: 10,
      //                     horizontalPadding: 0,
      //                     txt: "Clearance Detail",
      //                     func: (){
      //                       Get.to(() => ClearanceHistoryDetails(data: data));
      //                     },
      //                     txtClr: Colors.white,
      //                     bgClr: UIConstant.orange,
      //                     txtsize: 16,
      //                     rad: 20,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // )
    );
  }
}
