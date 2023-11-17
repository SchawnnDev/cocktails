import 'package:cocktails/models/drink.dart';

class Alcoholic extends Drink {
  Alcoholic({strAlcoholic}) : super(strAlcoholic: strAlcoholic);

  Alcoholic.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}