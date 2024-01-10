import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/views/widgets/drinks_page_template.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPageBinding implements Bindings {
  @override
  void dependencies() {
    final dataProvider = Get.find<PersistentDataProvider>();
    Get.lazyPut(() => CategoryController(categories: dataProvider.categories));
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryController categoryController = Get.find();
  final Rx<Filter> currentFilter = Filter.defaultFilter.obs;

  @override
  Widget build(BuildContext context) {
    final category = categoryController.findCategory();

    if (category == null) {
      Get.back();
      return Scaffold();
    }

    return DrinksPageTemplate(
      title: (category.name ?? 'No name').tr,
      filters: [
        Filter.defaultFilter,
        Filter.alcoholicFilter,
        Filter.glassFilter,
        Filter.ingredientFilter,
        Filter.nameAscFilter,
        Filter.nameDescFilter,
        Filter.popularityFilter,
      ],
      onFilterSelected: (filter) {
        categoryController.currentFilter(filter);
      },
      defaultFilter: categoryController.currentFilter,
      loadDrinks: categoryController.loadDrinks(
          category.name!, fullLoad: true
      ),
    );
  }
}
