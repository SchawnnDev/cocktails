import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/controllers/drink_controller.dart';
import 'package:cocktails/models/drink.dart';
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
      appBar: appBar(),
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
            'Recommendation',
            style: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          color: Colors.white,
          height: 190,
          child: GetX<DrinkController>(builder: (logic) {
            return ListView.separated(
                itemCount: drinkController.drinks.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 20, right: 20),
                separatorBuilder: (context, index) => SizedBox(
                      width: 25,
                    ),
                itemBuilder: (context, index) {
                  final Drink drink = drinkController.drinks[index];
                  return _recommendationSectionItem(index, drink);
                });
          }),
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
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Use CachedNetworkImage for loading the image with a placeholder
              SizedBox(
                width: 100,
                child: CachedNetworkImage(
                  imageUrl: drink.thumbnail ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    height: 100,
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
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
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
                      if (drink.ingredients != null &&
                          drink.ingredients!.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${drink.ingredients!.length}',
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
                  ),
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
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                builder: (context) => FractionallySizedBox(
                    heightFactor: 0.98, child: _buildRecipeModal(drink)),
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
          child: Text(
            'Category >',
            style: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            height: 120,
            color: Colors.white, // Color(0xFFBAA9DB),
            child: GetX<CategoryController>(builder: (logic) {
              return ListView.separated(
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
              );
            })),
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
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14,
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
              onTap: () {},
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

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Cocktails',
        style: TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      // leading: GestureDetector(
      //   child: Container(
      //     margin: EdgeInsets.all(10),
      //     alignment: Alignment.center,
      //     decoration: BoxDecoration(
      //         color: Color(0xffF7F8F8),
      //         borderRadius: BorderRadius.circular(10)),
      //     child: Icon(
      //       Icons.chevron_left,
      //       color: Colors.black,
      //       size: 24.0,
      //     ),
      //   ),
      // ),
    );
  }

  CustomScrollView _buildRecipeModal(Drink drink) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250.0,
          pinned: true,
          backgroundColor: Color(0xFFBAA9DB).withOpacity(0.3),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              drink.strDrink!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
            background: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CachedNetworkImage(
                      imageUrl: drink.strDrinkThumb ?? '',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 4),
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
                  )
                ],
              ),
            ),
            collapseMode: CollapseMode.pin,
          ),
          leading: Container(
            // margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              icon: Icon(Icons.close_outlined),
              color: Colors.black,
              onPressed: () {
                // Add your settings button functionality here
              },
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(Icons.favorite_outline),
                color: Colors.black,
                onPressed: () {
                  // Add your settings button functionality here
                },
              ),
            )
          ],
        ),
        SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Color(0xFFBAA9DB).withOpacity(0.6),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      'Ingredients',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 20,
                      // Adjust the spacing between items
                      runSpacing: 10,
                      // Adjust the run spacing (spacing between rows)
                      children: List.generate(
                        drink.ingredients!.length,
                        (index) => SizedBox(
                          width: 80, // Adjust the width as needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50, // Adjust the width as needed
                                height: 50, // Adjust the height as needed
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Icon(Icons.fastfood_outlined),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                drink.measures![index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                drink.ingredients![index],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFFBAA9DB).withOpacity(0.3),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      drink.strInstructions ?? 'No instructions',
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )
            ])
        ),
      ],
    );
  }
}
