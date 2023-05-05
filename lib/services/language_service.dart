import 'dart:ui';

import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import "../constants/txtconstants.dart";

class LanguageService{
  final box = GetStorage();

  bool loadLanguageisMyanmar(){
    bool value = box.read(TxtConstant.language) ?? false;
    return value;
  }

  Locale get locale => loadLanguageisMyanmar() ? Locale("my","MM") : Locale("en","US");

  changeLanguage(){
    if(box.read(TxtConstant.language) == null || box.read(TxtConstant.language) == false){
      box.write(TxtConstant.language, true);
      Get.updateLocale(locale);
    }else{
      box.write(TxtConstant.language, false);
      Get.updateLocale(locale);
    }
  }

}