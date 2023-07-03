import "package:flutter/material.dart";

class CustomButton extends StatelessWidget {
  final double verticalPadding;
  final double horizontalPadding;
  final String txt;
  final VoidCallback func;
  final Color txtClr;
  final Color bgClr;
  final double txtsize;
  final double rad;
  const CustomButton({
    Key? key,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.txt,
    required this.func,
    required this.txtClr,
    required this.bgClr,
    required this.txtsize,
    required this.rad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      style: FilledButton.styleFrom(
        elevation: 0,
        backgroundColor: bgClr,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(rad)
          ),
          // side: BorderSide.none,
        ),
        minimumSize: const Size(0, 0),
      ),
      child: Text(
        txt,
        style: TextStyle(
            fontSize: txtsize,
            color: txtClr,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
