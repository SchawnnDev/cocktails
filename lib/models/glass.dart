import 'package:cocktails/models/drink.dart';

class Glass extends Drink {
  Glass({strGlass}) : super(strGlass: strGlass);

  Glass.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}