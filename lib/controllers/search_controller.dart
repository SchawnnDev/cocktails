import 'package:cocktails/models/drink.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/services/boxes_service.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

class SearchModalController extends GetxController {
  final _buzzingDrinks = <Drink>[].obs;
  final _lastSearches = <String>[].obs;
  final _service = Get.find<BoxesService>();
  static const List<String> suggestions = [
    'Mojito',
    'Margarita',
    'Whisky',
    'Light',
    'Fresh',
    'Fruity',
  ];

  List<String> get lastSearches => _lastSearches;

  List<Drink> get buzzingDrinks => _buzzingDrinks;

  SearchModalController() {
    _lastSearches(_service.getLastSearches());
  }

  void addLastSearch(String search) {
    _service.addLastSearch(search);
    _lastSearches(_service.getLastSearches());
  }

  void fetchBuzzingDrinks() {
    final dataProvider = Get.find<PersistentDataProvider>();
    _buzzingDrinks(dataProvider.drinks
        .where((element) => element.isRecommended)
        .sample(6)
        .toList());
  }
}
