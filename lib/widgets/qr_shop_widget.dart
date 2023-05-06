
import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";

class QrShopWidget extends StatelessWidget {

  final String name;
  final bool pickUp;

  const QrShopWidget({
    Key? key,
    required this.name,
    required this.pickUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: UIConstant.normal.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: pickUp ? Colors.green : UIConstant.orange,
              borderRadius: pickUp ? null : BorderRadius.all(
                Radius.circular(10),
              ),
              shape: pickUp ? BoxShape.circle : BoxShape.rectangle
            ),
            child: pickUp
                ?
              Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              )
                :
              Text(
                "Pending ...",
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white
                ),
              ),
          ),
        ],
      ),
    );
  }
}
