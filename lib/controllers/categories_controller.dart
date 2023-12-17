import 'package:cocktails/models/category.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  final _categories = <Category>[].obs;

  List<Category> get categories => _categories;

  CategoriesController({List<Category>? categories}) {
    if (categories != null) {
      _categories(categories);
    }
  }

}