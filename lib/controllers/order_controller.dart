import 'dart:convert';

import 'package:delivery/services/order_service.dart';
import 'package:delivery/views/loading_screen.dart';
import 'package:delivery/widgets/snackBar_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import '../models/order_model.dart';

class OrderController extends GetxController{
  final OrderService service = OrderService();

  final RxList<OrderDetailModel> currentorderList = List<OrderDetailModel>.empty().obs;

  Future getCurrentOrderList()async{
    http.Response response = await service.getCurrentOrder();
    var rawdata = json.decode(response.body);
    print("Inside currentorderlist controller");
    print(rawdata);

    List<OrderDetailModel> orderDetailModelList = [];
    if(rawdata !=false){
      dynamic info = rawdata["data"];

      for(int e = 0 ; e < info.length; e++){
        dynamic data = info[e];
        List<OrderChoice> _orderChoices = [];
        if( data["orderChoices"] != null &&  data["orderChoices"] != [] && data["orderChoices"] != "null"){
          for(int a = 0; a < data["orderChoices"].length; a++){
            OrderChoice _neworderChoice = OrderChoice(
              itemId: data["orderChoices"][a]["itemId"].toString(),
              citemId: data["orderChoices"][a]["citemid"],
              citemName: data["orderChoices"][a]["citemName"],
              orderId: data["orderChoices"][a]["orderId"],
              uniqueId: data["orderChoices"][a]["uniqueId"],
              onlinePrice: data["orderChoices"][a]["onlinePrice"],
              price: data["orderChoices"][a]["price"],
              contractPrice: data["orderChoices"][a]["contractPrice"],
            );
            _orderChoices.add(_neworderChoice);
          }
        }else{
          print("This is null in order choices");
        }

        List<OrderItem> _orderItems = [];
        if(data["orderItems"] != null && data["orderItems"] != [] && data["orderItems"] != "null"){
          for(int b = 0; b < data["orderItems"].length; b++){

            List<OrderChoice> _choicesforsingleItem = [];
            dynamic _uniqueId = json.decode(data["orderItems"][b]["uniqueId"]) == 0 ? [] : json.decode(data["orderItems"][b]["uniqueId"]);
            for(int c = 0; c < _orderChoices.length; c++){
              int? _citemid = _orderChoices[c].citemId;
              String? _itemid = _orderChoices[c].itemId;
              if(_uniqueId.contains(_citemid) && data["orderItems"][b]["itemId"] == _itemid){
                _choicesforsingleItem.add(_orderChoices[c]);
              }
            }
            OrderItem _neworderItem = OrderItem(
              orderId: data["orderItems"][b]["orderId"],
              itemId: data["orderItems"][b]["itemId"],
              itemName: data["orderItems"][b]["itemName"],
              uniqueId: data["orderItems"][b]["uniqueId"],
              shopId: data["orderItems"][b]["shopId"],
              shopName: data["orderItems"][b]["shopName"],
              image: data["orderItems"][b]["image"],
              qty: data["orderItems"][b]["qty"],
              contractPrice: data["orderItems"][b]["contractPrice"],
              price: data["orderItems"][b]["price"],
              onlinePrice: data["orderItems"][b]["onlinePrice"],
              specialRequest: data["orderItems"][b]["specialRequest"],
              orderChoices: _choicesforsingleItem,
              pickupFlag: data["orderItems"][b]["pickupFlag"],
              shopConfirm:  data["orderItems"][b]["shopConfirm"],
            );

            _orderItems.add(_neworderItem);
          }
        }

        OrderDetailModel orderDetailModel = OrderDetailModel(
          orderId: data["orderId"],
          refNo: "${data["refNo"]}",
          orderDate: DateTime.parse(data["orderDate"]),
          shopName: data["shopName"],
          image: data["shopImage"] ?? "https://media.istockphoto.com/id/517188688/photo/mountain-landscape.jpg?s=1024x1024&w=is&k=20&c=MB1-O5fjps0hVPd97fMIiEaisPMEn4XqVvQoJFKLRrQ=",
          cusId: data["cusId"],
          cusName: data["cusName"],
          cuslat: data["lat"],
          cuslong: data["long"],
          cusAddress: data["detailAddress"],
          shopAddress: data["shopAddress"] ?? "",
          shoplat:data["sourceLat"],
          shoplong: data["sourceLong"],
          addressNote: data["addressNote"],
          phone: data["phone"],
          email: data["email"],
          distanceMeter: data["distanceMeter"],
          itemQty: data["itemQty"],
          totalContractPrice: data["totalContractPrice"],
          totalPrice: data["totalPrice"],
          discountAmount: data["discountAmt"],
          totalOnlinePrice: data["totalOnlinePrice"],
          deliCharges:  data["deliCharges"],
          creditCharges: data["creditCharges"],
          promotAmt: data["promotAmt"],
          promoCode: data["promoCode"],
          tax: data["tax"],
          tipsMoney: data["tipsMoney"],
          grandTotal: data["grandTotal"],
          orderStatus: data["orderStatus"],
          bikerFees: data["bikerFees"] ?? 0,
          orderItems: _orderItems,
          containerCharges: data["containerCharges"],
          orderComment: data["orderComment"],
          orderType: data["orderType"],
          preOrder: data["preOrder"],
          subTotal: data["subTotal"],
          paymentType: data["paymentType"],
        );

        orderDetailModelList.add(orderDetailModel);
      }
    }
    orderDetailModelList.sort((a,b) => b.orderDate!.compareTo(a.orderDate!));
    currentorderList.assignAll(orderDetailModelList.map((e) => e).toList());

    return orderDetailModelList;
  }


