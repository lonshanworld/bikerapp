class PunishmentModel{
  DateTime? date;
  String? orderId;
  String? itemId;
  String? uniqueId;
  String? itemName;
  String? itemNameMm;
  num? originQty;
  num? onlinePrice;
  String? shopId;
  String? shopName;
  num? damageQty;
  num? punishAmount;
  String? supportName;
  DateTime? supportDate;
  String? supportRemark;
  String? statementId;

  PunishmentModel({
    required this.date,
    required this.orderId,
    required this.itemId,
    required this.shopId,
    required this.itemName,
    required this.onlinePrice,
    required this.shopName,
    required this.uniqueId,
    required this.supportRemark,
    required this.supportName,
    required this.statementId,
    required this.punishAmount,
    required this.damageQty,
    required this.itemNameMm,
    required this.originQty,
    required this.supportDate,
  });

  PunishmentModel.fromJson(Map<String,dynamic> json){
    date = DateTime.parse(json["date"]);
    orderId = json["orderId"];
    itemId = json["itemId"];
    uniqueId = json["uniqueId"];
    itemName = json["itemName"];
    itemNameMm = json["itemNameMm"];
    originQty = json["originQty"];
    onlinePrice = json["onlinePrice"];
    shopId = json["shopId"];
    shopName = json["shopName"];
    damageQty = json["damageQty"];
    punishAmount = json["punishAmount"];
    supportName = json["supportName"];
    supportDate = json["supportDate"];
    supportRemark = json["supportRemark"];
    statementId = json["statementId"];
  }
}