import 'dart:convert';
import 'dart:io';

import 'package:delivery/constants/txtconstants.dart';
import 'package:delivery/controllers/useraccount_controller.dart';
import 'package:delivery/error_handlers/error_handlers.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';

class OrderService{
  final box = GetStorage();
  final UserAccountController userAccountController = Get.find<UserAccountController>();
  final ErrorHandler errorHandler = ErrorHandler();

  Future getCurrentOrder()async{
    String uri = "${TxtConstant.mainUrl}order/current-orders?userId=${box.read(TxtConstant.user_id)}";
    try{
      http.Response response = await http.get(Uri.parse(uri),headers: {
        "Authorization" : "bearer ${box.read(TxtConstant.accesstoken)}",
      });
      print("in getcurrentorder service || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }

  Future getSingleOrderDetail(String orderId)async{
    String uri = "${TxtConstant.mainUrl}order/$orderId";
    try{
      http.Response response = await http.get(Uri.parse(uri),headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorization" : "bearer ${box.read(TxtConstant.accesstoken)}",
      });

      print("in getsingleorderdetail service || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }

  Future getAllOrderHistory()async{
    DateTime currentdate = DateTime.now();
    String sdate =  DateFormat('y-MM-dd').format(currentdate.subtract(Duration(days: 30)));
    String edate = DateFormat('y-MM-dd').format(currentdate);
    print(sdate);
    print(edate);
    String uri = "${TxtConstant.mainUrl}order/previous-orders?userId=${box.read(TxtConstant.user_id)}&sdate=$sdate&edate=$edate";
    try{
      http.Response response = await http.get(Uri.parse(uri),headers: {
        "Authorization" : "bearer ${box.read(TxtConstant.accesstoken)}",
      });

      print("in getAllorderHistory service || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }


  Future OrderBikerAccept(String orderId)async{
    String uri = "${TxtConstant.mainUrl}order/biker-accept";
    dynamic forbody = {
      "bikerId" : "${userAccountController.bikermodel[0].userId}",
      "orderId" : orderId,
    };
    try{
      http.Response response = await http.post(Uri.parse(uri),headers: {
        'Content-Type': 'application/json',
        "Authorization" : "bearer ${box.read(TxtConstant.accesstoken)}",
      },body: json.encode(forbody));

      print("in orderbikeraccept || ${response.statusCode}");
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }


  Future bikerPickUp(String orderId)async{
    String uri = "${TxtConstant.mainUrl}order/biker-pickup";
    dynamic forbody={
      "orderId" : orderId,
      "shopId" : "null",
      "userId" : "${box.read(TxtConstant.user_id)}",
    };
    try{
      http.Response response = await http.post(Uri.parse(uri),headers: {
        'Content-Type': 'application/json',
        "Authorization" : "bearer ${box.read(TxtConstant.accesstoken)}",
      },body: json.encode(forbody));

      print("in orderbikeraccept || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }


  Future bikerDropOff(String orderId) async{
    String uri = "${TxtConstant.mainUrl}order/biker-dropoff";
    dynamic forbody = {
      "orderId" : orderId,
      "bikerId" : "${userAccountController.bikermodel[0].userId}",
    };
    try{
      http.Response response = await http.post(Uri.parse(uri),headers: {
        'Content-Type': 'application/json',
        "Authorization" : "bearer ${box.read(TxtConstant.accesstoken)}",
      },body: json.encode(forbody));

      print("in orderbikeraccept || ${response.statusCode}");
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }
}