import 'dart:convert';

import 'package:delivery/constants/txtconstants.dart';
import 'package:delivery/controllers/schedule_controller.dart';
import 'package:delivery/services/check_in_out_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import "dart:io";
import "package:get/get.dart";

import 'package:http/http.dart' as http;

import '../models/schedule_model.dart';
import '../views/loading_screen.dart';
import '../widgets/snackBar_custom_widget.dart';

class CheckInOutController extends GetxController{
  final CheckInOutService service = CheckInOutService();
  final ScheduleController scheduleController = Get.find<ScheduleController>();
  final box = GetStorage();

  Future<bool> checkIn(File image)async{
    http.StreamedResponse response = await service.checkIn(image);
    print("check in controller");
    print(response.statusCode);
    if(response.statusCode < 299){
      String data = await response.stream.bytesToString();
      print(data);
      // box.write(TxtConstant.checkIn, data);
      // box.write(TxtConstant.checkOutBtn, true);

      // TODO : reload schedule
      //---------------------------------------- ??
      await scheduleController.scheduleReload();

      CustomGlobalSnackbar.show(
        context: Get.context!,
        // title: "Success : ${response.statusCode}",
        title: "Success",
        txt: "Checked In Successfully!",
        icon: Icons.check,
        position: false,
      );
      return true;
    }else{
      CustomGlobalSnackbar.show(
        context: Get.context!,
        // title: "Failed : ${response.statusCode}",
        title: "fail".tr,
        txt: "checkinfail".tr,
        icon: Icons.info_outline,
        position: false,
      );
      return false;
    }
  }

  // dynamic getCheckInData(){
  //   // dynamic data = json.decode(box.read(TxtConstant.checkIn));
  //   // print(data["data"]);
  //
  //
  //   // TODO : schedule model nk chate yan
  //   //------------------------------??
  //   if(box.read(TxtConstant.checkIn) != null){
  //     dynamic data = json.decode(box.read(TxtConstant.checkIn));
  //     return ScheduleModel.fromJson(data["data"]);
  //   }else{
  //     return null;
  //   }
  // }

  Future<void> checkOut(ScheduleModel checkinSchedule)async{
    print("Inside checkout===================================");
    // ScheduleModel checkindata = getCheckInData();
    String checkoutDay = checkinSchedule.scheduleId.toString().split(" ")[0];

    http.Response respones = await service.checkOut(checkoutDay);
    if(respones.statusCode < 299){
      // box.remove(TxtConstant.checkIn);
      // box.write(TxtConstant.checkOutBtn, false);


      // TODO : reload schedule
      //---------------------------------------- ??
      await scheduleController.scheduleReload();

      CustomGlobalSnackbar.show(
        context: Get.context!,
        title: "Success!",
        txt: "Check out successfully.",
        icon: Icons.check,
        position: false,
      );
    }else{
      CustomGlobalSnackbar.show(
        context: Get.context!,
        title: "Check out Error",
        txt: "CheckOut is denied!",
        icon: Icons.info_outline,
        position: false,
      );
    }
  }
}