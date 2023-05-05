class ClearanceModel{
  String? userId;
  String? userName;
  num? cod;
  num? online;
  num? codPayment;
  num? onlinePayment;
  String? fullName;
  String? levelName;
  String? bikerClearanceId;
  num? areaId;
  String? areaName;
  num? miscusage;
  num? deposit;
  bool? status;
  bool? activeStatus;

  ClearanceModel({
    required this.userId,
    required this.userName,
    required this.cod,
    required this.online,
    required this.codPayment,
    required this.onlinePayment,
    required this.fullName,
    required this.levelName,
    required this.bikerClearanceId,
    required this.areaId,
    required this.areaName,
    required this.miscusage,
    required this.deposit,
    required this.status,
    required this.activeStatus,
  });

  ClearanceModel.fromJson(Map<String,dynamic>json){
    userId = json["userId"];
    userName = json["userName"];
    cod = json["cod"];
    online = json["online"];
    codPayment = json["codPayment"];
    onlinePayment = json["onlinePayment"];
    fullName = json["fullName"];
    levelName = json["levelName"];
    bikerClearanceId = json["bikerClearanceId"];
    areaId = json["areaId"];
    areaName = json["areaName"];
    miscusage = json["miscusage"];
    deposit = json["deposit"];
    status = json["status"];
    activeStatus = json["activeStatis"];
  }
}