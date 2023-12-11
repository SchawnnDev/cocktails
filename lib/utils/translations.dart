import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello World',
      'welcome': 'Welcome',
      'recommendation': 'Recommendation',
      'categories': 'Categories',
    },
    'de_DE': {
      'hello': 'Hallo Welt',
      'welcome': 'Willkommen',
      'recommendation': 'Empfehlung',
      'categories': 'Kategorien',
    },
    'fr_FR': {
      'hello': 'Bonjour monde',
      'welcome': 'Bienvenue',
      'recommendation': 'Recommendation',
      'categories': 'Catégories',
    },
  };
}