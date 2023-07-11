import "package:delivery/constants/txtconstants.dart";
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/error_handlers/error_screen.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/widgets/customButton_widget.dart";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:get/get.dart';
import "package:get_storage/get_storage.dart";
import "package:intl/intl.dart";

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
  final box = GetStorage();
  final FocusNode focusNode = FocusNode();
  String labelstring = "Enter your phone number";

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  var formatter = new NumberFormat("#,###");

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void onFocusChange(){
    labelstring = "Phone Number";
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Text(
                  TxtConstant.mainUrl,
                ),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: UIConstant.pink,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.phone_iphone,
                        size: 40,
                        color: UIConstant.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Log In with phone number",
                    style: UIConstant.title,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  style: UIConstant.minititle,
                  controller: textEditingController,
                  focusNode: focusNode,
                  maxLength: 9,
                  keyboardType: TextInputType.phone,
                  inputFormatters:<TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    // TextInputFormatter.withFunction((oldValue, newValue) {
                    //   int oldInt = int.parse(oldValue.text);
                    //   String newtext = formatter.format(oldInt);
                    //   return newValue.copyWith(
                    //     text: newtext,
                    //   );
                    // }),
                  ] ,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    prefix: Padding(
                      padding: EdgeInsets.only(
                        right: 10,
                      ),
                      child: Text(
                        "09",
                        style: UIConstant.minititle,
                      ),
                    ),
                    labelText: labelstring,
                    labelStyle: UIConstant.minititle.copyWith(
                      color: Colors.grey,
                    ),
                    floatingLabelStyle: UIConstant.normal.copyWith(
                      color: Colors.grey
                    ),
                    helperStyle:  UIConstant.tinytext,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: UIConstant.orange, width:2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    suffixIcon: Icon(
                      Icons.phone_enabled,
                      size: 26,
                      color: UIConstant.orange,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomButton(
                  verticalPadding: 10,
                  horizontalPadding: 0,
                  txt: "Login",
                  func: (){
                    print(textEditingController.text);
                    if(textEditingController.text.isEmpty || textEditingController.text.length > 9){
                      CustomGlobalSnackbar.show(
                        context: context,
                        title: "invalid".tr,
                        txt: "checkinput".tr,
                        icon: Icons.error_outline,
                        position: false,
                      );
                    }else{
                      // userAccountController.getUserLogin(textEditingController.text);
                      // Get.dialog(const LoadingScreen(), barrierDismissible: false);
                      String phno = "09${textEditingController.text}";
                      Get.dialog(const LoadingScreen(), barrierDismissible: false);
                      userAccountController.checkUser(phno).then((value) async{

                        if(value.toLowerCase().trim() == "biker"){
                          userAccountController.phoneNumber.value = phno;

                          // TODO: implement to send SMS
                          // await userAccountController.sendSMS();

                          // TODO: remove this for sendsms
                          userAccountController.getrandomrum();

                          Get.back();
                          Get.toNamed(RouteHelper.getPasscodePage());
                        }else{
                          Get.back();
                          showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (ctx){
                              return ErrorScreen(
                                title: "This is $value account",
                                txt: "Only biker can log in this app.",
                                btntxt: "OK",
                                Func: (){
                                  // box.erase();
                                  Navigator.of(ctx).pop();
                                },
                              );
                            },
                          );
                        }
                      });

                    }
                  },
                  txtClr: Colors.white,
                  bgClr: UIConstant.orange,
                  txtsize: 16,
                  rad: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
