// models/user.dart
import 'user_progress.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final UserProgress progress;
  final DateTime createdAt;
  final DateTime lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.progress,
    required this.createdAt,
    required this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      progress: UserProgress.fromJson(json['progress']),
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: DateTime.parse(json['lastLogin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'progress': progress.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
    };
  }
}