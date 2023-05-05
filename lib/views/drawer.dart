import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/noti_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/services/theme_service.dart";
import "package:delivery/views/setting_screen.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";
import "package:sizer/sizer.dart";

import "../constants/txtconstants.dart";
import "../widgets/alertDialog_widget.dart";

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    final UserAccountController userAccountController = Get.find<UserAccountController>();
    final NotiController notiController = Get.find<NotiController>();

    GetStorage box = GetStorage();

    ListTile customListTile(IconData icon, String title, VoidCallback Func ){
      return ListTile(
        leading: Icon(
          icon,
          color: UIConstant.orange,
          size: 22.sp,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp
          ),
        ),
        onTap: Func,
      );
    }


    CheckOutAlert(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialogWidget(
              title: "Check Out Schedule?",
              bodytxt: "If you log out, Check-In Schedules will automatically check out.",
              refusetxt: "No",
              accepttxt: "Yes, Check out",
              refusefunc: (){
                Navigator.of(context).pop();
              },
              acceptfunc: ()async{
                if(Theme.of(context).brightness == Brightness.dark){
                  ThemeService().switchTheme();
                }
                notiController.deleteAll();
                box.erase();
                Get.offAllNamed(RouteHelper.getLoginPage());
              }
          )
      );
    }

    LogoutAlert(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialogWidget(
              title: "Logout",
              bodytxt: "Are you sure want to Logout?",
              refusetxt: "No",
              accepttxt: "Yes, Logout",
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
                  if(Theme.of(context).brightness == Brightness.dark){
                    ThemeService().switchTheme();
                  }
                  notiController.deleteAll();
                  box.erase();
                  Get.offAllNamed(RouteHelper.getLoginPage());
                }
              }
          )
      );
    }

    return SizedBox(
      width: 75.w,
      child: Drawer(
        child: Obx((){
          return ListView(
            children: [
              SizedBox(
                height: 2.h,
              ),
              InkWell(
                onTap: (){
                  Get.toNamed(RouteHelper.getProfilePage());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 5.h,
                      backgroundImage: NetworkImage(
                        userAccountController.bikermodel[0].profileImage ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgWv75KuTKR5tEa6fNHmINh0SrIAoWhlAYbvoxnG7poIN8dLV4Fxe5IErjDo2RG6grnyU&usqp=CAU',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 3.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userAccountController.bikermodel[0].fullName!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            userAccountController.bikermodel[0].phone!,
                            style: TextStyle(
                              fontSize: 10.sp
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 1.h,
                ),
                margin: EdgeInsets.only(
                  top: 1.5.h,
                  bottom: 1.h,
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
                      "Cash Collected : ",
                      style: TextStyle(
                        fontSize: 12.sp
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          userAccountController.bikermodel[0].cashCollect.toString(),
                          style: TextStyle(
                              fontSize: 12.sp,
                            color: UIConstant.orange,
                          ),
                        ),
                        Text(
                          "MMK",
                          style: TextStyle(
                              fontSize: 12.sp
                          ),
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
                  size: 22.sp,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(
                      fontSize: 12.sp
                  ),
                ),

                subtitle: Text(
                  "Credit ${userAccountController.bikermodel[0].creditAmt} MMK  ||  MISC ${userAccountController.bikermodel[0].miscUsage} MMK",
                  style: TextStyle(
                      fontSize: 10.sp,
                    color: UIConstant.secondarytxtClr
                  ),
                ),
                onTap: () {
                  // Get.to(ChangePassword());
                  Get.toNamed(RouteHelper.getProfilePage());
                },
              ),
              customListTile(
                Icons.not_interested,
                "Punishments",
                () {
                  Get.toNamed(RouteHelper.getPunishmentPage());
                },
              ),
              customListTile(
                Icons.schedule_send_outlined,
                "Schedules",
                () {
                  Get.toNamed(RouteHelper.getSchedulePage());
                },
              ),
              customListTile(
                Icons.history,
                "Order History",
                () {
                  Get.toNamed(RouteHelper.getOrderHistoryPage());
                },
              ),
              customListTile(
                Icons.clear,
                "Clearance",
                () {
                  Get.toNamed(RouteHelper.getClearancePage());
                },
              ),
              customListTile(
                Icons.work_history,
                "Clearance History",
                () {
                  Get.toNamed(RouteHelper.getClearanceHistoryPage());
                },
              ),
              customListTile(
                Icons.description_outlined,
                "Statement History",
                () {

                },
              ),
              customListTile(
                Icons.rule,
                "Rules",
                () {

                },
              ),
              customListTile(
                Icons.shop_two_outlined,
                "Promotion Shops",
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
                "Settings",
                    () {
                  showDialog(
                    context: context,
                    builder: (ctx){
                      return const SettingScreen();
                    },
                  );
                },
              ),
              customListTile(
                Icons.logout_outlined,
                "Log Out",
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
