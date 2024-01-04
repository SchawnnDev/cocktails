class Glass {
  final String name;

  Glass({required this.name});

  factory Glass.fromJson(Map<String, dynamic> json) {
    return Glass(name: json['strGlass']);
  }

  String? getIcon() {
    const String prefix = 'assets/img';
    switch (name.toLowerCase()) {
      case "highball glass":
        return "$prefix/glass/highball.png";
      case "cocktail glass":
        return "$prefix/glass/cocktail.png";
      case "old-fashioned glass":
        return "$prefix/glass/old-fashioned.png";
      case "whiskey glass":
        return "$prefix/glass/whiskey.png";
      case "collins glass":
        return "$prefix/glass/collins.png";
      case "pousse cafe glass":
        return "$prefix/glass/cocktail.png"; // no image found
      case "champagne flute":
        return "$prefix/glass/champagne.png";
      case "whiskey sour glass":
        return "$prefix/glass/whiskey-sour.png";
      case "cordial glass":
        return "$prefix/glass/cordial.png";
      case "brandy snifter":
        return "$prefix/glass/brandy.png";
      case "white wine glass":
        return "$prefix/glass/white-wine.png";
      case "nick and nora glass":
        return "$prefix/glass/cocktail.png"; // no image found
      case "hurricane glass":
        return "$prefix/glass/hurricane.png";
      case "coffee mug":
        return "$prefix/glass/coffee-cup.png";
      case "shot glass":
        return "$prefix/glass/tequila-shot.png";
      case "jar":
        return "$prefix/glass/jar.png";
      case "irish coffee cup":
        return "$prefix/glass/irish-coffee.png";
      case "punch bowl":
        return "$prefix/punch.png";
      case "pitcher":
        return "$prefix/glass/pitcher.png";
      case "pint glass":
        return "$prefix/glass/pint.png";
      case "copper mug":
        return "$prefix/glass/copper-mug.png";
      case "wine glass":
        return "$prefix/glass/wine-glass.png";
      case "beer mug":
        return "$prefix/glass/beer.png";
      case "margarita/coupette glass":
        return "$prefix/glass/margarita.png";
      case "beer pilsner":
        return "$prefix/glass/pilsner.png";
      case "beer glass":
        return "$prefix/glass/beer.png";
      case "parfait glass":
        return "$prefix/glass/parfait.png";
      case "mason jar":
        return "$prefix/glass/smoothie.png";
      case "margarita glass":
        return "$prefix/glass/margarita.png";
      case "martini glass":
        return "$prefix/glass/martini.png";
      case "balloon glass":
        return "$prefix/glass/balloon.png";
      case "coupe glass":
        return "$prefix/glass/coupe.png";
      default:
        return null;
    }
  }
}
