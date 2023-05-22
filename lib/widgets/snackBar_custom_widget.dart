import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/uiconstants.dart';

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
              Radius.circular(10),
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 28,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.red : Colors.red.shade800,
                  ),
                  Text(
                    title,
                    style: UIConstant.minititle,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                txt,
                style: UIConstant.normal,
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 15,
            right:  15,
            bottom:  position ? deviceHeight- (140) : 40,
            // bottom: deviceHeight - (oneUnitHeight * 130),
          ),
        )
    );
  }
}