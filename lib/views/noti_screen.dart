import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/noti_controller.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";

import "../models/noti_model.dart";

class NotiScreen extends StatelessWidget {
  const NotiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final deviceWidth = MediaQuery.of(context).size.width;

    final NotiController notiController = Get.find<NotiController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Notification ${"history".tr}"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
          ),
          onPressed: () {
            // Get.offAllNamed("/home");
            Get.back();
          },
        ),
      ),
      body: Obx((){
        return (notiController.notiList.isEmpty)
            ?
        Center(
          child: Text("nonoti".tr),
        )
            :
        Center(
          child: SizedBox(
            width: deviceWidth > 500 ? deviceWidth * 0.85 : deviceWidth,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              itemCount: notiController.notiList.length,
              itemBuilder: (_, index) {
                RandomNotiModel item = notiController.notiList[notiController.notiList.length - index -1];
                return Container(
                  // decoration: BoxDecoration(
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.grey.shade300,
                  //       blurRadius: 4.0,
                  //       spreadRadius: 1.0,
                  //       offset: Offset(2.0, 2.0),
                  //     ),
                  //   ],
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.all(
                  //     Radius.circular(10),
                  //   ),
                  // ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Colors.grey
                          )
                      )
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: UIConstant.normal.copyWith(
                                fontWeight: FontWeight.bold,
                                color: UIConstant.orange,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                item.date.split(" ")[0],
                                style: UIConstant.small.copyWith(
                                  color: UIConstant.secondarytxtClr,
                                ),
                              ),
                              Text(
                                "${item.date.split(" ")[1]} ${item.date.split(" ")[2]}",
                                style: UIConstant.small.copyWith(
                                  color: UIConstant.secondarytxtClr,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        item.body,
                        style: UIConstant.small,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
