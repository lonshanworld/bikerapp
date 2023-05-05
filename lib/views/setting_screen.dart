import "package:delivery/constants/uiconstants.dart";
import "package:delivery/widgets/customButton_widget.dart";
import"package:flutter/material.dart";
import "package:get_storage/get_storage.dart";
import "package:get/get.dart";
import "package:sizer/sizer.dart";


import "../constants/txtconstants.dart";
import "../services/theme_service.dart";

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final box = GetStorage();
  // final AudioController audioController = Get.put(AudioController());
  // final OrderItemListController orderItemListController = Get.put(OrderItemListController());

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double oneUnitWidth = deviceWidth / 360;
    final double oneUnitHeight = deviceHeight/772;

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: UIConstant.orange,
          )
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
      title: Text(
        "Settings",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Change to Dark Mode",
                style: TextStyle(
                  fontSize: 12.sp
                ),
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: Switch(
                activeColor: Colors.green,
                activeTrackColor: Colors.green.shade200,
                value: box.read(TxtConstant.theme) ?? false,
                onChanged: (_){
                  setState(() {
                    ThemeService().switchTheme();
                  });
                },
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: CustomButton(
            verticalPadding: oneUnitHeight * 5,
            horizontalPadding: oneUnitWidth * 30,
            txt: "ok".tr,
            func: (){
              Navigator.of(context).pop();
            },
            txtClr:  Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            bgClr: UIConstant.orange,
            txtsize: oneUnitHeight * 14,
            rad: oneUnitHeight * 5,
          ),
        ),
      ],
    );
  }
}