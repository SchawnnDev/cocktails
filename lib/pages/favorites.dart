import 'package:cocktails/controllers/favorites_controller.dart';
import 'package:cocktails/pages/widgets/cocktails_appbar.dart';
import 'package:cocktails/pages/widgets/drink_card.dart';
import 'package:cocktails/pages/widgets/navbar.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesPageBinding extends Bindings {
  @override
  void dependencies() {
    final dataProvider = Get.find<PersistentDataProvider>();
    Get.lazyPut(() =>
        FavoritesController(
            favorites: dataProvider.randomDrinks)); // TODO: Change this
  }
}

class FavoritesPage extends StatefulWidget {

  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesController favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CocktailsAppBar(title: 'favorites'.tr, isBackButton: false),
      bottomNavigationBar: NavBar(index: 1, animate: true,),
      backgroundColor: Colors.white,
      body: Container(
        constraints: BoxConstraints.expand(),
        child: _favorites(),
      ),
      extendBody: true,
    );
  }

  SingleChildScrollView _favorites() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() =>
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.spaceEvenly,
                  children: List.generate(
                      favoritesController.favorites.length,
                          (index) {
                        // For scrolling test, uncomment this
                        // if (index >= categoryController.categories.length) {
                        //   return _categoriesItem(Category(name: 'Test'), index);
                        // }
                            final drink = favoritesController.favorites[index];

                        return DrinkCard(drink, index, singleColor: Color(0xFFBAA9DB).withOpacity(0.6),);
                      }),
                )),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>( Color(0xFFBAA9DB)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Text('more_favorites'.tr),
                  onPressed: () {
                    Get.offNamed('/swipe');
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
