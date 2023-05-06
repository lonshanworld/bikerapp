import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/noti_controller.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../models/noti_model.dart";

class NotiScreen extends StatelessWidget {
  const NotiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotiController notiController = Get.find<NotiController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Notification History"),
      ),
      body: Obx((){
        return (notiController.notiList.isEmpty)
            ?
        Center(
          child: Text("There is no Notifications"),
        )
            :
        ListView.builder(
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
                          ),
                        ),
                      ),
                      Text(
                        item.date,
                        style: UIConstant.small,
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
        );
      }),
    );
  }
}
