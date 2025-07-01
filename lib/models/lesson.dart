// models/lesson.dart
import 'lesson_type.dart';
import 'lesson_content.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final LessonType type;
  final int difficulty;
  final List<LessonContent> content;
  final bool isLocked;
  final bool isCompleted;
  final int? timeToComplete;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.content,
    this.isLocked = false,
    this.isCompleted = false,
    this.timeToComplete,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: LessonType.values.firstWhere((e) => e.name == json['type']),
      difficulty: json['difficulty'],
      content: (json['content'] as List)
          .map((e) => LessonContent.fromJson(e))
          .toList(),
      isLocked: json['isLocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      timeToComplete: json['timeToComplete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'difficulty': difficulty,
      'content': content.map((e) => e.toJson()).toList(),
      'isLocked': isLocked,
      'isCompleted': isCompleted,
      'timeToComplete': timeToComplete,
    };
  }
}