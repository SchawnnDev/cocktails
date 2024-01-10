import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final _categories = <Category>[].obs;
  final currentFilter = Filter.defaultFilter.obs;

  List<Category> get categories => _categories;

  CategoryController({List<Category>? categories}) {
    if (categories != null) {
      _categories(categories);
    }
  }

  /// Load drinks from API
  Future<List<Drink>> loadDrinks(String categoryName,
      {bool fullLoad = false, int? count}) async {
    final dataProvider = Get.find<PersistentDataProvider>();
    final drinks = await Get.find<TheCocktailsDBService>()
        .getDrinksByCategory(categoryName);
    // category drinks are incomplete, dont load them all but check in cache
    // whether we already have them
    var result = drinks.drinks ?? [];
    if (result.isEmpty) {
      return result;
    }

    // enrich with cached data
    dataProvider.getDrinksByCategory(categoryName).forEach((element) {
      if (!result.any((element) => element.idDrink == element.idDrink)) {
        result.add(element);
      }
    });

    if (fullLoad) {
      final fullDrinks = <Drink>[];
      // load all drinks

      if (count != null) {
        result = result.sample(count).toList();
      }

      for (var element in result) {
        final drink = await dataProvider.getDrink(element.idDrink);
        fullDrinks.add(drink ?? element);
      }
      return fullDrinks;
    }

    return result.map((e) {
      return dataProvider.findDrink(e.idDrink) ?? e;
    }).toList();
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
}
