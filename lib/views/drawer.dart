import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/check_in_out_controller.dart";
import "package:delivery/controllers/noti_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/services/logout_service.dart";
import "package:delivery/services/theme_service.dart";
import "package:delivery/views/setting_screen.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";

import "../constants/txtconstants.dart";
import "../widgets/alertDialog_widget.dart";
import "loading_screen.dart";
import "package:http/http.dart" as http;

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final UserAccountController userAccountController = Get.find<UserAccountController>();
  // final NotiController notiController = Get.find<NotiController>();
  final CheckInOutController checkInOutController = Get.find<CheckInOutController>();
  final LogOutService logOutService = LogOutService();

  bool showdefaultimage = false;

  GetStorage box = GetStorage();

  // String imageurl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgWv75KuTKR5tEa6fNHmINh0SrIAoWhlAYbvoxnG7poIN8dLV4Fxe5IErjDo2RG6grnyU&usqp=CAU';

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
    // checkImageError();
  }

  @override
  Widget build(BuildContext context) {
    //
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    final double drawerWidth = deviceWidth > 500 ? 350 : (deviceWidth / 4) * 3;

    ListTile customListTile(IconData icon, String title, VoidCallback Func ){
      return ListTile(
        leading: Icon(
          icon,
          color: UIConstant.orange,
          size: 26,
        ),
        title: Text(
          title,
          style: UIConstant.normal,
        ),
        onTap: Func,
      );
    }


    CheckOutAlert(BuildContext context) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialogWidget(
              title: "${"checkout".tr} ${"schedule".tr}?",
              bodytxt: "bothcheckoutandlogout".tr,
              refusetxt: "no".tr,
              accepttxt: "${"yes".tr}, ${"checkout".tr}",
              refusefunc: (){
                Navigator.of(context).pop();
              },
              acceptfunc: ()async{
                Get.dialog(const LoadingScreen(), barrierDismissible: false);
                await checkInOutController.checkOut();
                logOutService.logout(context);
                // Future.delayed(Duration(seconds: 2),(){
                //   if(Theme.of(context).brightness == Brightness.dark){
                //     ThemeService().switchTheme();
                //   }
                //   notiController.deleteAll();
                //   box.erase();
                //   Get.offAllNamed(RouteHelper.getLoginPage());
                // });
              }
          )
      );
    }

    LogoutAlert(BuildContext context) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialogWidget(
              title: "logout".tr,
              bodytxt: "wanttologout".tr,
              refusetxt: "no".tr,
              accepttxt: "${"yes".tr}, ${"logout".tr}",
              refusefunc: (){
                Navigator.of(context).pop();
              },
              acceptfunc: ()async{
                // share_pref_controller.getCheckOutBtn().then((value){
                //   if(value){
                //     CheckOutAlert(context);
                //   }else{
                //     setState(() {
                //       box.remove("username");
                //       box.remove("password");
                //       box.remove("name");
                //       box.remove("access_token");
                //       box.remove("usercode");
                //       box.remove("userGroup");
                //       deleteAction();
                //     });
                //
                //     Get.offAllNamed('/');
                //   }
                // });
                var value = box.read(TxtConstant.checkOutBtn);
                if(value == true){
                  CheckOutAlert(context);
                }else{
                  Get.dialog(const LoadingScreen(), barrierDismissible: false);
                  logOutService.logout(context);
                  // Future.delayed(Duration(seconds: 2),(){
                  //   if(Theme.of(context).brightness == Brightness.dark){
                  //     ThemeService().switchTheme();
                  //   }
                  //   notiController.deleteAll();
                  //   box.erase();
                  //   Get.offAllNamed(RouteHelper.getLoginPage());
                  // });
                }
              }
          )
      );
    }

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: Obx((){
          return ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: (){
                  Get.toNamed(RouteHelper.getProfilePage());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if(!showdefaultimage && (userAccountController.bikermodel[0].profileImage != null && userAccountController.bikermodel[0].profileImage !=""))Container(
                      width: deviceWidth > 500 ? 100 : 80,
                      height: deviceWidth > 500 ? 100 : 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            onError: (object, stacktrace){
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
                    if(showdefaultimage || userAccountController.bikermodel[0].profileImage == null || userAccountController.bikermodel[0].profileImage =="")Container(
                      width: deviceWidth > 500 ? 100 : 80,
                      height: deviceWidth > 500 ? 100 : 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/profile.png",
                          ),
                          fit: BoxFit.contain,
                        )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userAccountController.bikermodel[0].fullName!,
                            style: UIConstant.small.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            userAccountController.bikermodel[0].phone!,
                            style: UIConstant.small,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                margin: EdgeInsets.only(
                  top: 15,
                  bottom: 8,
                ),
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(
                        color: UIConstant.orange,
                        width: 1,
                      )
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${"cashcollected".tr} : ",
                      style: UIConstant.normal,
                    ),
                    Row(
                      children: [
                        Text(
                          userAccountController.bikermodel[0].cashCollect.toString(),
                          style: UIConstant.normal.copyWith(
                            color: UIConstant.orange,
                          ),
                        ),
                        Text(
                          "mmk".tr,
                          style: UIConstant.normal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: UIConstant.orange,
                  size: 24,
                ),
                title: Text(
                  "profile".tr,
                  style: UIConstant.normal,
                ),

                subtitle: Text(
                  "${"credit".tr} ${userAccountController.bikermodel[0].creditAmt ?? 0} ${"mmk".tr}  ||  ${"misc".tr} ${userAccountController.bikermodel[0].miscUsage ?? 0} ${"mmk".tr}",
                  style: UIConstant.tinytext.copyWith(
                    color: UIConstant.secondarytxtClr,
                  ),
                ),
                onTap: () {
                  // Get.to(ChangePassword());
                  Get.toNamed(RouteHelper.getProfilePage());
                },
              ),
              customListTile(
                Icons.not_interested,
                "punishment".tr,
                () {
                  Get.toNamed(RouteHelper.getPunishmentPage());
                },
              ),
              customListTile(
                Icons.schedule_send_outlined,
                "schedule".tr,
                () {
                  Get.toNamed(RouteHelper.getSchedulePage());
                },
              ),
              customListTile(
                Icons.history,
                "${"order".tr} ${"history".tr}",
                () {
                  Get.toNamed(RouteHelper.getOrderHistoryPage());
                },
              ),
              customListTile(
                Icons.clear,
                "clearance".tr,
                () {
                  Get.toNamed(RouteHelper.getClearancePage());
                },
              ),
              customListTile(
                Icons.work_history,
                "${"clearance".tr} ${"history".tr}",
                () {
                  Get.toNamed(RouteHelper.getClearanceHistoryPage());
                },
              ),
              customListTile(
                Icons.description_outlined,
                "${"statement".tr} ${"history".tr}",
                () {

                },
              ),
              customListTile(
                Icons.rule,
                "rules".tr,
                () {
                  Get.toNamed(RouteHelper.getRulePage());
                },
              ),
              customListTile(
                Icons.shop_two_outlined,
                "Promotion ${"shops".tr}",
                () {

                },
              ),
              customListTile(
                Icons.notification_important_outlined,
                "Notifications",
                () {
                  Get.toNamed(RouteHelper.getNotiPage());
                },
              ),
              customListTile(
                Icons.settings,
                "settings".tr,
                    () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx){
                      return const SettingScreen();
                    },
                  );
                },
              ),
              customListTile(
                Icons.logout_outlined,
                "logout".tr,
                () {
                  var value = box.read(TxtConstant.checkOutBtn);
                  print(value);

                  LogoutAlert(context);
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
