import 'package:cocktails/utils/consts.dart';

const url = "";

class Ingredient {
  String name;
  String measure;

  Ingredient({required this.name, required this.measure});

  String getLittleImageUrl() {
    return "$apiIngredientImageUrl/$name.png";
  }

}