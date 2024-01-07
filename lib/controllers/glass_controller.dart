import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/models/glass.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:get/get.dart';

class GlassController extends GetxController {
  final _glasses = <Glass>[].obs;
  final currentFilter = Filter.defaultFilter.obs;

  List<Glass> get glasses => _glasses;

  GlassController({List<Glass>? glasses}) {
    if (glasses != null) {
      _glasses(glasses);
    }
  }

  // Load glasses from API
  Future<List<Drink>> loadDrinks(String glassName, {bool fullLoad = false}) async {
    final dataProvider = Get.find<PersistentDataProvider>();
    final drinks =
    await Get.find<TheCocktailsDBService>().getDrinksByGlass(glassName);
    // glass drinks are incomplete, dont load them all but check in cache
    // whether we already have them
    final result = drinks.drinks;
    if (result == null) {
      return [];
    }

    // enrich with cached data
    dataProvider.getDrinksByGlass(glassName).forEach((element) {
      if (!result.any((element) => element.idDrink == element.idDrink)) {
        result.add(element);
      }
    });

    if (fullLoad) {
      final fullDrinks = <Drink>[];
      // load all drinks
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

  /// Find glass by name in URL
  Glass? findGlass() {
    var glassName = Get.parameters['glass_name'];

    if (glassName == null) {
      return null;
    }

    glassName = Uri.decodeComponent(glassName);
    return _glasses
        .firstWhereOrNull((element) => element.name == glassName);
  }

}
