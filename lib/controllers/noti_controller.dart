import 'dart:convert';
import 'dart:io';

import 'package:delivery/constants/txtconstants.dart';
import 'package:delivery/controllers/schedule_controller.dart';
import 'package:delivery/services/noti_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../models/noti_model.dart';

class NotiController extends GetxController{
  final NotiService service = NotiService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final ScheduleController scheduleController = Get.isRegistered<ScheduleController>() ? Get.find<ScheduleController>() : Get.put(ScheduleController());

  final RxList<RandomNotiModel> notiList = List<RandomNotiModel>.empty().obs;
  final RxList<NotiOrderModel> notiListByAlert = List<NotiOrderModel>.empty().obs;
  final RxList<NotiOrderModel> notiListByshowFlag = List<NotiOrderModel>.empty().obs;
  
  final box = GetStorage();

  Future<void>initController()async{
    await getAllNotis();
    await getAllNotisByAlert();
    await getAllNotisByshowFlag();
  }

  Future<void>getAllNotis()async{
    List<Map<String,dynamic>> _values = await service.getAllNotis();
    notiList.assignAll(_values.map((e) {
      RandomNotiModel randomNotiModel = new RandomNotiModel(
        title: e["notiTitle"],
        body: e["notiBody"],
        date: e["detailDate"],
      );
      return randomNotiModel;
    }).toList());
    // notiList.assignAll(_values.map((e) {
    //   NotiOrderModel _notimodel = new NotiOrderModel();
    //   _notimodel.title = e["notiTitle"];
    //   _notimodel.body = e["notiBody"];
    //   _notimodel.date = e["Date"];
    //   _notimodel.type = e["NotiType"];
    //   _notimodel.showFlag = e["showFlag"];
    //   if(e["notiData"] == null){
    //     _notimodel.notiBodyModel = null;
    //   }else{
    //     var data = json.decode(e["notiData"]);
    //     _notimodel.notiBodyModel = NotiBodyModel(
    //       orderTitle: data["orderTitle"],
    //       orderId: data["orderId"],
    //       refNo: data["refNo"],
    //       earning: data["earning"],
    //       shopName: data["shopName"],
    //       lat: data["lat"],
    //       long: data["long"],
    //       photo: data["photo"],
    //       distanceMeter: data["distanceMeter"],
    //       type: data["type"],
    //     );
    //   }
    //   print(_notimodel.showFlag);
    //   return _notimodel;
    // }).toList());
  }

  Future<void>getAllNotisByAlert()async{
    List<Map<String,dynamic>> _values = await service.getAllNotisByAlert();
    notiListByAlert.assignAll(_values.map((e) {
      NotiOrderModel _notimodel = new NotiOrderModel();
      _notimodel.title = e["notiTitle"];
      _notimodel.body = e["notiBody"];
      _notimodel.date = e["detailDate"];
      _notimodel.type = e["NotiType"];
      _notimodel.showFlag = e["showFlag"];
      var data = json.decode(e["notiData"]);
      _notimodel.notiBodyModel = NotiBodyModel(
        orderTitle: data["orderTitle"],
        orderId: data["orderId"],
        refNo: data["refNo"],
        earning: data["earning"],
        shopName: data["shopName"],
        lat: data["lat"],
        long: data["long"],
        photo: data["photo"],
        distanceMeter: data["distanceMeter"],
        type: data["type"],
      );
      // print(_notimodel.title);
      return _notimodel;
    }).toList());
  }

  Future<void>getAllNotisByshowFlag()async{
    List<Map<String,dynamic>> _values = await service.getAllNotisByshowFlag();
    notiListByshowFlag.assignAll(_values.map((e) {
      NotiOrderModel _notimodel = new NotiOrderModel();
      _notimodel.title = e["notiTitle"];
      _notimodel.body = e["notiBody"];
      _notimodel.date = e["detailDate"];
      _notimodel.type = e["NotiType"];
      _notimodel.showFlag = e["showFlag"];
      var data = json.decode(e["notiData"]);
      _notimodel.notiBodyModel = NotiBodyModel(
        orderTitle: data["orderTitle"],
        orderId: data["orderId"],
        refNo: data["refNo"],
        earning: data["earning"],
        shopName: data["shopName"],
        lat: data["lat"],
        long: data["long"],
        photo: data["photo"],
        distanceMeter: data["distanceMeter"],
        type: data["type"],
      );
      // print(_notimodel.title);
      return _notimodel;
    }).toList());
  }

