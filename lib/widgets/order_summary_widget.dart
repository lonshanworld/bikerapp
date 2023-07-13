import "package:delivery/models/order_model.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "../constants/uiconstants.dart";
import "../utils/change_num_format.dart";

class OrderSummaryWidget extends StatelessWidget {

  final OrderDetailModel orderDetailModel;
  const OrderSummaryWidget({
    super.key,
    required this.orderDetailModel,
  });

  @override
  Widget build(BuildContext context) {

    Widget pricerowitem({required String name, required num price}){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: UIConstant.normal,
          ),
          Text(
            "${changeNumberFormat(price)} ${"mmk".tr}",
            style: UIConstant.normal.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? UIConstant.bgDark
            : UIConstant.bgWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "${"order".tr} ${"total".tr}",
          //       style: UIConstant.normal,
          //     ),
          //     Text(
          //       "${_orderDetailModel.totalOnlinePrice} ${"mmk".tr}",
          //       style: UIConstant.normal.copyWith(
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ],
          // ),
          pricerowitem(name: "${"order".tr} ${"total".tr}", price: orderDetailModel.totalPrice!),
          SizedBox(
            height: 10,
          ),
          pricerowitem(name: "Discount", price: orderDetailModel.discountAmount!),
          SizedBox(
            height: 10,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "cashcollected".tr,
          //       style: UIConstant.normal,
          //     ),
          //     Text(
          //       "${_orderDetailModel.totalOnlinePrice! + _orderDetailModel.deliCharges!} ${"mmk".tr}",
          //       style: UIConstant.normal.copyWith(
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ],
          // ),
          pricerowitem(name: "Net Total", price: orderDetailModel.totalOnlinePrice!),
          SizedBox(
            height: 10,
          ),
          pricerowitem(name: "Container Charges", price: orderDetailModel.containerCharges!),
          SizedBox(
            height: 10,
          ),
          if(orderDetailModel.paymentType?.toLowerCase() == "credit")pricerowitem(
            name: "Credit Charges",
            price: orderDetailModel.creditCharges!,
          ),
          if(orderDetailModel.paymentType?.toLowerCase() == "credit")SizedBox(
            height: 10,
          ),
          if(orderDetailModel.promotAmt! > 0 )pricerowitem(
            name: "Promo Amt",
            price: orderDetailModel.promotAmt!,
          ),
          if(orderDetailModel.promotAmt! > 0 )SizedBox(
            height: 10,
          ),
          pricerowitem(name: "vat".tr, price: orderDetailModel.tax!),
          SizedBox(
            height: 10,
          ),
          pricerowitem(name: "Delivery Charges", price: orderDetailModel.deliCharges!),
          SizedBox(
            height: 10,
          ),
          if(orderDetailModel.tipsMoney! > 0 )pricerowitem(
            name: "Sub Total",
            price: orderDetailModel.subTotal!,
          ),
          if(orderDetailModel.tipsMoney! > 0 )SizedBox(
            height: 10,
          ),
          if(orderDetailModel.tipsMoney! > 0 )pricerowitem(
            name: "Tips",
            price: orderDetailModel.tipsMoney!,
          ),
          if(orderDetailModel.tipsMoney! > 0 )SizedBox(
            height: 10,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "vat".tr,
          //       style: UIConstant.normal,
          //     ),
          //     Text(
          //       "${_orderDetailModel.tax} ${"mmk".tr}",
          //       style: UIConstant.normal.copyWith(
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ],
          // ),
          pricerowitem(name: "Total", price: orderDetailModel.grandTotal!),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment Type",
                  style: UIConstant.small.copyWith(
                      color: Colors.grey
                  ),
                ),
                Text(
                  orderDetailModel.paymentType!,
                  style: UIConstant.small.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cash to collect",
                  style: UIConstant.minititle,
                ),
                Text(
                  "${orderDetailModel.paymentType!.toLowerCase() == "cash" ? changeNumberFormat(orderDetailModel.grandTotal!) : 0} ${"mmk".tr}",
                  style: UIConstant.minititle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
