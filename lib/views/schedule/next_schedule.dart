
import 'package:delivery/controllers/schedule_controller.dart';
import 'package:delivery/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/uiconstants.dart';
import '../../widgets/schedule_widget.dart';
import '../loading_screen.dart';

class NextSchedule extends StatefulWidget {
  const NextSchedule({Key? key}) : super(key: key);

  @override
  State<NextSchedule> createState() => _NextScheduleState();
}

class _NextScheduleState extends State<NextSchedule> {
  final ScheduleController scheduleController = Get.find<ScheduleController>();


  @override
  Widget build(BuildContext context) {

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: RefreshIndicator(
        color: UIConstant.orange,
        onRefresh: ()async{
          Get.dialog(const LoadingScreen(), barrierDismissible: false);
          await scheduleController.scheduleReload();
          Get.back();
        },
        child: Obx((){
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: 10,
              ),
              height: deviceHeight,
              width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: scheduleController.nextScheduleList.length,
                  itemBuilder: (context, index) {
                    ScheduleModel item = scheduleController.nextScheduleList[index];
                    return ScheduleWidget(
                      scheduleName: item.scheduleName!,
                      scheduleId: item.scheduleId!,
                      startSchedule: item.startSchedule!,
                      endSchedule: item.endSchedule!,
                    );
                  }),
            ),
          );
        }),
      ),
    );
  }
}
