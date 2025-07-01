
// models/word.dart
class Word {
  final String id;
  final String original;
  final String translation;
  final String? pronunciation;
  final String? example;
  final String? imageUrl;
  final String? audioUrl;
  final WordDifficulty difficulty;
  final List<String> categories;

  Word({
    required this.id,
    required this.original,
    required this.translation,
    this.pronunciation,
    this.example,
    this.imageUrl,
    this.audioUrl,
    this.difficulty = WordDifficulty.beginner,
    this.categories = const [],
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      original: json['original'],
      translation: json['translation'],
      pronunciation: json['pronunciation'],
      example: json['example'],
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      difficulty: WordDifficulty.values.firstWhere(
            (e) => e.name == json['difficulty'],
        orElse: () => WordDifficulty.beginner,
      ),
      categories: List<String>.from(json['categories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original': original,
      'translation': translation,
      'pronunciation': pronunciation,
      'example': example,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'difficulty': difficulty.name,
      'categories': categories,
    };
  }
}

enum WordDifficulty { beginner, intermediate, advanced }
