import 'package:cocktails/models/drink.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';

class Data {
  late final List<Drink> _categories;
  bool _loaded = false;

  List<Drink> get categories => _categories;

  bool get isLoaded => _loaded;

  Future<void> load() async {
    final thecocktailsdbService = TheCocktailsDBService();
    var drinksCategories = await thecocktailsdbService.getCategories();
    _categories = drinksCategories.drinks ?? [];
    _loaded = true;
  }

}