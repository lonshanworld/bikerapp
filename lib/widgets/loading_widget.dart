import "package:flutter/material.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";


import "../constants/uiconstants.dart";

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double oneUnitWidth = deviceWidth / 360;
    final double oneUnitHeight = deviceHeight/772;
    return Center(
      child: LoadingAnimationWidget.twistingDots(
        size: oneUnitWidth * 80,
        leftDotColor: UIConstant.pink,
        rightDotColor: UIConstant.orange,
      ),
    );
  }
}
