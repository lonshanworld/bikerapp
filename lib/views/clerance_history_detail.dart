
import 'package:delivery/models/clearance_history_model.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";


class ClearanceHistoryDetails extends StatefulWidget {
  ClearanceHistoryModel data;
  ClearanceHistoryDetails({
    required this.data,
  });


  @override
  State<ClearanceHistoryDetails> createState() => _ClearanceHistoryDetailsState();
}

class _ClearanceHistoryDetailsState extends State<ClearanceHistoryDetails> {

  TextEditingController totalOrderQTy = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController cashController = TextEditingController();
  TextEditingController miscController = TextEditingController();
  TextEditingController creditController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  @override
  void initState() {
    super.initState();
    totalOrderQTy.text = widget.data.totalOrderQty.toString();
    distanceController.text = widget.data.totalDistanceMeter.toString();
    cashController.text = widget.data.totalCashCollect.toString();
    miscController.text = widget.data.miscusage.toString();
    creditController.text = widget.data.creditAmt.toString();
    totalController.text = widget.data.totalCashCollect.toString();
  }

  @override
  Widget build(BuildContext context) {

    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Clerance Details"),
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 5),
            width: deviceWidth > 500 ? deviceWidth * 0.85 : deviceWidth,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Date: " + widget.data.date.toString().substring(0, 10),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Zone: " + widget.data.zoneName.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Qrder Qty",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: totalOrderQTy,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            //  labelText: "Level",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Distance",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: distanceController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            //  labelText: "COD",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Cash Collect",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: cashController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            //   labelText: "COD",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "MISC Usage",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: miscController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            //  labelText: "Credit",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Credit",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: creditController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            // labelText: "Total Clerance",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Clerance",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: totalController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            // labelText: "Total Clerance",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.orange),
                      SizedBox(height: 5),
                      Text("Capture payment Document")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
