
import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${orderItem.itemName}  x  ${orderItem.qty}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${orderItem.onlinePrice} MMK",
                style: TextStyle(
                  fontSize: 12,
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
                  fontSize: 10,
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
