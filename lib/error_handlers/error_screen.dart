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

    return WillPopScope(
      onWillPop: ()async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
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
              verticalPadding: 5,
              horizontalPadding: 30,
              txt: btntxt,
              func: Func,
              txtClr: Colors.white,
              bgClr: UIConstant.orange,
              txtsize:  14,
              rad: 5,
            ),
          ),
        ],
      ),
    );
  }
}