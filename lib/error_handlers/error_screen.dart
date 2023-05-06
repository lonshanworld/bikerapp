import 'package:delivery/constants/uiconstants.dart';
import 'package:delivery/widgets/customButton_widget.dart';
import 'package:flutter/material.dart';


class ErrorScreen extends StatelessWidget {
  final String title;
  final String txt;
  final String btntxt;
  final VoidCallback Func;
  const ErrorScreen({
    Key? key,
    required this.title,
    required this.txt,
    required this.btntxt,
    required this.Func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double oneUnitWidth = deviceWidth / 360;
    final double oneUnitHeight = deviceHeight/772;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: UIConstant.orange,
          )
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
      title: Text(
        title,
        style: UIConstant.title,
      ),
      content: Text(
        txt,
        style:  UIConstant.normal ,
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: CustomButton(
            verticalPadding: oneUnitHeight * 5,
            horizontalPadding: oneUnitWidth * 30,
            txt: btntxt,
            func: Func,
            txtClr: Colors.white,
            bgClr: UIConstant.orange,
            txtsize: oneUnitHeight * 14,
            rad: oneUnitHeight * 5,
          ),
        ),
      ],
    );
  }
}