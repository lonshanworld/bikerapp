import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../main.dart';

class FirebaseNotiController extends GetxController{

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late StreamSubscription<RemoteMessage> streamSubscription;

  // final RxString orderitem = "".obs;

  firebaseNotiInit()async{
    await firebaseMessaging.getInitialMessage();
    await firebaseMessaging.subscribeToTopic("android");

    streamSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      print(firebaseMessaging.app);
      await notiController.showNotification(
          remoteMessage: message
      );
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }
}