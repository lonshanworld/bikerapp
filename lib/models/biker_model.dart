class BikerModel{
  String? userId;
  String? userName;
  DateTime? joinDate;
  String? fullName;
  String? email;
  String? phone;
  String? nrc;
  String? level;
  String? profileImage;
  num? areaId;
  String? areaName;
  num? zoneId;
  String? zoneName;
  num? basicSalary;
  num? allowance;
  num? miscUsage;
  num? deposit;
  bool? permenant;
  String? note;
  num? cashCollect;
  bool? status;
  num? creditAmt;

  BikerModel({
    required this.userId,
    required this.userName,
    required this.joinDate,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.nrc,
    required this.level,
    required this.permenant,
    required this.profileImage,
    required this.status,
    required this.miscUsage,
    required this.allowance,
    required this.areaId,
    required this.areaName,
    required this.basicSalary,
    required this.cashCollect,
    required this.deposit,
    required this.note,
    required this.zoneId,
    required this.zoneName,
    required this.creditAmt,
  });

  BikerModel.fromjson(Map<String,dynamic> json){
    userId = json["userId"];
    userName = json["userName"];
    joinDate = DateTime.parse(json["joinDate"]);
    fullName = json["fullName"];
    email = json["email"];
    phone = json["phone"];
    nrc = json["nrc"];
    level = json["level"];
    permenant = json["permenant"];
    profileImage = json["profileImage"];
    status = json["status"];
    miscUsage = json["miscUsage"];
    allowance = json["allowance"];
    areaId = json["areaId"];
    areaName = json["areaName"];
    basicSalary = json["basicSalary"];
    cashCollect = json["cashCollect"];
    deposit = json["deposit"];
    note = json["note"];
    zoneId = json["zoneId"];
    zoneName = json["zoneName"];
    creditAmt = json["creditAmt"];
  }
}