
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:flutter/material.dart";


class AlertDialogWidget extends StatelessWidget {

  final String title;
  final String bodytxt;
  final String refusetxt;
  final String accepttxt;
  final VoidCallback refusefunc;
  final VoidCallback acceptfunc;

  const AlertDialogWidget({
    Key? key,
    required this.title,
    required this.bodytxt,
    required this.refusetxt,
    required this.accepttxt,
    required this.refusefunc,
    required this.acceptfunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: UIConstant.orange,
        )
      ),
      title: Text(title, style: TextStyle(color: Colors.redAccent)),
      content: Text(bodytxt),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: <Widget>[
        CustomButton(
            verticalPadding: 10,
            horizontalPadding: 20,
            txt: refusetxt,
            func: refusefunc,
            txtClr: UIConstant.orange,
            bgClr: UIConstant.pink,
            txtsize: 14,
            rad: 10,
        ),
        CustomButton(
            verticalPadding: 10,
            horizontalPadding: 20,
            txt: accepttxt,
            func: acceptfunc,
            txtClr: UIConstant.pink,
            bgClr: UIConstant.orange,
            txtsize: 14,
            rad: 10,
        )
      ],
    );
  }
}
