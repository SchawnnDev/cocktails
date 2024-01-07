import 'package:cocktails/controllers/glass_controller.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/views/widgets/drinks_page_template.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlassPageBinding implements Bindings {
  @override
  void dependencies() {
    final dataProvider = Get.find<PersistentDataProvider>();
    Get.lazyPut(() => GlassController(glasses: dataProvider.glasses));
  }
}

class GlassPage extends StatefulWidget {
  const GlassPage({super.key});

  @override
  State<GlassPage> createState() => _GlassPageState();
}

class _GlassPageState extends State<GlassPage> {
  final GlassController glassController = Get.find();
  final Rx<Filter> currentFilter = Filter.defaultFilter.obs;

  @override
  Widget build(BuildContext context) {
    final glass = glassController.findGlass();

    if (glass == null) {
      Get.back();
      return Scaffold();
    }

    return DrinksPageTemplate(
      title: glass.name.tr,
      filters: [
        Filter.defaultFilter,
        Filter.alcoholicFilter,
        Filter.ingredientFilter,
        Filter.categoryFilter,
        Filter.nameAscFilter,
        Filter.nameDescFilter,
        Filter.popularityFilter,
      ],
      onFilterSelected: (filter) {
        glassController.currentFilter(filter);
      },
      defaultFilter: glassController.currentFilter,
      loadDrinks: glassController.loadDrinks(glass.name),
    );
  }
}
