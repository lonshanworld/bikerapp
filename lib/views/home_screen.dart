
import "package:delivery/constants/txtconstants.dart";
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/check_in_out_controller.dart";
import "package:delivery/controllers/noti_controller.dart";
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/controllers/schedule_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/models/schedule_model.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/views/drawer.dart";
import "package:delivery/views/loading_screen.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";

import "package:get/get.dart";
import "package:get_storage/get_storage.dart";

import "../main.dart";
import "../models/noti_model.dart";
import "../widgets/current_order_widget.dart";
import "../widgets/loading_widget.dart";
import "../widgets/no_item_widget.dart";
import "../widgets/noti_widget.dart";
import "../widgets/schedule_widget.dart";
import "../widgets/subtitle_widget.dart";
import "confirm_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserAccountController userAccountController = Get.find<UserAccountController>();
  final NotiController notiController = Get.find<NotiController>();
  final OrderController orderController = Get.find<OrderController>();
  final CheckInOutController checkInOutController = Get.find<CheckInOutController>();
  final ScheduleController scheduleController = Get.find<ScheduleController>();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  ScheduleModel? checkinModel;
  final box = GetStorage();

  bool isloading = true;

  // requestFirebasePermission()async{
  //   NotificationSettings settings = await firebaseMessaging.requestPermission(
  //     alert: true,
  //     announcement: true,
  //     badge: true,
  //     carPlay: true,
  //     criticalAlert: true,
  //     provisional: true,
  //     sound: true,
  //   );
  //   print('User granted permission: ${settings.authorizationStatus}');
  // }

  reloadFun(){
    if(!mounted){
      return;
    }
    setState(() {
      isloading = true;
    });
    loadData();
  }

  loadData()async{
    await notiController.initController();
    await userAccountController.getInfo();
    await scheduleController.scheduleReload();
    await orderController.getCurrentOrderList();
    checkinModel = checkInOutController.getCheckInData();
    if(!mounted){
      return;
    }
    setState(() {
      isloading = false;
    });
  }

  firebaseNotiFunc(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await notiController.showNotification(
        remoteMessage: message
      );

    });
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  }



  @override
  void initState() {
    super.initState();
    firebaseNotiFunc();
    loadData();
  }

  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;


    return WillPopScope(
      onWillPop: ()async => false,
      child: Obx((){
        return Scaffold(
          appBar: AppBar(
            title: Text(
              userAccountController.bikermodel[0].fullName ?? "",
              // style: UIConstant.title.copyWith(
              //     fontWeight: FontWeight.normal
              // ),
            ),
            leading: Builder(
                builder: (ctx) {
                  return IconButton(
                    onPressed: (){
                      Scaffold.of(ctx).openDrawer();
                    },
                    icon: Icon(
                      Icons.menu_open,
                      size: 24,
                    ),
                  );
                }
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  box.read(TxtConstant.checkOutBtn) == true ? "Check Out" : "Check In",
                  style: UIConstant.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  // if(checkOutbtn != null){
                  //   if(checkOutbtn!){
                  //     showDialog(
                  //       context: context,
                  //       builder: (ctx) => CheckOutScreen(),
                  //     );
                  //   }else{
                  //     Get.toNamed(RouteHelper.getCheckInPage());
                  //   }
                  // }
                  if(box.read(TxtConstant.checkOutBtn)== true){
                    showDialog(
                      context: context,
                      builder: (ctx){
                        return ConfirmAll_Screen(
                          title: 'Confirm?!',
                          txt: 'Are you sure to check out?',
                          acceptFun: () async{
                            Get.dialog(const LoadingScreen(), barrierDismissible: false);
                            await checkInOutController.checkOut();
                            Get.offAllNamed(RouteHelper.getHomePage());
                          },
                          refuseFun: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  }else{
                    Get.toNamed(RouteHelper.getCheckInPage());
                  }
                },
              ),
            ],
          ),
          drawer: const DrawerPage(),
          body: isloading
              ?
          const LoadingWidget()
              :
          RefreshIndicator(
            color: UIConstant.orange,
            onRefresh: ()async{
              reloadFun();
            },
            child: Center(
              child: SizedBox(
                width: deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 10,
                      ),
                      child: Text(
                        "Dashboard",
                        style: UIConstant.title,
                      ),
                    ),
                    if(notiController.notiListByshowFlag.isEmpty)NoItemListWidget(
                        txt: "There is no Notification"
                    ),
                    if(notiController.notiListByshowFlag.isNotEmpty)ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: notiController.notiListByshowFlag.length,
                      itemBuilder: (ctx, index){
                        print("Get the length of list ${notiController.notiListByshowFlag.length}");
                        NotiOrderModel _item = notiController.notiListByshowFlag[notiController.notiListByshowFlag.length - index -1];
                        // String name = generalController.bikerModel[0].fullName;
                        return NotiWidget(
                          orderBody: _item.body!,
                          orderNo: _item.notiBodyModel!.refNo!,
                          orderId: _item.notiBodyModel!.orderId!,
                          earning: _item.notiBodyModel!.earning!,
                          shopName: _item.notiBodyModel!.shopName!,
                          distance: _item.notiBodyModel!.distanceMeter!,
                          photo: _item.notiBodyModel!.photo!,
                          func: (){
                            // setState(() {
                            //   _notiController.notiList.removeAt(index);
                            // });
                            notiController.updateshowFlag(_item.notiBodyModel!.orderId!);

                          },
                        );
                      },
                    ),

                    SubTitleWidget(txt: "Current Order"),
                    if(orderController.currentorderList.isEmpty)NoItemListWidget(
                      txt: "There is no Current Item",
                    ),
                    if(orderController.currentorderList.isNotEmpty)ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orderController.currentorderList.length,
                      itemBuilder: (ctx, index){
                        return CurrentOrderWidget(currentOrderModel: orderController.currentorderList[index]);
                      },
                    ),
                    SubTitleWidget(txt: "Check-In Schedule"),
                    if(checkinModel == null)NoItemListWidget(
                        txt: "There is no Check-In Schedule"
                    ),
                    if(checkinModel != null)ScheduleWidget(
                        scheduleName: checkinModel!.scheduleName!,
                        scheduleId: checkinModel!.scheduleId!,
                        startSchedule: checkinModel!.startSchedule!,
                        endSchedule: checkinModel!.endSchedule!,
                    ),
                    const SubTitleWidget(txt: "Schedule"),
                    if(scheduleController.nextScheduleList.isEmpty)const NoItemListWidget(
                        txt: "There is no Available Schedule"
                    ),
                    if(scheduleController.nextScheduleList.isNotEmpty)ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: scheduleController.nextScheduleList.length,
                        itemBuilder: (context, index) {
                          ScheduleModel item = scheduleController.nextScheduleList[index];
                          return ScheduleWidget(
                            scheduleName: item.scheduleName!,
                            scheduleId: item.scheduleId!,
                            startSchedule: item.startSchedule!,
                            endSchedule: item.endSchedule!,
                          );
                        }
                    ),



                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
