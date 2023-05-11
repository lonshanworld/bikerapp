import "dart:async";

import "package:delivery/controllers/cameraImage_controller.dart";
import "package:delivery/controllers/check_in_out_controller.dart";
import "package:delivery/controllers/clearance_controller.dart";
import "package:delivery/controllers/location_controller.dart";
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/controllers/schedule_controller.dart";
import "package:delivery/controllers/signalr_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/db/db_service.dart";
import "package:delivery/error_handlers/error_handlers.dart";
import "package:delivery/services/useraccount_service.dart";

import 'package:flutter/material.dart';
import "package:get/get.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";

import "controllers/noti_controller.dart";

class GlobalBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.isRegistered<UserAccountController>() ? Get.find<UserAccountController>() : Get.put(UserAccountController(), permanent: true);
    Get.isRegistered<ScheduleController>() ? Get.find<ScheduleController>() : Get.put(ScheduleController(),permanent: true);
    Get.isRegistered<NotiController>() ? Get.find<NotiController>() : Get.put(NotiController(),permanent: true);
    Get.isRegistered<OrderController>() ? Get.find<OrderController>() : Get.put(OrderController(),permanent: true);

    Get.isRegistered<CheckInOutController>() ? Get.find<CheckInOutController>() : Get.put(CheckInOutController(),permanent: true);
    // Get.isRegistered<LocationController>() ? Get.find<LocationController>() : Get.put(LocationController(),permanent: true);
    Get.isRegistered<SignalRController>() ? Get.find<SignalRController>() : Get.put(SignalRController(),permanent: true);

    Get.isRegistered<ClearanceController>() ? Get.find<ClearanceController>() : Get.put(ClearanceController(),permanent: true);
  }
}



class LifeCycleController extends SuperController{
  //
  // late StreamSubscription<InternetConnectionStatus> listener;
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   WidgetsBinding.instance.addObserver(this);
  //   listener = InternetConnectionChecker().onStatusChange.listen((status) {
  //     switch (status) {
  //       case InternetConnectionStatus.connected:
  //         print('Data connection is available.');
  //         print("The app is paused");
  //         WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.paused);
  //         print("This is after paused");
  //         break;
  //       case InternetConnectionStatus.disconnected:
  //         print('You are disconnected from the internet.');
  //
  //         break;
  //     }
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   listener.cancel();
  //   super.dispose();
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // Show your dialog here.
  //     Get.dialog(
  //       AlertDialog(
  //         title: Text('Dialog Title'),
  //         content: Text('Dialog Content'),
  //       ),
  //     );
  //   }
  // }

  @override
  void onDetached() {
    // TODO: implement onDetached
    print("-----------------------------------------------on Detached-----------------------------------------------------------");
    Get.isRegistered<UserAccountController>() ? Get.find<UserAccountController>() : Get.put(UserAccountController(), permanent: true);
    Get.isRegistered<ScheduleController>() ? Get.find<ScheduleController>() : Get.put(ScheduleController(),permanent: true);
    Get.isRegistered<NotiController>() ? Get.find<NotiController>() : Get.put(NotiController(),permanent: true);
    Get.isRegistered<OrderController>() ? Get.find<OrderController>() : Get.put(OrderController(),permanent: true);

    Get.isRegistered<CheckInOutController>() ? Get.find<CheckInOutController>() : Get.put(CheckInOutController(),permanent: true);
    // Get.isRegistered<LocationController>() ? Get.find<LocationController>() : Get.put(LocationController(),permanent: true);
    Get.isRegistered<SignalRController>() ? Get.find<SignalRController>() : Get.put(SignalRController(),permanent: true);

    Get.isRegistered<ClearanceController>() ? Get.find<ClearanceController>() : Get.put(ClearanceController(),permanent: true);

  }

  @override
  void onInactive() {
    // TODO: implement onInactive
    print("-----------------------------------------------on Inactive-----------------------------------------------------------");
    Get.isRegistered<UserAccountController>() ? Get.find<UserAccountController>() : Get.put(UserAccountController(), permanent: true);
    Get.isRegistered<ScheduleController>() ? Get.find<ScheduleController>() : Get.put(ScheduleController(),permanent: true);
    Get.isRegistered<NotiController>() ? Get.find<NotiController>() : Get.put(NotiController(),permanent: true);
    Get.isRegistered<OrderController>() ? Get.find<OrderController>() : Get.put(OrderController(),permanent: true);

    Get.isRegistered<CheckInOutController>() ? Get.find<CheckInOutController>() : Get.put(CheckInOutController(),permanent: true);
    // Get.isRegistered<LocationController>() ? Get.find<LocationController>() : Get.put(LocationController(),permanent: true);
    Get.isRegistered<SignalRController>() ? Get.find<SignalRController>() : Get.put(SignalRController(),permanent: true);

    Get.isRegistered<ClearanceController>() ? Get.find<ClearanceController>() : Get.put(ClearanceController(),permanent: true);
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
    print("-----------------------------------------------on Paused-----------------------------------------------------------");
    Get.isRegistered<UserAccountController>() ? Get.find<UserAccountController>() : Get.put(UserAccountController(), permanent: true);
    Get.isRegistered<ScheduleController>() ? Get.find<ScheduleController>() : Get.put(ScheduleController(),permanent: true);
    Get.isRegistered<NotiController>() ? Get.find<NotiController>() : Get.put(NotiController(),permanent: true);
    Get.isRegistered<OrderController>() ? Get.find<OrderController>() : Get.put(OrderController(),permanent: true);

    Get.isRegistered<CheckInOutController>() ? Get.find<CheckInOutController>() : Get.put(CheckInOutController(),permanent: true);
    // Get.isRegistered<LocationController>() ? Get.find<LocationController>() : Get.put(LocationController(),permanent: true);
    Get.isRegistered<SignalRController>() ? Get.find<SignalRController>() : Get.put(SignalRController(),permanent: true);

    Get.isRegistered<ClearanceController>() ? Get.find<ClearanceController>() : Get.put(ClearanceController(),permanent: true);
    // errorHandler.handleNoConnectionError(() {
    //   if(status == InternetConnectionStatus.connected){
    //     WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    //   }else{
    //
    //   }
    // });
    // Get.dialog(
    //   AlertDialog(
    //     title: Text('Paused'),
    //     content: Text('The app is paused.'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => print("Hi"),
    //         child: Text('OK'),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
    print("-----------------------------------------------on Resumed-----------------------------------------------------------");
    Get.isRegistered<UserAccountController>() ? Get.find<UserAccountController>() : Get.put(UserAccountController(), permanent: true);
    Get.isRegistered<ScheduleController>() ? Get.find<ScheduleController>() : Get.put(ScheduleController(),permanent: true);
    Get.isRegistered<NotiController>() ? Get.find<NotiController>() : Get.put(NotiController(),permanent: true);
    Get.isRegistered<OrderController>() ? Get.find<OrderController>() : Get.put(OrderController(),permanent: true);

    Get.isRegistered<CheckInOutController>() ? Get.find<CheckInOutController>() : Get.put(CheckInOutController(),permanent: true);
    // Get.isRegistered<LocationController>() ? Get.find<LocationController>() : Get.put(LocationController(),permanent: true);
    Get.isRegistered<SignalRController>() ? Get.find<SignalRController>() : Get.put(SignalRController(),permanent: true);

    Get.isRegistered<ClearanceController>() ? Get.find<ClearanceController>() : Get.put(ClearanceController(),permanent: true);
  }

}