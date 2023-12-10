import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class BoxesService extends GetxService {
  late Box settingsBox;

  Future<BoxesService> init() async {
    await Hive.initFlutter();
    settingsBox = await Hive.openBox('settings');
    return this;
  }

}