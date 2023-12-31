class Filter {
  final String name; // i18n key, also used for comparison
  final String imagePath;

  const Filter(this.name, this.imagePath);


  @override
  String toString() {
    return 'Filter{name: $name, imagePath: $imagePath}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Filter && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  static const Filter defaultFilter =
      Filter('all', 'assets/img/drink.png');
  static const Filter alcoholicFilter =
      Filter('alcoholic', 'assets/img/drunk.png');
  static const Filter glassFilter =
      Filter('glass', 'assets/img/beverage.png');
  static const Filter categoryFilter =
      Filter('category', 'assets/img/bar-counter.png');
  static const Filter ingredientFilter =
      Filter('ingredient', 'assets/img/grocery.png');
  static const Filter nameFilter =
      Filter('name', 'assets/img/letter.png');

}
