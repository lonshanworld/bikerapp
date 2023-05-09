import "package:delivery/controllers/cameraImage_controller.dart";
import "package:delivery/controllers/check_in_out_controller.dart";
import "package:delivery/controllers/clearance_controller.dart";
import "package:delivery/controllers/location_controller.dart";
import "package:delivery/controllers/order_controller.dart";
import "package:delivery/controllers/schedule_controller.dart";
import "package:delivery/controllers/signalr_controller.dart";
import "package:delivery/controllers/useraccount_controller.dart";
import "package:delivery/db/db_service.dart";
import "package:delivery/services/useraccount_service.dart";
import "package:get/get.dart";

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