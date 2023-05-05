
import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";
import "package:sizer/sizer.dart";

class QrShopWidget extends StatelessWidget {

  final String name;
  final bool pickUp;

  const QrShopWidget({
    Key? key,
    required this.name,
    required this.pickUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(1.h),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 0.3.h,
              horizontal: 1.h
            ),
            decoration: BoxDecoration(
              color: pickUp ? Colors.green : UIConstant.orange,
              borderRadius: pickUp ? null : BorderRadius.all(
                Radius.circular(1.h),
              ),
              shape: pickUp ? BoxShape.circle : BoxShape.rectangle
            ),
            child: pickUp
                ?
              Icon(
                Icons.check,
                color: Colors.white,
                size: 13.sp,
              )
                :
              Text(
                "Pending ...",
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.white
                ),
              ),
          ),
        ],
      ),
    );
  }
}
