import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/txtconstants.dart';

class ThemeService {
  final _storagebox = GetStorage();
  final _key = TxtConstant.theme;

  bool _loadThemeFromStoragebox() => _storagebox.read(_key) ?? false;

  _saveThemeToStorageBox(bool isDarkMode) =>
      _storagebox.write(_key, isDarkMode);

  ThemeMode get theme =>
      _loadThemeFromStoragebox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    // _saveThemeToStorageBox(!_loadThemeFromStoragebox());
    if(_storagebox.read(_key) == null || _storagebox.read(_key) == false){
      _saveThemeToStorageBox(true);
      Get.changeThemeMode(ThemeMode.dark);
    }else{
      _saveThemeToStorageBox(false);
      Get.changeThemeMode(ThemeMode.light);
    }
    // Get.changeThemeMode(_loadThemeFromStoragebox() ? ThemeMode.dark : ThemeMode.light);
  }

}