  Future<OrderDetailModel> getSingleOrderDetail(String orderId)async{
    http.Response response = await service.getSingleOrderDetail(orderId);
    var rawdata = json.decode(response.body);
    var data = rawdata["data"];
    List<OrderChoice> _orderChoices = [];
    // print(data["orderChoices"]);
    if( data["orderChoices"] != [] && data["orderChoices"] != null && data["orderChoices"] == "null"){
      for(int a = 0; a < data["orderChoices"].length; a++){
        OrderChoice _neworderChoice = OrderChoice(
          itemId: data["orderChoices"][a]["itemId"].toString(),
          citemId: data["orderChoices"][a]["citemid"],
          citemName: data["orderChoices"][a]["citemName"],
          orderId: data["orderChoices"][a]["orderId"],
          uniqueId: data["orderChoices"][a]["uniqueId"],
          onlinePrice: data["orderChoices"][a]["onlinePrice"],
          price: data["orderChoices"][a]["price"],
          contractPrice: data["orderChoices"][a]["contractPrice"],
        );
        _orderChoices.add(_neworderChoice);
      }
    }

    List<OrderItem> _orderItems = [];
    if(data["orderItems"] != [] && data["orderItems"] != null && data["orderItems"] != "null"){
      for(int b = 0; b < data["orderItems"].length; b++){

        List<OrderChoice> _choicesforsingleItem = [];
        dynamic _uniqueId = json.decode(data["orderItems"][b]["uniqueId"]) == 0 ? [] : json.decode(data["orderItems"][b]["uniqueId"]);
        for(int c = 0; c < _orderChoices.length; c++){
          int? _citemid = _orderChoices[c].citemId;
          String? _itemid = _orderChoices[c].itemId;
          if(_uniqueId.contains(_citemid) && data["orderItems"][b]["itemId"] == _itemid){
            _choicesforsingleItem.add(_orderChoices[c]);
          }
        }
        OrderItem _neworderItem = OrderItem(
          orderId: data["orderItems"][b]["orderId"],
          itemId: data["orderItems"][b]["itemId"],
          itemName: data["orderItems"][b]["itemName"],
          uniqueId: data["orderItems"][b]["uniqueId"],
          shopId: data["orderItems"][b]["shopId"],
          shopName: data["orderItems"][b]["shopName"],
          image: data["orderItems"][b]["image"],
          qty: data["orderItems"][b]["qty"],
          contractPrice: data["orderItems"][b]["contractPrice"],
          price: data["orderItems"][b]["price"],
          onlinePrice: data["orderItems"][b]["onlinePrice"],
          specialRequest: data["orderItems"][b]["specialRequest"],
          orderChoices: _choicesforsingleItem,
          pickupFlag: data["orderItems"][b]["pickupFlag"],
          shopConfirm:  data["orderItems"][b]["shopConfirm"],
        );

        _orderItems.add(_neworderItem);
      }
    }

    OrderDetailModel orderDetailModel = OrderDetailModel(
      orderId: data["orderId"],
      refNo: "${data["refNo"]}",
      orderDate: DateTime.parse(data["orderDate"]),
      shopName: data["shopName"],
      image: data["shopImage"] ?? "https://media.istockphoto.com/id/517188688/photo/mountain-landscape.jpg?s=1024x1024&w=is&k=20&c=MB1-O5fjps0hVPd97fMIiEaisPMEn4XqVvQoJFKLRrQ=",
      cusId: data["cusId"],
      cusName: data["cusName"],
      cuslat: data["lat"],
      cuslong: data["long"],
      cusAddress: data["detailAddress"],
      shopAddress: data["shopAddress"] ?? "",
      shoplat:data["sourceLat"],
      shoplong: data["sourceLong"],
      addressNote: data["addressNote"],
      phone: data["phone"],
      email: data["email"],
      distanceMeter: data["distanceMeter"],
      itemQty: data["itemQty"],
      totalContractPrice: data["totalContractPrice"],
      totalPrice: data["totalPrice"],
      discountAmount: data["discountAmt"],
      totalOnlinePrice: data["totalOnlinePrice"],
      deliCharges:  data["deliCharges"],
      creditCharges: data["creditCharges"],
      promotAmt: data["promotAmt"],
      promoCode: data["promoCode"],
      tax: data["tax"],
      tipsMoney: data["tipsMoney"],
      grandTotal: data["grandTotal"],
      orderStatus: data["orderStatus"],
      bikerFees: data["bikerFees"] ?? 0,
      orderItems: _orderItems,
      containerCharges: data["containerCharges"],
      orderComment: data["orderComment"],
      orderType: data["orderType"],
      preOrder: data["preOrder"],
      subTotal: data["subTotal"],
      paymentType: data["paymentType"],
    );
    return orderDetailModel;
  }


