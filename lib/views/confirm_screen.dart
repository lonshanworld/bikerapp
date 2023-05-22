import "package:delivery/widgets/customButton_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";


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
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: UIConstant.orange,
          )
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
      title: Text(
        title,
        style: UIConstant.minititle,
      ),
      content: Text(
        txt,
        style: UIConstant.normal,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              verticalPadding: 10,
              horizontalPadding: 30,
              txt: "cancel".tr,
              func: refuseFun,
              txtClr:  Colors.black,
              bgClr: UIConstant.pink,
              txtsize: 14,
              rad: 10,
            ),
            CustomButton(
              verticalPadding: 10,
              horizontalPadding: 40,
              txt: "yes".tr,
              func: acceptFun,
              txtClr: Colors.white,
              bgClr: UIConstant.orange,
              txtsize: 14,
              rad: 10,
            ),
          ],
        ),
      ],
    );
  }
}
