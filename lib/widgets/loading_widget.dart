import "package:flutter/material.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";


import "../constants/uiconstants.dart";

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        width: deviceWidth > 600 ? 400 : 250,
        height: deviceWidth > 600 ? 400 : 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: UIConstant.orange,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(30)),
          image: DecorationImage(
            image: AssetImage(
              "assets/images/Ride.gif",
            ),
            fit: BoxFit.cover,
          )
        ),
      ),
    );
  }
}
