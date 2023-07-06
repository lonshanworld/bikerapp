import 'dart:convert';

import 'package:delivery/constants/txtconstants.dart';
import 'package:delivery/error_handlers/error_handlers.dart';
import 'package:get_storage/get_storage.dart';
import "dart:io";
import "package:http/http.dart" as http;

class CheckInOutService{
  final box = GetStorage();
  final ErrorHandler errorHandler = ErrorHandler();


  Future checkIn(File image)async{
    String uri = "${TxtConstant.mainUrl}schedules/check-in";

    try{
      var request = http.MultipartRequest('POST', Uri.parse(uri));
      request.headers["Authorization"] = "Bearer ${box.read(TxtConstant.accesstoken)}";
      request.headers["Accept"] = "application/json";
      http.MultipartFile multipartFile =
      await http.MultipartFile.fromPath('image', image.path);
      request.files.add(multipartFile);

      var res = await request.send();
      // var response = await res.stream.bytesToString();
      // print(response);
      // if(res.statusCode > 299){
      //   throw errorHandler.handleUnknownError("Unknown Error");
      // }
      // return res;

      // http.Response response = await http.post(Uri.parse(uri),headers: {
      //   'Accept': 'application/json',
      //   "Authorization" : "bearer ${box.read(TxtConstant.accesstoken)}",
      // },body: json.encode(forbody));
      // print("in getcheckin service || ${response.statusCode}");
      // print(response.body);
      // if(response.statusCode > 299){
      //   throw errorHandler.handleError(response);
      // }
      // return response;
      return res;

    }on Exception catch(err){
      errorHandler.handleUnknownError(err.toString());
    }
  }

  Future checkOut(String date)async{
    String uri = "${TxtConstant.mainUrl}schedules/check-out?scheduledate=$date";
    // String uri = "${TxtConstant.mainUrl}schedules/check-out";
    try{
      http.Response response = await http.post(Uri.parse(uri),headers: {
        'Accept': 'application/json',
        "Authorization" : "bearer ${box.read(TxtConstant.accesstoken)}",
      });
      print("in checkout service || ${response.statusCode}");
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