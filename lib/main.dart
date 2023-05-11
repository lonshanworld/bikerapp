import 'dart:async';

import 'package:delivery/constants/txtconstants.dart';
import 'package:delivery/controllers/location_controller.dart';
import 'package:delivery/controllers/noti_controller.dart';
import 'package:delivery/controllers/schedule_controller.dart';
import 'package:delivery/controllers/signalr_controller.dart';
import 'package:delivery/db/db_service.dart';
import 'package:delivery/error_handlers/error_handlers.dart';

import 'package:delivery/routehelper.dart';

import 'package:delivery/services/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import "package:get/get.dart";
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';


import 'constants/uiconstants.dart';
import 'dependencies.dart';

import 'models/noti_model.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await setupFlutterNotifications();
//   showFlutterNotification(message);
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print('Handling a background message ${message.messageId}');
// }

final NotiController notiController = Get.isRegistered<NotiController>() ? Get.find<NotiController>() : Get.put(NotiController(),permanent: true);
final ScheduleController  scheduleController= Get.isRegistered<ScheduleController>() ? Get.find<ScheduleController>() : Get.put(ScheduleController(),permanent: true);

@pragma('vm:entry-point')
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message)async{
  print("backgroundMessage ${message.notification?.title}");
  notiController.showNotificationforBackground(
    remoteMessage: message,
  );

  await DBservices.initDB();
  if(message.data.containsKey("type")){
    print("This contain key");
    if(message.data["type"].toLowerCase() == "orderpickedup"){
      print("the type is orderpickedup");
      NotiOrderModel notiData = NotiOrderModel();
      notiData.title = message.notification?.title;

      notiData.body = message.notification?.body;
      notiData.notiBodyModel = NotiBodyModel(
        orderTitle: notiData.title!,
        orderId: message.data["orderId"].toString(),
        refNo: message.data["refNo"].toString(),
        earning: int.parse(message.data["earning"]),
        shopName: message.data["shopName"].toString(),
        lat: double.parse(message.data["lat"]),
        long: double.parse(message.data["long"]),
        photo: message.data["photo"],
        distanceMeter: double.parse(message.data["distanceMeter"]),
        type: message.data["type"].toString().toLowerCase(),
      );
      String _date = DateFormat("y-MMM-d").format(DateTime.now());
      notiData.date = _date;
      notiData.type =  message.data["type"];
      print(notiData.notiBodyModel?.type);

      notiController.updateshowFlag(notiData.notiBodyModel!.orderId!);
    }else if(message.data["type"].toLowerCase() == "orderalert"){
      print("the type is order alert");
      NotiOrderModel notiData = NotiOrderModel();
      notiData.title = message.notification?.title;
      // var jsonbodydata = json.decode(_notificationInfo!.body);
      notiData.body = message.notification?.body;
      notiData.notiBodyModel = NotiBodyModel(
        orderTitle: notiData.title!,
        orderId: message.data["orderId"].toString(),
        refNo: message.data["refNo"].toString(),
        earning: int.parse(message.data["earning"]),
        shopName: message.data["shopName"].toString(),
        lat: double.parse(message.data["lat"]),
        long: double.parse(message.data["long"]),
        photo: message.data["photo"],
        distanceMeter: double.parse(message.data["distanceMeter"]),
        type: message.data["type"].toString().toLowerCase(),
      );
      String _date = DateFormat("y-MMM-d").format(DateTime.now());
      notiData.date = _date;
      notiData.type =  message.data["type"];
      print(notiData.notiBodyModel?.type);

      notiData.showFlag = "true";
      print("This is in orderalert typpe");
      print(notiData);
      notiController.addNotiData(notiModel: notiData);
      print(notiController.notiListByshowFlag.length);
    }else{
      print("has key but no type");
      RandomNotiModel randomNotiModel = RandomNotiModel(
        title: message.notification!.title!,
        body: message.notification!.body!,
        date: DateTime.now().toString(),
      );
      notiController.addRandomNoti(randomNotiModel);
      await scheduleController.scheduleReload();
    }
  }else{
    print("no key");
    RandomNotiModel randomNotiModel = RandomNotiModel(
      title: message.notification!.title!,
      body: message.notification!.body!,
      date:DateFormat("y-MMM-d").format(DateTime.now()),
    );
    notiController.addRandomNoti(randomNotiModel);
    await scheduleController.scheduleReload();
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Get.put(LifeCycleController());
  await GetStorage.init();
  await DBservices.initDB();
  GlobalBindings().dependencies();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  // This widget is the root of your application.
  final NotiController notiController = Get.find<NotiController>();
  final SignalRController signalRController = Get.find<SignalRController>();


  late StreamSubscription<InternetConnectionStatus> listener;

  initFuncs()async{
    // await notiController.initController();

    await notiController.requestNotiPermission();
    await notiController.initialize();

    await signalRController.startSignalR();


    // close listener after 30 seconds, so the program doesn't run forever
    // await Future.delayed(Duration(seconds: 5));
    // await listener.cancel();
    // print("Listener cancelled");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          Get.back();
          print('Data connection is available.');
          WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
          break;
        case InternetConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          Get.dialog(
            AlertDialog(
              title: Text(
                'No Internet Connection',
                style: UIConstant.title,
              ),
              content: Text(
                'There is no internet connectio.  Please check your internet connection and try again.',
                style:  UIConstant.normal ,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color: UIConstant.orange,
                  )
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
            ),
          );

          Future.delayed(Duration(seconds: 3),(){
            WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.paused);
          });
          break;
      }
    });
    initFuncs();
  }


  @override
  void dispose() {
    listener.cancel();
    print("listener cancelled");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    print("Inside life cycle check ${state}");

    if(state == AppLifecycleState.paused){
      // showDialog(context: Get.context!, builder: (BuildContext context){
      //   return AlertDialog(
      //     title: Text('App Paused'),
      //     content: Text('The app is paused.'),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.pop(context),
      //         child: Text('OK'),
      //       ),
      //     ],
      //   );
      // });
      // Get.dialog(
      //   AlertDialog(
      //     title: Text('Paused'),
      //     content: Text('The app is paused.'),
      //     actions: [
      //       Obx((){
      //         return TextButton(
      //           onPressed: isPaused.value ? (){
      //             print("hi");
      //           } : null,
      //           child: Text('OK'),
      //         );
      //       }),
      //     ],
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quickfood BikerMobile',
        theme: UIConstant.lightTheme,
        darkTheme: UIConstant.darkTheme,
        themeMode: ThemeService().theme,
        // locale: LanguageService().locale,
        // translations: LanguageKeyStrings(),
        initialRoute: RouteHelper.getSplashPage(),
        getPages: RouteHelper.routes,
      ),
    );
  }


}
