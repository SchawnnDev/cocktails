import 'package:cocktails/utils/consts.dart';

const url = "";

class Ingredient {
  final String name;
  final String? measure;

  Ingredient({required this.name, this.measure});

  String getLittleImageUrl() {
    return "$apiIngredientImageUrl/$name.png";
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(name: json['strIngredient1']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
