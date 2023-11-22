import 'package:cocktails/models/drink.dart';
import 'package:get/get.dart';

class DrinkController extends GetxController {
  final _drinks = <Drink>[].obs;

  List<Drink> get drinks => _drinks;

  updateDrinks(List<Drink> drinks) {
    _drinks(drinks);
  }

}