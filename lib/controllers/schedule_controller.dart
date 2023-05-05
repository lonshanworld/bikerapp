import 'dart:convert';

import 'package:delivery/services/schedule_service.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import '../models/schedule_model.dart';

class ScheduleController extends GetxController{
  final ScheduleService service = ScheduleService();

  final RxList<ScheduleModel> availableScheduleList = List<ScheduleModel>.empty().obs;
  final RxList<ScheduleModel> nextScheduleList = List<ScheduleModel>.empty().obs;

  Future<void> getAvailableScheduleList()async{
    http.Response response = await service.getSchedule(false);
    final data = json.decode(response.body);

    List<ScheduleModel> datalist = [];
    data["data"].forEach((e){
      datalist.add(ScheduleModel.fromJson(e));
    });
    datalist.sort((a,b) => a.scheduleId!.compareTo(b.scheduleId!));
    availableScheduleList.assignAll(datalist.map((e) => e).toList());
  }

  Future<void> getNextScheduleList()async{
    http.Response response = await service.getSchedule(true);
    final data = json.decode(response.body);

    List<ScheduleModel> datalist = [];
    data["data"].forEach((e){
      datalist.add(ScheduleModel.fromJson(e));
    });
    datalist.sort((a,b) => a.scheduleId!.compareTo(b.scheduleId!));
    nextScheduleList.assignAll(datalist.map((e) => e).toList());
  }


  Future<void> scheduleReload()async{
    await getNextScheduleList();
    await getAvailableScheduleList();
  }

}
