import 'package:cocktails/models/drink.dart';

class Category extends Drink {
  Category({strCategory}) : super(strCategory: strCategory);

  Category.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}