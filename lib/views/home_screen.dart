
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
import "package:flutter/material.dart";

import "package:get/get.dart";
import "package:get_storage/get_storage.dart";
import "package:intl/intl.dart";

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

  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  ScheduleModel? checkinModel;
  final box = GetStorage();

  bool isloading = true;
  DateTime? checkoutTime;

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
    // DateTime starttime = DateTime.now();
    await userAccountController.getInfo();
    // if(mounted){
    //   setState(() {
    //     isloading = false;
    //   });
    // }
    await notiController.initController();
    await scheduleController.scheduleReload();
    await orderController.getCurrentOrderList();
    checkinModel = checkInOutController.getCheckInData();
    if(checkinModel != null){
      String checkoutDay = DateFormat("y-MM-d").format(checkinModel!.scheduleId!);
      String checkoutdetailtime = DateFormat.Hms().format(DateFormat.jm().parse(checkinModel!.endSchedule!));
      checkoutTime = DateTime.parse("${checkoutDay}T${checkoutdetailtime}");
    }
    // print("This is check out detail $checkoutall");  DateTime.parse("${checkoutDay}T${checkoutTime}")
    if(mounted){
      setState(() {
        isloading = false;
      });
    }
    // DateTime endtime = DateTime.now();
    // double delaytime = starttime.difference(endtime).inMilliseconds / 1000;
    // if(mounted){
    //   print("delay api time $delaytime");
    //   setState(() {
    //     isloading = false;
    //   });
    // }


  }

  // firebaseNotiFunc()async{
  //   await firebaseMessaging.getInitialMessage();
  //   await firebaseMessaging.subscribeToTopic("android");
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     print("This is normal message listen...............................................");
  //     print(firebaseMessaging.app);
  //     await notiController.showNotification(
  //       remoteMessage: message
  //     );
  //   });
  //   FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  //
  // }



  @override
  void initState() {
    super.initState();

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
                      size: 28,
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
                  box.read(TxtConstant.checkOutBtn) == true ? "checkout".tr : "checkin".tr,
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
                      barrierDismissible: false,
                      context: context,
                      builder: (ctx){
                        return ConfirmAll_Screen(
                          title: '${"confirm".tr}?!',
                          txt: '${"wanttocheckout".tr}?',
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
                    if(checkinModel != null && DateTime.now().isAfter(checkoutTime!))SizedBox(
                      height: 5,
                    ),
                    if(checkinModel != null && DateTime.now().isAfter(checkoutTime!))Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? UIConstant.pink : UIConstant.orange,
                          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        onPressed: (){
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (ctx){
                              return ConfirmAll_Screen(
                                title: '${"confirm".tr}?!',
                                txt: '${"wanttocheckout".tr}?',
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
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app_outlined,
                                  size: 28,
                                ),
                                Text(
                                  "clicktocheckout".tr,
                                  style: UIConstant.normal,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 10,
                      ),
                      child: Text(
                        "dashboard".tr,
                        style: UIConstant.title,
                      ),
                    ),
                    if(notiController.notiListByshowFlag.isEmpty)NoItemListWidget(
                        txt: "nonoti".tr
                    ),
                    if(notiController.notiListByshowFlag.isNotEmpty)ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                          photo: _item.notiBodyModel!.photo ?? "",
                          func: (){
                            // setState(() {
                            //   _notiController.notiList.removeAt(index);
                            // });
                            notiController.updateshowFlag(_item.notiBodyModel!.orderId!);

                          },
                        );
                      },
                    ),

                    SubTitleWidget(txt: "currentorder".tr,),
                    if(orderController.currentorderList.isEmpty)NoItemListWidget(
                      txt: "nocuritem".tr,
                    ),
                    if(orderController.currentorderList.isNotEmpty)ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orderController.currentorderList.length,
                      itemBuilder: (ctx, index){
                        return CurrentOrderWidget(currentOrderModel: orderController.currentorderList[index]);
                      },
                    ),
                    SubTitleWidget(txt: "${"checkin".tr} ${"schedule".tr}"),
                    if(checkinModel == null)NoItemListWidget(
                        txt: "nocheckinschedule".tr,
                    ),
                    if(checkinModel != null)ScheduleWidget(
                        scheduleName: checkinModel!.scheduleName!,
                        scheduleId: checkinModel!.scheduleId!,
                        startSchedule: checkinModel!.startSchedule!,
                        endSchedule: checkinModel!.endSchedule!,
                    ),
                    SubTitleWidget(txt: "schedule".tr),
                    if(scheduleController.nextScheduleList.isEmpty) NoItemListWidget(
                        txt: "noavailableschedule".tr,
                    ),
                    if(scheduleController.nextScheduleList.isNotEmpty)ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
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
