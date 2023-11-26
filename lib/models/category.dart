import 'dart:ui';

import 'package:cocktails/utils/utils.dart';

class Category {
  String name;
  late Color boxColor;
  late String? imagePath;

  Category({required this.name}) {
    imagePath = _getImagePath();
    boxColor = generateRandomPastelColor();
  }


  String? _getImagePath() {
    switch (name) {
      case 'Cocktail':
        return 'img/cocktail.png';
      case 'Ordinary Drink':
        return 'img/soda.png';
      case 'Shake':
        return 'img/frappe.png';
      case 'Other / Unknown':
        return 'img/open-box.png';
      case 'Cocoa':
        return 'img/cocoa.png';
      case 'Shot':
        return 'img/tequila-shot.png';
      case 'Coffee / Tea':
        return 'img/coffee-cup.png';
      case 'Homemade Liqueur':
        return 'img/liqueur.png';
      case 'Punch / Party Drink':
        return 'img/punch.png';
      case 'Beer':
        return 'img/beer.png';
      case 'Soft Drink':
        return 'img/soft-drinks.png';
    }
  }

}
