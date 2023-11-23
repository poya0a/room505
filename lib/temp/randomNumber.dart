import 'dart:math';

int generateRandomNumber() {
  Random random = Random();
  return 100 + random.nextInt(900);
}
