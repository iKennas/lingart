// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Import all modules
import 'utils/app_theme.dart' as MainAppTheme;
import 'utils/utils.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

// Import screens individually to avoid AppTheme conflicts
import 'screens/home_screen.dart';
import 'screens/lessons_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/profile_screen.dart';

// Import module screens individually with specific imports to avoid conflicts
import 'screens/modules/picture_word_learning_screen.dart';
import 'screens/modules/fill_blank_screen.dart';
import 'screens/modules/multiple_choice_screen.dart';
import 'screens/modules/grammar_lesson_screen.dart';
import 'screens/modules/teacher_lesson_screen.dart';
import 'screens/modules/missing_letter_screen.dart';
import 'screens/modules/voice_recognition_screen.dart';
import 'screens/modules/text_reading_screen.dart';
import 'screens/modules/dialog_screen.dart';
import 'screens/modules/card_game_screen.dart';
import 'screens/modules/balloon_game_screen.dart';
import 'screens/modules/basketball_game_screen.dart';
import 'screens/modules/chat_screen.dart';
import 'screens/modules/sentence_formation_screen.dart';
import 'screens/modules/youtube_link_screen.dart';
import 'screens/modules/blackboard_screen.dart';
// import 'screens/modules/letter_scramble_screen.dart' hide AppTheme;

// Achievement model
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final DateTime earnedAt;
  final int points;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.earnedAt,
    this.points = 0,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconName: json['iconName'],
      earnedAt: DateTime.parse(json['earnedAt']),
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'earnedAt': earnedAt.toIso8601String(),
      'points': points,
    };
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for modern look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: MainAppTheme.AppTheme.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  runApp(const LanguageLearningApp());
}

class LanguageLearningApp extends StatelessWidget {
  const LanguageLearningApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // Use the new advanced theme
        theme: MainAppTheme.AppTheme.lightTheme,

        // Routes
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.lessons: (context) => const LessonsScreen(),
          AppRoutes.profile: (context) => const ProfileScreen(),
        },

        // Route generation for dynamic routes
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.pictureWord:
              return _createRoute(const PictureWordLearningScreen());
            case AppRoutes.fillBlank:
              return _createRoute(const FillBlankScreen());
            case AppRoutes.multipleChoice:
              return _createRoute(const MultipleChoiceScreen());
            case AppRoutes.grammar:
              return _createRoute(const GrammarLessonScreen());
            case AppRoutes.teacher:
              return _createRoute(const TeacherLessonScreen());
            case AppRoutes.missingLetter:
              return _createRoute(const MissingLetterScreen());
            case AppRoutes.voiceRecognition:
              return _createRoute(const VoiceRecognitionScreen());
            case AppRoutes.textReading:
              return _createRoute(const TextReadingScreen());
            case AppRoutes.dialog:
              return _createRoute(const DialogScreen());
            case AppRoutes.cardGame:
              return _createRoute(const CardGameScreen());
            case AppRoutes.balloonGame:
              return _createRoute(const BalloonGameScreen());
            case AppRoutes.basketballGame:
              return _createRoute(const BasketballGameScreen());
            case AppRoutes.chat:
              return _createRoute(const ChatScreen());
            case AppRoutes.sentenceFormation:
              return _createRoute(const SentenceFormationScreen());
            case AppRoutes.youtubeLink:
              return _createRoute(const YouTubeLinkScreen());
            case AppRoutes.blackboard:
              return _createRoute(const BlackboardScreen());
          // case AppRoutes.letterScramble:
          //   return _createRoute(const LetterScrambleScreen());
            default:
              return _createRoute(const NotFoundScreen());
          }
        },
      ),
    );
  }

  // Create custom page transition
  static PageRoute _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

// Enhanced Splash Screen with advanced animations
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _progressController.forward();

    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainAppTheme.AppTheme.primaryBlue,
      body: Container(
        decoration: const BoxDecoration(
          gradient: MainAppTheme.AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo and App Name
              AnimatedBuilder(
                animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: MainAppTheme.AppTheme.white,
                              borderRadius: BorderRadius.circular(MainAppTheme.AppTheme.radiusXLarge),
                              boxShadow: [
                                BoxShadow(
                                  color: MainAppTheme.AppTheme.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.school,
                              size: 64,
                              color: MainAppTheme.AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: MainAppTheme.AppTheme.spacing24),
                          Text(
                            AppConstants.appName,
                            style: MainAppTheme.AppTheme.textTheme.headlineLarge?.copyWith(
                              color: MainAppTheme.AppTheme.white,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: MainAppTheme.AppTheme.spacing8),
                          Text(
                            'Türkçe öğrenmenin en eğlenceli yolu',
                            style: MainAppTheme.AppTheme.textTheme.bodyLarge?.copyWith(
                              color: MainAppTheme.AppTheme.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Animated Progress
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MainAppTheme.AppTheme.spacing40,
                    ),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: _progressAnimation.value,
                          backgroundColor: MainAppTheme.AppTheme.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            MainAppTheme.AppTheme.white,
                          ),
                          borderRadius: BorderRadius.circular(MainAppTheme.AppTheme.radiusSmall),
                          minHeight: 4,
                        ),
                        const SizedBox(height: MainAppTheme.AppTheme.spacing16),
                        Text(
                          'Yükleniyor...',
                          style: MainAppTheme.AppTheme.textTheme.bodyMedium?.copyWith(
                            color: MainAppTheme.AppTheme.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: MainAppTheme.AppTheme.spacing64),
            ],
          ),
        ),
      ),
    );
  }
}

