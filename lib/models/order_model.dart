class OrderDetailModel{
  String? orderId;
  String? refNo;
  DateTime? orderDate;
  bool? preOrder;
  String? orderType;
  String? orderComment;
  String? shopName;
  String? image;
  String? cusId;
  String? cusName;
  num? shoplat;
  num? shoplong;
  num? cuslat;
  num? cuslong;
  String? cusAddress;
  String? addressNote;
  String? shopAddress;
  String? phone;
  String? email;
  num? distanceMeter;
  int? itemQty;
  num? totalContractPrice;
  num? totalPrice;
  num? discountAmount;
  num? containerCharges;
  num? totalOnlinePrice;
  num? deliCharges;
  num? creditCharges;
  num? promotAmt;
  String? promoCode;
  num? tax;
  num? subTotal;
  num? tipsMoney;
  num? grandTotal;
  String? orderStatus;
  num? bikerFees;
  List<OrderItem>? orderItems;
  String? paymentType;

  OrderDetailModel({
    required this.orderId,
    required this.refNo,
    required this.orderDate,
    required this.shopName,
    required this.image,
    required this.cusId,
    required this.cusName,
    required this.shoplat,
    required this.shoplong,
    required this.cuslat,
    required this.cuslong,
    required this.cusAddress,
    required this.shopAddress,
    required this.addressNote,
    required this.phone,
    required this.email,
    required this.distanceMeter,
    required this.itemQty,
    required this.totalContractPrice,
    required this.totalPrice,
    required this.discountAmount,
    required this.totalOnlinePrice,
    required this.deliCharges,
    required this.creditCharges,
    required this.promotAmt,
    required this.promoCode,
    required this.tax,
    required this.tipsMoney,
    required this.grandTotal,
    required this.orderStatus,
    required this.bikerFees,
    required this.containerCharges,
    required this.orderComment,
    required this.orderType,
    required this.preOrder,
    required this.subTotal,
    required this.orderItems,
    required this.paymentType,
  });
}



class OrderItem{
  String? orderId;
  String? itemId;
  String? itemName;
  String? uniqueId;
  String? shopId;
  String? shopName;
  String? image;
  int? qty;
  num? contractPrice;
  num? price;
  num? onlinePrice;
  String? specialRequest;
  List<OrderChoice>? orderChoices;
  bool? shopConfirm;
  bool? pickupFlag;

  OrderItem({
    required this.orderId,
    required this.itemId,
    required this.itemName,
    required this.uniqueId,
    required this.shopId,
    required this.shopName,
    required this.image,
    required this.qty,
    required this.contractPrice,
    required this.price,
    required this.onlinePrice,
    required this.specialRequest,
    required this.orderChoices,
    required this.shopConfirm,
    required this.pickupFlag,
  });
}

class OrderChoice{

  int? citemId;
  String? citemName;
  num? contractPrice;
  num? price;
  num? onlinePrice;

  OrderChoice({
    required this.citemId,
    required this.citemName,
    required this.onlinePrice,
    required this.price,
    required this.contractPrice,
  });
}