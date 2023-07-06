
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/cameraImage_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/views/chat_screen.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:delivery/widgets/customtextfield_widget.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import"package:get/get.dart";
import "package:image_picker/image_picker.dart";
import "dart:io";
import "package:http/http.dart" as http;


import "../routehelper.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{

  final UserAccountController userAccountController = Get.find<UserAccountController>();
  final CameraImageControlller cameraImageControlller = Get.put(CameraImageControlller());
  TextEditingController nameController = TextEditingController();
  TextEditingController nrcController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final picker = ImagePicker();

  bool isShowImage = false;
  File? newselectedImage = File('');

  bool showdefaultimage = false;



  getCamera(){
    cameraImageControlller.getCamera().then((file){
      if(file == "" || file == null){
        return ;
      }else{
        if(mounted){
          setState(() {
            isShowImage = true;
            newselectedImage = file;
          });
        }
      }
    });
  }

  // nullPhotoNew() {
  //   setState(() {
  //     print("False New");
  //     isShowImage = false;
  //     newselectedImage = null;
  //   });
  // }
  //
  // imageChangeFunc(Object object, StackTrace? stackTrace){
  //   if(object.toString().split(",")[1].trim() == "statusCode: 404"){
  //     setState(() {
  //       imageurl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgWv75KuTKR5tEa6fNHmINh0SrIAoWhlAYbvoxnG7poIN8dLV4Fxe5IErjDo2RG6grnyU&usqp=CAU';
  //     });
  //   }
  // }

  // Future<void> checkImageError()async{
  //   if(userAccountController.bikermodel[0].profileImage != null){
  //     http.Response response = await http.get(Uri.parse(userAccountController.bikermodel[0].profileImage!));
  //     if(response.statusCode == 200){
  //       if(mounted){
  //         setState(() {
  //           imageurl = userAccountController.bikermodel[0].profileImage!;
  //         });
  //       }
  //     }
  //   }
  // }


  @override
  void initState() {
    super.initState();
    print("Checking image in profile");
    print(userAccountController.bikermodel[0].profileImage);
    nameController.text = userAccountController.bikermodel[0].fullName ??  "";
    nrcController.text = userAccountController.bikermodel[0].nrc ?? "";
    emailController.text = userAccountController.bikermodel[0].email ?? "";
    // checkImageError();
  }

  // late String img64;




  @override
  Widget build(BuildContext context) {

    final deviceWidth = MediaQuery.of(context).size.width;

    Text customText(String name, String txt){
      return Text(
        "$name : $txt",
        style: UIConstant.small,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
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
      body: Center(
        child: SizedBox(
          width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
          child: ListView(
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
                      if(!isShowImage && !showdefaultimage && userAccountController.bikermodel[0].profileImage!=null && userAccountController.bikermodel[0].profileImage!="")Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            onError: (object, stacktrace){
                              print("Checking image in profile");
                              print(userAccountController.bikermodel[0].profileImage!);
                              if(mounted){
                                setState(() {
                                  showdefaultimage = true;
                                });
                              }
                            },
                            image: NetworkImage(
                              userAccountController.bikermodel[0].profileImage!,
                            ),
                            fit: BoxFit.contain,
                          )
                        ),
                      ),
                      if(!isShowImage && showdefaultimage)Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/profile.png",
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      if(isShowImage && newselectedImage != "" && newselectedImage != null)Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(
                                newselectedImage!,
                              ),
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                      CustomButton(
                        verticalPadding: 5,
                        horizontalPadding: 20,
                        txt: "upload".tr,
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
                      customText("phone".tr, userAccountController.bikermodel[0].phone!),
                      Text("================"),
                      customText("level".tr, userAccountController.bikermodel[0].level!),
                      SizedBox(
                        height: 10,
                      ),
                      customText("misc".tr, userAccountController.bikermodel[0].miscUsage.toString()),
                      SizedBox(
                        height: 10,
                      ),
                      customText("zone".tr, userAccountController.bikermodel[0].zoneId.toString()),
                      SizedBox(
                        height: 10,
                      ),
                      customText("area".tr, userAccountController.bikermodel[0].areaId.toString()),
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
                hinttxt: "enteryourname".tr,
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
                hinttxt: "enteryournrc".tr,
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
                hinttxt: "enteryourgmail".tr,
              ),
              SizedBox(
                height: 25,
              ),
              CustomButton(
                verticalPadding: 15,
                horizontalPadding: 0,
                txt: "update".tr,
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
                txtsize: 16,
                rad: 10,
              ),
            ],
          ),
        ),
      ),
      // bottomSheet: AnimatedContainer(
      //   duration: Duration(seconds: 3),
      //   curve: Curves.easeInOutCubic,
      //   height: showBottomlayer ? MediaQuery.of(context).size.height - 100 : 0,
      //   color: Colors.red,
      // ),
    );
  }
}
