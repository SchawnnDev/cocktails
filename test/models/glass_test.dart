// test drink model class
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:cocktails/models/drink.dart';

import '../../lib/models/drinks.dart';
import '../../lib/models/glass.dart';

const drinksJson = r'''{"drinks":[{"strGlass":"Highball glass"},{"strGlass":"Cocktail glass"},{"strGlass":"Old-fashioned glass"},{"strGlass":"Whiskey Glass"},{"strGlass":"Collins glass"},{"strGlass":"Pousse cafe glass"},{"strGlass":"Champagne flute"},{"strGlass":"Whiskey sour glass"},{"strGlass":"Cordial glass"},{"strGlass":"Brandy snifter"},{"strGlass":"White wine glass"},{"strGlass":"Nick and Nora Glass"},{"strGlass":"Hurricane glass"},{"strGlass":"Coffee mug"},{"strGlass":"Shot glass"},{"strGlass":"Jar"},{"strGlass":"Irish coffee cup"},{"strGlass":"Punch bowl"},{"strGlass":"Pitcher"},{"strGlass":"Pint glass"},{"strGlass":"Copper Mug"},{"strGlass":"Wine Glass"},{"strGlass":"Beer mug"},{"strGlass":"Margarita\/Coupette glass"},{"strGlass":"Beer pilsner"},{"strGlass":"Beer Glass"},{"strGlass":"Parfait glass"},{"strGlass":"Mason jar"},{"strGlass":"Margarita glass"},{"strGlass":"Martini Glass"},{"strGlass":"Balloon Glass"},{"strGlass":"Coupe Glass"}]}''';
void main() {
  test('Glasses json should be parsed', () {
    // get json from drinkJson and test if parse it
    // Map<string, dynamic>
    Map<String, dynamic> json = jsonDecode(drinksJson);
    final glasses = Drinks.fromJson(json);

    expect(glasses.drinks, isNotNull);
    expect(glasses.drinks!, isNotEmpty);

    for (var glass in glasses.drinks!) {
      expect(glass.strGlass, isNotNull);
    }
  });
}