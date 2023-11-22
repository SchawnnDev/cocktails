
import 'package:flutter_test/flutter_test.dart';

import 'package:cocktails/services/thecocktailsdb_service.dart';

void main() {
  test('TheCocktailsDB service getCategories should return something', () async {
    final categories = await TheCocktailsDBService().getCategories();

    expect(categories.drinks, isNotNull);
    expect(categories.drinks!, isNotEmpty);
  });
}
