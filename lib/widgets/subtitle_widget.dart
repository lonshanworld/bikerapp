import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";
import 'package:sizer/sizer.dart';

class SubTitleWidget extends StatelessWidget {

  final String txt;

  const SubTitleWidget({
    Key? key,
    required this.txt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return Padding(
      padding: EdgeInsets.only(
        left: 2.h,
        top: 2.h,
      ),
      child: Text(
        txt,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
