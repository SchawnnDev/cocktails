import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/drinks.dart';
import 'package:cocktails/pages/widgets/cocktails_appbar.dart';
import 'package:cocktails/pages/widgets/drink_recipe_modal.dart';
import 'package:cocktails/pages/widgets/navbar.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
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
  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();
    var categoryName = Get.parameters['category_name'];

    if (categoryName == null) {
      Get.back();
      return Scaffold();
    }

    categoryName = Uri.decodeComponent(categoryName);
    final category = categoryController.categories
        .firstWhereOrNull((element) => element.name == categoryName);

    if (category == null) {
      Get.back();
      return Scaffold();
    }

    final cocktailsDBService = Get.find<TheCocktailsDBService>();

    return Scaffold(
      appBar: CocktailsAppBar(title: category.name, isBackButton: true),
      backgroundColor: Colors.white,
      body: Container(
        constraints: BoxConstraints.expand(),
        child: FutureBuilder(
          future: cocktailsDBService.getDrinks(categoryName),
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
                return _drinks(snapshot.data);
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

  SafeArea _drinks(Drinks? data) {
    return SafeArea(
      child: CustomScrollView(slivers: [
        SliverFillRemaining(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            itemCount: data?.drinks?.length ?? 0,
            itemBuilder: (context, index) {
              return _drinkItem(data!.drinks![index], index);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 16); // Adjust the height as needed
            },
          ),
        )),
      ]),
    );
  }

  Stack _drinkItem(Drink drink, int index) {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        decoration: BoxDecoration(
          color: Color(0xFFBAA9DB).withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Use CachedNetworkImage for loading the image with a placeholder
              SizedBox(
                height: 100,
                width: 100,
                child: CachedNetworkImage(
                  imageUrl: drink.thumbnail ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    // Adjust the height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
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
                      height: 100,
                      // Adjust the height as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(width: 5),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2),
                  child: Text(
                    (drink.strDrink ?? 'No name').toUpperCase(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            splashColor: Color(0x00542E71).withOpacity(0.2),
            highlightColor: Color(0x00542E71).withOpacity(0.3),
            onTapUp: (TapUpDetails details) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                enableDrag: true,
                showDragHandle: false,
                useSafeArea: true,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                builder: (context) => DrinkRecipeModal(
                  drink: drink,
                ),
              );
            },
          ),
        ),
      ),
    ]);
  }
}
