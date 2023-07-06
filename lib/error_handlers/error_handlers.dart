import 'dart:convert';

import 'package:delivery/services/logout_service.dart';
import 'package:delivery/services/noti_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'error_screen.dart';
import 'forceexit_service.dart';

class ErrorHandler{
  final NotiService notiService =NotiService();
  final LogOutService logOutService = LogOutService();
  final box = GetStorage();

  handleError(http.Response response){
    if(response.statusCode >400 && response.statusCode < 404){
      Get.back();
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (ctx){
          return ErrorScreen(
            // title: "Unauthorized Error : ${response.statusCode}",
            title: "Unauthorized",
            txt: json.decode(response.body)["error"].toString(),
            btntxt: "Click to Logout",
            Func: (){
              // if(Theme.of(Get.context!).brightness == Brightness.dark){
              //   ThemeService().switchTheme();
              // }
              // notiService.deleteAll();
              // box.erase();
              // Get.offAllNamed(RouteHelper.getLoginPage());
              logOutService.logout(Get.context!);
            },
          );
        },
      );
    }else if(response.statusCode > 499 && response.statusCode < 600){
      Get.back();
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (ctx){
          return ErrorScreen(
            // title: "Internal Server Error : ${response.statusCode}",
            // txt: json.decode(response.body)["error"]["message"],
            title: "We are sorry!",
            txt: json.decode(response.body)["error"].toString(),
            btntxt: "Click to go back",
            Func: (){
              Get.back();
              Get.back();
            },
          );
        },
      );
    }else if(response.statusCode > 299 && response.statusCode < 401){
      Get.back();
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (ctx){
          return ErrorScreen(
            // title: "Unexpected Error : ${response.statusCode}",
            // txt: json.decode(response.body)["error"]["message"],
            title: "We are sorry!",
            txt: json.decode(response.body)["error"].toString(),
            btntxt: "Click to go back",
            Func: (){
              Get.back();
              Get.back();
            },
          );
        },
      );
    }else if(response.statusCode > 403 && response.statusCode < 499){
      Get.back();
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (ctx){
          return ErrorScreen(
            // title: "Unexpected Error : ${response.statusCode}",
            // txt: json.decode(response.body)["error"]["message"],
            title: "We are sorry!",
            txt: json.decode(response.body)["error"].toString(),
            btntxt: "Click to go back",
            Func: (){
              Get.back();
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
      barrierDismissible: false,
      builder: (ctx){
        return ErrorScreen(
          // title: "Unknown Error",
          // txt: txt,
          title: "We are sorry!",
          txt: txt,
          btntxt: "Click to go back",
          Func: (){
            Get.back();
            Get.back();
            // ForceExitAppService().exitApp();
          },
        );
      },
    );
  }

  handleforTokenError(http.Response response){
    if(response.statusCode > 299){
      Get.back();
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (ctx){
          return ErrorScreen(
            // title: "Unauthorized Error : ${response.statusCode}",
            title: "Unauthorized",
            txt:json.decode(response.body)["error"].toString(),
            btntxt: "Click to Logout",
            Func: (){
              // if(Theme.of(Get.context!).brightness == Brightness.dark){
              //   ThemeService().switchTheme();
              // }
              // notiService.deleteAll();
              // box.erase();
              // Get.offAllNamed(RouteHelper.getLoginPage());
              logOutService.logout(Get.context!);
            },
          );
        },
      );
    }
  }

  handleNoSignalRerror(String txt){
    Get.back();
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (ctx){
        return ErrorScreen(
          // title: "Unknown Error",
          // txt: txt,
          title: "We are sorry",
          txt: txt,
          btntxt: "Click to leave the app",
          Func: (){
            ForceExitAppService().exitApp();
          },
        );
      },
    );
  }


  // handleDBerror(String title, String txt, VoidCallback Funcs ){
  //   Get.back();
  //   showDialog(
  //     context: Get.context!,
  //     barrierDismissible: false,
  //     builder: (ctx){
  //       return ErrorScreen(
  //         // title: "Unknown Error",
  //         // txt: txt,
  //         title: title,
  //         txt: txt,
  //         btntxt: "Click to leave the app",
  //         Func: (){
  //           Funcs();
  //           logOutService.logout(Get.context!);
  //           ForceExitAppService().exitApp();
  //         },
  //       );
  //     },
  //   );
  // }
}