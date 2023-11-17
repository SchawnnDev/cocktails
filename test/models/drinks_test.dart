// test drink model class
import 'dart:convert';

import 'package:cocktails/models/drinks.dart';
import 'package:flutter_test/flutter_test.dart';

const drinksJson = r'''{"drinks":[{"idDrink":"11028","strDrink":"Amaretto Stinger","strDrinkAlternate":null,"strTags":null,"strVideo":null,"strCategory":"Ordinary Drink","strIBA":null,"strAlcoholic":"Alcoholic","strGlass":"Cocktail glass","strInstructions":"Shake ingredients well with cracked ice, strain into a cocktail glass, and serve.","strInstructionsES":"Agite bien los ingredientes con hielo picado, cuele en un vaso de c\u00f3ctel y sirva.","strInstructionsDE":"Die Zutaten gut mit zerkleinertem Eis sch\u00fctteln, in ein Cocktailglas abseihen und servieren.","strInstructionsFR":null,"strInstructionsIT":"Shakerare bene gli ingredienti con ghiaccio tritato, filtrare in una coppetta da cocktail e servire.","strInstructionsZH-HANS":null,"strInstructionsZH-HANT":null,"strDrinkThumb":"https:\/\/www.thecocktaildb.com\/images\/media\/drink\/vvop4w1493069934.jpg","strIngredient1":"Amaretto","strIngredient2":"White Creme de Menthe","strIngredient3":null,"strIngredient4":null,"strIngredient5":null,"strIngredient6":null,"strIngredient7":null,"strIngredient8":null,"strIngredient9":null,"strIngredient10":null,"strIngredient11":null,"strIngredient12":null,"strIngredient13":null,"strIngredient14":null,"strIngredient15":null,"strMeasure1":"1 1\/2 oz ","strMeasure2":"3\/4 oz ","strMeasure3":null,"strMeasure4":null,"strMeasure5":null,"strMeasure6":null,"strMeasure7":null,"strMeasure8":null,"strMeasure9":null,"strMeasure10":null,"strMeasure11":null,"strMeasure12":null,"strMeasure13":null,"strMeasure14":null,"strMeasure15":null,"strImageSource":null,"strImageAttribution":null,"strCreativeCommonsConfirmed":"No","dateModified":"2017-04-24 22:38:54"}]}''';

void main() {
  test('Drinks json should be parsed', () {
    // get json from drinkJson and test if parse it
    // Map<string, dynamic>
    Map<String, dynamic> json = jsonDecode(drinksJson);
    final drinks = Drinks.fromJson(json);
    expect(drinks.drinks, isNotNull);
    expect(drinks.drinks!.length, 1);
    expect(drinks.drinks![0], isNotNull);
    final drink = drinks.drinks![0];
    expect(drink.idDrink, '11028');
    expect(drink.strDrink, 'Amaretto Stinger');
    expect(drink.strDrinkAlternate, null);
    expect(drink.strTags, null);
    expect(drink.strVideo, null);
    expect(drink.strCategory, 'Ordinary Drink');
    expect(drink.strIBA, null);
    expect(drink.strAlcoholic, 'Alcoholic');
    expect(drink.strGlass, 'Cocktail glass');
    expect(drink.strInstructions,
        'Shake ingredients well with cracked ice, strain into a cocktail glass, and serve.');
    expect(drink.strInstructionsES,
        'Agite bien los ingredientes con hielo picado, cuele en un vaso de c\u00f3ctel y sirva.');
    expect(drink.strInstructionsDE,
        'Die Zutaten gut mit zerkleinertem Eis sch\u00fctteln, in ein Cocktailglas abseihen und servieren.');
    expect(drink.strInstructionsFR, null);
    expect(drink.strInstructionsIT,
        'Shakerare bene gli ingredienti con ghiaccio tritato, filtrare in una coppetta da cocktail e servire.');
    expect(drink.strInstructionsZHHANS, null);
    expect(drink.strInstructionsZHHANT, null);
    expect(drink.strDrinkThumb,
        'https:\/\/www.thecocktaildb.com\/images\/media\/drink\/vvop4w1493069934.jpg');
    expect(drink.ingredients, ['Amaretto', 'White Creme de Menthe']);
    expect(drink.measures, ['1 1\/2 oz ', '3\/4 oz ']);
    expect(drink.strImageSource, null);
    expect(drink.strImageAttribution, null);
    expect(drink.strCreativeCommonsConfirmed, 'No');
    expect(drink.dateModified, isNotNull);
  });
}