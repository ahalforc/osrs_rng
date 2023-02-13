import 'dart:math';

List<int> simulate({required int numerator, required int denominator}) {
  final random = Random();
  final result = List.generate(denominator, (_) => 0);
  while (result.sublist(0, numerator).any((i) => i == 0)) {
    result[random.nextInt(result.length)]++;
  }
  return result;
}
