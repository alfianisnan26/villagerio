import 'dart:math' as math;

class Random {
  static int generateRandomNumber(int min, int max) {
    if (min >= max) {
      throw ArgumentError("min must be less than max");
    }

    math.Random random = math.Random();
    int range = max - min + 1;
    return min + random.nextInt(range);
  }
}
