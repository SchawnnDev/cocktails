import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class BoxesService extends GetxService {
  late Box settingsBox;
  late Box favoritesBox;
  late Box dislikesBox;

  Future<BoxesService> init() async {
    await Hive.initFlutter();
    settingsBox = await Hive.openBox('settings');
    favoritesBox = await Hive.openBox('favorites');
    dislikesBox = await Hive.openBox('dislikes');
    return this;
  }

  Future<void> clear() async {
    await settingsBox.clear();
    await favoritesBox.clear();
    await dislikesBox.clear();
  }

  void addFavorite(String id) {
    favoritesBox.put(id, true);
  }

  bool isFavorite(String id) {
    return favoritesBox.containsKey(id);
  }

  void removeFavorite(String id) {
    favoritesBox.delete(id);
  }

  void addDislike(String id) {
    dislikesBox.put(id, true);
  }

  bool isDisliked(String id) {
    return dislikesBox.containsKey(id);
  }

  void removeDislike(String id) {
    dislikesBox.delete(id);
  }
}
