
// models/question.dart
class Question {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;
  final String? audioUrl;
  final QuestionType type;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.audioUrl,
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      audioUrl: json['audioUrl'],
      type: QuestionType.values.firstWhere((e) => e.name == json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'audioUrl': audioUrl,
      'type': type.name,
    };
  }
}

enum QuestionType { fillBlank, multipleChoice, trueFalse }
