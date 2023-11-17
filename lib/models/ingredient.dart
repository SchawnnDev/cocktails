import 'package:cocktails/models/drink.dart';

class Ingredient extends Drink {
  Ingredient({strIngredient}) : super(ingredients: List<String>.from([strIngredient]));

  Ingredient.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  String get ingredient => ingredients![0];
}