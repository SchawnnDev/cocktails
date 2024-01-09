import 'package:cocktails/utils/consts.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class BoxesService extends GetxService {
  late Box settingsBox;
  late Box favoritesBox;
  late Box dislikesBox;
  late Box lastSearches;

  Future<BoxesService> init() async {
    await Hive.initFlutter();
    settingsBox = await Hive.openBox('settings');
    favoritesBox = await Hive.openBox('favorites');
    dislikesBox = await Hive.openBox('dislikes');
    lastSearches = await Hive.openBox('lastSearches');
    return this;
  }

  Future<void> clear() async {
    await settingsBox.clear();
    await favoritesBox.clear();
    await dislikesBox.clear();
    await lastSearches.clear();
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

  void addLastSearch(String search) {
    if (search.isEmpty) {
      return;
    }
    // we don't want any duplicates
    // FILO
    for (var i = 0; i < lastSearches.length; i++) {
      final element = lastSearches.getAt(i);
      if (element == search) {
        lastSearches.deleteAt(i);
        break;
      }
    }

    if (lastSearches.length >= maxLastSearches) {
      lastSearches.deleteAt(0);
    }
    lastSearches.add(search);
  }

  List<String> getLastSearches() {
    return lastSearches.values.toList().cast<String>().reversed.toList();
  }
}
