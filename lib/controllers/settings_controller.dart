import 'package:cocktails/models/setting.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/services/boxes_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final _settings = <Setting>[].obs;

  List<Setting> get settings => _settings;

  RxBool measureInOz = true.obs;

  @override
  void onInit() {
    super.onInit();
    final boxesService = Get.find<BoxesService>();

    _settings([
      Setting(
        boxesService.settingsBox.get('language',
            defaultValue: Get.deviceLocale?.toString() ?? 'en_US'),
        icon: Icons.language,
        values: {'en_US': 'en_US', 'fr_FR': 'fr_FR', 'de_DE': 'de_DE'},
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
      Setting(
        boxesService.settingsBox.get('measurementUnit', defaultValue: 'oz'),
        icon: Icons.precision_manufacturing,
        values: {'oz': 'Ounces', 'ml': 'Milliliters'},
        name: 'measurementUnit',
        onChange: (newValue) {
          boxesService.settingsBox.put('measurementUnit', newValue);
          measureInOz(newValue == 'oz');
          return newValue;
        },
      ),
      Setting('click_reset_favorites',
          icon: Icons.favorite_outline,
          values: {},
          name: 'reset_favorites', onTap: (BuildContext ctx) async {
        bool result = await showAlertDialog(
          ctx,
          'reset_favorites'.tr,
          'are_you_sure_reset'.tr,
        );

        if (!result) {
          return;
        }

        final dataProvider = Get.find<PersistentDataProvider>();
        dataProvider.clearFavorites();
      }),
      Setting('click_reset_dislikes',
          icon: Icons.thumb_down_outlined,
          values: {},
          name: 'reset_dislikes', onTap: (BuildContext ctx) async {
        bool result = await showAlertDialog(
          ctx,
          'reset_dislikes'.tr,
          'are_you_sure_reset'.tr,
        );

        if (!result) {
          return;
        }

        final dataProvider = Get.find<PersistentDataProvider>();
        dataProvider.clearDislikes();
      }),
      Setting('click_reset_all',
          icon: Icons.restart_alt_outlined,
          values: {},
          name: 'reset_all', onTap: (BuildContext ctx) async {
        bool result = await showAlertDialog(
          ctx,
          'reset_all'.tr,
          'are_you_sure_reset'.tr,
        );

        if (!result) {
          return;
        }

        final dataProvider = Get.find<PersistentDataProvider>();
        dataProvider.clearAll();
      }),
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

  ThemeMode getThemeMode() {
    final setting = getSetting('theme');
    if (setting != null) {
      switch (setting.getValue()) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
          return ThemeMode.system;
      }
    }
    return ThemeMode.system;
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

  Future<bool> showAlertDialog(
      BuildContext context, String title, String message) async {
    Widget cancelButton = TextButton(
      child: Text("cancel".tr),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("ok".tr),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );

    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title.tr),
          content: Text(message.tr),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );

    return result;
  }
}
