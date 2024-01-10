import 'ingredient.dart';

class Ingredients {
  List<Ingredient>? ingredients;

  Ingredients({this.ingredients});

  Ingredients.fromJson(Map<String, dynamic> json) {
    if (json['ingredients'] != null) {
      ingredients = [];
      json['ingredients'].forEach((v) {
        ingredients!.add(Ingredient.fromJson(v));
      });
    }
  }
}
