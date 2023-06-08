import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";

class MessageWidget extends StatelessWidget {

  final bool isBiker;
  final String txt;
  const MessageWidget({
    super.key,
    required this.isBiker,
    required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: isBiker ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(!isBiker)Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/profile.png",
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: 250,
              minWidth: 10,
            ),
            decoration: BoxDecoration(
                color: isBiker ?  Theme.of(context).brightness == Brightness.dark ? UIConstant.orange : UIConstant.pink : Colors.grey,
                borderRadius: BorderRadius.only(
                  topRight:  Radius.circular(isBiker ? 0 : 20),
                  topLeft: Radius.circular(isBiker ? 20 : 0),
                  bottomLeft:  Radius.circular(isBiker ? 20 : 0),
                  bottomRight:  Radius.circular(isBiker ? 0 : 20),
                )
            ),
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 15,
            ),
            child: Text(
              txt,
            ),
          ),
        ],
      ),
    );
  }
}
