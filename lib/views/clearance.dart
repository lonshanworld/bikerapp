
import 'package:delivery/constants/uiconstants.dart';
import 'package:delivery/controllers/clearance_controller.dart';
import 'package:delivery/models/clearance_model.dart';
import 'package:delivery/widgets/no_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "dart:io";

import '../controllers/cameraImage_controller.dart';
import '../widgets/camera_widget.dart';
import '../widgets/customButton_widget.dart';
import '../widgets/customtextfield_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/textfieldWithLabel.dart';

class Clearance extends StatefulWidget {
  const Clearance({Key? key}) : super(key: key);

  @override
  State<Clearance> createState() => _ClearanceState();
}

class _ClearanceState extends State<Clearance> {

  final ClearanceController clearanceController = Get.find<ClearanceController>();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController cashController = TextEditingController();
  final TextEditingController miscController = TextEditingController();
  final TextEditingController creditController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  final CameraImageControlller imageControlller = Get.put(CameraImageControlller());
  ClearanceModel? clearanceModel;

  bool isShowImage = false;
  File? newselectedImage = File('');
  bool hideBtn = false;
  bool isloading = true;

  Future assignData()async{
    clearanceModel = await clearanceController.getClearance();
    if(clearanceModel !=null){
      levelController.text = clearanceModel!.levelName!;
      cashController.text = clearanceModel!.cod.toString();
      miscController.text = clearanceModel!.miscusage.toString();
      creditController.text = clearanceModel!.codPayment.toString();
      totalController.text = (clearanceModel!.miscusage! + clearanceModel!.deposit! + clearanceModel!.cod!).toString();
    }
    setState(() {
      isloading = false;
    });
  }

  getCameraImage(){
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
  void initState() {
    // TODO: implement initState
    super.initState();
    newselectedImage = null;
    assignData();
  }

  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Clearance"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 24,
          ),
          onPressed: () {
            // Get.offAllNamed("/home");
            Get.back();
          },
        ),
      ),
      body: isloading
          ?
      const LoadingWidget()
          :
      (clearanceModel == null)
          ?
      Center(
        child: SizedBox(
          width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              NoItemListWidget(txt: "noclearanceitem".tr),
            ],
          ),
        ),
      )
          :
      Center(
        child: SizedBox(
          width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
          child: ListView(
            padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
            ),
            children: [
              TextFieldwithLabel(
                label: "level".tr,
                txtController: levelController,
                inputType: TextInputType.text,
              ),
              SizedBox(height: 5),
              TextFieldwithLabel(
                label: "cashondelivery".tr,
                txtController: cashController,
                inputType: TextInputType.number,
              ),
              SizedBox(height: 5),
              TextFieldwithLabel(
                label: "${"misc".tr} ${"usage".tr}",
                txtController: miscController,
                inputType: TextInputType.number,
              ),
              SizedBox(height: 5),
              TextFieldwithLabel(
                label: "credit".tr,
                txtController: creditController,
                inputType: TextInputType.number,
              ),
              SizedBox(height: 5),
              TextFieldwithLabel(
                label: "${"total".tr} ${"clearance".tr}",
                txtController: totalController,
                inputType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              CameraWidget(
                  gettoCamerafun: (){
                    getCameraImage();
                  },
                  height: (deviceHeight / 100) * 30,
                  isshowImage: isShowImage,
                  iamgePath: newselectedImage,
                  removephotofun: (){
                    nullPhotoNew();
                  }
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: CustomTextField(
                  txtcontroller: paymentController,
                  txtsize: 16,
                  verticalpadding: 15,
                  horizontalpadding: 15,
                  textInputType: TextInputType.number,
                  hinttxt: "${"payment".tr} ${"amount".tr}",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                verticalPadding: 10,
                horizontalPadding: 0,
                txt: "clearance".tr,
                func: (){

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
    );
  }
}