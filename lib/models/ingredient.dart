import 'package:cocktails/utils/consts.dart';

class Ingredient {
  final String name;
  final String? measure;

  Ingredient({required this.name, this.measure});

  String getLittleImageUrl() {
    return "$apiIngredientImageUrl/$name.png";
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(name: json['strIngredient1'] ?? json['strIngredient']);
  }

  @override
  String toString() {
    return 'Ingredient{name: $name, measure: $measure}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
