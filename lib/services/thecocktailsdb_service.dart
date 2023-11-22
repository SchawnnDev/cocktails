import 'dart:convert';

import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/drinks.dart';
import 'package:http/http.dart' as http;

class TheCocktailsDBService {

  final String apiUrl = 'https://www.thecocktaildb.com/api/json/v1/1/';

  Uri _buildUri(String script) {
    return Uri.parse(apiUrl + script);
  }

  Future<Drinks> getCategories() async {
    final response = await http.get(_buildUri('list.php?c=list'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Drinks.fromJson(data);
    } else {
      return Future.error('Failed to load categories');
    }
  }

  Future<Drink?> getRandomDrink() async {
    final response = await http.get(_buildUri('random.php'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final drinks = Drinks.fromJson(data);
      if (drinks.drinks != null && drinks.drinks!.isNotEmpty) {
        return drinks.drinks![0];
      }
    } else {
      return Future.error('Failed to load drink');
    }
    return null;
  }

  Future<Drinks> getRandomDrinks(int count) async {
    if (count <= 0) {
      return Drinks();
    }

    final Drinks drinks = Drinks(drinks: []);
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

}