class ClearanceHistoryModel{
  String? bikerClearanceId;
  DateTime? date;
  String? bikerId;
  String? bikerName;
  String? levelName;
  num? totalOrderQty;
  num? totalDistanceMeter;
  num? totalCashCollect;
  num? transferAmt;
  num? creditAmt;
  num? miscusage;
  String? paymentType;
  String? employeeId;
  String? employeeName;
  num? areaId;
  String? areaName;
  num? zoneId;
  String? zoneName;
  String? remark;

  ClearanceHistoryModel({
    required this.bikerClearanceId,
    required this.date,
    required this.bikerId,
    required this.bikerName,
    required this.levelName,
    required this.totalOrderQty,
    required this.totalDistanceMeter,
    required this.totalCashCollect,
    required this.transferAmt,
    required this.creditAmt,
    required this.miscusage,
    required this.areaName,
    required this.areaId,
    required this.zoneId,
    required this.zoneName,
    required this.paymentType,
    required this.employeeId,
    required this.employeeName,
    required this.remark,
  });

  ClearanceHistoryModel.fromJson(Map<String,dynamic>json){
    bikerClearanceId = json["bikerClearanceId"];
    date = DateTime.parse(json["date"]);
    bikerId = json["bikerId"];
    bikerName = json["bikerName"];
    levelName = json["levelName"];
    totalOrderQty = json["totalOrderQty"];
    totalDistanceMeter = json["totalDistanceMeter"];
    totalCashCollect = json["totalCashCollect"];
    transferAmt = json["transferAmt"];
    creditAmt = json["creditAmt"];
    miscusage = json["miscusage"];
    paymentType = json["paymentType"];
    employeeId = json["employeeId"];
    employeeName = json["employeeName"];
    areaId = json["areaId"];
    areaName = json["areaName"];
    zoneId = json["zoneId"];
    zoneName = json["zoneName"];
    remark = json["remark"];
  }
}