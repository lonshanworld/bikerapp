import "package:flutter/material.dart";
import "package:loading_animation_widget/loading_animation_widget.dart";
import "package:sizer/sizer.dart";

import "../constants/uiconstants.dart";

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.twistingDots(
        size: 10.h,
        leftDotColor: UIConstant.pink,
        rightDotColor: UIConstant.orange,
      ),
    );
  }
}
