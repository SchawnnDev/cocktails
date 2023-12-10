import 'dart:ui';

import 'package:cocktails/services/boxes_service.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final storage = Get.find<BoxesService>();
  final RxString locale = Get.locale.toString().obs;

  final Map<String, dynamic> optionsLocales = {
    'en_US': {
      'languageCode': 'en',
      'countryCode': 'US',
      'description': 'English'
    },
    'de_DE': {
      'languageCode': 'de',
      'countryCode': 'DE',
      'description': 'German'
    },
    'fr_FR': {
      'languageCode': 'fr',
      'countryCode': 'FR',
      'description': 'French'
    },
  };

  void updateLocale(String key) {
    final String languageCode = optionsLocales[key]['languageCode'];
    final String countryCode = optionsLocales[key]['countryCode'];
    Get.updateLocale(Locale(languageCode, countryCode));
    locale.value = Get.locale.toString();
    storage.settingsBox.put('languageCode', languageCode);
    storage.settingsBox.put('countryCode', countryCode);
  }
}