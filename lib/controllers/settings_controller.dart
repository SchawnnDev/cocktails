import 'package:cocktails/models/setting.dart';
import 'package:cocktails/services/boxes_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final _settings = <Setting>[].obs;
  List<Setting> get settings => _settings;

  @override
  void onInit() {
    super.onInit();
    final boxesService = Get.find<BoxesService>();

    _settings([
      Setting(
        boxesService.settingsBox.get('language',
            defaultValue: Get.deviceLocale?.toString() ?? 'en_US'),
        icon: Icons.language,
        values: {'en_US': 'English', 'fr_FR': 'Français', 'de_DE': 'Deutsch'},
        name: 'language',
        onChange: (newValue) {
          var split = newValue.split('_');
          if (split.length != 2) {
            return 'en_US';
          }
          boxesService.settingsBox.put('language', newValue);
          Get.updateLocale(Locale(split[0], split[1]));
          return newValue;
        },
      ),
      Setting(
        boxesService.settingsBox.get('theme', defaultValue: 'system'),
        icon: Icons.brightness_6,
        values: {'light': 'Light', 'dark': 'Dark', 'system': 'System'},
        name: 'theme',
        onChange: (newValue) {
          boxesService.settingsBox.put('theme', newValue);

          switch (newValue) {
            case 'light':
              Get.changeThemeMode(ThemeMode.light);
              return newValue;
            case 'dark':
              Get.changeThemeMode(ThemeMode.dark);
              return newValue;
              case 'system':
              Get.changeThemeMode(ThemeMode.system);
              return newValue;
          }
          
          return newValue;
        },
      ),
    ]);
  }

  Setting? getSetting(String name) {
    return _settings.firstWhereOrNull((element) => element.name == name);
  }

  void setSetting(String name, String value) {
    final setting = getSetting(name);
    if (setting != null) {
      setting.setValue(value);
    }
  }

  Locale getLocale() {
    final setting = getSetting('language');
    if (setting != null) {
      var split = setting.getValue().split('_');
      if (split.length == 2) {
        return Locale(split[0], split[1]);
      }
    }
    return const Locale('en', 'US');
  }

}