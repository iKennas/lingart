// models/user_progress.dart
class UserProgress {
  final int totalPoints;
  final int streak;
  final int completedLessons;
  final int totalLessons;
  final int masteredWords;
  final int totalWords;
  final List<String> completedModules;
  final DateTime lastStudyDate;

  UserProgress({
    this.totalPoints = 0,
    this.streak = 0,
    this.completedLessons = 0,
    this.totalLessons = 60,
    this.masteredWords = 0,
    this.totalWords = 500,
    this.completedModules = const [],
    DateTime? lastStudyDate,
  }) : lastStudyDate = lastStudyDate ?? DateTime.now();

  double get progressPercentage =>
      totalLessons > 0 ? completedLessons / totalLessons : 0.0;

  double get wordMasteryPercentage =>
      totalWords > 0 ? masteredWords / totalWords : 0.0;

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      totalPoints: json['totalPoints'] ?? 0,
      streak: json['streak'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
      totalLessons: json['totalLessons'] ?? 60,
      masteredWords: json['masteredWords'] ?? 0,
      totalWords: json['totalWords'] ?? 500,
      completedModules: List<String>.from(json['completedModules'] ?? []),
      lastStudyDate: DateTime.parse(json['lastStudyDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'streak': streak,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'masteredWords': masteredWords,
      'totalWords': totalWords,
      'completedModules': completedModules,
      'lastStudyDate': lastStudyDate.toIso8601String(),
    };
  }

  UserProgress copyWith({
    int? totalPoints,
    int? streak,
    int? completedLessons,
    int? totalLessons,
    int? masteredWords,
    int? totalWords,
    List<String>? completedModules,
    DateTime? lastStudyDate,
  }) {
    return UserProgress(
      totalPoints: totalPoints ?? this.totalPoints,
      streak: streak ?? this.streak,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      masteredWords: masteredWords ?? this.masteredWords,
      totalWords: totalWords ?? this.totalWords,
      completedModules: completedModules ?? this.completedModules,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
    );
  }
}