// models/lesson_content.dart
class LessonContent {
  final String id;
  final String? text;
  final String? imageUrl;
  final String? audioUrl;
  final Map<String, dynamic>? data;

  LessonContent({
    required this.id,
    this.text,
    this.imageUrl,
    this.audioUrl,
    this.data,
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) {
    return LessonContent(
      id: json['id'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'data': data,
    };
  }
}