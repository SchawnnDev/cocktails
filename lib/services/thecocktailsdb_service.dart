import 'dart:convert';

import 'package:cocktails/models/drinks.dart';
import 'package:http/http.dart' as http;

class TheCocktailsDBService {

  Future<Drinks> getCategories() async {
    final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Drinks.fromJson(data);
    } else {
      throw Exception('Failed to load categories');
    }
  }

}