import 'package:cocktails/models/drink.dart';

class Drinks {
  List<Drink>? drinks;

  Drinks({this.drinks});

  Drinks.fromJson(Map<String, dynamic> json) {
    if (json['drinks'] != null) {
      drinks = <Drink>[];
      json['drinks'].forEach((v) {
        drinks!.add(Drink.fromJson(v));
      });
    }
  }
}