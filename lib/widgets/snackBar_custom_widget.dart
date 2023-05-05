import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/uiconstants.dart';
import 'package:sizer/sizer.dart';

class CustomGlobalSnackbar{
  final String title;
  final String txt;
  final IconData icon;
  final bool position;

  CustomGlobalSnackbar({
    required this.title,
    required this.txt,
    required this.icon,
    required this.position,
  });

  static show({
    required BuildContext context,
    required String title,
    required String txt,
    required IconData icon,
    required bool position,
    int? duration,
  }){
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: duration ?? 3),
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? UIConstant.pink : UIConstant.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1.h),
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 20.sp,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.red : Colors.white,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize:13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                txt,
                style: TextStyle(
                    fontSize: 11.sp,
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 2.h,
            right:  2.h,
            bottom:  position ? deviceHeight- (13.h) : 5.h,
            // bottom: deviceHeight - (oneUnitHeight * 130),
          ),
        )
    );
  }
}