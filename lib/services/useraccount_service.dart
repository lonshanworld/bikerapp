
import 'dart:convert';

import 'package:delivery/constants/txtconstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';

import '../error_handlers/error_handlers.dart';
import "dart:io";

import '../error_handlers/error_screen.dart';

class UserAccountService{

  final ErrorHandler errorHandler = ErrorHandler();
  final box = GetStorage();

  Future usercheck(String mobileNo)async{
    String uri = "${TxtConstant.mainUrl}auth/get-user?phone=$mobileNo";
    try{
      http.Response response = await http.get(Uri.parse(uri));
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }

  Future userLogin(String mobileNo)async{
    String uri = "${TxtConstant.mainUrl}auth/access-token";
    try{
      http.Response response = await http.post(Uri.parse(uri),body : {
        "Username" : mobileNo,
        "password" : TxtConstant.defaultPassword,
      });
      print("in userLogin || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }


  Future sendSMSservice(String phNum, String randomnum)async{
    String uri = "${TxtConstant.mainUrl}sms";
    try{
      http.Response response = await http.post(Uri.parse(uri),body: {
        'To': phNum,
        'Message':
        "Your OTP Code is $randomnum. Please enter this code for your Biker account",
      });
      print("in sendSMSservice || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }

  Future registerToken(String? token, String userId)async{
    String uri = "${TxtConstant.mainUrl}notifications/register-token";
    print(userId);
    print(token);
    try{
      http.Response response = await http.post(Uri.parse(uri),headers:{
        'Authorization': 'Bearer ${box.read(TxtConstant.accesstoken)}',
      },body: {
        'UserId': userId,
        'Role': "biker",
        'Platform' : "mobile",
        'NotificationToken': token,
      });
      print("in registerToken || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }

  Future getBikerInfo()async{
    String uri = "${TxtConstant.mainUrl}me/personal";
    try{
      http.Response response = await http.get(Uri.parse(uri),headers: {
        'Accept': '*/*',
        // // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ${box.read(TxtConstant.accesstoken)}',
      });
      print("In getbiker info || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }

  Future refreshUserToken()async{
    String uri = "${TxtConstant.mainUrl}auth/refresh-token";
    try{
      http.Response response = await http.post(Uri.parse(uri),body: {
        'Access_Token': box.read(TxtConstant.accesstoken),
        'Refresh_Token': box.read(TxtConstant.refreshtoken),
      });
      print("In revokeuser info || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }

  Future bikerUpdate({
    required String name,
    required String nrc,
    required String email,
    required File profile,
  })async{
    String uri = "${TxtConstant.mainUrl}me/personal/biker";
    dynamic bodydata = {
      "UserId" : box.read(TxtConstant.user_id),
      "FullName" : name,
      "NRC" : nrc,
      "Email" : email,
      "ProfileImg" : profile.path,
    };

    try{
      // http.Response response = await http.put(Uri.parse(uri),headers: {
      //   'Accept': 'application/json',
      //   // // 'Content-Type': 'application/json',
      //   'Authorization': 'Bearer ${box.read(TxtConstant.accesstoken)}',
      // },body: json.encode(bodydata));
      // print("In updatebiker info || ${response.statusCode}");
      // print(response.body);
      // if(response.statusCode > 299){
      //   throw errorHandler.handleError(response);
      // }
      // return response;
      var request = http.MultipartRequest('PUT', Uri.parse(uri));
      request.headers["Authorization"] = "Bearer ${ box.read(TxtConstant.accesstoken)}";
      request.headers["Accept"] = "application/json";
      http.MultipartFile multipartFile =
      await http.MultipartFile.fromPath('ProfileImg', profile.path);
      request.files.add(multipartFile);
      Map<String, dynamic> data = Map<String, String>();
      //normal data
      data["UserId"] =  box.read(TxtConstant.user_id);
      data["FullName"] = name;
      data['Nrc'] = nrc;
      data['Email'] = email;
      request.fields.addAll(data as Map<String,String>);
      var res = await request.send();
      return res;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }


  Future punishmentData() async{
    DateTime currentdate = DateTime.now();
    String sdate =  DateFormat('y-MM-d').format(currentdate.subtract(Duration(days: 30)));
    String edate = DateFormat('y-MM-d').format(currentdate);
    String uri =  "${TxtConstant.mainUrl}punishment?sdate=$sdate&edate=$edate";
    try{
      var response = await http.get(Uri.parse(uri),headers: {
        'Accept': 'application/json',
        "Authorization" : "bearer ${box.read("access_token")}",
      });
      print("In punishment info || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }

}