import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/glass.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final _categories = <Category>[].obs;
  final _recommendations = <Drink>[].obs;
  final _ingredients = <Ingredient>[].obs;
  final _glasses = <Glass>[].obs;

  List<Category> get categories => _categories;
  List<Drink> get recommendations => _recommendations;
  List<Ingredient> get ingredients => _ingredients;
  List<Glass> get glasses => _glasses;

  HomeController(
      {List<Category>? categories,
      List<Drink>? recommendations,
      List<Glass>? glasses}) {
    if (categories != null) {
      _categories(categories.sample(10).toList());
    }
    if (recommendations != null) {
      _recommendations(recommendations);
      _ingredients(
          recommendations.expand((e) => e.ingredients).take(10).toList());
    }
    if (glasses != null) {
      _glasses(glasses.sample(10).toList());
    }
  }
}
