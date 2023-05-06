import 'package:delivery/constants/uiconstants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


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
        horizontal: 15,
        vertical: 15,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
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
            style: UIConstant.minititle,
          ),
          SizedBox(
            height: 3,
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
                    style: UIConstant.title.copyWith(
                      fontWeight: FontWeight.normal,
                      color: UIConstant.orange,
                    ),
                  ),
                  Text(
                    DateFormat("E").format(scheduleId),
                    style: UIConstant.minititle.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Center(
                    child: Text(
                      startSchedule,
                      style: UIConstant.normal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "~",
                      style: UIConstant.title,
                    ),
                  ),
                  Center(
                    child: Text(
                      endSchedule,
                      style: UIConstant.normal.copyWith(
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
