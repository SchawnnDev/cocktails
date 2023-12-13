import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/controllers/drink_controller.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/pages/widgets/cocktails_appbar.dart';
import 'package:cocktails/pages/widgets/drink_recipe_modal.dart';
import 'package:cocktails/pages/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cocktails/models/category.dart';
import 'package:shimmer/shimmer.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryController categoryController = Get.find();
  final DrinkController drinkController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CocktailsAppBar(isBackButton: false),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          SizedBox(
            height: 20,
          ),
          _categoriesSection(),
          SizedBox(
            height: 20,
          ),
          _recommendationSection()
        ],
      ),
      bottomNavigationBar: NavBar()
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
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          color: Colors.white,
          height: 220,
          child: Obx(() => ListView.separated(
              itemCount: drinkController.drinks.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 20, right: 20),
              separatorBuilder: (context, index) => SizedBox(
                    width: 25,
                  ),
              itemBuilder: (context, index) {
                final Drink drink = drinkController.drinks[index];
                return _recommendationSectionItem(index, drink);
              })),
        )
      ],
    );
  }

  Stack _recommendationSectionItem(int index, Drink drink) {
    return Stack(children: [
      Container(
        width: 150,
        decoration: BoxDecoration(
          color: Color(0xFFBAA9DB).withOpacity(index % 2 == 0 ? 0.6 : 0.3),
          //generateRandomPastelColor().withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Use CachedNetworkImage for loading the image with a placeholder
              SizedBox(
                height: 120,
                width: 120,
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
              Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Text(
                  drink.strDrink ?? 'No name',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    //fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              if (drink.strAlcoholic != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      drink.strAlcoholic! == "Alcoholic"
                          ? Icons.local_bar_outlined
                          : Icons.no_drinks_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                    Spacer(),
                    if (drink.ingredients.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${drink.ingredients.length}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            Icons.liquor,
                            size: 20,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ],
                  ],
                )
              ],
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
                  itemCount: categoryController.categories.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  separatorBuilder: (context, index) => SizedBox(
                    width: 25,
                  ),
                  itemBuilder: (context, index) {
                    final Category category =
                        categoryController.categories[index];
                    return _categoriesSectionItem(category, index);
                  },
                ))),
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
            hintText: 'Search Cocktail',
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
