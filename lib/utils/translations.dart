import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello World',
      'welcome': 'Welcome',
      'recommendation': 'Recommendation',
      'categories': 'Categories',
      'search_cocktail_hint': 'Search cocktail',
      'ingredients': 'Ingredients',
      'see_all_ingredients': 'See all ingredients',
    },
    'de_DE': {
      'hello': 'Hallo Welt',
      'welcome': 'Willkommen',
      'recommendation': 'Empfehlung',
      'categories': 'Kategorien',
      'search_cocktail_hint': 'Cocktail suchen',
      'ingredients': 'Zutaten',
      'see_all_ingredients': 'Alle Zutaten anzeigen',
    },
    'fr_FR': {
      'hello': 'Bonjour monde',
      'welcome': 'Bienvenue',
      'recommendation': 'Recommendation',
      'categories': 'Catégories',
      'search_cocktail_hint': 'Rechercher un cocktail',
      'ingredients': 'Ingrédients',
      'see_all_ingredients': 'Voir tous les ingrédients',
    },
  };
}