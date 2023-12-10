import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello World',
      'welcome': 'Welcome',
    },
    'de_DE': {
      'hello': 'Hallo Welt',
      'welcome': 'willkommen',
    },
    'fr_FR': {
      'hello': 'Bonjour monde',
      'welcome': 'Bienvenue',
    },
  };
}