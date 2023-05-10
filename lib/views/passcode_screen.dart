import 'dart:async';

import 'package:delivery/controllers/useraccount_controller.dart';
import 'package:delivery/routehelper.dart';
import 'package:delivery/widgets/customButton_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../constants/uiconstants.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../widgets/snackBar_custom_widget.dart';
import 'loading_screen.dart';

class PasscodeScreen extends StatefulWidget {

  const PasscodeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PasscodeScreen> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {

  final UserAccountController userAccountController = Get.find<UserAccountController>();
  int time = 120;
  bool showresendBtn = false;
  late Timer newtimer;


  void resendCode(){
    time = 120;
    newtimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time --;
      setState(() {
        showresendBtn = false;
      });
      if(time == 0){
        timer.cancel();
        setState(() {
          showresendBtn = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    resendCode();
  }


  @override
  void dispose() {
    newtimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    final TextEditingController pinController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 28,
            ),
            color: UIConstant.orange,
          ),
        ),
        body:  Obx((){
          return Center(
            child: SizedBox(
              width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
              child: ListView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 80,
                ),
                children: [
                  Text(
                    'Verification',
                    style: UIConstant.maintitle.copyWith(
                      color: UIConstant.orange
                    ),
                  ),
                  Text(userAccountController.randomnum.toString()),
                  // Text(userAccountController.phoneNumber.toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Enter the OTP code from the SMS we just sent you.',
                    style: UIConstant.normal.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // OtpTextField(
                  //   numberOfFields: 6,
                  //   borderColor: Colors.grey,
                  //   focusedBorderColor: UIConstant.orange,
                  //   textStyle: UIConstant.title,
                  //   showFieldAsBox: false,
                  //   borderWidth: 4.0,
                  //   //runs when every textfield is filled
                  //   onSubmit: (String verificationCode) async{
                  //     if(verificationCode == userAccountController.randomnum.value.toString()){
                  //       Get.dialog(const LoadingScreen(), barrierDismissible: false);
                  //       await userAccountController.verifiedUser();
                  //       await userAccountController.getInfo();
                  //       Get.offAllNamed(RouteHelper.getHomePage());
                  //     }else{
                  //       CustomGlobalSnackbar.show(
                  //         context: context,
                  //         title: "OTP code Wrong",
                  //         txt: "Your OTP code is wrong. Please check SMS again",
                  //         icon: Icons.error_outline,
                  //         position: false,
                  //       );
                  //     }
                  //   },
                  // ),
                  Pinput(
                    length: 6,
                    controller: pinController,
                    closeKeyboardWhenCompleted: true,
                    keyboardType: TextInputType.number,
                    hapticFeedbackType: HapticFeedbackType.vibrate,
                    defaultPinTheme: PinTheme(
                      width: 40,
                      height: 50,
                      margin: EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      textStyle: UIConstant.title,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 3,
                          )
                        )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  // if(!showresendBtn)Text(
                  //   "Do you want to resend code in $time seconds",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 14.sp,
                  //     color: UIConstant.secondarytxtClr,
                  //   ),
                  // ),
                  if(!showresendBtn)Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do you want to resend code in  ",
                        textAlign: TextAlign.center,
                        style: UIConstant.small.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        time.toString(),
                        textAlign: TextAlign.center,
                        style: UIConstant.small.copyWith(
                          color: Colors.redAccent,
                        ),
                      ),
                      Text(
                        "  seconds",
                        textAlign: TextAlign.center,
                        style: UIConstant.small.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  if(showresendBtn)CustomButton(
                    verticalPadding: 10,
                    horizontalPadding: 0,
                    txt: "Resend code again",
                    func: ()async{
                      Get.dialog(const LoadingScreen(), barrierDismissible: false);

                      // TODO: implement to send SMS
                      // await userAccountController.sendSMS();

                      // TODO: remove this to send SMS
                      await userAccountController.getrandomrum();
                      resendCode();
                      Get.back();
                    },
                    txtClr: Colors.white,
                    bgClr: UIConstant.orange,
                    txtsize: 14,
                    rad: 10,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }


}
