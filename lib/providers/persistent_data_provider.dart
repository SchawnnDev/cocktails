import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

class PersistentDataProvider {
  List<Category> categories = [];
  List<Drink> randomDrinks = [];
  RxBool error = false.obs;
  bool first = true;

  Future<void> load() async {
    var cocktailsDBService = Get.find<TheCocktailsDBService>();

    try {
      var foundCategories = await cocktailsDBService.getCategories();
      categories = foundCategories.drinks
          ?.map((element) => element.strCategory)
          .whereNotNull()
          .map((e) => Category(name: e))
          .toList() ??
          [];

      randomDrinks = (await cocktailsDBService.getRandomDrinks(10)).drinks ?? [];
      print(error);
      if (first) {
        first = false;
        error(true);
      } else {
        error(false);
      }
    } catch (e) {
      error(true);
      print(e);
    }
  }
}
