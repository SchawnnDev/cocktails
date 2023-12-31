import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/views/widgets/cocktails_appbar.dart';
import 'package:cocktails/views/widgets/drink_card.dart';
import 'package:cocktails/views/widgets/navbar.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

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
        isFilter: false,
        // sort
        defaultFilter: categoryController.currentFilter,
        filters: [
          Filter.defaultFilter,
          Filter.alcoholicFilter,
          Filter.glassFilter,
          Filter.ingredientFilter,
          Filter.nameFilter,
        ],
        onFilterSelected: (filter) {
          categoryController.currentFilter(filter);
        },
      ),
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

                return AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: ObxValue(
                    (filter) {
                      return _drinks();
                    },
                    categoryController.currentFilter,
                  ),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                );
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
          padding: const EdgeInsets.all(15),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (categoryController.currentFilter.value ==
                  Filter.defaultFilter)
                _allDrinks(),
              if (categoryController.currentFilter.value ==
                  Filter.alcoholicFilter)
                _alcoholicDrinks(),
              if (categoryController.currentFilter.value == Filter.glassFilter)
                _glassDrinks(),
              if (categoryController.currentFilter.value ==
                  Filter.ingredientFilter)
                _ingredientDrinks(),
              if (categoryController.currentFilter.value == Filter.nameFilter)
                _nameDrinks(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allDrinks() {
    return Obx(
      () => Wrap(
        spacing: 15,
        runSpacing: 15,
        alignment: WrapAlignment.spaceEvenly,
        children: List.generate(
          categoryController.drinks.length,
          (index) {
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
          },
        ),
      ),
    );
  }

  Widget _alcoholicDrinks() {
    final dataProvider = Get.find<PersistentDataProvider>();
    final drinksByAlcoholic = categoryController.drinksByAlcoholic;
    final children = <Widget>[];

    for (var category in drinksByAlcoholic.keys) {
      final drinks = drinksByAlcoholic[category]!;
      children.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      children.add(SizedBox(
        height: 205,
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(width: 25),
          scrollDirection: Axis.horizontal,
          itemCount: drinks.length,
          itemBuilder: (context, index) {
            final drink = drinks[index];

            return FutureBuilder(
              future: dataProvider.getDrink(drink.idDrink),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError || snapshot.data == null) {
                    return Container();
                  }

                  return DrinkCard(
                    drink,
                    index,
                    singleColor: Color(0xFFBAA9DB).withOpacity(0.6),
                  );
                }

                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: SizedBox(
                    height: 110,
                    width: 140,
                  ),
                );
              },
            );
          },
        ),
      ));
    }

    return Column(
      children: children,
    );
  }

  Widget _glassDrinks() {
    return Container();
  }

  Widget _ingredientDrinks() {
    return Container();
  }

  Widget _nameDrinks() {
    return Container();
  }
}
