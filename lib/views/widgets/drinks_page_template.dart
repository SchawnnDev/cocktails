import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/filter.dart';
import 'package:cocktails/models/glass.dart';
import 'package:cocktails/models/ingredient.dart';
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

class DrinksPageTemplate extends StatefulWidget {
  final String title;
  final Rx<Filter> defaultFilter;
  final List<Filter> filters;
  final Function(Filter)? onFilterSelected;
  final Future<List<Drink>> loadDrinks;

  DrinksPageTemplate({
    super.key,
    required this.title,
    required this.filters,
    required this.defaultFilter,
    this.onFilterSelected,
    required this.loadDrinks,
  });

  @override
  State<DrinksPageTemplate> createState() => _DrinksPageTemplateState();
}

class _DrinksPageTemplateState extends State<DrinksPageTemplate> {
  final Rx<Filter> currentFilter = Filter.defaultFilter.obs;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CocktailsAppBar(
        title: widget.title.tr,
        isBackButton: true,
        isFilterButton: true,
        isFilter: false,
        // sort
        defaultFilter: widget.defaultFilter,
        filters: widget.filters,
        onFilterSelected: (Filter newFilter) {
          currentFilter(newFilter);
          if (widget.onFilterSelected != null) {
            widget.onFilterSelected!(newFilter);
          }
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 750),
            curve: Curves.easeInOut,
          );
        },
      ),
      body: FutureBuilder(
        future: widget.loadDrinks,
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
                    return _drinks(snapshot.data ?? []);
                  },
                  currentFilter,
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

  bool _drinkIsStretch(Filter filter) =>
      filter == Filter.defaultFilter ||
      filter == Filter.popularityFilter ||
      filter == Filter.nameAscFilter ||
      filter == Filter.nameDescFilter;

  Widget _drinks(List<Drink> drinks) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: _drinkIsStretch(currentFilter.value)
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.start,
          children: [
            if (currentFilter.value == Filter.defaultFilter)
              _allDrinks(drinks, Filter.defaultFilter),
            if (currentFilter.value == Filter.alcoholicFilter)
              _alcoholicDrinks(drinks),
            if (currentFilter.value == Filter.glassFilter) _glassDrinks(drinks),
            if (currentFilter.value == Filter.ingredientFilter)
              _ingredientDrinks(drinks),
            if (currentFilter.value == Filter.categoryFilter)
              _categoryDrinks(drinks),
            if (currentFilter.value == Filter.nameAscFilter)
              _allDrinks(drinks, Filter.nameAscFilter),
            if (currentFilter.value == Filter.nameDescFilter)
              _allDrinks(drinks, Filter.nameDescFilter),
            if (currentFilter.value == Filter.popularityFilter)
              _allDrinks(drinks, Filter.popularityFilter),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _allDrinks(List<Drink> drinks, Filter filter) {
    List<Drink> sortedDrinks = drinks.toList();

    if (filter == Filter.defaultFilter) {
      sortedDrinks.shuffle();
    } else if (filter == Filter.nameAscFilter) {
      sortedDrinks =
          sortedDrinks.sorted((a, b) => a.strDrink!.compareTo(b.strDrink!));
    } else if (filter == Filter.nameDescFilter) {
      sortedDrinks =
          sortedDrinks.sorted((a, b) => b.strDrink!.compareTo(a.strDrink!));
    } else if (filter == Filter.popularityFilter) {
      sortedDrinks =
          sortedDrinks.sorted((a, b) => b.favorites.compareTo(a.favorites));
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Wrap(
        spacing: 15,
        runSpacing: 15,
        alignment: WrapAlignment.spaceEvenly,
        children: List.generate(
          sortedDrinks.length,
          (index) {
            final drink = sortedDrinks[index];

            return DrinkCard(
              drink,
              index,
              singleColor: getPrimColor(context).withOpacity(0.6),
            );
          },
        ),
      ),
    );
  }

  Widget _alcoholicDrinks(List<Drink> drinks) {
    final dataProvider = Get.find<PersistentDataProvider>();

    return FutureBuilder(
      future: dataProvider.getAlcoholicFilters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error'));
          }

          return _createAlcoholicFilters(drinks, snapshot.data);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _createAlcoholicFilters(
      List<Drink> drinks, List<String>? alcoholicFilters) {
    if (alcoholicFilters == null) {
      return Center(
        child: Text('No drinks'),
      );
    }

    final dataProvider = Get.find<PersistentDataProvider>();

    return FutureBuilder(
      future: Future.wait([
        Future.wait(
            drinks.map((e) async => dataProvider.getDrink(e.idDrink)).toList()),
        Future.delayed(const Duration(milliseconds: 500)) // smooth
      ]),
      builder: (context, snapshot) {
        final children = <Widget>[];

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error'));
          }

          final data = (snapshot.data?[0] as List<Drink?>?) ?? [];
          children.add(SizedBox(height: 20));

          for (var filter in alcoholicFilters) {
            final drinks = data
                .where((element) => element?.strAlcoholic == filter)
                .map((e) => e!)
                .toList();

            if (drinks.isEmpty) {
              continue;
            }

            children.addAll(_createSection(
                filter.tr, '${widget.title.tr}: ${filter.tr}', null, drinks));
          }
        } else {
          children.addAll(_createShimmers(alcoholicFilters));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        );
      },
    );
  }

  Widget _glassDrinks(List<Drink> drinks) {
    final dataProvider = Get.find<PersistentDataProvider>();

    return FutureBuilder(
      future: dataProvider.getGlasses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error'));
          }

          return _createGlasses(drinks, snapshot.data);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _createGlasses(List<Drink> drinks, List<Glass>? glasses) {
    if (glasses == null) {
      return Center(
        child: Text('No glasses'),
      );
    }

    final dataProvider = Get.find<PersistentDataProvider>();

    return FutureBuilder(
      future: Future.wait([
        Future.wait(
            drinks.map((e) async => dataProvider.getDrink(e.idDrink)).toList()),
        Future.delayed(const Duration(milliseconds: 500))
      ]),
      builder: (context, snapshot) {
        final children = <Widget>[];

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error'));
          }

          final data = (snapshot.data?[0] as List<Drink?>?) ?? [];
          children.add(SizedBox(height: 20));

          // sort glasses
          glasses.sort((a, b) {
            int aCount = 0;
            int bCount = 0;

            for (var drink in data) {
              if (drink == null) continue;
              if (drink.strGlass == a.name) aCount++;
              if (drink.strGlass == b.name) bCount++;
            }

            final int result = bCount.compareTo(aCount);

            if (result == 0) {
              return b.name.compareTo(a.name);
            }

            return result;
          });

          for (var glass in glasses) {
            final drinks = data
                .where((element) => element?.strGlass == glass.name)
                .map((e) => e!)
                .toList();

            if (drinks.isEmpty) {
              continue;
            }

            children.addAll(_createSection(
                glass.name.tr,
                '${widget.title.tr}: ${glass.name.tr}',
                glass.getIcon(),
                drinks));
          }
        } else {
          final shimmerGlasses = glasses.sample(10).toList();
          children.addAll(_createShimmers(
            shimmerGlasses.map((e) => e.name).toList(),
            images: shimmerGlasses.map((e) => e.getIcon() ?? '').toList(),
          ));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        );
      },
    );
  }

  Widget _ingredientDrinks(List<Drink> drinks) {
    final dataProvider = Get.find<PersistentDataProvider>();
    var ingredients = dataProvider.getCachedIngredients();

    return FutureBuilder(
      future: Future.wait([
        Future.wait(
            drinks.map((e) async => dataProvider.getDrink(e.idDrink)).toList()),
        Future.delayed(const Duration(milliseconds: 500))
      ]),
      builder: (context, snapshot) {
        final children = <Widget>[];

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error'));
          }

          final data = (snapshot.data?[0] as List<Drink?>?) ?? [];

          // get all ingredients from previously loaded drinks
          var ingredients = data
              .map((e) => e?.ingredients ?? [])
              .expand((element) => element)
              .toList();

          // count ingredients occurrences to sort them
          final ingredientCount = <Ingredient, int>{};
          for (var ingredient in ingredients) {
            ingredientCount.update(ingredient, (value) => value + 1,
                ifAbsent: () => 1);
          }

          // we only want ingredients that are used in more than one drink
          // but if we have less than 8 ingredients, we want to show them all
          final finalIngredients = ingredientCount.entries
              .toList()
              .where((element) => element.value > 1)
              .toList();

          finalIngredients.sort((a, b) {
            return b.value.compareTo(a.value);
          });

          if (finalIngredients.length < 8) {
            ingredients = ingredientCount.entries
                .map((e) => e.key)
                .take(15) // limit to 15
                .toList();
          } else {
            ingredients = finalIngredients
                .map((e) => e.key)
                .take(30) // limit to 30
                .toList();
          }

          // sort ingredients
          ingredients.sort((a, b) {
            int aCount = 0;
            int bCount = 0;

            for (var drink in data) {
              if (drink == null) continue;
              if (drink.ingredients.contains(a)) aCount++;
              if (drink.ingredients.contains(b)) bCount++;
            }

            final int result = bCount.compareTo(aCount);

            if (result == 0) {
              return b.name.compareTo(a.name);
            }

            return result;
          });

          children.add(SizedBox(height: 20));

          for (var ingredient in ingredients) {
            final drinks = data
                .where((element) =>
                    element?.ingredients
                        .any((element) => element.name == ingredient.name) ??
                    false)
                .map((e) => e!)
                .toList();

            if (drinks.isEmpty) {
              continue;
            }

            children.addAll(
              _createSection(
                ingredient.name.tr,
                '${widget.title.tr}: ${ingredient.name.tr}',
                ingredient.getLittleImageUrl(),
                drinks,
                imageIsLocale: false,
              ),
            );
          }
        } else {
          final shimmerIngredients = ingredients.sample(10).toList();
          children.addAll(_createShimmers(
            shimmerIngredients.map((e) => e.name).toList(),
            images:
                shimmerIngredients.map((e) => e.getLittleImageUrl()).toList(),
            imageIsLocale: false,
          ));
        }

        children.add(SizedBox(height: 10));

        children.add(Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(getPrimColor(context)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: Text('more_ingredients'.tr),
            onPressed: () {
              // TODO:
              Get.offNamed('/swipe');
            },
          ),
        ));

        children.add(SizedBox(height: 10));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        );
      },
    );
  }

  Widget _categoryDrinks(List<Drink> drinks) {
    final dataProvider = Get.find<PersistentDataProvider>();
    var categories = dataProvider.categories.toList();

    return FutureBuilder(
      future: Future.wait([
        Future.wait(
            drinks.map((e) async => dataProvider.getDrink(e.idDrink)).toList()),
        Future.delayed(const Duration(milliseconds: 500))
      ]),
      builder: (context, snapshot) {
        final children = <Widget>[];

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error'));
          }

          final data = (snapshot.data?[0] as List<Drink?>?) ?? [];
          children.add(SizedBox(height: 20));

          // sort glasses
          categories.sort((a, b) {
            int aCount = 0;
            int bCount = 0;

            for (var drink in data) {
              if (drink == null) continue;
              if (drink.strCategory == a.name) aCount++;
              if (drink.strCategory == b.name) bCount++;
            }

            final int result = bCount.compareTo(aCount);

            if (result == 0) {
              if (a.name == null) {
                return 1;
              }
              if (b.name == null) {
                return -1;
              }
              return b.name!.compareTo(a.name!);
            }

            return result;
          });

          for (var category in categories) {
            final drinks = data
                .where((element) => element?.strCategory == category.name)
                .map((e) => e!)
                .toList();

            if (drinks.isEmpty) {
              continue;
            }

            children.addAll(_createSection(
              category.name!.tr,
              '${widget.title.tr}: ${category.name!.tr}',
              category.imagePath ?? 'assets/img/cocktail.png',
              drinks,
            ));
          }
        } else {
          final shimmerCategories = categories.sample(10).toList();
          children.addAll(_createShimmers(
            shimmerCategories.map((e) => e.name!).toList(),
            images: shimmerCategories
                .map((e) => e.imagePath ?? 'assets/img/cocktail.png')
                .toList(),
          ));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        );
      },
    );
  }

  /// Create shimmers
  List<Widget> _createShimmers(List<String> titles,
      {List<String>? images, bool imageIsLocale = true}) {
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
                if (imageIsLocale) ...[
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ] else ...[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 45,
                      height: 45,
                      // Adjust the height as needed
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                SizedBox(width: 10),
                Text(
                  title.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

  List<Widget> _createSection(
      String title, String seeMoreTitle, String? image, List<Drink> drinks,
      {bool imageIsLocale = true}) {
    var result = <Widget>[];
    result.add(
      Padding(
        padding: EdgeInsets.only(left: 20, right: 10),
        child: GestureDetector(
          onTapUp: (details) {
            _openSeeMore(drinks, seeMoreTitle);
          },
          child: Row(
            children: [
              if (image != null) ...[
                if (imageIsLocale) ...[
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ] else ...[
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: image,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 45,
                          height: 45,
                          // Adjust the height as needed
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                ],
                SizedBox(width: 10),
              ],
              Text(
                title,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    result.add(SizedBox(height: 10));
    result.add(
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
                _openSeeMore(drinks, seeMoreTitle);
              }, primColor(context, index), 140, 205);
            }

            return DrinkCard(drink, index,
                singleColor: primColor(context, index));
          },
        ),
      ),
    );
    result.add(SizedBox(height: 20));
    return result;
  }

  _openSeeMore(List<Drink> drinks, String title) {
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
        title: title,
      ),
    );
  }
}
