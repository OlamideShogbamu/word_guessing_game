import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:word_guessing_game/game_controller.dart';
import 'package:word_guessing_game/main.dart';

void main() {
  group('Widget Tests', () {
    setUp(() {
      Get.testMode = true;
    });

    tearDown(Get.reset);

    testWidgets('should display all UI elements correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Verify app bar
      expect(find.text('Word Guessing Game'), findsOneWidget);

      // Verify score display (initial score should be 0)
      expect(find.text('Score: 0'), findsOneWidget);

      // Verify secret word section exists
      expect(find.text('Secret Word'), findsOneWidget);

      // Verify input field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter 4-letter word...'), findsOneWidget);

      // Verify available words section
      expect(find.text('🧾 Available Words'), findsOneWidget);

      // Verify all predefined words are displayed
      expect(find.text('tree'), findsOneWidget);
      expect(find.text('star'), findsOneWidget);
      expect(find.text('moon'), findsOneWidget);
      expect(find.text('book'), findsOneWidget);
      expect(find.text('cake'), findsOneWidget);
      expect(find.text('ship'), findsOneWidget);
    });

    testWidgets('should handle text input and guess submission', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'book');
      await tester.pump();

      // Verify the TextField is empty after submission
      expect(tester.widget<TextField>(textField).controller?.text, isEmpty);
    });

    testWidgets('should show correct feedback for correct guess', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<GameController>();
      controller.secretWord.value = 'tree';

      await tester.enterText(find.byType(TextField), 'tree');
      await tester.pump();

      // Verify correct feedback
      expect(find.text('TREE'), findsOneWidget);
      expect(find.text('Correct!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Handle the delayed new game
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump();
    });

    testWidgets('should update score display when correct guess is made', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<GameController>();
      controller.secretWord.value = 'tree';

      await tester.enterText(find.byType(TextField), 'tree');
      await tester.pump();

      expect(find.text('Score: 10'), findsOneWidget);

      // Handle the delayed new game
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump();
    });

    testWidgets('should start new game when new game button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<GameController>();
      controller.secretWord.value = 'tree';

      // Make a guess first
      await tester.enterText(find.byType(TextField), 'book');
      await tester.pump();

      // Need to ensure content is scrolled into view
      await tester.dragFrom(
        tester.getCenter(find.byType(SingleChildScrollView)),
        const Offset(0, -500),
      );
      await tester.pump();

      // Now tap the new game button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify new game started
      expect(controller.guesses, isEmpty);
      expect(controller.secretWord.value, isNotEmpty);
      expect(controller.secretWord.value.length, equals(4));
    });

    testWidgets('should not accept guesses with incorrect length', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(find.byType(TextField), 'cat');
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'house');
      await tester.pump();

      expect(find.text('🎲 Your Guesses'), findsNothing);
    });

    testWidgets('should display stars for secret word', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      final controller = Get.find<GameController>();
      controller.secretWord.value = 'tree'; // Set a known word
      await tester.pump(); // Wait for UI to update

      // Find the container with stars
      final starText = find.text(' ⭐⭐⭐⭐');
      expect(starText, findsOneWidget);
    });
  });
}
