import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/glass.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:cocktails/services/boxes_service.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:get/get.dart';

/// Persistent data provider
///
/// This provider is used to cache data from API
///
/// We have one main drinks list, which is used to cache drinks from API
/// The other lists only contain references to drinks from the main list
/// This is done to avoid duplication of drinks in memory
class PersistentDataProvider {
  List<Drink> _drinks = [];
  List<Category> _categories = [];
  List<Glass> _glasses = [];
  List<Ingredient> _ingredients = [];
  List<String> _alcoholicFilters = [];

  // Getters
  List<Drink> get drinks => _drinks;
  List<Category> get categories => _categories;
  List<Glass> get glasses => _glasses;
  List<String> get alcoholicFilters => _alcoholicFilters;

  final RxBool error = false.obs;
  bool loaded = false;
  bool ingredientsLoaded = false;
  final boxesService = Get.find<BoxesService>();

  /// Load needed data from API
  Future<void> load() async {
    if (loaded) {
      return;
    }
    var cocktailsDBService = Get.find<TheCocktailsDBService>();
    var boxesService = Get.find<BoxesService>();

    try {
      var foundCategories = await cocktailsDBService.getCategories();
      _categories = foundCategories.drinks ?? [];

      var randomDrinks = await cocktailsDBService.getRandomDrinks(15);

      // Add random drinks to cache
      for (var drink in randomDrinks.drinks ?? []) {
        addDrink(drink);
      }

      // load favorites
      await getDrinks(boxesService.favoritesBox.keys.cast<String>().toList());

      // we need to set drinks as recommended
      selectRandomDrinks(10).forEach((element) {
        element.isRecommended = true;
      });

      // load glasses
      await getGlasses();

      loaded = true;
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
  /// And checks for favorites status
  /// And adds listener to favorites status
  void addDrink(Drink drink) {
    if (findDrink(drink.idDrink) != null) {
      return;
    }
    final String idDrink = drink.idDrink!;
    if (boxesService.isFavorite(idDrink)) {
      drink.favorite(true);
    }
    if (boxesService.isDisliked(idDrink)) {
      drink.disliked(true);
    }
    drink.favorite.listen((p0) {
      if (p0) {
        boxesService.addFavorite(idDrink);
      } else {
        boxesService.removeFavorite(idDrink);
      }
    });
    drink.disliked.listen((p0) {
      if (p0) {
        boxesService.addDislike(idDrink);
      } else {
        boxesService.removeDislike(idDrink);
      }
    });
    drink.isFullyLoaded = true;
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
        addDrink(result);
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  /// Search drinks from cache or from API
  Future<List<Drink>> searchDrinks(String what) async {
    var result = <Drink>[];
    var cocktailsDBService = Get.find<TheCocktailsDBService>();

    try {
      var foundDrinks = what.length == 1
          ? await cocktailsDBService.searchDrinksByFirstLetter(what[0])
          : await cocktailsDBService.searchDrinks(what);
      for (var drink in foundDrinks.drinks ?? []) {
        addDrink(drink);
        result.add(drink);
      }
      return result;
    } catch (e) {
      return result;
    }
  }

  /// Get drinks from cache or from API
  Future<List<Drink>> getDrinks(List<String> ids) async {
    var result = <Drink>[];
    for (var id in ids) {
      var drink = await getDrink(id);
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

  /// Get random drinks from cache
  Future<List<Drink>> getRandomDrinks(
      int count, Set<String> idsToExclude) async {
    var result = <Drink>[];
    var cocktailsDBService = Get.find<TheCocktailsDBService>();

    while (result.length < count) {
      var drinks =
          await cocktailsDBService.getRandomDrinks(count - result.length);
      for (Drink drink in drinks.drinks ?? []) {
        if (drink.idDrink == null) continue;
        addDrink(drink); // cache drink
        if (!idsToExclude.contains(drink.idDrink!)) {
          result.add(drink);
        }
      }
    }
    return result;
  }

  /// Get random drinks from cache
  List<Drink> selectRandomDrinks(int count) {
    var result = <Drink>[];
    var random = Random();
    while (result.length < count) {
      var drink = _drinks[random.nextInt(_drinks.length)];
      if (!result.contains(drink)) {
        result.add(drink);
      }
    }
    return result;
  }

  /// Get all alcoholic filters from cache or from API
  Future<List<String>> getAlcoholicFilters() async {
    final cocktailsDBService = Get.find<TheCocktailsDBService>();
    if (_alcoholicFilters.isEmpty) {
      _alcoholicFilters = await cocktailsDBService.getAlcoholicFilters();
    }
    return _alcoholicFilters;
  }

  /// Get all glasses from cache or from API
  Future<List<Glass>> getGlasses() async {
    final cocktailsDBService = Get.find<TheCocktailsDBService>();
    if (_glasses.isEmpty) {
      final glasses = await cocktailsDBService.getGlasses();
      _glasses = glasses.drinks ?? [];
    }
    return _glasses;
  }

  /// Get all ingredients from cache or from API
  Future<List<Ingredient>> getIngredients() async {
    final cocktailsDBService = Get.find<TheCocktailsDBService>();
    if (_ingredients.isEmpty) {
      final ingredients = await cocktailsDBService.getIngredients();
      _ingredients = ingredients.drinks ?? [];
    }
    return _ingredients;
  }

  /// Search ingredients from cache or from API
  Future<List<Ingredient>> searchIngredients(String what) async {
    var cocktailsDBService = Get.find<TheCocktailsDBService>();

    try {
      var foundIngredients = await cocktailsDBService.searchIngredients(what);
      var result = foundIngredients.ingredients ?? [];
      for (var ingredient in result) {
        if (_ingredients.contains(ingredient)){
          continue;
        }
        _ingredients.add(ingredient);
      }
      return result;
    } catch (e) {
      return [];
    }
  }

  /// Get all ingredients from cache
  List<Ingredient> getCachedIngredients() {
    var result = _drinks.map((e) => e.ingredients).expand((element) => element).toList();
    result.addAll(_ingredients);
    return result;
  }

  /// Clear all boxes (resets favorites & dislikes & cache)
  void clearCache() {
    clearDislikes();
    clearFavorites();
    boxesService.clear();
  }

  /// Clear favorites
  void clearFavorites() {
    for (var element in _drinks) {
      element.favorite(false);
    }
    boxesService.favoritesBox.clear();
  }

  /// Clear dislikes
  void clearDislikes() {
    for (var element in _drinks) {
      element.disliked(false);
    }
    boxesService.dislikesBox.clear();
  }

}
