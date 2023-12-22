import 'package:cocktails/models/category.dart';
import 'package:get/get.dart';

class IngredientsController extends GetxController {
  final _ingredients = <Category>[].obs;

  List<Category> get ingredients => _ingredients;

  IngredientsController({List<Category>? ingredients}) {
    if (ingredients != null) {
      _ingredients(ingredients);
    }
  }

}