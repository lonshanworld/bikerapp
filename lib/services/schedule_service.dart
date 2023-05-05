import 'dart:io';

import 'package:delivery/constants/txtconstants.dart';
import 'package:delivery/error_handlers/error_handlers.dart';
import 'package:get_storage/get_storage.dart';
import "package:http/http.dart" as http;

class ScheduleService{
  final box = GetStorage();
  final ErrorHandler errorHandler = ErrorHandler();

  Future getSchedule(bool isNext)async{
    String uri = isNext ? "${TxtConstant.mainUrl}schedules/next-schedule"  : "${TxtConstant.mainUrl}schedules/avaliable";
    try{
      http.Response response = await http.get(Uri.parse(uri),headers: {
        'Accept': '*/*',
        // // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ${box.read(TxtConstant.accesstoken)}',
      });

      print("in getschedule service || ${response.statusCode}");
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