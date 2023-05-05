import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/cameraImage_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:delivery/widgets/customtextfield_widget.dart";
import "package:flutter/material.dart";
import"package:get/get.dart";
import "package:image_picker/image_picker.dart";
import "dart:io";

import "package:sizer/sizer.dart";

import "../routehelper.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final UserAccountController userAccountController = Get.find<UserAccountController>();
  final CameraImageControlller cameraImageControlller = Get.put(CameraImageControlller());
  TextEditingController nameController = TextEditingController();
  TextEditingController nrcController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final picker = ImagePicker();

  bool isShowImage = false;
  File? newselectedImage = File('');

  getCamera(){
    cameraImageControlller.getCamera().then((file){
      setState(() {
        isShowImage = true;
        newselectedImage = file;
      });
    });
  }

  // nullPhotoNew() {
  //   setState(() {
  //     print("False New");
  //     isShowImage = false;
  //     newselectedImage = null;
  //   });
  // }


  @override
  void initState() {
    super.initState();
    nameController.text = userAccountController.bikermodel[0].fullName ??  "";
    nrcController.text = userAccountController.bikermodel[0].nrc ?? "";
    emailController.text = userAccountController.bikermodel[0].email ?? "";
  } // late String img64;

  @override
  Widget build(BuildContext context) {

    Text customText(String name, String txt){
      return Text(
        "$name : $txt",
        style: TextStyle(
          fontSize: 10.sp,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 3.h,
          horizontal: 3.h,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  if(!isShowImage)CircleAvatar(
                    radius: 8.h,
                    backgroundImage: NetworkImage(
                      userAccountController.bikermodel[0].profileImage ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgWv75KuTKR5tEa6fNHmINh0SrIAoWhlAYbvoxnG7poIN8dLV4Fxe5IErjDo2RG6grnyU&usqp=CAU',
                    ),
                  ),
                  if(isShowImage)CircleAvatar(
                    radius: 8.h,
                    backgroundImage: FileImage(
                      newselectedImage!,
                    ),
                  ),
                  CustomButton(
                    verticalPadding: 0.5.h,
                    horizontalPadding: 3.h,
                    txt: "Upload",
                    func: (){
                      getCamera();
                    },
                    txtClr: Colors.white,
                    bgClr: UIConstant.orange,
                    txtsize: 10.sp,
                    rad: 1.h,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    userAccountController.bikermodel[0].fullName!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  customText("Phone", userAccountController.bikermodel[0].phone!),
                  Text("================"),
                  customText("Level", userAccountController.bikermodel[0].level!),
                  SizedBox(
                    height: 1.h,
                  ),
                  customText("MISC", userAccountController.bikermodel[0].miscUsage.toString()),
                  SizedBox(
                    height: 1.h,
                  ),
                  customText("Zone", userAccountController.bikermodel[0].zoneId.toString()),
                  SizedBox(
                    height: 1.h,
                  ),
                  customText("Area", userAccountController.bikermodel[0].areaId.toString()),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          CustomTextField(
            txtcontroller: nameController,
            txtsize: 12.sp,
            verticalpadding: 1.5.h,
            horizontalpadding: 2.h,
            textInputType: TextInputType.text,
            hinttxt: "Enter your name",
          ),
          SizedBox(
            height: 1.5.h,
          ),
          CustomTextField(
            txtcontroller: nrcController,
            txtsize: 12.sp,
            verticalpadding: 1.5.h,
            horizontalpadding: 2.h,
            textInputType: TextInputType.text,
            hinttxt: "Enter your NRC",
          ),
          SizedBox(
            height: 1.5.h,
          ),
          CustomTextField(
            txtcontroller: emailController,
            txtsize: 12.sp,
            verticalpadding: 1.5.h,
            horizontalpadding: 2.h,
            textInputType: TextInputType.text,
            hinttxt: "Enter your email",
          ),
          SizedBox(
            height: 3.h,
          ),
          CustomButton(
            verticalPadding: 1.5.h,
            horizontalPadding: 0,
            txt: "Update",
            func: ()async{
              await userAccountController.bikerupdate(
                name: nameController.text,
                nrc: nrcController.text,
                email: emailController.text,
                profile: newselectedImage!,
              );
              Get.offAllNamed(RouteHelper.getHomePage());
            },
            txtClr: Colors.white,
            bgClr: UIConstant.orange,
            txtsize: 12.sp,
            rad: 1.5.h,
          ),
        ],
      ),
    );
  }
}
