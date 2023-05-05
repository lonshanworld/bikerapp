import "package:delivery/widgets/customButton_widget.dart";
import "package:flutter/material.dart";
import "package:sizer/sizer.dart";


import "../constants/uiconstants.dart";

class ConfirmAll_Screen extends StatelessWidget {

  final String title;
  final String txt;
  final VoidCallback acceptFun;
  final VoidCallback refuseFun;

  const ConfirmAll_Screen({
    Key? key,
    required this.title,
    required this.txt,
    required this.acceptFun,
    required this.refuseFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.h),
          side: BorderSide(
            color: UIConstant.orange,
          )
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        txt,
        style: TextStyle(
          fontSize: 12.sp,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              verticalPadding: 1.h,
              horizontalPadding: 4.h,
              txt: "Cancel",
              func: refuseFun,
              txtClr:  Colors.black,
              bgClr: UIConstant.pink,
              txtsize: 12.sp,
              rad: 1.h,
            ),
            CustomButton(
              verticalPadding:1.h,
              horizontalPadding:4.h,
              txt: "Yes",
              func: acceptFun,
              txtClr: Colors.white,
              bgClr: UIConstant.orange,
              txtsize: 12.sp,
              rad: 1.h,
            ),
          ],
        ),
      ],
    );
  }
}
