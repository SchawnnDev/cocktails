import 'dart:math';
import 'dart:ui';

Color generateRandomPastelColor() {
  Random random = Random();

  // Generate random RGB values
  int red = 128 + random.nextInt(128);
  int green = 128 + random.nextInt(128);
  int blue = 128 + random.nextInt(128);

  // Create a color by blending with white
  return Color.fromARGB(255, red, green, blue);
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}
