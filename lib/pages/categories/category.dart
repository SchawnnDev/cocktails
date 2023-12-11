import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/controllers/drink_controller.dart';
import 'package:cocktails/models/category.dart';
import 'package:cocktails/pages/widgets/cocktails_appbar.dart';
import 'package:cocktails/pages/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DrinkController());
  }
}

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

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

    return Scaffold(
        appBar: CocktailsAppBar(title: category.name, isBackButton: true),
        backgroundColor: Colors.white,
        body: _categories(),
        bottomNavigationBar: NavBar(
          animate: false,
        ));
  }

  SingleChildScrollView _categories() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text('Category Page'),
          // child: Obx(() => Wrap(
          //       spacing: 15,
          //       runSpacing: 15,
          //       children: List.generate(categoryController.categories.length,
          //           (index) {
          //         // For scrolling test, uncomment this
          //         // if (index >= categoryController.categories.length) {
          //         //   return _categoriesItem(Category(name: 'Test'), index);
          //         // }
          //
          //         return _categoriesItem(
          //             categoryController.categories[index], index);
          //       }),
          //     )),
        ),
      ),
    );
  }

  SizedBox _categoriesItem(Category category, int index) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
                color:
                    category.boxColor.withOpacity(index % 2 == 0 ? 0.6 : 0.3),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                          category.imagePath ?? 'img/cocktail.png')),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 18,
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
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
