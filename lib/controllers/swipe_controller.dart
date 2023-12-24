import 'package:cocktails/models/drink.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
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

  void loadMore() {
    loadingMore(true);
    final dataProvider = Get.find<PersistentDataProvider>();
    // dataProvider.getDrink(id).then((value) {
    //   _drinks(value);
    //   loadingMore(false);
    // });
  }

}
