import 'package:cocktails/controllers/favorites_controller.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/utils/themes.dart';
import 'package:cocktails/views/widgets/cocktails_appbar.dart';
import 'package:cocktails/views/widgets/drink_card.dart';
import 'package:cocktails/views/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesPageBinding extends Bindings {
  @override
  void dependencies() {
    final dataProvider = Get.find<PersistentDataProvider>();
    Get.lazyPut(() => FavoritesController(
        favorites: dataProvider.drinks
            .where((element) => element.favorite.value)
            .toList()));
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
      bottomNavigationBar: NavBar(
        index: 1,
        animate: true,
      ),
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
              Obx(() => Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.spaceEvenly,
                    children: List.generate(
                        favoritesController.favorites.length, (index) {
                      // For scrolling test, uncomment this
                      // if (index >= categoryController.categories.length) {
                      //   return _categoriesItem(Category(name: 'Test'), index);
                      // }
                      final drink = favoritesController.favorites[index];

                      return DrinkCard(
                        drink,
                        index,
                        singleColor:
                            Theme.of(context).primaryColor.withOpacity(0.6),
                      );
                    }),
                  )),
              SizedBox(height: 20),
              Center(
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
