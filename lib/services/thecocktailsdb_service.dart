import 'dart:convert';
import 'dart:developer';

import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/drinks.dart';
import 'package:cocktails/models/glass.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:cocktails/models/ingredients.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TheCocktailsDBService extends GetxService {
  final String apiUrl = 'https://www.thecocktaildb.com/api/json/v1/1/';

  Future<TheCocktailsDBService> init() async {
    return this;
  }

  Uri _buildUri(String script) {
    return Uri.parse(apiUrl + script);
  }

  /// Get drinks by category from API
  Future<Drinks<Drink>> getDrinksByCategory(String category) async {
    final response = await http.get(_buildUri('filter.php?c=$category'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Drinks.fromJson(data, (json) => Drink.fromJson(json));
    } else {
      return Future.error('Failed to load drinks');
    }
  }

  /// Get drinks by ingredient from API
  Future<Drinks<Drink>> getDrinksByIngredient(String ingredient) async {
    final response = await http.get(_buildUri('filter.php?i=$ingredient'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Drinks.fromJson(data, (json) => Drink.fromJson(json));
    } else {
      return Future.error('Failed to load drinks');
    }
  }

  /// Get drinks by glass from API
  Future<Drinks<Drink>> getDrinksByGlass(String glass) async {
    final response = await http.get(_buildUri('filter.php?g=$glass'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Drinks.fromJson(data, (json) => Drink.fromJson(json));
    } else {
      return Future.error('Failed to load drinks');
    }
  }

  /// Get all categories from API
  Future<Drinks<Category>> getCategories() async {
    final response = await http.get(_buildUri('list.php?c=list'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Drinks.fromJson(data, (json) => Category.fromJson(json));
    } else {
      return Future.error('Failed to load categories');
    }
  }

  /// Get random drink from API
  Future<Drink?> getRandomDrink() async {
    final response = await http.get(_buildUri('random.php'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final drinks = Drinks.fromJson(data, (json) => Drink.fromJson(json));
      if (drinks.drinks != null && drinks.drinks!.isNotEmpty) {
        return drinks.drinks![0];
      }
    } else {
      return Future.error('Failed to load drink');
    }
    return null;
  }

  /// Get random drinks from API
  Future<Drinks<Drink>> getRandomDrinks(int count) async {
    if (count <= 0) {
      return Drinks();
    }

    final Drinks<Drink> drinks = Drinks(drinks: []);
    var errors = count;

    while (count != 0) {
      try {
        Drink? drink = await getRandomDrink();
        if (drink != null) {
          drinks.drinks!.add(drink);
          count--;
          continue;
        }
      } catch (e) {}

      // we give the api count retries before decrementing count
      // so the maximum requests that can be made are : 2*count
      if (errors == 0) {
        count--;
      } else {
        errors--;
      }
    }

    return drinks;
  }

  /// Get drink from API
  Future<Drink?> getDrink(String id) async {
    final response = await http.get(_buildUri('lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final drinks = Drinks.fromJson(data, (json) => Drink.fromJson(json));
      if (drinks.drinks != null && drinks.drinks!.isNotEmpty) {
        return drinks.drinks![0];
      }
    } else {
      return Future.error('Failed to load drink');
    }
    return null;
  }

  /// Get alcoholic filters from API
  Future<List<String>> getAlcoholicFilters() async {
    final response = await http.get(_buildUri('list.php?a=list'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final drinks = Drinks.fromJson(data, (json) => Drink.fromJson(json));
      if (drinks.drinks != null && drinks.drinks!.isNotEmpty) {
        return drinks.drinks!.map((e) => e.strAlcoholic!).toList();
      }
    } else {
      return Future.error('Failed to load drink');
    }
    return [];
  }

  /// Get glasses from API
  Future<Drinks<Glass>> getGlasses() async {
    final response = await http.get(_buildUri('list.php?g=list'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Drinks.fromJson(data, (json) => Glass.fromJson(json));
    } else {
      return Future.error('Failed to load glasses');
    }
  }

  /// Get ingredients from API
  Future<Drinks<Ingredient>> getIngredients() async {
    final response = await http.get(_buildUri('list.php?i=list'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Drinks.fromJson(data, (json) => Ingredient.fromJson(json));
    } else {
      return Future.error('Failed to load ingredients');
    }
  }

  /// Search drinks from API
  Future<Drinks<Drink>> searchDrinks(String what) async {
    final response = await http.get(_buildUri('search.php?s=$what'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Drinks.fromJson(data, (json) => Drink.fromJson(json));
    } else {
      return Future.error('Failed to load drinks');
    }
  }

  /// Search drinks by first letter from API
  Future<Drinks<Drink>> searchDrinksByFirstLetter(String letter) async {
    final response = await http.get(_buildUri('search.php?f=$letter'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Drinks.fromJson(data, (json) => Drink.fromJson(json));
    } else {
      return Future.error('Failed to load drinks');
    }
  }

  /// Search ingredients from API
  Future<Ingredients> searchIngredients(String what) async {
    final response = await http.get(_buildUri('search.php?i=$what'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Ingredients.fromJson(data);
    } else {
      return Future.error('Failed to load ingredients');
    }
  }

}
