import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";

class NoItemListWidget extends StatelessWidget {

  final String txt;

  const NoItemListWidget({
    Key? key,
    required this.txt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),
      margin: EdgeInsets.symmetric(
        vertical:  10,
        horizontal:  20,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          if(Theme.of(context).brightness == Brightness.light)BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0),
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular( 10),
        ),
        color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
      ),
      alignment: Alignment.center,
      child: Text(
        txt,
        style: UIConstant.normal.copyWith(
          color: UIConstant.secondarytxtClr,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
