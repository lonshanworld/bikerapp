import 'package:flutter/cupertino.dart';

class NotiOrderModel{
  String? title;
  String? body;
  NotiBodyModel? notiBodyModel;
  String? date;
  String? type;
  String? showFlag;

  NotiOrderModel({
    this.title,
    this.body,
    this.notiBodyModel,
    this.showFlag,
    this.date,
    this.type,
  });
}


class NotiBodyModel{
  String? orderTitle;
  String? orderId;
  String? refNo;
  int? earning;
  String? shopName;
  double? lat;
  double? long;
  String? photo;
  double? distanceMeter;
  String? type;

  NotiBodyModel({
    required this.orderTitle,
    required this.orderId,
    required this.refNo,
    required this.earning,
    required this.shopName,
    required this.lat,
    required this.long,
    required this.photo,
    required this.distanceMeter,
    required this.type,
  });


  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = <String,dynamic>{};
    data["orderTitle"] = orderTitle;
    data["orderId"] = orderId;
    data["refNo"] = refNo;
    data["earning"] = earning;
    data["shopName"] = shopName;
    data["lat"] = lat;
    data["long"] = long;
    data["photo"] = photo;
    data["distanceMeter"] = distanceMeter;
    data["type"] = type;

    return data;
  }
}

class RandomNotiModel{
  final String title;
  final String body;
  final String date;

  RandomNotiModel({
    required this.title,
    required this.body,
    required this.date,
  });
}

