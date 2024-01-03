import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwipeController extends GetxController {
  final _drinks = <Drink>[].obs;
  final loadingMore = false.obs;
  final dataProvider = Get.find<PersistentDataProvider>();

  List<Drink> get drinks => _drinks;

  SwipeController({List<Drink>? drinks}) {
    if (drinks != null) {
      _drinks(drinks);
    }
  }

  Future<void> loadMore() async {
    loadingMore(true);
    // Get all drinks that are not favorites & not already in the list
    final toExclude = drinks.map((e) => e.idDrink!).toSet();
    dataProvider.drinks
        .where((element) => element.favorite.value || element.disliked.value)
        .forEach((element) {
      toExclude.add(element.idDrink!);
    });
    await dataProvider
        .getRandomDrinks(10, toExclude)
        .then((value) => drinks.addAll(value))
        .whenComplete(() {
      loadingMore(false);
    });
  }

  void swipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    final Drink drink = drinks[previousIndex];
    switch (activity) {
      case Swipe():
        if (activity.direction == AxisDirection.left) {
          drink.disliked(true);
          drink.favorite(false);
          break;
        } else if (activity.direction == AxisDirection.right) {
          drink.disliked(false);
          drink.favorite(true);
          break;
        }
        break;
      case Unswipe():
        drink.favorite(false);
        drink.disliked(false);
        break;
      default:
        break;
    }
  }
}
