import 'package:cocktails/models/drink.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwipeController extends GetxController {
  final _drinks = <Drink>[].obs;
  final loadingMore = false.obs;

  List<Drink> get drinks => _drinks;

  SwipeController({List<Drink>? drinks}) {
    if (drinks != null) {
      _drinks(drinks);
    }
  }

  Future<void> loadMore() async {
    loadingMore(true);
    final dataProvider = Get.find<PersistentDataProvider>();
    // Get all drinks that are not favorites & not already in the list
    final toExclude = drinks.map((e) => e.idDrink!).toSet();
    dataProvider.drinks
        .where((element) => !element.favorite.value)
        .forEach((element) {
      toExclude.add(element.idDrink!);
    });
    //await Future.delayed(Duration(seconds: 15));
    await dataProvider
        .getRandomDrinks(10, toExclude)
        .then((value) => drinks.addAll(value))
        .whenComplete(() { loadingMore(false); });
  }
}
