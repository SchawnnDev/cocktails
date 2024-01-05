import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/models/glass.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:get/get.dart';

class GlassesController extends GetxController {
  final _glasses = <Glass>[].obs;
  final currentFilter = Filter.defaultFilter.obs;

  List<Glass> get glasses => _glasses;

  GlassesController({List<Glass>? glasses}) {
    if (glasses != null) {
      _glasses(glasses);
    }
  }

  Future load() async {
    final dataProvider = Get.find<PersistentDataProvider>();
    final glasses = await dataProvider.getGlasses();
    _glasses(glasses);
  }

}
