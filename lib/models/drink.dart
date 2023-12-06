import 'package:cocktails/models/ingredient.dart';

class Drink {
  String? idDrink;
  String? strDrink;
  String? strDrinkAlternate;
  String? strTags;
  String? strVideo;
  String? strCategory;
  String? strIBA;
  String? strAlcoholic;
  String? strGlass;
  String? strDrinkThumb;
  String? thumbnail;
  String? strImageSource;
  String? strImageAttribution;
  String? strCreativeCommonsConfirmed;
  String? dateModified;
  late List<Ingredient> ingredients;
  late Map<String, List<String>> instructions;

  Drink({this.idDrink,
    this.strDrink,
    this.strDrinkAlternate,
    this.strTags,
    this.strVideo,
    this.strCategory,
    this.strIBA,
    this.strAlcoholic,
    this.strGlass,
    this.strDrinkThumb,
    this.strImageSource,
    this.strImageAttribution,
    this.strCreativeCommonsConfirmed,
    this.dateModified,
    this.thumbnail})
  : ingredients = [],
  instructions = {};

  Drink.fromJson(Map<String, dynamic> json) {
    idDrink = json['idDrink'];
    strDrink = json['strDrink'];
    strDrinkAlternate = json['strDrinkAlternate'];
    strTags = json['strTags'];
    strVideo = json['strVideo'];
    strCategory = json['strCategory'];
    strIBA = json['strIBA'];
    strAlcoholic = json['strAlcoholic'];
    strGlass = json['strGlass'];

    _addInstructions('EN', json['strInstructions']);
    _addInstructions('ES', json['strInstructionsES']);
    _addInstructions('DE', json['strInstructionsDE']);
    _addInstructions('FR', json['strInstructionsFR']);
    _addInstructions('IT', json['strInstructionsIT']);
    _addInstructions('ZH-HANS', json['strInstructionsZH-HANS']);
    _addInstructions('ZH-HANT', json['strInstructionsZH-HANT']);
    strDrinkThumb = json['strDrinkThumb'];

    if(strDrinkThumb != null) {
      thumbnail = "${strDrinkThumb!}/preview";
    }

    ingredients = [];

    for (var i = 1; i <= 15; i++) {
      String? name = json['strIngredient$i'];
      if (name == null) continue;
      String measure = json['strMeasure$i'] ?? '1x';
      ingredients.add(Ingredient(name: name, measure: measure));
    }

    strImageSource = json['strImageSource'];
    strImageAttribution = json['strImageAttribution'];
    strCreativeCommonsConfirmed = json['strCreativeCommonsConfirmed'];
    dateModified = json['dateModified'];
  }

  void _addInstructions(String lang, String? value) {
    instructions[lang] = [];
    if (value == null) {
      return;
    }

    List<String> splitInstructions = value.split('.');
    splitInstructions = splitInstructions.map((instruction) => instruction.trim()).toList();
    instructions[lang] = splitInstructions;
  }

}
