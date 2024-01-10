import 'package:cocktails/controllers/ingredient_controller.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/views/widgets/drinks_page_template.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IngredientPageBinding implements Bindings {
  @override
  void dependencies() {
    final dataProvider = Get.find<PersistentDataProvider>();
    Get.lazyPut(() =>
        IngredientController(ingredients: dataProvider.getCachedIngredients()));
  }
}

class IngredientPage extends StatefulWidget {
  const IngredientPage({super.key});

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  final IngredientController ingredientController = Get.find();
  final Rx<Filter> currentFilter = Filter.defaultFilter.obs;

  @override
  Widget build(BuildContext context) {
    final ingredient = ingredientController.findIngredient();

    if (ingredient == null) {
      Get.back();
      return Scaffold();
    }

    return DrinksPageTemplate(
      title: ingredient.name.tr,
      filters: [
        Filter.defaultFilter,
        Filter.alcoholicFilter,
        Filter.glassFilter,
        Filter.categoryFilter,
        Filter.nameAscFilter,
        Filter.nameDescFilter,
        Filter.popularityFilter,
      ],
      onFilterSelected: (filter) {
        ingredientController.currentFilter(filter);
      },
      defaultFilter: ingredientController.currentFilter,
      loadDrinks:
          ingredientController.loadDrinks(ingredient.name, fullLoad: true),
    );
  }
}
