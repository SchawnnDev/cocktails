import 'package:cocktails/pages/categories/categories.dart';
import 'package:cocktails/pages/categories/category.dart';
import 'package:cocktails/pages/favorites.dart';
import 'package:cocktails/pages/home.dart';
import 'package:cocktails/pages/settings.dart';
import 'package:cocktails/pages/swipe.dart';
import 'package:get/get.dart';

class Routes {
  static const String initialRoute = '/';

  static final routes = [
    GetPage(
      name: '/',
      page: () => const HomePage(),
      transition: Transition.fadeIn,
      binding: HomePageBinding(),
    ),
    GetPage(
      name: '/categories',
      page: () => const CategoriesPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
      binding: CategoriesPageBinding(),
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
  ];
}
