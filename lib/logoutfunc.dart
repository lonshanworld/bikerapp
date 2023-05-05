import 'package:delivery/controllers/noti_controller.dart';
import 'package:delivery/controllers/useraccount_controller.dart';
import "package:get/get.dart";

class LogOut{
  final UserAccountController userAccountController = Get.find<UserAccountController>();
  final NotiController notiController = Get.find<NotiController>();

  Future<void> logoutFunc()async{
    userAccountController.Logout();
    notiController.deleteAll();
  }
}