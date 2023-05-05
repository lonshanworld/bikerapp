import 'package:delivery/constants/uiconstants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';


class ScheduleWidget extends StatelessWidget {

  final String scheduleName;
  final DateTime scheduleId;
  final String startSchedule;
  final String endSchedule;

  const ScheduleWidget({
    Key? key,
    required this.scheduleName,
    required this.scheduleId,
    required this.startSchedule,
    required this.endSchedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 2.h,
        vertical: 2.h,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 1.5.h,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(2.h),
          ),
          color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            scheduleName.toString(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat("dd, MMM").format(scheduleId),
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: UIConstant.orange,
                    ),
                  ),
                  Text(
                    DateFormat("E").format(scheduleId),
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Center(
                    child: Text(
                      startSchedule,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                       ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "~",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                     ),
                    ),
                  ),
                  Center(
                    child: Text(
                      endSchedule,
                      style: TextStyle(
                          fontSize: 14.sp ,
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
