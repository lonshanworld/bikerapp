import 'package:delivery/models/time_model.dart';

class ScheduleModel{
  String? scheduleDetailId;
  DateTime? scheduleId;
  String? scheduleName;
  String? startSchedule;
  String? endSchedule;

  ScheduleModel({
    required this.scheduleDetailId,
    required this.scheduleId,
    required this.scheduleName,
    required this.startSchedule,
    required this.endSchedule,
  });

  ScheduleModel.fromJson(Map<String,dynamic>? json){
    if(json != null){
      scheduleDetailId = json["scheduleDetailId"];
      scheduleId = DateTime.parse(json["scheduleId"]);
      scheduleName = json["scheduleName"];
      startSchedule = TimeModel().dateTime(json["startSchedule"]);
      endSchedule = TimeModel().dateTime(json["endSchedule"]);
    }
  }
}