// Enhanced Not Found Screen
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainAppTheme.AppTheme.lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MainAppTheme.AppTheme.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 404 Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: MainAppTheme.AppTheme.accentRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(MainAppTheme.AppTheme.radiusXLarge),
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: MainAppTheme.AppTheme.accentRed,
                ),
              ),

              const SizedBox(height: MainAppTheme.AppTheme.spacing32),

              // Error Message
              Text(
                '404',
                style: MainAppTheme.AppTheme.textTheme.displayLarge?.copyWith(
                  color: MainAppTheme.AppTheme.accentRed,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: MainAppTheme.AppTheme.spacing16),

              Text(
                'Sayfa Bulunamadı',
                style: MainAppTheme.AppTheme.textTheme.headlineMedium?.copyWith(
                  color: MainAppTheme.AppTheme.darkGrey,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: MainAppTheme.AppTheme.spacing12),

              Text(
                'Aradığınız sayfa mevcut değil veya taşınmış olabilir.',
                style: MainAppTheme.AppTheme.textTheme.bodyLarge?.copyWith(
                  color: MainAppTheme.AppTheme.mediumGrey,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: MainAppTheme.AppTheme.spacing40),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton.outline(
                    text: 'Geri Dön',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const SizedBox(width: MainAppTheme.AppTheme.spacing16),
                  CustomButton.primary(
                    text: 'Ana Sayfa',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                            (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// State Management Providers (Enhanced)
class AppStateProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String _currentTheme = 'light';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentTheme => _currentTheme;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setTheme(String theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? MainAppTheme.AppTheme.accentRed : MainAppTheme.AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MainAppTheme.AppTheme.radiusMedium),
        ),
        margin: const EdgeInsets.all(MainAppTheme.AppTheme.spacing16),
      ),
    );
  }
}

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  UserProgress? _userProgress;
  List<Achievement> _achievements = [];

  User? get currentUser => _currentUser;
  UserProgress? get userProgress => _userProgress;
  List<Achievement> get achievements => _achievements;

  bool get isLoggedIn => _currentUser != null;

  void setUser(User user) {
    _currentUser = user;
    _userProgress = user.progress;
    notifyListeners();
  }

  void updateProgress(UserProgress progress) {
    _userProgress = progress;
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        profileImage: _currentUser!.profileImage,
        progress: progress,
        createdAt: _currentUser!.createdAt,
        lastLogin: DateTime.now(),
      );
    }
    notifyListeners();
  }

  void addAchievement(Achievement achievement) {
    _achievements.add(achievement);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _userProgress = null;
    _achievements.clear();
    notifyListeners();
  }
}

class LessonProvider extends ChangeNotifier {
  List<Lesson> _lessons = [];
  List<Word> _words = [];
  Lesson? _currentLesson;
  Map<String, double> _lessonProgress = {};
  List<String> _completedLessons = [];

  List<Lesson> get lessons => _lessons;
  List<Word> get words => _words;
  Lesson? get currentLesson => _currentLesson;
  Map<String, double> get lessonProgress => _lessonProgress;
  List<String> get completedLessons => _completedLessons;

  void setLessons(List<Lesson> lessons) {
    _lessons = lessons;
    notifyListeners();
  }

  void setWords(List<Word> words) {
    _words = words;
    notifyListeners();
  }

  void setCurrentLesson(Lesson lesson) {
    _currentLesson = lesson;
    notifyListeners();
  }

  void updateLessonProgress(String lessonId, double progress) {
    _lessonProgress[lessonId] = progress;
    notifyListeners();
  }

  void completeLesson(String lessonId) {
    if (!_completedLessons.contains(lessonId)) {
      _completedLessons.add(lessonId);
      _lessonProgress[lessonId] = 1.0;
      notifyListeners();
    }
  }

  void resetProgress() {
    _lessonProgress.clear();
    _completedLessons.clear();
    _currentLesson = null;
    notifyListeners();
  }
}