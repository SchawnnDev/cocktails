import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/controllers/drink_controller.dart';
import 'package:cocktails/pages/categories/categories.dart';
import 'package:cocktails/pages/categories/category.dart';
import 'package:cocktails/pages/favorites.dart';
import 'package:cocktails/pages/home.dart';
import 'package:cocktails/pages/settings.dart';
import 'package:cocktails/pages/splash.dart';
import 'package:cocktails/pages/swipe.dart';
import 'package:cocktails/services/boxes_service.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:cocktails/utils/translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  runApp(const MyApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => BoxesService().init());
  await Get.putAsync(() => TheCocktailsDBService().init());
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LanguageController(), permanent: true);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<BoxesService>();
    final categoryController = Get.put(CategoryController(), permanent: true);
    final drinkController = Get.put(DrinkController());
    Get.put(LanguageController(), permanent: true);
    final cocktailsDBService = Get.find<TheCocktailsDBService>();

    return FutureBuilder(
      future: Future.wait([
        cocktailsDBService.getCategories(),
        cocktailsDBService.getRandomDrinks(2),
        // Future.delayed(const Duration(seconds: 2)),
      ]),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data![0].drinks != null) {
              categoryController
                  .updateCategoriesDrink(snapshot.data![0].drinks!);
            }

            if (snapshot.data![1].drinks != null) {
              drinkController.updateDrinks(snapshot.data![1].drinks!);
            }
          }

          child = GetMaterialApp(
            translations: AppTranslations(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Karla'),
            locale: Locale(
                storage.settingsBox.get('languageCode', defaultValue: 'en'),
                storage.settingsBox.get('countryCode', defaultValue: 'US')),
            // Not Get.deviceLocale
            fallbackLocale: Locale('en', 'US'),
            initialRoute: '/swipe',
            getPages: [
              GetPage(
                  name: '/',
                  page: () => const HomePage(),
                  transition: Transition.fadeIn),
              GetPage(
                name: '/categories',
                page: () => const CategoriesPage(),
                transition: Transition.rightToLeft,
                transitionDuration: const Duration(milliseconds: 200),
              ),
              GetPage(
                name: '/category/:category_name',
                page: () => const CategoryPage(),
                transition: Transition.rightToLeft,
                transitionDuration: const Duration(milliseconds: 200),
                binding: CategoryPageBinding(),
              ),
              GetPage(
                  name: '/favorites',
                  page: () => const FavoritesPage(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: '/swipe',
                  page: () => const SwipePage(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: '/settings',
                  page: () => const SettingsPage(),
                  transition: Transition.fadeIn)
            ],
            initialBinding: InitialBinding(),
          );
        } else {
          child = const Splash();
        }
        return AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: child,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            });
      },
    );
  }
}
