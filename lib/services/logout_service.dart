import 'package:delivery/controllers/check_in_out_controller.dart';
import 'package:delivery/controllers/noti_controller.dart';
import 'package:delivery/services/noti_service.dart';
import 'package:delivery/services/theme_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import "package:get/get.dart";

import '../dependencies.dart';
import '../routehelper.dart';

class LogOutService{
  final box = GetStorage();

  final NotiService notiService = NotiService();

  logout(BuildContext context){
    Future.delayed(Duration(seconds: 2),(){
      if(Theme.of(context).brightness == Brightness.dark){
        ThemeService().switchTheme();
      }
      notiService.deleteAll();
      box.erase();
      Get.offAllNamed(RouteHelper.getLoginPage());
    });
  }
}