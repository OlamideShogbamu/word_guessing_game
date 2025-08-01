import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:word_guessing_game/game_controller.dart';

void main() {
  // Setup GetX for testing
  setUpAll(() {
    Get.testMode = true; // Fixed: removed extra semicolon
  });

  group('GameController Tests', () {
    late GameController controller;

    setUp(() {
      controller = GameController();
    });

    tearDown(Get.reset);

    group('1. Secret Word Selection Tests', () {
      test('should select a secret word from the predefined list', () {
        // Act
        controller.onInit();

        // Assert that the secret word is selected from the list
        expect(
          controller.secretWord.value,
          isNotEmpty,
        ); // Fixed: removed duplicate check
        expect(controller.words.contains(controller.secretWord.value), true);
      });

      test('should select a new secret word on new game', () {
        Set<String> selectedWords = {};

        for (int i = 0; i < 20; i++) {
          controller.newGame();
          selectedWords.add(controller.secretWord.value);
        }

        // Assert - should select from a valid list and show some variety
        expect(selectedWords.length, greaterThan(1));
        for (final String word in selectedWords) {
          expect(controller.words.contains(word), true);
          expect(word.length, equals(4)); // Fixed: 'except' -> 'expect'
        }
      });

      test('should not select a secret word that is not in the list', () {
        for (int i = 0; i < 10; i++) {
          controller.newGame();
          expect(
            controller.words.contains(controller.secretWord.value),
            true,
            reason:
                'Selected word "${controller.secretWord.value}" is not in the list',
          );
        }
      });
    });

    group('2. Guessing Logic Tests', () {
      setUp(() {
        controller.onInit();
        controller.secretWord.value =
            'tree'; // Set a known secret word for testing
      });

      test('should accept exactly 4-letter words', () {
        controller.makeGuess('star');
        expect(controller.guesses.length, 1);
        expect(controller.guesses.contains('star'), true);
      });

      test('should not accept guesses that are not 4 letters', () {
        controller.makeGuess('st');
        expect(controller.guesses.length, 0);

        controller.makeGuess('stars');
        expect(controller.guesses.length, 0);

        controller.makeGuess('');
        expect(controller.guesses.length, 0);
      });

      test('should correctly identify incorrect guesses', () {
        controller.secretWord.value = 'tree';
        controller.makeGuess('star');

        expect(controller.guesses.contains('star'), true);
        expect(controller.secretWord.value, 'tree');
      });

      test('should handle case-insensitive comparisons', () {
        // Fixed: added missing opening brace
        int initialScore = controller.score.value; // Fixed: 'init' -> 'int'

        controller.makeGuess('TrEe');
        expect(
          controller.score.value,
          initialScore + 10,
        ); // Fixed: removed extra closing parenthesis
      });
    });

    group('3. Scoring System Tests', () {
      setUp(() {
        controller.onInit();
        controller.secretWord.value =
            'tree'; // Set a known secret word for testing
      });

      test('should increase score by 10 for each correct guess', () {
        int initialScore = controller.score.value;

        controller.makeGuess('tree');
        expect(controller.score.value, initialScore + 10);
      });

      test('should not increase score for incorrect guesses', () {
        int initialScore = controller.score.value;

        controller.makeGuess('star');
        expect(controller.score.value, initialScore);
      });

      test('should accumulate score over multiple guesses', () {
        int initialScore = controller.score.value;

        controller.makeGuess('tree');
        expect(controller.score.value, initialScore + 10);

        controller.makeGuess('star');
        expect(
          controller.score.value,
          initialScore + 10,
        ); // Score should not change

        controller.secretWord.value =
            'star'; // Fixed: need to set new secret word for next correct guess
        controller.makeGuess('star'); // Fixed: this should now be correct
        expect(
          controller.score.value,
          initialScore + 20,
        ); // Fixed: should be +20, not +10
      });

      test('should maintain score when new game starts', () {
        // Fixed: added missing opening brace
        controller.makeGuess('tree'); // Make a correct guess first
        int scoreAfterCorrectGuess =
            controller.score.value; // Fixed: declare this variable

        controller.newGame();
        expect(controller.score.value, scoreAfterCorrectGuess);
      });
    });

    group('4. Guess History Tests', () {
      setUp(() {
        controller.onInit();
        controller.secretWord.value =
            'tree'; // Set a known secret word for testing
      });

      test('should save all valid guesses to history', () {
        controller.makeGuess('star');
        controller.makeGuess('tree');
        controller.makeGuess('bark');

        expect(controller.guesses.length, 3);
        expect(controller.guesses.contains('star'), true);
        expect(controller.guesses.contains('tree'), true);
        expect(controller.guesses.contains('bark'), true);
      });

      test('should maintain guess order', () {
        controller.makeGuess('star');
        controller.makeGuess('tree');
        controller.makeGuess('bark');

        expect(controller.guesses[0], 'star');
        expect(controller.guesses[1], 'tree');
        expect(controller.guesses[2], 'bark');
      });

      test('should clear guess history on new game', () {
        controller.makeGuess('star');
        controller.makeGuess('tree');
        expect(controller.guesses.length, 2);

        controller.newGame();
        expect(controller.guesses.length, 0);
      });

      test('should save correct guess before starting new game', () {
        controller.makeGuess('tree');
        expect(controller.guesses.contains('tree'), true);
      });
    });

    group('5. Integration Test', () {
      test('should handle complete game flow correctly', () {
        controller.onInit();
        controller.secretWord.value =
            'tree'; // Set a known secret word for testing
        int initialScore = controller.score.value; // Fixed: 'init' -> 'int'

        // Make guesses - only 'tree' will be correct
        controller.makeGuess('star');
        controller.makeGuess('tree');
        controller.makeGuess('bark');

        expect(controller.guesses.length, 3);
        expect(
          controller.score.value,
          initialScore + 10,
        ); // Fixed: only one correct guess = +10
        expect(
          controller.guesses.contains('star'),
          true,
        ); // Fixed: 'book' -> 'star' (matches actual guess)
        expect(controller.guesses.contains('tree'), true);
        expect(controller.guesses.contains('bark'), true);
      });

      test('should reset game state on new game', () {
        // Fixed: added missing opening brace
        controller.onInit();
        controller.makeGuess('star');
        controller.makeGuess('tree');
        String originalSecretWord = controller.secretWord.value;

        controller.newGame();

        // Assert
        expect(controller.guesses.length, 0);
        expect(
          controller.secretWord.value,
          isNotEmpty,
        ); // Fixed: added missing semicolon
        expect(
          controller.secretWord.value.length,
          equals(4),
        ); // Fixed: added missing dot
        expect(controller.words.contains(controller.secretWord.value), true);
        expect(controller.secretWord.value != originalSecretWord, true);
      });

      test('should handle multiple games with score accumulation', () {
        controller.onInit();
        int initialScore = controller.score.value; // Fixed: 'init' -> 'int'

        // Act - Play multiple games
        controller.secretWord.value = 'tree';
        controller.makeGuess('tree');

        controller.secretWord.value = 'bark';
        controller.makeGuess('bark');

        controller.secretWord.value = 'book';
        controller.makeGuess('book');
        controller.makeGuess('star'); // This will be incorrect

        expect(controller.score.value, initialScore + 30);
      });
    });

    group('6. Error Handling Tests', () {
      // Fixed: added missing opening brace
      setUp(() {
        controller.onInit();
      });

      test('should handle null guesses', () {
        controller.makeGuess(null);
        expect(
          controller.guesses.length,
          0,
          reason: 'Should not accept null guesses',
        );
      });

      test('should handle whitespace-only guesses', () {
        controller.makeGuess('    ');
        expect(
          controller.guesses.length,
          0,
          reason: 'Should not accept whitespace-only guesses',
        );

        controller.makeGuess('\t\n  ');
        expect(
          controller.guesses.length,
          0,
          reason: 'Should not accept whitespace-only guesses',
        );
      });

      test('should trim guesses before processing', () {
        controller.secretWord.value = 'tree';
        controller.makeGuess('tree  ');
        expect(controller.guesses.length, 1);
        expect(controller.guesses[0], 'tree');
        expect(
          controller.score.value,
          10,
          reason: 'Should accept and correctly process trimmed guesses',
        );
      });

      test('should handle special characters in guesses', () {
        controller.makeGuess('tre!');
        controller.makeGuess('12ab');
        controller.makeGuess('@#%&');

        expect(
          controller.guesses.length,
          0,
          reason: 'Should not accept guesses with special characters',
        );
      });
    });
  });
}
