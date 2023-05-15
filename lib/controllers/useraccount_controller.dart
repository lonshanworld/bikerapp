import 'dart:convert';
import 'dart:math';

import 'package:delivery/constants/txtconstants.dart';
import 'package:delivery/models/biker_model.dart';
import 'package:delivery/routehelper.dart';
import 'package:delivery/widgets/snackBar_custom_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import "package:http/http.dart" as http;
import '../models/punishment_model.dart';
import '../services/useraccount_service.dart';
import '../views/loading_screen.dart';
import "dart:io";

class UserAccountController extends GetxController{
  final UserAccountService service = UserAccountService();
  final box = GetStorage();

  final RxList<BikerModel> bikermodel = List<BikerModel>.empty().obs;

  RxInt randomnum = 0.obs;
  RxString phoneNumber = "".obs;


  Future<void> getUserLogin(String number)async{
    Get.dialog(const LoadingScreen(), barrierDismissible: false);
    http.Response response = await service.userLogin(number);
    dynamic userdataRaw = json.decode(response.body);
    phoneNumber.value = number.toString();
    // getrandomrum();
    box.write(TxtConstant.accesstoken, userdataRaw["data"]["access_token"]);
    box.write(TxtConstant.refreshtoken, userdataRaw["data"]["refresh_token"]);
    box.write(TxtConstant.user_id, userdataRaw["data"]["user"]["id"]);
    // box.write(TxtConstant.user_userName, userdataRaw["data"]["user"]["userName"]);
    // box.write(TxtConstant.user_email, userdataRaw["data"]["user"]["email"]);
    // box.write(TxtConstant.user_phNo, userdataRaw["data"]["user"]["phoneNumber"]);
    // box.write(TxtConstant.user_fullName, userdataRaw["data"]["user"]["fullName"]);
    box.write(TxtConstant.user_role, userdataRaw["data"]["user"]["user_role"]);
    Get.back();
  }

  Future<void> checkUser(String number)async{
    await service.userLogin(number);
  }

  getrandomrum(){
    var rnd = Random();
    var num = rnd.nextInt(999999);
    while (num < 100000) {
      num *= 10;
    }

    randomnum.value = num;
  }

  Future<void> sendSMS()async{
    getrandomrum();
    await service.sendSMSservice(phoneNumber.toString(), randomnum.toString());
  }

  Future<void>verifiedUser()async{

    print("This is in verified");
    await getUserLogin(phoneNumber.value);

    // print(userdataRaw["data"]["user"]["id"]);
    await registerNotiToken();
  }

  Future<void>registerNotiToken()async{
    String? tokenvalue = await FirebaseMessaging.instance.getToken();
    print("This is notitoken :: $tokenvalue");
    await service.registerToken(tokenvalue, box.read(TxtConstant.user_id));
    await getInfo();
  }

  Future<void> revokeuserToken()async{
    http.Response response = await service.revokeUserToken();
    await registerNotiToken();
    dynamic userdataRaw = json.decode(response.body);
    box.write(TxtConstant.accesstoken, userdataRaw["data"]["access_token"]);
    box.write(TxtConstant.refreshtoken, userdataRaw["data"]["refresh_token"]);
  }

  Future<void> getInfo()async{
    http.Response response = await service.getBikerInfo();
    dynamic data = json.decode(response.body)["data"];
    BikerModel bikerdata = BikerModel.fromjson(data);
    List<BikerModel> list = [];
    list.add(bikerdata);
    bikermodel.assignAll(list.map((e) => e).toList());
  }


  Future<void>bikerupdate({
    required String name,
    required String nrc,
    required String email,
    required File profile,
  })async{
    http.StreamedResponse response = await service.bikerUpdate(name: name, nrc: nrc, email: email, profile: profile);
    if(response.statusCode < 299){
      CustomGlobalSnackbar.show(
        context: Get.context!,
        title: "Update : ${response.statusCode}",
        txt: "Biker Update Success.",
        icon: Icons.check,
        position: true,
      );
      getInfo();
    }else{
      CustomGlobalSnackbar.show(
        context: Get.context!,
        title: "Update Failed : ${response.statusCode}",
        txt: "Biker Update Failed.",
        icon: Icons.check,
        position: true,
      );
    }
  }


  Future<List<PunishmentModel>> getPunishment()async{
    http.Response rawdata = await service.punishmentData();
    var data = json.decode(rawdata.body)["data"];
    List<PunishmentModel> punishmentList = [];
    for(var item in data){
      PunishmentModel _pmodel = PunishmentModel.fromJson(item);
      punishmentList.add(_pmodel);
    }
    return punishmentList;
  }


  
  // Logout(){
  //   box.remove(TxtConstant.language);
  //   box.remove(TxtConstant.theme);
  //   box.remove(TxtConstant.accesstoken);
  //   box.remove(TxtConstant.refreshtoken);
  //   box.remove(TxtConstant.user_id);
  //   box.remove(TxtConstant.user_userName);
  //   box.remove(TxtConstant.user_email);
  //   box.remove(TxtConstant.user_phNo);
  //   box.remove(TxtConstant.user_fullName);
  //   box.remove(TxtConstant.user_role);
  // }
}