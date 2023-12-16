import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

class PersistentDataProvider {
  late List<Category> categories;
  late List<Drink> randomDrinks;

  Future<void> load() async {
    var cocktailsDBService = Get.find<TheCocktailsDBService>();

    var foundCategories = await cocktailsDBService.getCategories();
    categories = foundCategories.drinks
            ?.map((element) => element.strCategory)
            .whereNotNull()
            .map((e) => Category(name: e))
            .toList() ??
        [];

    randomDrinks = (await cocktailsDBService.getRandomDrinks(2)).drinks ?? [];
  }
}
