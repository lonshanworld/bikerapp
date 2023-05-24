import "package:delivery/constants/uiconstants.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:get/get.dart";

class LocationErrorScreen extends StatefulWidget {
  final bool turnOn;

  const LocationErrorScreen({
    Key? key,
    required this.turnOn,
  }) : super(key: key);

  @override
  State<LocationErrorScreen> createState() => _LocationErrorScreenState();
}

class _LocationErrorScreenState extends State<LocationErrorScreen> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if(state == AppLifecycleState.resumed){
      if(widget.turnOn){
        LocationPermission permission = await Geolocator.checkPermission();
        if(permission != LocationPermission.deniedForever || permission != LocationPermission.denied || permission != LocationPermission.unableToDetermine){
          Get.offAllNamed(RouteHelper.getSplashPage());
        }
      }else{
        bool gpsenabled = await Geolocator.isLocationServiceEnabled();
        if(gpsenabled){
          Get.offAllNamed(RouteHelper.getSplashPage());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
          ),
          onPressed: (){
            Get.offAllNamed(RouteHelper.getSplashPage());
          },
        ),
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.turnOn ? "Location Permission must be always allowed" : "Location is not turned on",
              style: UIConstant.minititle,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Please click the button to go to Location Setting.",
              style: UIConstant.normal,
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              verticalPadding: 5,
              horizontalPadding: 30,
              txt: "Go to Location Setting",
              func: ()async{
                widget.turnOn ? await Geolocator.openAppSettings() : await Geolocator.openLocationSettings();
              },
              txtClr: Colors.white,
              bgClr: UIConstant.orange,
              txtsize: 14,
              rad: 5,
            ),
          ],
        ),
      ),
    );
  }



}
