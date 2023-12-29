import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/views/widgets/cocktails_appbar.dart';
import 'package:cocktails/views/widgets/drink_card.dart';
import 'package:cocktails/views/widgets/navbar.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPageBinding implements Bindings {
  @override
  void dependencies() {
    final dataProvider = Get.find<PersistentDataProvider>();
    Get.lazyPut(() => CategoryController(categories: dataProvider.categories));
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryController categoryController = Get.find();
  final Rx<Filter> currentFilter = Filter.defaultFilter.obs;
  @override
  Widget build(BuildContext context) {
    final category = categoryController.findCategory();

    if (category == null) {
      Get.back();
      return Scaffold();
    }

    return Scaffold(
      appBar: CocktailsAppBar(
          title: category.name ?? 'No name',
          isBackButton: true,
          isFilterButton: true,
          defaultFilter: Filter.defaultFilter,
          filters: [
            Filter.defaultFilter,
            Filter.alcoholicFilter,
            Filter.glassFilter,
            Filter.ingredientFilter,
            Filter.nameFilter,
          ],
          onFilterSelected: (filter) {
            print(filter);
          }),
      backgroundColor: Colors.white,
      body: Container(
        constraints: BoxConstraints.expand(),
        child: FutureBuilder(
          future: categoryController.loadDrinks(category.name!),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(child: Text('No connection'));
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  Get.back();
                  return Center(child: Text('Error'));
                }
                return _drinks();
            }
          },
        ),
      ),
      bottomNavigationBar: NavBar(
        animate: false,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }

  SingleChildScrollView _drinks() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() => Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.spaceEvenly,
                children: List.generate(
                    categoryController.drinks.length, (index) {
                  // For scrolling test, uncomment this
                  // if (index >= categoryController.categories.length) {
                  //   return _categoriesItem(Category(name: 'Test'), index);
                  // }
                  final drink = categoryController.drinks[index];

                  return DrinkCard(
                    drink,
                    index,
                    singleColor: Color(0xFFBAA9DB).withOpacity(0.6),
                  );
                }),
              )),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
