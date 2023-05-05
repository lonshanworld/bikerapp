import "package:delivery/views/check_in.dart";
import "package:delivery/views/clerance.dart";
import "package:delivery/views/clerance_history.dart";
import "package:delivery/views/drop_off_screen.dart";
import "package:delivery/views/home_screen.dart";
import "package:delivery/views/login_screen.dart";
import "package:delivery/views/noti_screen.dart";
import "package:delivery/views/orderHistory.dart";
import "package:delivery/views/order_detail_screen.dart";
import "package:delivery/views/order_summary_screen.dart";
import "package:delivery/views/passcode_screen.dart";
import "package:delivery/views/profile_screen.dart";
import "package:delivery/views/punishments_screen.dart";
import "package:delivery/views/qr_screen.dart";
import "package:delivery/views/schedule/schedule_tabbar.dart";
import "package:delivery/views/splash_screen.dart";
import "package:get/get.dart";

extension on String{
  bool toBoolean(){
    print(this);
    String str = toString();
    if(str.toLowerCase() == "false"){
      return false;
    }else{
      return true;
    }
  }
}

class RouteHelper{
  static const String SplashPage = "/splash";
  static const String LoginPage = "/login";
  static const String PasscodePage = "/passcode";
  static const String HomePage = "/";
  static const String OrderDetailPage = "/orderdetail";
  static const String CheckInPage = "/checkin";
  static const String profilePage = "/profile";
  static const String PunishmentPage = "/punishment";
  static const String OrderHistory = "/orderHistory";
  static const String Notification = "/notification";
  static const String QrPage = "/qrscreen";
  static const String DropOffpage = "/dropoff";
  static const String OrderSummaryPage = "/ordersummary";
  static const String SchedulePage = "/schedule";
  static const String ClearancePage = "/clearance";
  static const String ClearanceHistoryPage = "/clearanceHistory";

  //---------------
  // static const String ClearancePage = "/clearance";
  // static const String ClearanceHistoryPage = "/clearancehistory";
  // static const String OrderSummaryPage = "/ordersummary?orderId"


  static String getSplashPage() => SplashPage;
  static String getLoginPage() => LoginPage;
  static String getPasscodePage() => PasscodePage;
  static String getHomePage() => HomePage;
  static String getOrderDetailPage({
    required String orderId,
    required bool hasButton,
  }) => '$OrderDetailPage?orderId=$orderId&hasButton=$hasButton';
  static String getCheckInPage() => CheckInPage;
  static String getProfilePage() => profilePage;
  static String getPunishmentPage() => PunishmentPage;
  static String getOrderHistoryPage() => OrderHistory;
  static String getNotiPage() => Notification;
  static String getQrPage({required String orderId}) => "$QrPage?orderId=$orderId";
  static String getDropOffPage({required String orderId}) => "$DropOffpage?orderId=$orderId";
  static String getOrderSummaryPage({required String orderId}) => "$OrderSummaryPage?orderId=$orderId";
  static String getSchedulePage() => SchedulePage;
  static String getClearancePage() => ClearancePage;
  static String getClearanceHistoryPage() => ClearanceHistoryPage;

  static List<GetPage> routes = [
    GetPage(
      name: SplashPage,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: LoginPage,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: PasscodePage,
      page: () => const PasscodeScreen(),
    ),
    GetPage(
      name: HomePage,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: OrderDetailPage,
      page: (){
        var orderId = Get.parameters["orderId"];
        var hasButton = Get.parameters["hasButton"];
        return OrderDetailScreen(orderId: orderId!, hasButton: hasButton!.toBoolean());
      },
    ),
    GetPage(
      name: CheckInPage,
      page: () => const CheckInScreen(),
    ),
    GetPage(
      name: profilePage,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: PunishmentPage,
      page: () => const PunishmentScreen(),
    ),
    GetPage(
      name: OrderHistory,
      page: ()=> const OrderHistoryScreen(),
    ),
    GetPage(
      name: Notification,
      page: () => const NotiScreen(),
    ),
    GetPage(
      name: QrPage,
      page: (){
        var orderId = Get.parameters["orderId"];
        return QRscreen(orderId: orderId!);
      },
    ),
    GetPage(
      name: DropOffpage,
      page: (){
        var orderId = Get.parameters["orderId"];
        return DropOffScreen(orderId: orderId!);
      },
    ),
    GetPage(
      name: OrderSummaryPage,
      page : (){
        var orderId = Get.parameters["orderId"];
        return OrderSummaryScreen(orderId: orderId!);
      }
    ),
    GetPage(
      name: SchedulePage,
      page: () => const ScheduleTabbar(),
    ),
    GetPage(
      name: ClearancePage,
      page: () => const Clerance(),
    ),
    GetPage(
      name: ClearanceHistoryPage,
      page: () => const ClearanceHistory(),
    ),
  ];
}