import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/controllers/drink_controller.dart';
import 'package:cocktails/pages/favorites.dart';
import 'package:cocktails/pages/home.dart';
import 'package:cocktails/pages/splash.dart';
import 'package:cocktails/pages/swipe.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.put(CategoryController());
    final DrinkController drinkController = Get.put(DrinkController());

    final TheCocktailsDBService cocktailsDBService = Get.put(TheCocktailsDBService());
    return FutureBuilder(
      future: Future.wait([
        cocktailsDBService.getCategories(),
        cocktailsDBService.getRandomDrinks(5),
        Future.delayed(const Duration(seconds: 2)),
      ]),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done) {

          if (snapshot.hasData) {
            if (snapshot.data![0] != null && snapshot.data![0].drinks != null) {
              categoryController.updateCategoriesDrink(snapshot.data![0].drinks!);
            }

            if(snapshot.data![1] != null && snapshot.data![1].drinks != null) {
              drinkController.updateDrinks(snapshot.data![1].drinks!);
            }

          }

          child = GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Karla'),
            getPages: [
              GetPage(
                  name: '/',
                  page: () => const HomePage(),
                  transition: Transition.fadeIn
              ),
              GetPage(
                  name: '/favorites',
                  page: () => const FavoritesPage(),
                  transition: Transition.fadeIn
              ),
              GetPage(
                  name: '/swipe',
                  page: () => const SwipePage(),
                  transition: Transition.fadeIn
              )
            ],
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
