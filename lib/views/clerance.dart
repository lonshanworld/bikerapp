
import 'package:delivery/constants/uiconstants.dart';
import 'package:delivery/controllers/clearance_controller.dart';
import 'package:delivery/models/clearance_model.dart';
import 'package:delivery/widgets/no_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import "dart:io";

import '../controllers/cameraImage_controller.dart';
import '../widgets/camera_widget.dart';
import '../widgets/customButton_widget.dart';
import '../widgets/customtextfield_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/textfieldWithLabel.dart';

class Clerance extends StatefulWidget {
  const Clerance({Key? key}) : super(key: key);

  @override
  State<Clerance> createState() => _CleranceState();
}

class _CleranceState extends State<Clerance> {

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Clerance"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: (){
            Get.offAllNamed("/home");
          },
        ),
      ),
      body: isloading
          ?
      const LoadingWidget()
          :
      (clearanceModel == null)
          ?
      ListView(
        children: [
          SizedBox(
            height: 2.h,
          ),
          NoItemListWidget(txt: "There is no Item in clearance"),
        ],
      )
          :
      ListView(
        padding: EdgeInsets.symmetric(
            vertical: 3.h,
            horizontal: 3.h,
        ),
        children: [
          TextFieldwithLabel(
            label: "Level",
            txtController: levelController,
            inputType: TextInputType.text,
          ),
          SizedBox(height: 1.h),
          TextFieldwithLabel(
            label: "Cash-on Delivery",
            txtController: cashController,
            inputType: TextInputType.number,
          ),
          SizedBox(height: 1.h),
          TextFieldwithLabel(
            label: "MISC Usage",
            txtController: miscController,
            inputType: TextInputType.number,
          ),
          SizedBox(height: 1.h),
          TextFieldwithLabel(
            label: "Credit",
            txtController: creditController,
            inputType: TextInputType.number,
          ),
          SizedBox(height: 1.h),
          TextFieldwithLabel(
            label: "Total Clearance",
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
              height: 30.h,
              isshowImage: isShowImage,
              iamgePath: newselectedImage,
              removephotofun: (){
                nullPhotoNew();
              }
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 1.5.h,
            ),
            child: CustomTextField(
              txtcontroller: paymentController,
              txtsize: 16.sp,
              verticalpadding: 2.h,
              horizontalpadding: 2.h,
              textInputType: TextInputType.number,
              hinttxt: "Payment Amount",
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          CustomButton(
            verticalPadding: 1.5.h,
            horizontalPadding: 0,
            txt: "Clearance",
            func: (){

            },
            txtClr: Colors.white,
            bgClr: UIConstant.orange,
            txtsize: 14.sp,
            rad: 1.5.h,
          ),
        ],
      ),
    );
  }
}
