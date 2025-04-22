// theme_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  var box = GetStorage();

  RxBool isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    bool storedDark = box.read("isDark") ?? false;
    isDark.value = storedDark;
    themeMode.value = storedDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleReactiveTheme(bool val) {
    isDark.value = val;
    themeMode.value = val ? ThemeMode.dark : ThemeMode.light;
    box.write('isDark', isDark.value);
  }
}
