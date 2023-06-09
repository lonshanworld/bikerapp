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
import '../views/loading_screen.dart';
import 'language_service.dart';

class LogOutService{
  final box = GetStorage();

  final NotiService notiService = NotiService();

  logout(BuildContext context){
    Get.dialog(const LoadingScreen(), barrierDismissible: false);
    Future.delayed(Duration(seconds: 2),(){
      if(Theme.of(context).brightness == Brightness.dark){
        ThemeService().switchTheme();
      }
      if(Get.locale.toString() != "en_US"){
        LanguageService().changeLanguage();
      }
      notiService.deleteAll();
      box.erase();
      Get.back();
      Get.offAllNamed(RouteHelper.getLoginPage());
    });
  }
}