import 'dart:io';

import 'package:delivery/constants/txtconstants.dart';
import 'package:get_storage/get_storage.dart';
import "package:http/http.dart" as http;
import '../error_handlers/error_handlers.dart';

class ClearanceService{
  final box = GetStorage();
  final ErrorHandler errorHandler = ErrorHandler();

  Future getClearance()async{
    print(box.read(TxtConstant.user_id));
    String uri = "${TxtConstant.mainUrl}transaction/clearance?userId=${box.read(TxtConstant.user_id)}";
    try{
      http.Response response = await http.get(Uri.parse(uri),headers: {
        'Accept': '*/*',
        // // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ${box.read(TxtConstant.accesstoken)}',
      });

      print("in getClearance service || ${response.statusCode}");
      print(response.body);
      if(response.statusCode > 299){
        throw errorHandler.handleError(response);
      }
      return response;
    }on Exception catch(err){
      throw errorHandler.handleUnknownError(err.toString());
    }
  }



  Future getClearanceHistory()async{
    String uri = "${TxtConstant.mainUrl}transaction/clearance-history?userId=${box.read(TxtConstant.user_id)}&pagesize=0&pagerows=3";
    try{
      http.Response response = await http.get(Uri.parse(uri),headers: {
        'Accept': '*/*',
        // // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ${box.read(TxtConstant.accesstoken)}',
      });

      print("in getClearanceHistory service || ${response.statusCode}");
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