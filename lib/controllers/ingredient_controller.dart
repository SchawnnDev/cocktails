import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:get/get.dart';

class IngredientController extends GetxController {
  final _ingredients = <Ingredient>[].obs;
  final currentFilter = Filter.defaultFilter.obs;

  List<Ingredient> get ingredients => _ingredients;

  IngredientController({List<Ingredient>? ingredients}) {
    if (ingredients != null) {
      _ingredients(ingredients);
    }
  }

  /// Load drinks from API
  Future<List<Drink>> loadDrinks(String ingredientName,
      {bool fullLoad = false}) async {
    final dataProvider = Get.find<PersistentDataProvider>();
    final drinks = await Get.find<TheCocktailsDBService>()
        .getDrinksByIngredient(ingredientName);
    // ingredient drinks are incomplete, dont load them all but check in cache
    // whether we already have them
    final result = drinks.drinks;
    if (result == null) {
      return [];
    }

    // enrich with cached data
    dataProvider.getDrinksByIngredient(ingredientName).forEach((element) {
      if (!result.any((element) => element.idDrink == element.idDrink)) {
        result.add(element);
      }
    });

    if (fullLoad) {
      final fullDrinks = <Drink>[];
      // load all drinks
      for (var element in result) {
        final drink = await dataProvider.getDrink(element.idDrink);
        fullDrinks.add(drink ?? element);
      }
      return fullDrinks;
    }

    return result.map((e) {
      return dataProvider.findDrink(e.idDrink) ?? e;
    }).toList();
  }

  /// Find ingredient by name in URL
  Ingredient? findIngredient() {
    var ingredientName = Get.parameters['ingredient_name'];

    if (ingredientName == null) {
      return null;
    }

    ingredientName = Uri.decodeComponent(ingredientName);

    // TODO: we should not only search in the cache but also search in API

    return _ingredients
        .firstWhereOrNull((element) => element.name == ingredientName);
  }
}
