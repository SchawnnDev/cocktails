import 'package:cocktails/models/category.dart';
import 'package:get/get.dart';

import 'package:cocktails/models/drink.dart';
import 'package:collection/collection.dart';

class CategoryController extends GetxController {
  final _categories = <Category>[].obs;

  List<Category> get categories => _categories;

  updateCategories(List<Category> categories) {
    _categories(categories);
  }

  updateCategoriesDrink(List<Drink> categories) {
    _categories(categories
        .map((element) => element.strCategory)
        .whereNotNull()
        .map((e) => Category(name: e))
        .toList());
  }
}
