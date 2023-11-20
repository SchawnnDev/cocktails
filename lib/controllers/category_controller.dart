import 'package:get/get.dart';

import 'package:cocktails/models/drink.dart';
import 'package:collection/collection.dart';


class CategoryController extends GetxController {
  final _categories = <String>[].obs;
  List<String> get categories => _categories;

  updateCategories(List<String> categories) {
    _categories(categories);
  }

  updateCategoriesDrink(List<Drink> categories) {
    _categories(categories.map((element) => element.strCategory).whereNotNull().toList());
  }

}