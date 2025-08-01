import 'dart:math';

import 'package:get/get.dart';

class GameController extends GetxController {
  final List<String> words = ['tree', 'star', 'moon', 'book', 'cake', 'ship'];
  final RxString secretWord = ''.obs;
  final RxList<String> guesses = <String>[].obs;
  final RxInt score = 0.obs;

  @override
  void onInit() {
    super.onInit();
    newGame();
  }

  void newGame() {
    secretWord.value = words[Random().nextInt(words.length)];
    guesses.clear();
    // Don't reset score here - let it accumulate across games
  }

  void makeGuess(String? guess) {
    if (guess == null) return;

    final trimmedGuess = guess.trim();
    if (trimmedGuess.length == 4 &&
        RegExp(r'^[a-zA-Z]+$').hasMatch(trimmedGuess)) {
      guesses.add(trimmedGuess);
      if (trimmedGuess.toLowerCase() == secretWord.value.toLowerCase()) {
        score.value += 10;
        // Add a small delay before starting new game for better UX
        Future.delayed(const Duration(milliseconds: 1500), newGame);
      }
    }
  }
}
