
import 'dart:io';

import 'package:delivery/constants/uiconstants.dart';
import 'package:delivery/routehelper.dart';
import 'package:delivery/views/loading_screen.dart';
import 'package:delivery/widgets/customButton_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cameraImage_controller.dart';
import '../controllers/check_in_out_controller.dart';
import '../widgets/camera_widget.dart';
import '../widgets/snackBar_custom_widget.dart';
// import 'dart:io' as Io;

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  // final picker = ImagePicker();
  // late String img64;
  final CameraImageControlller imageControlller = Get.put(CameraImageControlller());
  final CheckInOutController checkInOutController = Get.find<CheckInOutController>();

  bool isShowImage = false;
  File? newselectedImage = File('');
  bool hideBtn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newselectedImage = null;
  }

  getCamera(){
    imageControlller.getCamera().then((file){
      setState(() {
        isShowImage = true;
        newselectedImage = file;
      });
    });

  }


  nullPhotoNew() {
    setState(() {
      print("False New");
      isShowImage = false;
      newselectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check In",
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
          ),
          onPressed: (){
            Get.offAllNamed(RouteHelper.getHomePage());
          },
        ),
      ),

      body:ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        children: [
          CameraWidget(
              gettoCamerafun: (){
                getCamera();
              },
              height: (deviceHeight / 100 ) * 40,
              isshowImage: isShowImage,
              iamgePath: newselectedImage,
              removephotofun: (){
                nullPhotoNew();
              },
          ),
          SizedBox(
            height: 10,
          ),
          CustomButton(
            verticalPadding: 10,
            horizontalPadding: 0,
            txt: "Check In",
            func: ()async{
              // if(!hideBtn) {newselectedImage!.path == "" || newselectedImage == null
              //       ?
              //   CustomGlobalSnackbar.show(
              //     context: context,
              //     title: "Require Image",
              //     txt: "Image is required to proceed.",
              //     icon: Icons.info_outline,
              //     position: true,
              //   )
              //       :
              //   generalController.checkIn(context, newselectedImage).then((value){
              //     Get.snackbar(
              //       value ? "Success" : "Failed",
              //       value? "Checked In Successfully!" : "There is no item available to Check In!",
              //       borderRadius: 10,
              //       backgroundColor: GlobalStyle.primaryColor.withOpacity(0.2),
              //       duration: Duration(seconds: 5),
              //       snackPosition: SnackPosition.BOTTOM,
              //     );
              //     setState(() {
              //       hideBtn = !value;
              //     });
              //     if(value){
              //       Get.offAllNamed("/home");
              //     }
              //   });
              // }
              if(!hideBtn){
                if(newselectedImage!.path == "" || newselectedImage == null){
                  CustomGlobalSnackbar.show(
                    context: context,
                    title: "Require Image",
                    txt: "Image is required to proceed.",
                    icon: Icons.info_outline,
                    position: true,
                  );
                }else{
                  Get.dialog(const LoadingScreen(), barrierDismissible: false);
                  bool value = await checkInOutController.checkIn(newselectedImage!);
                  Get.back();
                  setState(() {
                    hideBtn = !value;
                  });
                  if(value){
                    Get.offAllNamed(RouteHelper.getHomePage());
                  }
                }
              }
            },
            txtClr: Colors.white,
            bgClr: !hideBtn ? UIConstant.orange : Colors.grey,
            txtsize: 16,
            rad: 10,
          ),

        ],
      ),
    );
  }
}
