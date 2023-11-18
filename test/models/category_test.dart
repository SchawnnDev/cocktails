// test drink model class
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:cocktails/models/drinks.dart';


const categoriesJson = r'''{"drinks":[{"strCategory":"Ordinary Drink"},{"strCategory":"Cocktail"},{"strCategory":"Shake"},{"strCategory":"Other \/ Unknown"},{"strCategory":"Cocoa"},{"strCategory":"Shot"},{"strCategory":"Coffee \/ Tea"},{"strCategory":"Homemade Liqueur"},{"strCategory":"Punch \/ Party Drink"},{"strCategory":"Beer"},{"strCategory":"Soft Drink"}]}''';

void main() {
  test('Categories json should be parsed', () {
    // get json from drinkJson and test if parse it
    // Map<string, dynamic>
    Map<String, dynamic> json = jsonDecode(categoriesJson);
    final glasses = Drinks.fromJson(json);

    expect(glasses.drinks, isNotNull);
    expect(glasses.drinks!, isNotEmpty);

    for (var glass in glasses.drinks!) {
      expect(glass.strCategory, isNotNull);
    }

    expect(glasses.drinks![0].strCategory, 'Ordinary Drink');

  });
}