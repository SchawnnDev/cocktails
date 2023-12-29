import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final _categories = <Category>[].obs;
  final _drinks = <Drink>[].obs;

  List<Category> get categories => _categories;

  List<Drink> get drinks => _drinks;

  CategoryController({List<Category>? categories}) {
    if (categories != null) {
      _categories(categories);
    }
  }

  // Load categories from API
  Future<void> loadDrinks(String categoryName) async {
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
}
