import 'dart:ui';

class Category {
  String? name;
  late Color boxColor;
  late String? imagePath;

  Category({required this.name}) {
    imagePath = _getImagePath();
    boxColor = Color(0xFFBAA9DB); //generateRandomPastelColor();
  }

  String? _getImagePath() {
    switch (name) {
      case 'Cocktail':
        return 'assets/img/cocktail.png';
      case 'Ordinary Drink':
        return 'assets/img/soda.png';
      case 'Shake':
        return 'assets/img/frappe.png';
      case 'Other / Unknown':
        return 'assets/img/open-box.png';
      case 'Cocoa':
        return 'assets/img/cocoa.png';
      case 'Shot':
        return 'assets/img/tequila-shot.png';
      case 'Coffee / Tea':
        return 'assets/img/coffee-cup.png';
      case 'Homemade Liqueur':
        return 'assets/img/liqueur.png';
      case 'Punch / Party Drink':
        return 'assets/img/punch.png';
      case 'Beer':
        return 'assets/img/beer.png';
      case 'Soft Drink':
        return 'assets/img/soft-drinks.png';
    }
    return 'assets/img/cocktail.png';
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['strCategory']);
  }
}
