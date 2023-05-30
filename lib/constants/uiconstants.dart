import "dart:ui";

import "package:flutter/material.dart";
import "package:get/get.dart";

class UIConstant{
  // static double screenHeight = Get.context!.height;   // 781
  // static double screenWidth = Get.context!.width;   // 392.7
  //
  // static double oneUnitHeight = screenHeight / 772;
  // static double oneUnitWidth = screenWidth / 360;

  // static const Color orange = Color(0xFFF26600);

  // static const Color orange = Color(0xFFF68C13);
  static const Color orange = Color(0xFFFD680C);

  // static const Color oppositeorange = Color(0xFF0973B9);
  static const Color oppositeorange = Color(0xFF0287C6);

  static const Color pink = Color(0xFFFFEAD1);
  static const Color bgWhite = Color(0xFFF8F8F8);
  static const Color bgDark = Color(0xFF333333);


  // static const Color txtBlack = Colors.black;
  // static const Color txtWhite = Colors.white;
  static const Color secondarytxtClr = Colors.grey;

  static final lightTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.light,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      toolbarHeight: 50,
      centerTitle: true,
      backgroundColor: pink,
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.dark,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      toolbarHeight: 50,
      centerTitle: true,
      backgroundColor: orange,
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static TextStyle maintitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    // color: txtClr,
  );

  static TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    // color: txtClr,
  );

  static TextStyle minititle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    // color: txtClr,
  );

  static TextStyle normal = TextStyle(
    fontSize: 14,
    // color: txtClr,
  );

  static TextStyle small = TextStyle(
    fontSize: 12,
  );

  static TextStyle tinytext = TextStyle(
    fontSize: 10,
    // color: secondarytxtClr,
  );
}