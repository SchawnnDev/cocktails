class Drinks<T> {
  List<T>? drinks;

  Drinks({this.drinks});

  Drinks.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    if (json['drinks'] != null) {
      drinks = <T>[];
      json['drinks'].forEach((v) {
        drinks!.add(fromJsonT(v));
      });
    }
  }
}
