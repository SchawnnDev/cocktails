import 'package:cocktails/controllers/categories_controller.dart';
import 'package:cocktails/models/category.dart';
import 'package:cocktails/pages/widgets/cocktails_appbar.dart';
import 'package:cocktails/pages/widgets/navbar.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesPageBinding extends Bindings {
  @override
  void dependencies() {
    final dataProvider = Get.find<PersistentDataProvider>();
    Get.lazyPut(() => CategoriesController(categories: dataProvider.categories));
  }
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CategoriesController categoriesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CocktailsAppBar(title: 'categories'.tr, isBackButton: true),
      backgroundColor: Colors.white,
      body:
          Container(constraints: BoxConstraints.expand(), child: _categories()),
      bottomNavigationBar: NavBar(
        animate: false,
      ),
      extendBody: true,
    );
  }

  SingleChildScrollView _categories() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Obx(() => Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.spaceEvenly,
                  children: List.generate(categoriesController.categories.length,
                      (index) {
                    // For scrolling test, uncomment this
                    // if (index >= categoryController.categories.length) {
                    //   return _categoriesItem(Category(name: 'Test'), index);
                    // }

                    return _categoriesItem(
                        categoriesController.categories[index], index);
                  }),
                )),
          ),
        ),
      ),
    );
  }

  SizedBox _categoriesItem(Category category, int index) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Container(
            width: 105,
            decoration: BoxDecoration(
                color:
                    category.boxColor.withOpacity(index % 2 == 0 ? 0.6 : 0.3),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 65,
                  height: 65,
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
                      fontSize: 17,
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
                      '/category/${Uri.encodeComponent(category.name)}');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
