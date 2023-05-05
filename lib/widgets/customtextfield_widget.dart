
import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";
import "package:sizer/sizer.dart";

class CustomTextField extends StatelessWidget {

  final TextEditingController txtcontroller;
  final double txtsize;
  final double verticalpadding;
  final double horizontalpadding;
  final TextInputType textInputType;
  String? hinttxt;

  CustomTextField({
    Key? key,
    required this.txtcontroller,
    required this.txtsize,
    required this.verticalpadding,
    required this.horizontalpadding,
    required this.textInputType,
    this.hinttxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontSize: txtsize,
      ),
      controller: txtcontroller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: UIConstant.orange, width:2),
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: verticalpadding,
          horizontal: horizontalpadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        hintText: hinttxt,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      // cursorColor: appStore.isDarkModeOn ? white : blackColor,
    );
  }
}
