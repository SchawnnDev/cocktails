import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/controllers/drink_controller.dart';
import 'package:cocktails/models/drink.dart';
import 'package:cocktails/pages/widgets/navbar.dart';
import 'package:cocktails/utils/utils.dart';
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
            height: 40,
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
          height: 240,
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
                  return Container(
                    width: 180,
                    decoration: BoxDecoration(
                      color: Color(0xFFBAA9DB).withOpacity(index % 2 == 0 ? 0.6 : 0.3),//generateRandomPastelColor().withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Use CachedNetworkImage for loading the image with a placeholder
                        SizedBox(
                          width: 130,
                          child: CachedNetworkImage(
                            imageUrl: drink.thumbnail ?? '',
                            imageBuilder: (context, imageProvider) => Container(
                              height: 120,
                              // Adjust the height as needed
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                                height: 120, // Adjust the height as needed
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
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
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        if (drink.strAlcoholic != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                drink.strAlcoholic! == "Alcoholic" ? Icons.local_bar : Icons.no_drinks,
                                size: 16,
                                color: Colors.grey,
                              ),
                              Text(
                                drink.strAlcoholic!,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          )
                        ],
                        if (drink.ingredients != null && drink.ingredients!.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${drink.ingredients!.length}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                  Icons.shopping_cart_outlined,
                                size: 16,
                                color: Colors.black,
                              )
                            ],
                          )
                        ],
                        // Container(
                        //   height: 45,
                        //   width: 130,
                        //   decoration: BoxDecoration(
                        //     gradient: LinearGradient(colors: [
                        //       Color(0xff9DCEFF),
                        //       Color(0xff92A3FD),
                        //     ]),
                        //     borderRadius: BorderRadius.circular(50),
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       'View',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.w600,
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  );
                });
          }),
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
          child: Text(
            'Category',
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
                  return Container(
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
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(category.imagePath ?? 'img/cocktail.png')
                          ),
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
                  );
                },
              );
            })),
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
}
