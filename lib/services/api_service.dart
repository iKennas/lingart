
// services/api_service.dart
import 'package:dio/dio.dart';
import '../models/models.dart';

class ApiService {
  static final Dio _dio = Dio();
  static const String baseUrl = 'https://your-api-url.com/api';

  static Future<void> init() async {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if needed
          // options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
        onError: (error, handler) {
          print('API Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  // User API calls
  static Future<User?> loginUser(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return User.fromJson(response.data['user']);
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  static Future<User?> registerUser(String name, String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        return User.fromJson(response.data['user']);
      }
    } catch (e) {
      print('Registration error: $e');
    }
    return null;
  }

  // Content API calls
  static Future<List<Lesson>> fetchLessons() async {
    try {
      final response = await _dio.get('/lessons');
      if (response.statusCode == 200) {
        return (response.data['lessons'] as List)
            .map((json) => Lesson.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Fetch lessons error: $e');
    }
    return [];
  }

  static Future<List<Word>> fetchWords() async {
    try {
      final response = await _dio.get('/words');
      if (response.statusCode == 200) {
        return (response.data['words'] as List)
            .map((json) => Word.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Fetch words error: $e');
    }
    return [];
  }

  static Future<List<Question>> fetchQuestions(String lessonId) async {
    try {
      final response = await _dio.get('/lessons/$lessonId/questions');
      if (response.statusCode == 200) {
        return (response.data['questions'] as List)
            .map((json) => Question.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Fetch questions error: $e');
    }
    return [];
  }

  // Progress tracking
  static Future<void> updateProgress(String userId, UserProgress progress) async {
    try {
      await _dio.put('/users/$userId/progress', data: progress.toJson());
    } catch (e) {
      print('Update progress error: $e');
    }
  }

  // Chat API calls
  static Future<List<ChatMessage>> fetchChatMessages(String chatId) async {
    try {
      final response = await _dio.get('/chats/$chatId/messages');
      if (response.statusCode == 200) {
        return (response.data['messages'] as List)
            .map((json) => ChatMessage.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Fetch chat messages error: $e');
    }
    return [];
  }

  static Future<void> sendChatMessage(String chatId, ChatMessage message) async {
    try {
      await _dio.post('/chats/$chatId/messages', data: message.toJson());
    } catch (e) {
      print('Send message error: $e');
    }
  }
}
