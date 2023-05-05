
import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";
import "package:sizer/sizer.dart";

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
      padding: EdgeInsets.all(2.h),
      margin: EdgeInsets.symmetric(
        vertical: 1.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(1.h),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(hasMoreShop)Text(
            orderItem.shopName!,
            style: TextStyle(
              fontSize: 12.sp,
              color: UIConstant.orange,
            ),
          ),
          if(hasMoreShop)SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${orderItem.itemName}  x  ${orderItem.qty}",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${orderItem.onlinePrice} MMK",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if(orderItem.orderChoices!.isNotEmpty)SizedBox(
            height: 1.h,
          ),
          if(orderItem.orderChoices!.isNotEmpty) Wrap(
            children: [
              for(OrderChoice _orderChoice in orderItem.orderChoices!) Text(
                "${_orderChoice.citemName}, ",
                style: TextStyle(
                  fontSize: 10.sp,
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
