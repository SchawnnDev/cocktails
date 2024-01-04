import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:get/get.dart';

class IngredientsController extends GetxController {
  final _ingredients = <Ingredient>[].obs;

  List<Ingredient> get ingredients => _ingredients;

  IngredientsController({List<Ingredient>? ingredients}) {
    if (ingredients != null) {
      _ingredients(ingredients);
    }
  }

  Future load() async {
    final dataProvider = Get.find<PersistentDataProvider>();
    final ingredients = await dataProvider.getIngredients();

    // Enrich ingredients with existing drinks
    dataProvider.drinks.where((element) => element.ingredients.isNotEmpty)
        .forEach((drink) {
      for (var ingredient in drink.ingredients) {
        if (ingredients.any((element) => element.name == ingredient.name)) {
          continue;
        }
        ingredients.add(ingredient);
      }
    });

    _ingredients(ingredients);
  }

}
