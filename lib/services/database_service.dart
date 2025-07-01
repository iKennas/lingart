// services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'language_learning.db';
  static const int _databaseVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
  }

  static Future<void> _createDatabase(Database db, int version) async {
    // User table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        profileImage TEXT,
        progress TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        lastLogin TEXT NOT NULL
      )
    ''');

    // Lessons table
    await db.execute('''
      CREATE TABLE lessons (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        difficulty INTEGER NOT NULL,
        content TEXT NOT NULL,
        isLocked INTEGER NOT NULL DEFAULT 0,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        timeToComplete INTEGER
      )
    ''');

    // Words table
    await db.execute('''
      CREATE TABLE words (
        id TEXT PRIMARY KEY,
        original TEXT NOT NULL,
        translation TEXT NOT NULL,
        pronunciation TEXT,
        example TEXT,
        imageUrl TEXT,
        audioUrl TEXT,
        difficulty TEXT NOT NULL,
        categories TEXT NOT NULL
      )
    ''');

    // Questions table
    await db.execute('''
      CREATE TABLE questions (
        id TEXT PRIMARY KEY,
        question TEXT NOT NULL,
        options TEXT NOT NULL,
        correctAnswer TEXT NOT NULL,
        explanation TEXT,
        audioUrl TEXT,
        type TEXT NOT NULL
      )
    ''');

    // Chat messages table
    await db.execute('''
      CREATE TABLE chat_messages (
        id TEXT PRIMARY KEY,
        senderId TEXT NOT NULL,
        senderName TEXT NOT NULL,
        message TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        type TEXT NOT NULL,
        isFromTeacher INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // User progress tracking
    await db.execute('''
      CREATE TABLE user_lesson_progress (
        userId TEXT NOT NULL,
        lessonId TEXT NOT NULL,
        completedAt TEXT,
        score INTEGER,
        timeSpent INTEGER,
        PRIMARY KEY (userId, lessonId)
      )
    ''');
  }

  // User operations
  static Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'profileImage': user.profileImage,
        'progress': user.progress.toJson().toString(),
        'createdAt': user.createdAt.toIso8601String(),
        'lastLogin': user.lastLogin.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<User?> getUser(String id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return User.fromJson({
        'id': map['id'],
        'name': map['name'],
        'email': map['email'],
        'profileImage': map['profileImage'],
        'progress': map['progress'],
        'createdAt': map['createdAt'],
        'lastLogin': map['lastLogin'],
      });
    }
    return null;
  }

  static Future<void> updateUserProgress(String userId, UserProgress progress) async {
    final db = await database;
    await db.update(
      'users',
      {'progress': progress.toJson().toString()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Lesson operations
  static Future<void> insertLesson(Lesson lesson) async {
    final db = await database;
    await db.insert(
      'lessons',
      {
        'id': lesson.id,
        'title': lesson.title,
        'description': lesson.description,
        'type': lesson.type.name,
        'difficulty': lesson.difficulty,
        'content': lesson.content.map((e) => e.toJson()).toString(),
        'isLocked': lesson.isLocked ? 1 : 0,
        'isCompleted': lesson.isCompleted ? 1 : 0,
        'timeToComplete': lesson.timeToComplete,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Lesson>> getAllLessons() async {
    final db = await database;
    final maps = await db.query('lessons');
    return maps.map((map) => Lesson.fromJson({
      'id': map['id'],
      'title': map['title'],
      'description': map['description'],
      'type': map['type'],
      'difficulty': map['difficulty'],
      'content': map['content'],
      'isLocked': map['isLocked'] == 1,
      'isCompleted': map['isCompleted'] == 1,
      'timeToComplete': map['timeToComplete'],
    })).toList();
  }

  // Word operations
  static Future<void> insertWord(Word word) async {
    final db = await database;
    await db.insert(
      'words',
      {
        'id': word.id,
        'original': word.original,
        'translation': word.translation,
        'pronunciation': word.pronunciation,
        'example': word.example,
        'imageUrl': word.imageUrl,
        'audioUrl': word.audioUrl,
        'difficulty': word.difficulty.name,
        'categories': word.categories.join(','),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Word>> getAllWords() async {
    final db = await database;
    final maps = await db.query('words');
    return maps.map((map) => Word.fromJson({
      'id': map['id'],
      'original': map['original'],
      'translation': map['translation'],
      'pronunciation': map['pronunciation'],
      'example': map['example'],
      'imageUrl': map['imageUrl'],
      'audioUrl': map['audioUrl'],
      'difficulty': map['difficulty'],
      'categories': (map['categories'] as String).split(','),
    })).toList();
  }
}
