import 'dart:math';

import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/models/category.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/models/glass.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/utils/themes.dart';
import 'package:cocktails/views/widgets/cocktails_appbar.dart';
import 'package:cocktails/views/widgets/drink_card.dart';
import 'package:cocktails/views/widgets/more_card.dart';
import 'package:cocktails/views/widgets/navbar.dart';
import 'package:cocktails/views/widgets/see_more_modal.dart';
import 'package:collection/collection.dart';
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
      body: FutureBuilder(
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
                    return _drinks(category);
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
      bottomNavigationBar: NavBar(
        animate: false,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }

  Widget _drinks(Category category) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              categoryController.currentFilter.value == Filter.defaultFilter
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.start,
          children: [
            if (categoryController.currentFilter.value == Filter.defaultFilter)
              _allDrinks(),
            if (categoryController.currentFilter.value ==
                Filter.alcoholicFilter)
              _alcoholicDrinks(category),
            if (categoryController.currentFilter.value == Filter.glassFilter)
              _glassDrinks(category),
            if (categoryController.currentFilter.value ==
                Filter.ingredientFilter)
              _ingredientDrinks(),
            if (categoryController.currentFilter.value == Filter.nameFilter)
              _nameDrinks(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _allDrinks() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Obx(
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
                singleColor: Theme.of(context).primaryColor.withOpacity(0.6),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _alcoholicDrinks(Category category) {
    final dataProvider = Get.find<PersistentDataProvider>();

    return FutureBuilder(
      future: dataProvider.getAlcoholicFilters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error'));
          }

          return _createAlcoholicFilters(category, snapshot.data);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _createAlcoholicFilters(
      Category category, List<String>? alcoholicFilters) {
    if (alcoholicFilters == null) {
      return Center(
        child: Text('No drinks'),
      );
    }

    final dataProvider = Get.find<PersistentDataProvider>();

    return FutureBuilder(
      future: Future.wait([
        Future.wait(categoryController.drinks
            .map((e) async => dataProvider.getDrink(e.idDrink))
            .toList()),
        Future.delayed(const Duration(seconds: 1))
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error'));
          }

          final data = snapshot.data?[0] as List<Drink?>?;
          final children = <Widget>[];
          children.add(SizedBox(height: 20));

          for (var filter in alcoholicFilters) {
            final drinks = data
                    ?.where((element) => element?.strAlcoholic == filter)
                    .map((e) => e!)
                    .toList() ??
                [];

            if (drinks.isEmpty) {
              continue;
            }

            children.add(
              Padding(
                padding: EdgeInsets.only(left: 20, right: 10),
                child: GestureDetector(
                  onTapUp: (details) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: true,
                      showDragHandle: false,
                      useSafeArea: true,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10))),
                      builder: (context) => SeeMoreModal(
                        drinks: drinks,
                        title: '${category.name}: ${filter.tr}',
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        filter.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${'see_all'.tr} >',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            children.add(SizedBox(height: 10));
            children.add(
              SizedBox(
                height: 205,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 25),
                  scrollDirection: Axis.horizontal,
                  itemCount: min(drinks.length, 16),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  itemBuilder: (context, index) {
                    final drink = drinks[index];

                    if (index == 15) {
                      return MoreCard('see_all', () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          showDragHandle: false,
                          useSafeArea: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          builder: (context) => SeeMoreModal(
                            drinks: drinks,
                            title: 'filter'.tr,
                          ),
                        );
                      }, primColor(context, index), 140, 205);
                    }

                    return DrinkCard(drink, index,
                        singleColor: Color(0xFFBAA9DB)
                            .withOpacity(index % 2 == 0 ? 0.6 : 0.3));
                  },
                ),
              ),
            );
            children.add(SizedBox(height: 20));
          }

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: children);
        }

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _createShimmers(alcoholicFilters));
      },
    );
  }

  Widget _glassDrinks(Category category) {
    final dataProvider = Get.find<PersistentDataProvider>();

    return FutureBuilder(
      future: dataProvider.getGlasses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error'));
          }

          return _createGlasses(category, snapshot.data);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _createGlasses(Category category, List<Glass>? glasses) {
    if (glasses == null) {
      return Center(
        child: Text('No glasses'),
      );
    }

    final dataProvider = Get.find<PersistentDataProvider>();

    return FutureBuilder(
      future: Future.wait([
        Future.wait(categoryController.drinks
            .map((e) async => dataProvider.getDrink(e.idDrink))
            .toList()),
        Future.delayed(const Duration(seconds: 1))
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error'));
          }

          final data = snapshot.data?[0] as List<Drink?>?;
          final children = <Widget>[];
          children.add(SizedBox(height: 20));

          for (var glass in glasses) {
            final drinks = data
                    ?.where((element) => element?.strGlass == glass.name)
                    .map((e) => e!)
                    .toList() ??
                [];

            if (drinks.isEmpty) {
              continue;
            }

            children.add(
              Padding(
                padding: EdgeInsets.only(left: 20, right: 10),
                child: GestureDetector(
                  onTapUp: (details) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: true,
                      showDragHandle: false,
                      useSafeArea: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      builder: (context) => SeeMoreModal(
                        drinks: drinks,
                        title: '${category.name}: ${glass.name.tr}',
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      if (glass.getIcon() != null) ...[
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: Image.asset(
                            glass.getIcon()!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                      Text(
                        glass.name.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (drinks.length >= 15) ...[
                        Spacer(),
                        Text(
                          '${'see_all'.tr} >',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
            children.add(SizedBox(height: 10));
            children.add(
              SizedBox(
                height: 205,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 25),
                  scrollDirection: Axis.horizontal,
                  itemCount: min(drinks.length, 16),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  itemBuilder: (context, index) {
                    final drink = drinks[index];

                    if (index == 15) {
                      return MoreCard('see_all', () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          showDragHandle: false,
                          useSafeArea: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10))),
                          builder: (context) => SeeMoreModal(
                            drinks: drinks,
                            title: 'filter'.tr,
                          ),
                        );
                      }, primColor(context, index), 140, 205);
                    }

                    return DrinkCard(drink, index,
                        singleColor: primColor(context, index));
                  },
                ),
              ),
            );
            children.add(SizedBox(height: 20));
          }

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: children);
        }

        final shimmerGlasses = glasses.sample(10).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: _createShimmers(
            shimmerGlasses.map((e) => e.name).toList(),
            images: shimmerGlasses.map((e) => e.getIcon() ?? '').toList(),
          ),
        );
      },
    );
  }

  Widget _ingredientDrinks() {
    return Container();
  }

  Widget _nameDrinks() {
    return Container();
  }

  /// Create shimmers
  List<Widget> _createShimmers(List<String> titles, {List<String>? images}) {
    final children = <Widget>[];
    children.add(SizedBox(height: 20));
    final bool hasImages = images != null && images.isNotEmpty;

    for (var i = 0; i < titles.length; i++) {
      final title = titles[i];

      if (hasImages && i < images.length && images[i].isNotEmpty) {
        final image = images[i];
        children.add(
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 45,
                  height: 45,
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  title.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Spacer(),
                // Text(
                //   '${'see_all'.tr} >',
                //   style: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
          ),
        );
      } else {
        children.add(
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Row(
              children: [
                Text(
                  title.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  '${'see_all'.tr} >',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      children.add(SizedBox(height: 10));
      children.add(
        SizedBox(
          height: 205,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 25),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            itemCount: 5,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 150,
                height: 205,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 150,
                    height: 205,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      children.add(SizedBox(height: 20));
    }

    return children;
  }
}
