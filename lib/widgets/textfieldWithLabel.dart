
import "package:flutter/material.dart";
import "package:sizer/sizer.dart";

import "customtextfield_widget.dart";

class TextFieldwithLabel extends StatelessWidget {

  final String label;
  final TextEditingController txtController;
  final TextInputType inputType;

  const TextFieldwithLabel({
    Key? key,
    required this.label,
    required this.txtController,
    required this.inputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child:CustomTextField(
            txtcontroller: txtController,
            txtsize: 12.sp,
            verticalpadding: 0,
            horizontalpadding: 1.5.h,
            textInputType: inputType,
          ),
        ),
      ],
    );
  }
}
