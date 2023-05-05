
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
import "package:sizer/sizer.dart";

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

      print("This is notification message");
      print(message.notification!.title);
      print(message.notification!.body);
      print(message.data.containsKey("type"));
      print(message.data);
      print("-----------------------------------------------------------------------------------");
      print(notiController.notiList.length);
      print(notiController.notiListByshowFlag.length);
      print(notiController.notiListByAlert.length);
      // setState(() {
      //
      // });
      // if(message.data.containsKey("type")){
      //
      //   if(message.data["type"].toLowerCase() == "orderpickedup"){
      //     NotiOrderModel notiData = NotiOrderModel();
      //     notiData.title = message.notification?.title;
      //     // var jsonbodydata = json.decode(_notificationInfo!.body);
      //     notiData.body = message.notification?.body;
      //     notiData.notiBodyModel = NotiBodyModel(
      //       orderTitle: notiData.title!,
      //       orderId: message.data["orderId"].toString(),
      //       refNo: message.data["refNo"].toString(),
      //       earning: int.parse(message.data["earning"]),
      //       shopName: message.data["shopName"].toString(),
      //       lat: double.parse(message.data["lat"]),
      //       long: double.parse(message.data["long"]),
      //       photo: message.data["photo"],
      //       distanceMeter: double.parse(message.data["distanceMeter"]),
      //       type: message.data["type"].toString().toLowerCase(),
      //     );
      //     String _date = DateTime.now().toString();
      //     notiData.date = _date;
      //     notiData.type =  message.data["type"];
      //     print(notiData.notiBodyModel?.type);
      //
      //     notiController.updateshowFlag(notiData.notiBodyModel!.orderId!);
      //   }else if(message.data["type"].toLowerCase() == "orderalert"){
      //     NotiOrderModel notiData = NotiOrderModel();
      //     notiData.title = message.notification?.title;
      //     // var jsonbodydata = json.decode(_notificationInfo!.body);
      //     notiData.body = message.notification?.body;
      //     notiData.notiBodyModel = NotiBodyModel(
      //       orderTitle: notiData.title!,
      //       orderId: message.data["orderId"].toString(),
      //       refNo: message.data["refNo"].toString(),
      //       earning: int.parse(message.data["earning"]),
      //       shopName: message.data["shopName"].toString(),
      //       lat: double.parse(message.data["lat"]),
      //       long: double.parse(message.data["long"]),
      //       photo: message.data["photo"],
      //       distanceMeter: double.parse(message.data["distanceMeter"]),
      //       type: message.data["type"].toString().toLowerCase(),
      //     );
      //     String _date = DateTime.now().toString();
      //     notiData.date = _date;
      //     notiData.type =  message.data["type"];
      //     print(notiData.notiBodyModel?.type);
      //
      //     notiData.showFlag = "true";
      //     print("This is in orderalert typpe");
      //     print(notiData);
      //     notiController.addNotiData(notiModel: notiData);
      //     print(notiController.notiListByshowFlag.length);
      //   }else{
      //     RandomNotiModel randomNotiModel = RandomNotiModel(
      //       title: message.notification!.title!,
      //       body: message.notification!.body!,
      //       date: DateTime.now().toString(),
      //     );
      //     notiController.addRandomNoti(randomNotiModel);
      //   }
      // }else{
      //   RandomNotiModel randomNotiModel = RandomNotiModel(
      //     title: message.notification!.title!,
      //     body: message.notification!.body!,
      //     date: DateTime.now().toString(),
      //   );
      //   notiController.addRandomNoti(randomNotiModel);
      // }
      //
      // setState(() {
      //   // // print("noti ${message.notification}");
      //   // // print("Checking message.............................");
      //   // // print(message.data.length);
      //   //
      //   // NotiOrderModel notiData = NotiOrderModel();
      //   // notiData.title = message.notification?.title;
      //   // // var jsonbodydata = json.decode(_notificationInfo!.body);
      //   // notiData.body = message.notification?.body;
      //   // notiData.notiBodyModel = NotiBodyModel(
      //   //   orderTitle: notiData.title!,
      //   //   orderId: message.data["orderId"].toString(),
      //   //   refNo: message.data["refNo"].toString(),
      //   //   earning: int.parse(message.data["earning"]),
      //   //   shopName: message.data["shopName"].toString(),
      //   //   lat: double.parse(message.data["lat"]),
      //   //   long: double.parse(message.data["long"]),
      //   //   photo: message.data["photo"],
      //   //   distanceMeter: double.parse(message.data["distanceMeter"]),
      //   //   type: message.data["type"],
      //   // );
      //   // String _date = DateTime.now().toString();
      //   // notiData.date = _date;
      //   // notiData.type =  message.data["type"];
      //   // print(notiData.notiBodyModel?.type);
      //   //
      //   // if(notiData.notiBodyModel?.type.toString() == "orderpickedup"){
      //   //   notiController.updateshowFlag(notiData.notiBodyModel!.orderId!);
      //   // }else if(notiData.notiBodyModel?.type.toString() == "orderalert" ){
      //   //   notiData.showFlag = "true";
      //   //   print("This is in noti home");
      //   //   print(notiData);
      //   //   notiController.addNotiData(notiModel: notiData);
      //   //   print(notiController.notiList.length);
      //   // }else{
      //   //
      //   // }
      //
      // });
      // reloadFun();
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

    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double oneUnitWidth = deviceWidth / 360;
    // final double oneUnitHeight = deviceHeight/772;


    return Obx((){
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 7.h,
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
                    size: 28.sp,
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
                style: TextStyle(
                  fontSize: 13.sp,
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
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 3.h,
                  top: 1.5.h,
                ),
                child: Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
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
      );
    });
  }
}
