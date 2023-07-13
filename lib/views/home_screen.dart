import "dart:async";

import "package:delivery/constants/txtconstants.dart";
import "package:delivery/constants/uiconstants.dart";
import "package:delivery/controllers/chatsignal_controller.dart";
import "package:delivery/controllers/check_in_out_controller.dart";
import "package:delivery/controllers/noti_controller.dart";
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/controllers/schedule_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/error_handlers/error_screen.dart";
import "package:delivery/models/schedule_model.dart";
import "package:delivery/routehelper.dart";
import "package:delivery/views/drawer.dart";
import "package:delivery/views/loading_screen.dart";
import "package:delivery/widgets/customButton_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_shake_animated/flutter_shake_animated.dart";


import "package:get/get.dart";
import "package:get_storage/get_storage.dart";
import "package:intl/intl.dart";

import "../controllers/signalr_controller.dart";
import "../models/noti_model.dart";
import "../services/call_service.dart";
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
  final UserAccountController userAccountController =
  Get.find<UserAccountController>();
  final NotiController notiController = Get.find<NotiController>();
  final OrderController orderController = Get.find<OrderController>();
  final SignalRController signalRController = Get.find<SignalRController>();
  final CheckInOutController checkInOutController =
  Get.find<CheckInOutController>();
  final ScheduleController scheduleController = Get.find<ScheduleController>();
  final ChatSignalControlller chatSignalControlller = Get.put(ChatSignalControlller());

  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  ScheduleModel? checkinModel;
  final box = GetStorage();

  bool isloading = true;
  bool autoplay = false;

  // DateTime? checkoutTime;
  Timer? timer;

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

  forcecheckout() {
    if(mounted){
      setState(() {
        autoplay  = true;
      });
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return ErrorScreen(
            title: "Check out!",
            txt: orderController.currentorderList.isEmpty
                ? "Please check out first before continue any further process"
                : "Please don't forget to check out after deliverying all current items",
            btntxt: orderController.currentorderList.isEmpty
                ? "Click to check out"
                : "ok".tr,
            Func: orderController.currentorderList.isEmpty
                ? () async {
              Get.dialog(const LoadingScreen(),
                  barrierDismissible: false);
              await checkInOutController.checkOut(userAccountController.bikermodel[0].checkInSchedule!);
              if(mounted){
                setState(() {
                  autoplay = false;
                });
              }
              Get.offAllNamed(RouteHelper.getHomePage());
            }
                : () {
              Navigator.of(ctx).pop();
            },
          );
        });
  }

  reloadFun() {
    if (!mounted) {
      return;
    }
    setState(() {
      isloading = true;
    });
    loadData();
  }

  Future<void> loadData() async {
    // DateTime starttime = DateTime.now();
    if(mounted){
      setState(() {
        autoplay  = false;
      });
    }
    await userAccountController.getInfo();
    // await _registerCallBloc().then((_) {
    //   _isInitialized = true;
    //   if (mounted) setState(() {});
    // });
    // if(mounted){
    //   setState(() {
    //     isloading = false;
    //   });
    // }
    await notiController.initController();
    await scheduleController.scheduleReload();
    await orderController.getCurrentOrderList();
    checkinModel = userAccountController.bikermodel[0].checkInSchedule;
    // print(checkinModel!.scheduleId!);
    String data = "2023-07-13T00:00:00";
    String data2 = "2023-07-13T03:00:00";
    List<String> datelist = [
      "2023-07-13T00:00:00",
      "2023-07-13T00:00:00",
      "2023-07-13T00:00:00",
    ];

    if (checkinModel != null) {
      var checkoutDay = checkinModel!.scheduleId!.toString().split(" ");
      String checkoutdetailtime = DateFormat.Hms()
          .format(DateFormat.jm().parse(checkinModel!.endSchedule!));
      DateTime checkoutTime =
      DateTime.parse("${checkoutDay[0]}T${checkoutdetailtime}");
      print("This is checkout time");
      // print(checkinModel!.scheduleId.toString());
      // // print(checkoutDay);
      // print(checkoutTime);
      Duration diff = checkoutTime.difference(DateTime.now());
      print(diff.inSeconds);
      if (diff.inSeconds > 0) {
        timer = Timer(
          Duration(seconds: diff.inSeconds),
          forcecheckout,
        );
      } else {
        // if(mounted){
        //   setState(() {
        //     showErrorbox = true;
        //   });
        // }
        forcecheckout();
      }
    }
    // print("This is check out detail $checkoutall");  DateTime.parse("${checkoutDay}T${checkoutTime}")
    if (mounted) {
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
    signalRController.startSignalR();
    // DBservices.initDB().then((_){
    //   loadData();
    // });
    chatSignalControlller.sendSignal().then((_) {
      loadData().then((_) {
        // _registerCallBloc().then((_) {
        //   _isInitialized = true;
        //   if (mounted) setState(() {});
        // });
      });
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    signalRController.stopSignal();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;

    // (){
    //   if(showErrorbox){
    //     showDialog( barrierDismissible: false ,context: context, builder: (ctx){
    //       return ErrorScreen(
    //         title: "Check out!",
    //         txt: "Please check out first before continue any further process",
    //         btntxt: "Click to check out",
    //         Func: ()async{
    //           Get.dialog(const LoadingScreen(), barrierDismissible: false);
    //           await checkInOutController.checkOut();
    //           Get.offAllNamed(RouteHelper.getHomePage());
    //         },
    //       );
    //     });
    //   }
    // }();

    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              userAccountController.bikermodel[0].fullName ?? "",
              // style: UIConstant.title.copyWith(
              //     fontWeight: FontWeight.normal
              // ),
            ),
            leading: Builder(builder: (ctx) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(ctx).openDrawer();
                },
                icon: const Icon(
                  Icons.menu_open,
                  size: 28,
                ),
              );
            }),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 5,
                ),
                child: ShakeWidget(
                  shakeConstant: ShakeRotateConstant2(),
                  autoPlay: autoplay,
                  duration: Duration(milliseconds: 1500),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                      backgroundColor: Theme.of(context).brightness == Brightness.light ? UIConstant.orange : UIConstant.pink,
                      minimumSize: const Size(0, 0),
                      padding: EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 7,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)
                        ),
                        // side: BorderSide.none,
                      ),
                    ),
                    child: Text(
                      userAccountController.bikermodel[0].checkInSchedule != null
                          ? "checkout".tr
                          : "checkin".tr,
                      style: UIConstant.normal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (userAccountController.bikermodel[0].checkInSchedule != null) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (ctx) {
                            return ConfirmAll_Screen(
                              title: '${"confirm".tr}?!',
                              txt: '${"wanttocheckout".tr}?',
                              acceptFun: () async {
                                Get.dialog(const LoadingScreen(),
                                    barrierDismissible: false);
                                await checkInOutController.checkOut(userAccountController.bikermodel[0].checkInSchedule!);
                                Get.offAllNamed(RouteHelper.getHomePage());
                              },
                              refuseFun: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      } else {
                        Get.toNamed(RouteHelper.getCheckInPage());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          drawer: const DrawerPage(),
          body: isloading
              ? const LoadingWidget()
              : RefreshIndicator(
            color: UIConstant.orange,
            onRefresh: () async {
              reloadFun();
            },
            child: Center(
              child: SizedBox(
                width:
                deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
                child: ListView(
                  children: [
                    // ElevatedButton(onPressed: ()=>{
                    //   Get.to(()=>ChatScreen(
                    //     orderId: "K9UF-M6C9-0V3O-SGZO",
                    //   ))
                    // }, child: Text("testing")),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 10,
                      ),
                      child: Text(
                        "dashboard".tr,
                        style: UIConstant.title,
                      ),
                    ),
                    if (notiController.notiListByshowFlag.isEmpty)
                      NoItemListWidget(txt: "nonoti".tr),
                    if (notiController.notiListByshowFlag.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                        notiController.notiListByshowFlag.length,
                        itemBuilder: (ctx, index) {
                          print(
                              "Get the length of list ${notiController.notiListByshowFlag.length}");
                          NotiOrderModel _item = notiController
                              .notiListByshowFlag[
                          notiController.notiListByshowFlag.length -
                              index -
                              1];
                          // String name = generalController.bikerModel[0].fullName;
                          return NotiWidget(
                            orderBody: _item.body!,
                            orderNo: _item.notiBodyModel!.refNo!,
                            orderId: _item.notiBodyModel!.orderId!,
                            earning: _item.notiBodyModel!.earning!,
                            shopName: _item.notiBodyModel!.shopName!,
                            distance: _item.notiBodyModel!.distanceMeter!,
                            photo: _item.notiBodyModel!.photo ?? "",
                            func: () {
                              // setState(() {
                              //   _notiController.notiList.removeAt(index);
                              // });
                              notiController.updateshowFlag(
                                  _item.notiBodyModel!.orderId!);
                            },
                          );
                        },
                      ),

                    SubTitleWidget(
                      txt: "currentorder".tr,
                    ),
                    if (orderController.currentorderList.isEmpty)
                      NoItemListWidget(
                        txt: "nocuritem".tr,
                      ),
                    if (orderController.currentorderList.isNotEmpty)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                        orderController.currentorderList.length,
                        itemBuilder: (ctx, index) {
                          return CurrentOrderWidget(
                              currentOrderModel: orderController
                                  .currentorderList[index]);
                        },
                      ),
                    SubTitleWidget(
                        txt: "${"checkin".tr} ${"schedule".tr}"),
                    if (checkinModel == null)
                      NoItemListWidget(
                        txt: "nocheckinschedule".tr,
                      ),
                    if (checkinModel != null)
                      ScheduleWidget(
                        scheduleName: checkinModel!.scheduleName!,
                        scheduleId: checkinModel!.scheduleId!,
                        startSchedule: checkinModel!.startSchedule!,
                        endSchedule: checkinModel!.endSchedule!,
                      ),
                    SubTitleWidget(txt: "schedule".tr),
                    if (scheduleController.nextScheduleList.isEmpty)
                      NoItemListWidget(
                        txt: "noavailableschedule".tr,
                      ),
                    if (scheduleController.nextScheduleList.isNotEmpty)
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          itemCount:
                          scheduleController.nextScheduleList.length,
                          itemBuilder: (context, index) {
                            ScheduleModel item = scheduleController
                                .nextScheduleList[index];
                            return ScheduleWidget(
                              scheduleName: item.scheduleName!,
                              scheduleId: item.scheduleId!,
                              startSchedule: item.startSchedule!,
                              endSchedule: item.endSchedule!,
                            );
                          }),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );

    // final child = WillPopScope(
    //   onWillPop: () async => false,
    //   child: Obx(() {
    //     return Scaffold(
    //       appBar: AppBar(
    //         title: Text(
    //           userAccountController.bikermodel[0].fullName ?? "",
    //           // style: UIConstant.title.copyWith(
    //           //     fontWeight: FontWeight.normal
    //           // ),
    //         ),
    //         leading: Builder(builder: (ctx) {
    //           return IconButton(
    //             onPressed: () {
    //               Scaffold.of(ctx).openDrawer();
    //             },
    //             icon: const Icon(
    //               Icons.menu_open,
    //               size: 28,
    //             ),
    //           );
    //         }),
    //         actions: [
    //           TextButton(
    //             style: TextButton.styleFrom(
    //               foregroundColor: Theme.of(context).primaryColor,
    //             ),
    //             child: Text(
    //               box.read(TxtConstant.checkOutBtn) == true
    //                   ? "checkout".tr
    //                   : "checkin".tr,
    //               style: UIConstant.normal.copyWith(
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             onPressed: () {
    //               if (box.read(TxtConstant.checkOutBtn) == true) {
    //                 showDialog(
    //                   barrierDismissible: false,
    //                   context: context,
    //                   builder: (ctx) {
    //                     return ConfirmAll_Screen(
    //                       title: '${"confirm".tr}?!',
    //                       txt: '${"wanttocheckout".tr}?',
    //                       acceptFun: () async {
    //                         Get.dialog(const LoadingScreen(),
    //                             barrierDismissible: false);
    //                         await checkInOutController.checkOut(userAccountController.bikermodel[0].checkInSchedule!);
    //                         Get.offAllNamed(RouteHelper.getHomePage());
    //                       },
    //                       refuseFun: () {
    //                         Navigator.of(context).pop();
    //                       },
    //                     );
    //                   },
    //                 );
    //               } else {
    //                 Get.toNamed(RouteHelper.getCheckInPage());
    //               }
    //             },
    //           ),
    //         ],
    //       ),
    //       drawer: const DrawerPage(),
    //       body: isloading
    //           ? const LoadingWidget()
    //           : RefreshIndicator(
    //         color: UIConstant.orange,
    //         onRefresh: () async {
    //           reloadFun();
    //         },
    //         child: Center(
    //           child: SizedBox(
    //             width:
    //             deviceWidth > 500 ? deviceWidth * 0.8 : deviceWidth,
    //             child: ListView(
    //               children: [
    //                 // ElevatedButton(onPressed: ()=>{
    //                 //   Get.to(()=>ChatScreen(
    //                 //     orderId: "K9UF-M6C9-0V3O-SGZO",
    //                 //   ))
    //                 // }, child: Text("testing")),
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                     left: 20,
    //                     top: 10,
    //                   ),
    //                   child: Text(
    //                     "dashboard".tr,
    //                     style: UIConstant.title,
    //                   ),
    //                 ),
    //                 if (notiController.notiListByshowFlag.isEmpty)
    //                   NoItemListWidget(txt: "nonoti".tr),
    //                 if (notiController.notiListByshowFlag.isNotEmpty)
    //                   ListView.builder(
    //                     shrinkWrap: true,
    //                     physics: const NeverScrollableScrollPhysics(),
    //                     itemCount:
    //                     notiController.notiListByshowFlag.length,
    //                     itemBuilder: (ctx, index) {
    //                       print(
    //                           "Get the length of list ${notiController.notiListByshowFlag.length}");
    //                       NotiOrderModel _item = notiController
    //                           .notiListByshowFlag[
    //                       notiController.notiListByshowFlag.length -
    //                           index -
    //                           1];
    //                       // String name = generalController.bikerModel[0].fullName;
    //                       return NotiWidget(
    //                         orderBody: _item.body!,
    //                         orderNo: _item.notiBodyModel!.refNo!,
    //                         orderId: _item.notiBodyModel!.orderId!,
    //                         earning: _item.notiBodyModel!.earning!,
    //                         shopName: _item.notiBodyModel!.shopName!,
    //                         distance: _item.notiBodyModel!.distanceMeter!,
    //                         photo: _item.notiBodyModel!.photo ?? "",
    //                         func: () {
    //                           // setState(() {
    //                           //   _notiController.notiList.removeAt(index);
    //                           // });
    //                           notiController.updateshowFlag(
    //                               _item.notiBodyModel!.orderId!);
    //                         },
    //                       );
    //                     },
    //                   ),
    //
    //                 SubTitleWidget(
    //                   txt: "currentorder".tr,
    //                 ),
    //                 if (orderController.currentorderList.isEmpty)
    //                   NoItemListWidget(
    //                     txt: "nocuritem".tr,
    //                   ),
    //                 if (orderController.currentorderList.isNotEmpty)
    //                   ListView.builder(
    //                     physics: const NeverScrollableScrollPhysics(),
    //                     shrinkWrap: true,
    //                     itemCount:
    //                     orderController.currentorderList.length,
    //                     itemBuilder: (ctx, index) {
    //                       return CurrentOrderWidget(
    //                           currentOrderModel: orderController
    //                               .currentorderList[index]);
    //                     },
    //                   ),
    //                 SubTitleWidget(
    //                     txt: "${"checkin".tr} ${"schedule".tr}"),
    //                 if (checkinModel == null)
    //                   NoItemListWidget(
    //                     txt: "nocheckinschedule".tr,
    //                   ),
    //                 if (checkinModel != null)
    //                   ScheduleWidget(
    //                     scheduleName: checkinModel!.scheduleName!,
    //                     scheduleId: checkinModel!.scheduleId!,
    //                     startSchedule: checkinModel!.startSchedule!,
    //                     endSchedule: checkinModel!.endSchedule!,
    //                   ),
    //                 SubTitleWidget(txt: "schedule".tr),
    //                 if (scheduleController.nextScheduleList.isEmpty)
    //                   NoItemListWidget(
    //                     txt: "noavailableschedule".tr,
    //                   ),
    //                 if (scheduleController.nextScheduleList.isNotEmpty)
    //                   ListView.builder(
    //                       physics: const NeverScrollableScrollPhysics(),
    //                       shrinkWrap: true,
    //                       padding: const EdgeInsets.symmetric(
    //                         horizontal: 10,
    //                       ),
    //                       itemCount:
    //                       scheduleController.nextScheduleList.length,
    //                       itemBuilder: (context, index) {
    //                         ScheduleModel item = scheduleController
    //                             .nextScheduleList[index];
    //                         return ScheduleWidget(
    //                           scheduleName: item.scheduleName!,
    //                           scheduleId: item.scheduleId!,
    //                           startSchedule: item.startSchedule!,
    //                           endSchedule: item.endSchedule!,
    //                         );
    //                       }),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   }),
    // );
    //
    // if (!_isInitialized) return child;
    // return BlocProvider(
    //   create: (context) => vcService,
    //   child: CallWrapper(
    //     child: child,
    //   ),
    // );
  }
}
