import 'dart:convert';

import 'package:delivery/controllers/noti_controller.dart';
import 'package:delivery/services/noti_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../routehelper.dart';
import '../services/theme_service.dart';
import 'error_screen.dart';
import 'forceexit_service.dart';

class ErrorHandler{
  final NotiService notiService =NotiService();
  final box = GetStorage();

  handleError(http.Response response){
    if(response.statusCode >400 && response.statusCode < 404){
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (ctx){
          return ErrorScreen(
            title: "Unauthorized Error : ${response.statusCode}",
            txt: "Please Click the button to Logout and Login again to continue.",
            btntxt: "Click to Logout",
            Func: (){
              if(Theme.of(Get.context!).brightness == Brightness.dark){
                ThemeService().switchTheme();
              }
              notiService.deleteAll();
              box.erase();
              Get.offAllNamed(RouteHelper.getLoginPage());
            },
          );
        },
      );
    }else if(response.statusCode > 499 && response.statusCode < 600){
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (ctx){
          return ErrorScreen(
            title: "Internal Server Error : ${response.statusCode}",
            txt: json.decode(response.body)["error"]["message"],
            btntxt: "Click to go back",
            Func: (){
              Get.back();
            },
          );
        },
      );
    }else if(response.statusCode > 299 && response.statusCode < 401){
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (ctx){
          return ErrorScreen(
            title: "Unexpected Error : ${response.statusCode}",
            txt: json.decode(response.body)["error"]["message"],
            btntxt: "Click to go back",
            Func: (){
              Get.back();
            },
          );
        },
      );
    }else if(response.statusCode > 403 && response.statusCode < 499){
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (ctx){
          return ErrorScreen(
            title: "Unexpected Error : ${response.statusCode}",
            txt: json.decode(response.body)["error"]["message"],
            btntxt: "Click to go back",
            Func: (){
              Get.back();
            },
          );
        },
      );
    }
  }

  handleUnknownError(String txt){
    Get.back();
    showDialog(
      context: Get.context!,
      builder: (ctx){
        return ErrorScreen(
          title: "Unknown Error",
          txt: txt,
          btntxt: "Click to go back",
          Func: (){
            Get.back();
          },
        );
      },
    );
  }

  handleNullError(String txt){
    Get.back();
    showDialog(
      context: Get.context!,
      builder: (ctx){
        return ErrorScreen(
          title: "Unknown Error",
          txt: txt,
          btntxt: "Click to leave the app",
          Func: (){
            ForceExitAppService().exitApp();
          },
        );
      },
    );
  }
}