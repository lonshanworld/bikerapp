import 'dart:convert';

import 'package:delivery/models/clearance_history_model.dart';
import 'package:delivery/services/clearance_service.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import '../models/clearance_model.dart';

class ClearanceController extends GetxController{
  final ClearanceService service = ClearanceService();

  Future<ClearanceModel> getClearance()async{
    http.Response response = await service.getClearance();
    final data = json.decode(response.body);
    ClearanceModel clearanceModel = ClearanceModel.fromJson(data["data"]);
    return clearanceModel;
  }

  Future<List<ClearanceHistoryModel>> getClearanceHistory()async{
    http.Response response = await service.getClearanceHistory();
    final data = json.decode(response.body);
    List<ClearanceHistoryModel> datalist = [];

    if(data["data"] != null || data["data"] != []){
      // data["data"].foreach((e){
      //   datalist.add(ClearanceHistoryModel.fromJson(e));
      // });
      for(int a = 0 ; a < data["data"].length; a++){
        datalist.add(data["data"][a]);
      }
    }

    datalist.sort((a,b) => a.date!.compareTo(b.date!));
    return datalist;
  }
}