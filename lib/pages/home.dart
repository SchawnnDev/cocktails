import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/controllers/home_controller.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/models/ingredient.dart';
import 'package:cocktails/pages/widgets/cocktails_appbar.dart';
import 'package:cocktails/pages/widgets/drink_card.dart';
import 'package:cocktails/pages/widgets/drink_recipe_modal.dart';
import 'package:cocktails/pages/widgets/navbar.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cocktails/models/category.dart';
import 'package:shimmer/shimmer.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    final dataProvider = Get.find<PersistentDataProvider>();
    Get.lazyPut(() => HomeController(
          categories: dataProvider.categories,
          recommendations: dataProvider.randomDrinks,
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CocktailsAppBar(isBackButton: false),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchField(),
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    _recommendationSection(),
                    SizedBox(
                      height: 20,
                    ),
                    _categoriesSection(),
                    if (homeController.ingredients.isNotEmpty) ...[
                      SizedBox(
                        height: 20,
                      ),
                      _ingredientsSection(),
                    ],
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        extendBody: true,
        bottomNavigationBar: NavBar(),
    );
  }

  Column _recommendationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'recommendation'.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          color: Colors.white,
          height: 205,
          child: Obx(() => ListView.separated(
              itemCount: homeController.recommendations.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 20, right: 20),
              separatorBuilder: (context, index) => SizedBox(
                    width: 25,
                  ),
              itemBuilder: (context, index) {
                final Drink drink = homeController.recommendations[index];
                return DrinkCard(drink, index);
              }),
          ),
        )
      ],
    );
  }

  Column _categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTapUp: (details) {
              Get.toNamed('/categories');
            },
            child: Row(
              children: [
                Text(
                  'categories'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: 16,
                  weight: 16,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            height: 120,
            color: Colors.white,
            child: Obx(() => ListView.separated(
                  itemCount: homeController.categories.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  separatorBuilder: (context, index) => SizedBox(
                    width: 25,
                  ),
                  itemBuilder: (context, index) {
                    final Category category = homeController.categories[index];
                    return _categoriesSectionItem(category, index);
                  },
                )),),
      ],
    );
  }

  Stack _categoriesSectionItem(Category category, int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          decoration: BoxDecoration(
              color: category.boxColor.withOpacity(index % 2 == 0 ? 0.6 : 0.3),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Image.asset(category.imagePath ?? 'img/cocktail.png')),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: Color(0x00542E71).withOpacity(0.2),
              highlightColor: Color(0x00542E71).withOpacity(0.3),
              onTapUp: (TapUpDetails details) {
                Get.toNamed('/category/${Uri.encodeComponent(category.name)}');
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _ingredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTapUp: (details) {
              Get.toNamed('/ingredients');
            },
            child: Row(
              children: [
                Text(
                  'ingredients'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: 16,
                  weight: 16,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            height: 120,
            color: Colors.white,
            child: Obx(() => ListView.separated(
                  itemCount: homeController.ingredients.length + 1,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  separatorBuilder: (context, index) => SizedBox(
                    width: 25,
                  ),
                  itemBuilder: (context, index) {
                    if (index == homeController.ingredients.length) {
                      return _ingredientsSectionItemMore(index);
                    }

                    final Ingredient ingredient =
                        homeController.ingredients[index];
                    return _ingredientsSectionItem(ingredient, index);
                  },
                ))),
      ],
    );
  }

  Stack _ingredientsSectionItem(Ingredient ingredient, int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          decoration: BoxDecoration(
              color: Color(0xFFBAA9DB).withOpacity(index % 2 == 0 ? 0.6 : 0.3),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 50, // Adjust the width as needed
                height: 50, // Adjust the height as needed
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: ingredient.getLittleImageUrl(),
                    imageBuilder: (context, imageProvider) => Container(
                      height: 40,
                      width: 40,
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
                        width: 50,
                        height: 50,
                        // Adjust the height as needed
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  ingredient.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: Color(0x00542E71).withOpacity(0.2),
              highlightColor: Color(0x00542E71).withOpacity(0.3),
              onTapUp: (TapUpDetails details) {
                Get.toNamed(
                    '/ingredient/${Uri.encodeComponent(ingredient.name)}');
              },
            ),
          ),
        ),
      ],
    );
  }

  Stack _ingredientsSectionItemMore(int index) {
    return Stack(
      children: [
        Container(
            width: 100,
            decoration: BoxDecoration(
                color:
                    Color(0xFFBAA9DB).withOpacity(index % 2 == 0 ? 0.6 : 0.3),
                borderRadius: BorderRadius.circular(16)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(
                'see_all_ingredients'.tr,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ))),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: Color(0x00542E71).withOpacity(0.2),
              highlightColor: Color(0x00542E71).withOpacity(0.3),
              onTapUp: (TapUpDetails details) {
                Get.toNamed('/ingredients');
              },
            ),
          ),
        ),
      ],
    );
  }

  Container _searchField() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xff1D1617).withOpacity(0.11),
          blurRadius: 40,
          spreadRadius: 0.0,
        )
      ]),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(15),
            hintText: 'search_cocktail_hint'.tr,
            hintStyle: TextStyle(color: Color(0xffDDDADA)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            /*         suffixIcon: Container(
                  width: 80,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        VerticalDivider(
                          color: Colors.black,
                          indent: 10,
                          endIndent: 10,
                          thickness: 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
