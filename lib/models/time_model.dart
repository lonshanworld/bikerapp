import 'package:intl/intl.dart';

class TimeModel{
  num? ticks;
  num? days;
  num? hours;
  num? milliseconds;
  num? minutes;
  num? seconds;
  num? totalDays;
  num? totalHours;
  num? totalMilliseconds;
  num? totalMinutes;
  num? totalSeconds;

  TimeModel({
    this.ticks,
    this.days,
    this.hours,
    this.milliseconds,
    this.minutes,
    this.seconds,
    this.totalDays,
    this.totalHours,
    this.totalMilliseconds,
    this.totalMinutes,
    this.totalSeconds,
  });

  String dateTime(Map<String,dynamic>json){
    ticks = json["ticks"];
    days = json["days"];
    hours = json["hours"];
    milliseconds = json["milliseconds"];
    minutes = json["minutes"];
    seconds = json["seconds"];
    totalDays = json["totalDays"];
    totalMinutes = json["totalMinutes"];
    totalMilliseconds = json["totalMilliseconds"];
    totalSeconds = json["totalSeconds"];

    int min = totalMinutes!.toInt() % 60;
    int hr = (totalMinutes!.toInt() / 60).floor();
    String date = "$hr:$min";
    String datetime = DateFormat.jm().format(DateFormat("hh:mm").parse(date));
    return datetime;
  }
}