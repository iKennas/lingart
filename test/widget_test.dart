// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:language_learning_app/main.dart';  // Fix: Use your actual package name

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LanguageLearningApp());  // Fix: Use your actual app class name

    // Verify that our app loads properly
    expect(find.text('Dil Öğrenme Uygulaması'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for splash screen to finish
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify that we're now on the home screen
    expect(find.text('Merhaba,'), findsOneWidget);
    expect(find.text('Hadi öğrenmeye başlayalım'), findsOneWidget);
  });
}