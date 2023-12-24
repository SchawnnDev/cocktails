class Glass {
  final String name;

  Glass({required this.name});

  factory Glass.fromJson(Map<String, dynamic> json) {
    return Glass(name: json['strGlass']);
  }
}