import 'package:cocktails/models/setting.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class BoxesService extends GetxService {
  late Box settingsBox;
  late List<Setting> settings;

  Future<BoxesService> init() async {
    await Hive.initFlutter();
    settingsBox = await Hive.openBox('settings');
    return this;
  }

}
