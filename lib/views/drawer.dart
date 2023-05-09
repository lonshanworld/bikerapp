import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/noti_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/services/theme_service.dart";
import "package:delivery/views/setting_screen.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";

import "../constants/txtconstants.dart";
import "../widgets/alertDialog_widget.dart";

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double oneUnitWidth = deviceWidth / 360;
    final double oneUnitHeight = deviceHeight/772;

    final double drawerWidth = deviceWidth > 500 ? 350 : (deviceWidth / 4) * 3;

    final UserAccountController userAccountController = Get.find<UserAccountController>();
    final NotiController notiController = Get.find<NotiController>();

    GetStorage box = GetStorage();

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
                    CircleAvatar(
                      radius: deviceWidth > 500 ? 50 : 40,
                      backgroundImage: NetworkImage(
                        userAccountController.bikermodel[0].profileImage ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgWv75KuTKR5tEa6fNHmINh0SrIAoWhlAYbvoxnG7poIN8dLV4Fxe5IErjDo2RG6grnyU&usqp=CAU',
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
                      "Cash Collected : ",
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
                          "MMK",
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
                  "Profile",
                  style: UIConstant.normal,
                ),

                subtitle: Text(
                  "Credit ${userAccountController.bikermodel[0].creditAmt} MMK  ||  MISC ${userAccountController.bikermodel[0].miscUsage} MMK",
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
                  Get.toNamed(RouteHelper.getRulePage());
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