  Future<List<OrderDetailModel>> getOrderHistoryList()async{
    http.Response response = await service.getAllOrderHistory();
    var rawdata = json.decode(response.body);
    print("Inside orderhistory controller");
    print(rawdata);

    List<OrderDetailModel> orderDetailModelList = [];
    if(rawdata !=false){
      dynamic info = rawdata["data"];

      for(int e = 0 ; e < info.length; e++){
        dynamic data = info[e];
        List<OrderChoice> _orderChoices = [];

        if( data["orderChoices"] != null &&  data["orderChoices"] != [] && data["orderChoices"] != "null"){
          for(int a = 0; a < data["orderChoices"].length; a++){
            OrderChoice _neworderChoice = OrderChoice(
              itemId: data["orderChoices"][a]["itemId"].toString(),
              citemId: data["orderChoices"][a]["citemid"],
              citemName: data["orderChoices"][a]["citemName"],
              orderId: data["orderChoices"][a]["orderId"],
              uniqueId: data["orderChoices"][a]["uniqueId"],
              onlinePrice: data["orderChoices"][a]["onlinePrice"],
              price: data["orderChoices"][a]["price"],
              contractPrice: data["orderChoices"][a]["contractPrice"],
            );
            _orderChoices.add(_neworderChoice);
          }
        }

        List<OrderItem> _orderItems = [];
        if(data["orderItems"] != null && data["orderItems"] != [] && data["orderItems"] != "null"){
          for(int b = 0; b < data["orderItems"].length; b++){

            List<OrderChoice> _choicesforsingleItem = [];
            dynamic _uniqueId = json.decode(data["orderItems"][b]["uniqueId"]) == 0 ? [] : json.decode(data["orderItems"][b]["uniqueId"]);
            for(int c = 0; c < _orderChoices.length; c++){
              int? _citemid = _orderChoices[c].citemId;
              String? _itemid = _orderChoices[c].itemId;
              if(_uniqueId.contains(_citemid) && data["orderItems"][b]["itemId"] == _itemid){
                _choicesforsingleItem.add(_orderChoices[c]);
              }
            }
            OrderItem _neworderItem = OrderItem(
              orderId: data["orderItems"][b]["orderId"],
              itemId: data["orderItems"][b]["itemId"],
              itemName: data["orderItems"][b]["itemName"],
              uniqueId: data["orderItems"][b]["uniqueId"],
              shopId: data["orderItems"][b]["shopId"],
              shopName: data["orderItems"][b]["shopName"],
              image: data["orderItems"][b]["image"],
              qty: data["orderItems"][b]["qty"],
              contractPrice: data["orderItems"][b]["contractPrice"],
              price: data["orderItems"][b]["price"],
              onlinePrice: data["orderItems"][b]["onlinePrice"],
              specialRequest: data["orderItems"][b]["specialRequest"],
              orderChoices: _choicesforsingleItem,
              pickupFlag: data["orderItems"][b]["pickupFlag"],
              shopConfirm:  data["orderItems"][b]["shopConfirm"],
            );

            _orderItems.add(_neworderItem);
          }
        }

        OrderDetailModel orderDetailModel = OrderDetailModel(
          orderId: data["orderId"],
          refNo: "${data["refNo"]}",
          orderDate: DateTime.parse(data["orderDate"]),
          shopName: data["shopName"],
          image: data["shopImage"] ?? "https://media.istockphoto.com/id/517188688/photo/mountain-landscape.jpg?s=1024x1024&w=is&k=20&c=MB1-O5fjps0hVPd97fMIiEaisPMEn4XqVvQoJFKLRrQ=",
          cusId: data["cusId"],
          cusName: data["cusName"],
          cuslat: data["lat"],
          cuslong: data["long"],
          cusAddress: data["detailAddress"],
          shopAddress: data["shopAddress"] ?? "",
          shoplat:data["sourceLat"],
          shoplong: data["sourceLong"],
          addressNote: data["addressNote"],
          phone: data["phone"],
          email: data["email"],
          distanceMeter: data["distanceMeter"],
          itemQty: data["itemQty"],
          totalContractPrice: data["totalContractPrice"],
          totalPrice: data["totalPrice"],
          discountAmount: data["discountAmt"],
          totalOnlinePrice: data["totalOnlinePrice"],
          deliCharges:  data["deliCharges"],
          creditCharges: data["creditCharges"],
          promotAmt: data["promotAmt"],
          promoCode: data["promoCode"],
          tax: data["tax"],
          tipsMoney: data["tipsMoney"],
          grandTotal: data["grandTotal"],
          orderStatus: data["orderStatus"],
          bikerFees: data["bikerFees"] ?? 0,
          orderItems: _orderItems,
          containerCharges: data["containerCharges"],
          orderComment: data["orderComment"],
          orderType: data["orderType"],
          preOrder: data["preOrder"],
          subTotal: data["subTotal"],
          paymentType: data["paymentType"],
        );

        orderDetailModelList.add(orderDetailModel);
      }
    }
    orderDetailModelList.sort((a,b) => b.orderDate!.compareTo(a.orderDate!));
    return orderDetailModelList;
  }


  Future<void> acceptOrder(String orderId)async{
    http.Response response = await service.OrderBikerAccept(orderId);
    if(response.statusCode <299){
      CustomGlobalSnackbar.show(
        context: Get.context!,
        title: "Order Accept",
        txt: "Thanks for accepting order.",
        icon: Icons.emoji_emotions_outlined,
        position: true,
      );
    }
  }

  Future<void>bikerPickup(String orderId)async{
    Get.dialog(LoadingScreen(), barrierDismissible: false);
    await service.bikerPickUp(orderId);
    Get.back();
  }

  Future<void> bikerDropOff(String orderId) async{
    http.Response response = await service.bikerDropOff(orderId);
    if(response.statusCode < 299){
      CustomGlobalSnackbar.show(
        context: Get.context!,
        title: "Order Accept",
        txt: "Thanks for accepting order.",
        icon: Icons.emoji_emotions_outlined,
        position: true,
      );
    }else{
      CustomGlobalSnackbar.show(
        context: Get.context!,
        title: "Order cannot accepted",
        txt: "Order cannnot be accepted.  Please try again later.",
        icon: Icons.info_outline,
        position: true,
      );
    }
  }
}