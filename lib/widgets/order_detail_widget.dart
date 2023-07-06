
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/utils/change_num_format.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../models/order_model.dart";

class OrderDetailWidget extends StatelessWidget {

  final OrderItem orderItem;
  final bool hasMoreShop;

  OrderDetailWidget({
    required this.orderItem,
    required this.hasMoreShop,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(hasMoreShop)Text(
            orderItem.shopName!,
            style: TextStyle(
              fontSize: 14,
              color: UIConstant.orange,
            ),
          ),
          if(hasMoreShop)SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${orderItem.itemName}  x  ${orderItem.qty}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "${changeNumberFormat(orderItem.onlinePrice!)} ${"mmk".tr}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if(orderItem.orderChoices!.isNotEmpty)SizedBox(
            height: 10,
          ),
          if(orderItem.orderChoices!.isNotEmpty) Wrap(
            children: [
              for(OrderChoice _orderChoice in orderItem.orderChoices!) Text(
                "${_orderChoice.citemName}, ",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
