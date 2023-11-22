import 'dart:ui';

import 'package:cocktails/utils/utils.dart';

class Category {
  String name;
  Color boxColor;

  Category({required this.name, Color? boxColor})
    : boxColor = boxColor ?? generateRandomPastelColor();
}
