import 'package:cocktails/controllers/category_controller.dart';
import 'package:cocktails/pages/home.dart';
import 'package:cocktails/pages/splash.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.put(CategoryController());
    final TheCocktailsDBService cocktailsDBService = Get.put(TheCocktailsDBService());
    return FutureBuilder(
      future: Future.wait([
        cocktailsDBService.getCategories(),
        Future.delayed(const Duration(seconds: 2)),
      ]),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done) {

          if (snapshot.hasData) {
            if (snapshot.data?[0] != null && snapshot.data![0].drinks != null) {
              categoryController.updateCategoriesDrink(snapshot.data![0].drinks!);
            }
          }

          child = GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Karla'),
            getPages: [
              GetPage(
                  name: '/',
                  page: () => const HomePage(),
                  transition: Transition.fadeIn)
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
