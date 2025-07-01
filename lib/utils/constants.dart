// utils/constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Dil Öğrenme Uygulaması';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://your-api-url.com/api';
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Spacing
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  // Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;

  // Game Settings
  static const int balloonGameDuration = 60; // seconds
  static const int basketballMaxShots = 10;
  static const int cardGameMaxPairs = 8;
  static const int wordScrambleTimeLimit = 30; // seconds

  // Progress Settings
  static const int dailyGoalMinutes = 60;
  static const int streakResetHours = 36;
  static const int pointsPerCorrectAnswer = 10;
  static const int pointsPerCompletedLesson = 50;

  // Audio Settings
  static const double defaultVolume = 0.8;
  static const int speechTimeoutSeconds = 10;

  // UI Settings
  static const int maxWordsPerLesson = 10;
  static const int maxQuestionsPerQuiz = 15;
  static const double minProgressBarHeight = 4.0;
}

