
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/models/order_model.dart";
import "package:flutter/material.dart";

class QrShopWidget extends StatelessWidget {

  final OrderItem item;

  const QrShopWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(
        bottom: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${item.itemName!}  x ${item.qty}",
              style: UIConstant.normal.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: item.pickupFlag! ? Colors.green : UIConstant.orange,
              borderRadius: item.pickupFlag! ? null : BorderRadius.all(
                Radius.circular(10),
              ),
              shape: item.pickupFlag! ? BoxShape.circle : BoxShape.rectangle
            ),
            child: item.pickupFlag!
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
                  fontSize: 9,
                  color: Colors.white
                ),
              ),
          ),
        ],
      ),
    );
  }
}
