import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/widgets/customButton_widget.dart";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:get/get.dart';
import "package:sizer/sizer.dart";

import "../widgets/snackBar_custom_widget.dart";
import "loading_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final UserAccountController userAccountController = Get.find<UserAccountController>();

  @override
  Widget build(BuildContext context) {

    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: UIConstant.pink,
                      borderRadius: BorderRadius.all(
                        Radius.circular(1.h,),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.phone_iphone,
                      size: 40.sp,
                      color: UIConstant.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Log In with phone number",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              TextField(
                style: TextStyle(
                  fontSize: 14.sp,
                ),
                controller: textEditingController,
                maxLength: 11,
                keyboardType: TextInputType.phone,
                inputFormatters:<TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ] ,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 2.h,
                    horizontal: 3.h,
                  ),
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(1.h)),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  hintText: "Enter Your Phone Number",
                  helperStyle:  TextStyle(
                    fontSize: 10.sp,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(1.h)),
                    borderSide: BorderSide(color: UIConstant.orange, width:2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(1.h)),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: 2.h,
              ),
              CustomButton(
                verticalPadding: 1.5.h,
                horizontalPadding: 0,
                txt: "Login",
                func: (){
                  print(textEditingController.text);
                  if(textEditingController.text.isEmpty || textEditingController.text.length > 12){
                    CustomGlobalSnackbar.show(
                      context: context,
                      title: "Input Invalid",
                      txt: "Please check Input value",
                      icon: Icons.error_outline,
                      position: false,
                    );
                  }else{
                    // userAccountController.getUserLogin(textEditingController.text);
                    // Get.dialog(const LoadingScreen(), barrierDismissible: false);
                    Get.dialog(const LoadingScreen(), barrierDismissible: false);
                    userAccountController.checkUser(textEditingController.text).then((_) async{
                      userAccountController.phoneNumber.value = textEditingController.text;

                      // TODO: implement to send SMS
                      // await userAccountController.sendSMS();

                      // TODO: remove this for sendsms
                      userAccountController.getrandomrum();

                      Get.back();
                      Get.toNamed(RouteHelper.getPasscodePage());
                    });

                  }
                },
                txtClr: Colors.white,
                bgClr: UIConstant.orange,
                txtsize: 14.sp,
                rad: 1.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
