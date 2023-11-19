import 'package:get/get.dart';

class CategoryController extends GetxController {
  final _categories = <String>[].obs;
  List<String> get categories => _categories;

  updateCategories(List<String> categories) {
    _categories(categories);
  }

}