import 'package:cocktails/models/drink.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final _favorites = <Drink>[].obs;
  List<Drink> get favorites => _favorites;

  FavoritesController({List<Drink>? favorites}) {
    if (favorites != null) {
      _favorites(favorites);
    }
  }

}