import "dart:async";

import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/routehelper.dart";
import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:get_storage/get_storage.dart";
import "package:sizer/sizer.dart";

import "../constants/txtconstants.dart";
import "../constants/uiconstants.dart";
import "package:get/get.dart";

import "../controllers/location_controller.dart";
import "../error_handlers/error_screen.dart";
import "loading_screen.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  late Animation<double> animation;
  late AnimationController animationController;
  final UserAccountController userAccountController = Get.find<UserAccountController>();
  final LocationController locationController = Get.find<LocationController>();

  final box = GetStorage();
  late Timer timer;

  Checkroute()async{
    bool value = await locationController.getPermission();
    if(value){
      if(box.read(TxtConstant.accesstoken) == null){
        return Get.offAllNamed(RouteHelper.getLoginPage());
      }else{
        Get.dialog(const LoadingScreen(), barrierDismissible: false);
        await userAccountController.revokeuserToken();
        await userAccountController.getInfo();
        return Get.offAllNamed(RouteHelper.getHomePage());
      }
    }else{
      print("What");
      throw showDialog(context: Get.context!, builder:(ctx){
        return ErrorScreen(
          title: "Location Permission",
          txt: "Location Permission must not be denied.",
          btntxt: 'Allow permission',
          Func: () async{
            await Geolocator.openAppSettings();
          },
        );
      } );
    }

  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );

    timer = Timer(
      const Duration(seconds: 6),
      Checkroute,
    );
  }


  // @override
  // void dispose() {
  //   animationController.dispose();
  //   timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScaleTransition(
        scale: animation,
        child: Center(
          child: Image.asset(
            "assets/images/ic_launcher.png",
            width: 80.w,
          ),
        ),
      ),
    );
  }
}
