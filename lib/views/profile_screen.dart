import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/cameraImage_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:delivery/widgets/customtextfield_widget.dart";
import "package:flutter/material.dart";
import"package:get/get.dart";
import "package:image_picker/image_picker.dart";
import "dart:io";


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
        style: UIConstant.small,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  if(!isShowImage)CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      userAccountController.bikermodel[0].profileImage ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgWv75KuTKR5tEa6fNHmINh0SrIAoWhlAYbvoxnG7poIN8dLV4Fxe5IErjDo2RG6grnyU&usqp=CAU',
                    ),
                  ),
                  if(isShowImage)CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(
                      newselectedImage!,
                    ),
                  ),
                  CustomButton(
                    verticalPadding: 5,
                    horizontalPadding: 20,
                    txt: "Upload",
                    func: (){
                      getCamera();
                    },
                    txtClr: Colors.white,
                    bgClr: UIConstant.orange,
                    txtsize: 12,
                    rad: 5,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    userAccountController.bikermodel[0].fullName!,
                    style: UIConstant.normal.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  customText("Phone", userAccountController.bikermodel[0].phone!),
                  Text("================"),
                  customText("Level", userAccountController.bikermodel[0].level!),
                  SizedBox(
                    height: 10,
                  ),
                  customText("MISC", userAccountController.bikermodel[0].miscUsage.toString()),
                  SizedBox(
                    height: 10,
                  ),
                  customText("Zone", userAccountController.bikermodel[0].zoneId.toString()),
                  SizedBox(
                    height: 10,
                  ),
                  customText("Area", userAccountController.bikermodel[0].areaId.toString()),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          CustomTextField(
            txtcontroller: nameController,
            txtsize: 14,
            verticalpadding: 10,
            horizontalpadding: 15,
            textInputType: TextInputType.text,
            hinttxt: "Enter your name",
          ),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
            txtcontroller: nrcController,
            txtsize: 14,
            verticalpadding: 10,
            horizontalpadding: 15,
            textInputType: TextInputType.text,
            hinttxt: "Enter your NRC",
          ),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
            txtcontroller: emailController,
            txtsize: 14,
            verticalpadding: 10,
            horizontalpadding: 15,
            textInputType: TextInputType.text,
            hinttxt: "Enter your email",
          ),
          SizedBox(
            height: 25,
          ),
          CustomButton(
            verticalPadding: 15,
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
            txtsize: 14,
            rad: 10,
          ),
        ],
      ),
    );
  }
}
