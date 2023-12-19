import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class BoxesService extends GetxService {
  late Box settingsBox;
  late Box favoritesBox;

  Future<BoxesService> init() async {
    await Hive.initFlutter();
    settingsBox = await Hive.openBox('settings');
    favoritesBox = await Hive.openBox('favorites');
    return this;
  }

}
