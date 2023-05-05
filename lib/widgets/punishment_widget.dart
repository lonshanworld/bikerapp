
import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:sizer/sizer.dart";

class PunishmentWidget extends StatelessWidget {

  final String date;
  final String itemname;
  final String shopname;
  final int quantity;
  final double punishmentAmount;
  String? supportname;
  String? supportremark;
  final bool isSatisfied;

  PunishmentWidget({
    Key? key,
    required this.date,
    required this.itemname,
    required this.shopname,
    required this.quantity,
    required this.punishmentAmount,
    required this.isSatisfied,
    this.supportname,
    this.supportremark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final valueFormat = new NumberFormat("#,##0.00", "en_US");
    

    Widget stylingContainer(String name, String txt2, {bool value = false,bool isReverse = false}){
      return Row(
        mainAxisAlignment: isReverse ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text(
              name,
            style: TextStyle(
              color: value ? Colors.grey : isReverse ? UIConstant.orange :Colors.black,
              fontSize: isReverse ? 16.sp : 12.sp,
            ),
          ),
          Text(
              txt2,
            style: TextStyle(
              color: value ? Colors.grey : isReverse ? Colors.black :  UIConstant.orange,
              fontSize: isReverse ? 16.sp : 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 1.h,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
        horizontal: 2.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(1.h),
        ),
        boxShadow: [
          if(isSatisfied)BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 :Colors.grey.shade300,
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0),
          ),
        ],
        border:  Border.all(
          width: isSatisfied ? 0 : 1,
          color: isSatisfied ? Colors.transparent : UIConstant.orange,
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          stylingContainer(
              itemname,
              "   x $quantity",
              value: isSatisfied,
          ),
          Divider(
            height: 3.h,
            color: isSatisfied ? Colors.grey : UIConstant.orange,
            thickness: 1,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  shopname,
                  style: TextStyle(
                    color: isSatisfied ? Colors.grey : Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: isSatisfied ? Colors.grey : Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          stylingContainer(valueFormat.format(punishmentAmount), " MMK", value: isSatisfied,isReverse: true),
          if(supportname != null)Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 24.sp,
                color: isSatisfied ? Colors.grey : UIConstant.orange,
              ),
              SizedBox(
                width: 1.h,
              ),
              Text(
                "${supportname!} :  ",
                style: TextStyle(
                  color: isSatisfied ? Colors.grey : Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Expanded(
                child: Text(
                  supportremark!,
                  style: TextStyle(
                    color: isSatisfied ? Colors.grey : UIConstant.orange,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}