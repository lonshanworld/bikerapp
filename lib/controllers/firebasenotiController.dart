import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../main.dart';
import 'noti_controller.dart';

class FirebaseNotiController extends GetxController{

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late StreamSubscription<RemoteMessage> streamSubscription;
  final NotiController notiController = Get.isRegistered<NotiController>() ? Get.find<NotiController>() : Get.put(NotiController());

  // final RxString orderitem = "".obs;

  firebaseNotiInit()async{
    await firebaseMessaging.getInitialMessage();

    streamSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      print(firebaseMessaging.app);
      await notiController.showNotification(
          remoteMessage: message
      );

    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }
}