  Future<void>updateshowFlag(String orderId)async{
    await service.updateshowFlag(orderId);
    await initController();
  }

  Future<void>addNotiData({required NotiOrderModel notiModel})async{
    print("noti data is added");
    await service.addNotiData(notimodel: notiModel);
    await initController();
  }

  Future<void>addRandomNoti(RandomNotiModel randomNotiModel) async{
    await service.insertRandomNoti(randomNotiModel);
    await initController();
  }

  Future<void>deleteAll()async{
    await service.deleteAll();
    await initController();
  }

  Future<void>initialize() async {
    var androidInitialize = AndroidInitializationSettings("mipmap/ic_launcher");
    var iosInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );
    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,

    );
  }

  Future<void>requestNotiPermission()async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true,
      );
    } else if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
  }



  @pragma('vm:entry-point')
  Future<void> showNotification({
    required RemoteMessage remoteMessage,
  })async{
    AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
      "Youcannameidwhatever",
      "This is for channal name",
      channelDescription: "This is channel description",
      playSound : true,
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );

    DarwinNotificationDetails _iOSNotificationDetail = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var notidetails = NotificationDetails(
      android: _androidNotificationDetails,
      iOS: _iOSNotificationDetail,
    );

    // await flutterLocalNotificationsPlugin.show(0, remoteMessage.notification!.title, remoteMessage.notification!.body, notidetails);
    print("checking noti data ----------------------------------------------------");
    print(remoteMessage.data);
    // print("This is checking noti ${remoteMessage.data["type"]}");
    if(remoteMessage.data.containsKey("type")){
      print("This contain key");
      if(remoteMessage.data["type"].toString().toLowerCase().trim() == "orderpickedup"){
        // print("the type is orderpickedup");
        // NotiOrderModel notiData = NotiOrderModel();
        // notiData.title = remoteMessage.notification?.title;
        // // var jsonbodydata = json.decode(_notificationInfo!.body);
        // notiData.body = remoteMessage.notification?.body;
        // notiData.notiBodyModel = NotiBodyModel(
        //   orderTitle: notiData.title!,
        //   orderId: remoteMessage.data["orderId"].toString(),
        //   refNo: remoteMessage.data["refNo"].toString(),
        //   earning: int.parse(remoteMessage.data["earning"]),
        //   shopName: remoteMessage.data["shopName"].toString(),
        //   lat: double.parse(remoteMessage.data["lat"]),
        //   long: double.parse(remoteMessage.data["long"]),
        //   photo: remoteMessage.data["photo"],
        //   distanceMeter: double.parse(remoteMessage.data["distanceMeter"]),
        //   type: remoteMessage.data["type"].toString().toLowerCase(),
        // );
        // String _date = DateFormat("y-MMM-d").format(DateTime.now());
        // notiData.date = _date;
        // notiData.type =  remoteMessage.data["type"];
        // print(notiData.notiBodyModel?.type);
        //
        // updateshowFlag(notiData.notiBodyModel!.orderId!);

        // RandomNotiModel randomNotiModel = RandomNotiModel(
        //   title: remoteMessage.notification!.title!,
        //   body: remoteMessage.notification!.body!,
        //   date: DateFormat("y-MMM-d").format(DateTime.now()),
        // );
        print('This is order pick up noti ----- ${remoteMessage.data["type"].toString().trim()}');
        if(remoteMessage.data["bikerId"].toString() != box.read(TxtConstant.user_id)){
          await flutterLocalNotificationsPlugin.show(0, remoteMessage.notification!.title, remoteMessage.notification!.body, notidetails);
        }
        updateshowFlag(remoteMessage.data["orderId"].toString().trim());


      }else if(remoteMessage.data["type"].toString().toLowerCase().trim() == "ordercancel"){
        await flutterLocalNotificationsPlugin.show(0, remoteMessage.notification!.title, remoteMessage.notification!.body, notidetails);
        updateshowFlag(remoteMessage.data["orderId"].toString().trim());
        // if(remoteMessage.data["bikerId"].toString() != box.read(TxtConstant.user_id)){
        //
        // }
      }else if(remoteMessage.data["type"].toString().toLowerCase().trim() == "orderalert"){
        await flutterLocalNotificationsPlugin.show(0, remoteMessage.notification!.title, remoteMessage.notification!.body, notidetails);
        print("the type is order alert");
        NotiOrderModel notiData = NotiOrderModel();
        notiData.title = remoteMessage.notification?.title;
        // var jsonbodydata = json.decode(_notificationInfo!.body);
        notiData.body = remoteMessage.notification?.body;
        notiData.notiBodyModel = NotiBodyModel(
          orderTitle: notiData.title!,
          orderId: remoteMessage.data["orderId"].toString(),
          refNo: remoteMessage.data["refNo"].toString(),
          earning: int.parse(remoteMessage.data["earning"]),
          shopName: remoteMessage.data["shopName"].toString(),
          lat: double.parse(remoteMessage.data["lat"]),
          long: double.parse(remoteMessage.data["long"]),
          photo: remoteMessage.data["photo"],
          distanceMeter: double.parse(remoteMessage.data["distanceMeter"]),
          type: remoteMessage.data["type"].toString().toLowerCase(),
        );
        String _date = DateFormat("y-MMM-d H:mm a").format(DateTime.now());
        notiData.date = _date;
        notiData.type =  remoteMessage.data["type"];
        print(notiData.notiBodyModel?.type);

        notiData.showFlag = "true";
        print("This is in orderalert type");
        print(notiData);
        addNotiData(notiModel: notiData);
        print(notiListByshowFlag.length);

      }else if(remoteMessage.data["type"].toString().toLowerCase().trim() == "schedule"){
        await flutterLocalNotificationsPlugin.show(0, remoteMessage.notification!.title, remoteMessage.notification!.body, notidetails);
        print("This is inside schedule");
        RandomNotiModel randomNotiModel = RandomNotiModel(
          title: remoteMessage.notification!.title!,
          body: remoteMessage.notification!.body!,
          date: DateFormat("y-MMM-d H:mm a").format(DateTime.now()),
        );
        addRandomNoti(randomNotiModel);
        await scheduleController.scheduleReload();
      }else{
        await flutterLocalNotificationsPlugin.show(0, remoteMessage.notification!.title, remoteMessage.notification!.body, notidetails);
        print("has key but no type");
        RandomNotiModel randomNotiModel = RandomNotiModel(
          title: remoteMessage.notification!.title!,
          body: remoteMessage.notification!.body!,
          date: DateFormat("y-MMM-d H:mm a").format(DateTime.now()),
        );
        addRandomNoti(randomNotiModel);
        // await scheduleController.scheduleReload();
      }
    }else{
      await flutterLocalNotificationsPlugin.show(0, remoteMessage.notification!.title, remoteMessage.notification!.body, notidetails);

      print("no key");
      RandomNotiModel randomNotiModel = RandomNotiModel(
        title: remoteMessage.notification!.title!,
        body: remoteMessage.notification!.body!,
        date: DateFormat("y-MMM-d H:mm a").format(DateTime.now()),
      );
      addRandomNoti(randomNotiModel);
      // await scheduleController.scheduleReload();
    }

  }


  Future<void> showNotiwithoutFunc({
    required RemoteMessage remoteMessage,
  })async{
    AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
      "Youcannameidwhatever",
      "This is for channal name",
      channelDescription: "This is channel description",
      playSound : true,
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );

    DarwinNotificationDetails _iOSNotificationDetail = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var notidetails = NotificationDetails(
      android: _androidNotificationDetails,
      iOS: _iOSNotificationDetail,
    );

    await flutterLocalNotificationsPlugin.show(0, remoteMessage.notification!.title, remoteMessage.notification!.body, notidetails);
  }

  Future<void> showNotiforChat({
    required String sender,
    required String text,
  })async{
    AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
      "Youcannameidwhatever",
      "This is for channal name",
      channelDescription: "This is channel description",
      playSound : true,
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );

    DarwinNotificationDetails _iOSNotificationDetail = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var notidetails = NotificationDetails(
      android: _androidNotificationDetails,
      iOS: _iOSNotificationDetail,
    );

    await flutterLocalNotificationsPlugin.show(0, sender, text, notidetails);
  }
  // @pragma('vm:entry-point')
  // Future<void> showNotificationforBackground({
  //   required RemoteMessage remoteMessage
  // })async{
  //   AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
  //     "Youcannameidwhatever",
  //     "This is for channal name",
  //     channelDescription: "This is channel description",
  //     playSound : true,
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     enableVibration: true,
  //   );
  //
  //   DarwinNotificationDetails _iOSNotificationDetail = DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );
  //
  //   var notidetails = NotificationDetails(
  //     android: _androidNotificationDetails,
  //     iOS: _iOSNotificationDetail,
  //   );
  //   await flutterLocalNotificationsPlugin.show(0, remoteMessage.notification!.title, remoteMessage.notification!.body, notidetails);
  //   // if(remoteMessage.data.containsKey("type")){
  //   //   print("This contain key");
  //   //   if(remoteMessage.data["type"].toLowerCase() == "orderpickedup"){
  //   //     print("the type is orderpickedup");
  //   //     NotiOrderModel notiData = NotiOrderModel();
  //   //     notiData.title = remoteMessage.notification?.title;
  //   //     // var jsonbodydata = json.decode(_notificationInfo!.body);
  //   //     notiData.body = remoteMessage.notification?.body;
  //   //     notiData.notiBodyModel = NotiBodyModel(
  //   //       orderTitle: notiData.title!,
  //   //       orderId: remoteMessage.data["orderId"].toString(),
  //   //       refNo: remoteMessage.data["refNo"].toString(),
  //   //       earning: int.parse(remoteMessage.data["earning"]),
  //   //       shopName: remoteMessage.data["shopName"].toString(),
  //   //       lat: double.parse(remoteMessage.data["lat"]),
  //   //       long: double.parse(remoteMessage.data["long"]),
  //   //       photo: remoteMessage.data["photo"],
  //   //       distanceMeter: double.parse(remoteMessage.data["distanceMeter"]),
  //   //       type: remoteMessage.data["type"].toString().toLowerCase(),
  //   //     );
  //   //     String _date = DateFormat("y-MMM-d").format(DateTime.now());
  //   //     notiData.date = _date;
  //   //     notiData.type =  remoteMessage.data["type"];
  //   //     print(notiData.notiBodyModel?.type);
  //   //
  //   //     updateshowFlag(notiData.notiBodyModel!.orderId!);
  //   //   }else if(remoteMessage.data["type"].toLowerCase() == "orderalert"){
  //   //     print("the type is order alert");
  //   //     NotiOrderModel notiData = NotiOrderModel();
  //   //     notiData.title = remoteMessage.notification?.title;
  //   //     // var jsonbodydata = json.decode(_notificationInfo!.body);
  //   //     notiData.body = remoteMessage.notification?.body;
  //   //     notiData.notiBodyModel = NotiBodyModel(
  //   //       orderTitle: notiData.title!,
  //   //       orderId: remoteMessage.data["orderId"].toString(),
  //   //       refNo: remoteMessage.data["refNo"].toString(),
  //   //       earning: int.parse(remoteMessage.data["earning"]),
  //   //       shopName: remoteMessage.data["shopName"].toString(),
  //   //       lat: double.parse(remoteMessage.data["lat"]),
  //   //       long: double.parse(remoteMessage.data["long"]),
  //   //       photo: remoteMessage.data["photo"],
  //   //       distanceMeter: double.parse(remoteMessage.data["distanceMeter"]),
  //   //       type: remoteMessage.data["type"].toString().toLowerCase(),
  //   //     );
  //   //     String _date = DateFormat("y-MMM-d").format(DateTime.now());
  //   //     notiData.date = _date;
  //   //     notiData.type =  remoteMessage.data["type"];
  //   //     print(notiData.notiBodyModel?.type);
  //   //
  //   //     notiData.showFlag = "true";
  //   //     print("This is in orderalert typpe");
  //   //     print(notiData);
  //   //     addNotiData(notiModel: notiData);
  //   //     print(notiListByshowFlag.length);
  //   //   }else{
  //   //     print("has key but no type");
  //   //     RandomNotiModel randomNotiModel = RandomNotiModel(
  //   //       title: remoteMessage.notification!.title!,
  //   //       body: remoteMessage.notification!.body!,
  //   //       date: DateTime.now().toString(),
  //   //     );
  //   //     addRandomNoti(randomNotiModel);
  //   //     await scheduleController.scheduleReload();
  //   //   }
  //   // }else{
  //   //   print("no key");
  //   //   RandomNotiModel randomNotiModel = RandomNotiModel(
  //   //     title: remoteMessage.notification!.title!,
  //   //     body: remoteMessage.notification!.body!,
  //   //     date: DateTime.now().toString(),
  //   //   );
  //   //   addRandomNoti(randomNotiModel);
  //   //   await scheduleController.scheduleReload();
  //   // }
  // }




}