import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final _categories = <Category>[].obs;
  final _drinks = <Drink>[].obs;
  final currentFilter = Filter.defaultFilter.obs;

  List<Category> get categories => _categories;
  List<Drink> get drinks => _drinks;

  CategoryController({List<Category>? categories}) {
    if (categories != null) {
      _categories(categories);
    }
  }

  // Load categories from API
  Future<void> loadDrinks(String categoryName, {bool fullLoad = false}) async {
    final dataProvider = Get.find<PersistentDataProvider>();
    final drinks =
        await Get.find<TheCocktailsDBService>().getDrinks(categoryName);
    // category drinks are incomplete, dont load them all but check in cache
    // whether we already have them
    final result = drinks.drinks;
    if (result == null) {
      _drinks([]);
      return;
    }

    // enrich with cached data
    dataProvider.getDrinksByCategory(categoryName).forEach((element) {
      if (!result.any((element) => element.idDrink == element.idDrink)) {
        result.add(element);
      }
    });

    if (fullLoad) {
      // load all drinks
      _drinks([]);
      for (var element in result) {
        final drink = await dataProvider.getDrink(element.idDrink);
        if (drink != null) {
          _drinks.add(drink);
        } else {
          _drinks.add(element);
        }
      }
      return;
    }

    _drinks(result.map((e) {
      return dataProvider.findDrink(e.idDrink) ?? e;
    }).toList());
  }

  /// Find category by name in URL
  Category? findCategory() {
    var categoryName = Get.parameters['category_name'];

    if (categoryName == null) {
      return null;
    }

    categoryName = Uri.decodeComponent(categoryName);
    return _categories
        .firstWhereOrNull((element) => element.name == categoryName);
  }

  Map<String, List<Drink>> get drinksByFirstLetter {
    final result = <String, List<Drink>>{};
    for (var drink in _drinks) {
      if (drink.strDrink == null) {
        continue;
      }
      final firstLetter = drink.strDrink![0].toUpperCase();
      if (!result.containsKey(firstLetter)) {
        result[firstLetter] = [];
      }
      result[firstLetter]!.add(drink);
    }
    return result;
  }

  Map<String, List<Drink>> get drinksByAlcoholic {
    final result = <String, List<Drink>>{};
    for (var drink in _drinks) {
      if (drink.strAlcoholic == null) {
        continue;
      }
      final alcoholic = drink.strAlcoholic!;
      if (!result.containsKey(alcoholic)) {
        result[alcoholic] = [];
      }
      result[alcoholic]!.add(drink);
    }
    return result;
  }

  Map<String, List<Drink>> get drinksByGlass {
    final result = <String, List<Drink>>{};
    for (var drink in _drinks) {
      if (drink.strGlass == null) {
        continue;
      }
      final glass = drink.strGlass!;
      if (!result.containsKey(glass)) {
        result[glass] = [];
      }
      result[glass]!.add(drink);
    }
    return result;
  }

  Map<String, List<Drink>> get drinksByIngredient {
    final result = <String, List<Drink>>{};
    for (var drink in _drinks) {
      if (drink.ingredients.isEmpty) {
        continue;
      }
      for (var ingredient in drink.ingredients) {
        if (!result.containsKey(ingredient.name)) {
          result[ingredient.name] = [];
        }
        result[ingredient.name]!.add(drink);
      }
    }
    return result;
  }
}
