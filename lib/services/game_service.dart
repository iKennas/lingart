// services/game_service.dart
import 'dart:math';
import '../models/models.dart';

class GameService {
  static final Random _random = Random();

  // Card matching game logic
  static List<Map<String, dynamic>> generateCardPairs(List<Word> words) {
    final cards = <Map<String, dynamic>>[];

    for (final word in words.take(6)) {
      // Add word card
      cards.add({
        'id': '${word.id}_word',
        'type': 'word',
        'content': word.original,
        'matchId': word.id,
        'isFlipped': false,
        'isMatched': false,
      });

      // Add image/translation card
      cards.add({
        'id': '${word.id}_translation',
        'type': 'translation',
        'content': word.translation,
        'matchId': word.id,
        'isFlipped': false,
        'isMatched': false,
      });
    }

    cards.shuffle(_random);
    return cards;
  }

  // Balloon game logic
  static List<Map<String, dynamic>> generateBalloons(int count) {
    final balloons = <Map<String, dynamic>>[];

    for (int i = 0; i < count; i++) {
      balloons.add({
        'id': 'balloon_$i',
        'x': _random.nextDouble() * 300 + 50,
        'y': _random.nextDouble() * 400 + 100,
        'color': _generateRandomColor(),
        'isPopped': false,
        'points': _random.nextInt(10) + 1,
      });
    }

    return balloons;
  }

  static int _generateRandomColor() {
    final colors = <int>[0xFF2196F3, 0xFF4CAF50, 0xFFFF9800, 0xFF9C27B0, 0xFFF44336];
    return colors[_random.nextInt(colors.length)];
  }

  // Basketball game logic
  static bool calculateBasketballShot(double angle, double power) {
    // Simple physics calculation for basketball shot
    final targetAngle = 45.0; // Optimal angle
    final targetPower = 0.7; // Optimal power (0.0 - 1.0)

    final angleDiff = (angle - targetAngle).abs();
    final powerDiff = (power - targetPower).abs();

    // Success probability based on angle and power accuracy
    final successProbability = 1.0 - (angleDiff / 90.0 + powerDiff) / 2.0;

    return _random.nextDouble() < successProbability.clamp(0.1, 0.9);
  }

  // Word scramble logic
  static String scrambleWord(String word) {
    final letters = word.split('')..shuffle(_random);
    return letters.join('');
  }

  static bool checkWordMatch(String scrambled, String original, String userInput) {
    return userInput.toLowerCase().trim() == original.toLowerCase().trim();
  }

  // Score calculation
  static int calculateScore(int correctAnswers, int totalQuestions, int timeSpent) {
    final accuracy = correctAnswers / totalQuestions;
    final timeBonus = (300 - timeSpent).clamp(0, 300) / 300; // 5 minute max

    return ((accuracy * 100 + timeBonus * 50) * 10).round();
  }
}