import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/glass.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

class PersistentDataProvider {
  List<Drink> _drinks = [];
  List<Category> categories = [];
  List<Glass> glasses = [];
  List<Ingredient> ingredients = [];
  List<Drink> randomDrinks = [];
  RxBool error = false.obs;

  /// Load needed data from API
  Future<void> load() async {
    var cocktailsDBService = Get.find<TheCocktailsDBService>();

    try {
      var foundCategories = await cocktailsDBService.getCategories();
      categories = foundCategories.drinks ?? [];

      var randomDrinks = await cocktailsDBService.getRandomDrinks(10);
      this.randomDrinks = randomDrinks.drinks ?? [];

      // Add random drinks to cache
      for (var drink in this.randomDrinks) {
        addDrink(drink);
      }

      error(false);
    } catch (e) {
      error(true);
      print(e);
    }
  }

  /// Find drink in cache
  Drink? findDrink(String? id) {
    return id == null
        ? null
        : _drinks.firstWhereOrNull((element) => element.idDrink == id);
  }

  /// Add drink to cache if it doesn't exist
  void addDrink(Drink drink) {
    if (findDrink(drink.idDrink) != null) {
      return;
    }
    _drinks.add(drink);
  }

  /// Get drink from cache or from API
  Future<Drink?> getDrink(String? id) async {
    if (id == null) {
      return null;
    }

    var result = findDrink(id);
    if (result != null) {
      return result;
    }

    var cocktailsDBService = Get.find<TheCocktailsDBService>();

    try {
      result = await cocktailsDBService.getDrink(id);
      if (result != null) {
        _drinks.add(result);
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  /// Get drinks from cache or from API
  Future<List<Drink>> getDrinks(List<Drink> ids) async {
    var result = <Drink>[];
    for (var id in ids) {
      var drink = await getDrink(id.idDrink);
      if (drink != null) {
        result.add(drink);
      }
    }
    return result;
  }

  /// Get drinks from cache by category
  List<Drink> getDrinksByCategory(String category) {
    return _drinks.where((d) => d.strCategory == category).toList();
  }

  /// Get drinks from cache by glass
  List<Drink> getDrinksByGlass(String glass) {
    return _drinks.where((d) => d.strGlass == glass).toList();
  }

  /// Get drinks from cache by ingredient
  List<Drink> getDrinksByIngredient(String ingredient) {
    return _drinks
        .where((d) => d.ingredients.any((i) => i.name == ingredient))
        .toList();
  }

  /// Enrich drinks in category with cache
  List<Drink> enrichCategoryDrinks(String category, List<Drink> drinks) {
    var cachedDrinks = Set<Drink>.from(getDrinksByCategory(category));
    cachedDrinks.addAll(drinks.where((drink) => !cachedDrinks.contains(drink)));
    return cachedDrinks.toList();
  }

  /// Enrich drinks in glass with cache
  List<Drink> enrichGlassDrinks(String glass, List<Drink> drinks) {
    var cachedDrinks = Set<Drink>.from(getDrinksByGlass(glass));
    cachedDrinks.addAll(drinks.where((drink) => !cachedDrinks.contains(drink)));
    return cachedDrinks.toList();
  }

  /// Enrich drinks in ingredient with cache
  List<Drink> enrichIngredientDrinks(String ingredient, List<Drink> drinks) {
    var cachedDrinks = Set<Drink>.from(getDrinksByIngredient(ingredient));
    cachedDrinks.addAll(drinks.where((drink) => !cachedDrinks.contains(drink)));
    return cachedDrinks.toList();
  }
}
