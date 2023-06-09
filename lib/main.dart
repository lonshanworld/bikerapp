import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:delivery/constants/txtconstants.dart';
import 'package:delivery/controllers/firebasenotiController.dart';
import 'package:delivery/controllers/location_controller.dart';
import 'package:delivery/controllers/noti_controller.dart';
import 'package:delivery/controllers/schedule_controller.dart';
import 'package:delivery/controllers/signalr_controller.dart';
import 'package:delivery/db/db_service.dart';
import 'package:delivery/error_handlers/error_handlers.dart';

import 'package:delivery/routehelper.dart';
import 'package:delivery/services/language_service.dart';

import 'package:delivery/services/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


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

// final NotiController notiController = Get.isRegistered<NotiController>() ? Get.find<NotiController>() : Get.put(NotiController());

@pragma('vm:entry-point')
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message)async{
  await GetStorage.init();
  GlobalBindings().dependencies();
  print('This is background message listen ----------------------------------------------------------------------------');
  await DBservices.initDB();
  print("backgroundMessage ${message.notification?.title}");
  final NotiController notiController = Get.isRegistered<NotiController>() ? Get.find<NotiController>() : Get.put(NotiController());
  await notiController.showNotification(
    remoteMessage: message,
  );
}

@pragma('vm:entry-point')
onTapNotificationforbackground(NotificationResponse response){
  print("This is in background noti tap");
  print(response);
  if(response.payload == "/punishment"){
    Get.toNamed(RouteHelper.getProfilePage());
  }else{
    print("No route for this message");
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Plugin must be initialized before using
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // Get.put(LifeCycleController());
  await GetStorage.init();
  await DBservices.initDB();

  GlobalBindings().dependencies();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  // This widget is the root of your application.
  final NotiController notiController = Get.isRegistered<NotiController>() ? Get.find<NotiController>() : Get.put(NotiController());

  final FirebaseNotiController firebaseNotiController = Get.put(FirebaseNotiController(),permanent: true);


  late StreamSubscription<InternetConnectionStatus> listener;



  initFuncs()async{
    // await notiController.initController();

    await notiController.requestNotiPermission();
    await notiController.initialize();




    // close listener after 30 seconds, so the program doesn't run forever
    // await Future.delayed(Duration(seconds: 5));
    // await listener.cancel();
    // print("Listener cancelled");
  }

  // firebaseNotiFunc()async{
  //   await firebaseMessaging.getInitialMessage();
  //   await firebaseMessaging.subscribeToTopic("android");
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     print("This is normal message listen...............................................");
  //     print(firebaseMessaging.app);
  //     await notiController.showNotification(
  //         remoteMessage: message
  //     );
  //   });
  //   FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  //
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          Get.back();
          print('Data connection is available.');
          // WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
          break;
        case InternetConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          showDialog(barrierDismissible: false,context: Get.context!, builder: (ctx){
            return WillPopScope(
              onWillPop: ()async=> false,
              child: AlertDialog(
                titlePadding: EdgeInsets.only(
                  top: 20,
                ),
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'No Internet Connection',
                  style: UIConstant.title.copyWith(
                    color: UIConstant.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Container(
                  width: Get.context!.width > 600 ? 300 : 250,
                  height: Get.context!.width > 600 ? 300 : 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/noconnection.gif",
                        ),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: UIConstant.orange,
                    )
                ),
                backgroundColor: UIConstant.bgWhite,
              ),
            );
          });

          // Future.delayed(Duration(seconds: 3),(){
          //   WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.paused);
          // });
          break;
      }
    });
    // listener = InternetConnectionChecker().onStatusChange.listen((status) {
    //   switch (status) {
    //     case InternetConnectionStatus.connected:
    //       Get.back();
    //       print('Data connection is available.');
    //       // WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    //       break;
    //     case InternetConnectionStatus.disconnected:
    //       print('You are disconnected from the internet.');
    //       Get.dialog(
    //         AlertDialog(
    //           title: Text(
    //             'No Internet Connection',
    //             style: UIConstant.title.copyWith(
    //               color: UIConstant.orange,
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //           content: Container(
    //             width: Get.context!.width > 600 ? 400 : 250,
    //             height: Get.context!.width > 600 ? 400 : 250,
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.all(Radius.circular(30)),
    //                 image: DecorationImage(
    //                   image: AssetImage(
    //                     "assets/images/noconnection.gif",
    //                   ),
    //                   fit: BoxFit.cover,
    //                 )
    //             ),
    //           ),
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(8.0),
    //               side: BorderSide(
    //                 color: UIConstant.orange,
    //               )
    //           ),
    //           backgroundColor: Theme.of(Get.context!).brightness == Brightness.dark ? UIConstant.bgDark : UIConstant.bgWhite,
    //         ),
    //         barrierDismissible: false,
    //       );
    //
    //       // Future.delayed(Duration(seconds: 3),(){
    //       //   WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    //       // });
    //       break;
    //   }
    // });
    initFuncs();
    // firebaseNotiFunc();
    firebaseNotiController.firebaseNotiInit();
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
  }

  @override
  Widget build(BuildContext context) {

    // final deviceWidth = MediaQuery.of(context).size.width;



    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quickfood BikerMobile',
      theme: UIConstant.lightTheme,
      darkTheme: UIConstant.darkTheme,
      themeMode: ThemeService().theme,
      locale: LanguageService().locale,
      translations: LanguageKeyStrings(),
      initialRoute: RouteHelper.getSplashPage(),
      getPages: RouteHelper.routes,
    );
  }


}
