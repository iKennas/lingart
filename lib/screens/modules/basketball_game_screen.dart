// screens/modules/basketball_game_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import '../../utils/app_theme.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class BasketballGameScreen extends StatefulWidget {
  const BasketballGameScreen({Key? key}) : super(key: key);

  @override
  State<BasketballGameScreen> createState() => _BasketballGameScreenState();
}

class _BasketballGameScreenState extends State<BasketballGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _ballController;
  late Animation<double> _fadeAnimation;

  bool gameStarted = false;
  bool gameEnded = false;
  bool questionVisible = false;
  int score = 0;
  int level = 1;
  int questionsAnswered = 0;
  int timeLeft = 30;
  late Timer _gameTimer;

  String currentQuestion = '';
  List<String> currentOptions = [];
  String correctAnswer = '';
  String selectedAnswer = '';

  final List<Map<String, dynamic>> basketballQuestions = [
    {
      'question': 'Türkçede "basketbol" kelimesi hangi dilden gelir?',
      'options': ['İngilizce', 'Fransızca', 'Almanca', 'İtalyanca'],
      'correct': 'İngilizce',
      'difficulty': 1,
    },
    {
      'question': '"Top" kelimesinin çoğulu nedir?',
      'options': ['toplar', 'topları', 'toplara', 'topların'],
      'correct': 'toplar',
      'difficulty': 1,
    },
    {
      'question': '"Oyun" kelimesinin eş anlamlısı hangisidir?',
      'options': ['çalışma', 'eğlence', 'ders', 'sınav'],
      'correct': 'eğlence',
      'difficulty': 2,
    },
    {
      'question': 'Hangi cümle doğru yazılmıştır?',
      'options': [
        'Basketbol oynamayı seviyorum',
        'Basketbol oynamağı seviyorum',
        'Basketbol oynamagı seviyorum',
        'Basketbol oyunmayı seviyorum'
      ],
      'correct': 'Basketbol oynamayı seviyorum',
      'difficulty': 2,
    },
    {
      'question': '"Başarılı" kelimesinin zıt anlamlısı nedir?',
      'options': ['başarısız', 'güçlü', 'hızlı', 'yavaş'],
      'correct': 'başarısız',
      'difficulty': 1,
    },
    {
      'question': 'Hangi kelime spor terimidir?',
      'options': ['defans', 'masa', 'kitap', 'kalem'],
      'correct': 'defans',
      'difficulty': 2,
    },
    {
      'question': '"Kazanmak" fiilinin geniş zaman çekimi nedir?',
      'options': ['kazanır', 'kazandı', 'kazanacak', 'kazanıyor'],
      'correct': 'kazanır',
      'difficulty': 3,
    },
    {
      'question': '"Takım" kelimesi hangi anlama gelir?',
      'options': ['group/team', 'game', 'ball', 'court'],
      'correct': 'group/team',
      'difficulty': 2,
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _ballController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _ballController.dispose();
    if (gameStarted && !gameEnded) {
      _gameTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E8B57), // Basketball court green
      appBar: AppBar(
        title: const Text('Basketbol Oyunu'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (gameStarted && !gameEnded) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing8,
              ),
              margin: const EdgeInsets.only(right: AppTheme.spacing8),
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: Text(
                'Seviye $level',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing8,
              ),
              margin: const EdgeInsets.only(right: AppTheme.spacing16),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: Text(
                '${timeLeft}s',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          // Basketball Court Background
          _buildCourtBackground(),

          // Game Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: !gameStarted
                ? _buildStartScreen()
                : gameEnded
                ? _buildEndScreen()
                : _buildGameScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildCourtBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2E8B57),
            Color(0xFF228B22),
          ],
        ),
      ),
      child: CustomPaint(
        painter: BasketballCourtPainter(),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                boxShadow: AppTheme.accentShadow,
              ),
              child: const Icon(
                Icons.sports_basketball,
                size: 60,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

            Text(
              'Basketbol Bilgi Yarışması',
              style: AppTheme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing16),

            Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  Text(
                    'Nasıl Oynanır?',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    '🏀 Soruları okuyun ve doğru cevabı verin\n'
                        '⏱️ Her soru için sınırlı zamanınız var\n'
                        '📈 Doğru cevaplar seviyenizi yükseltir\n'
                        '🏆 Hedef: En yüksek skoru elde edin!',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing40),

            CustomButton.primary(
              text: 'Oyunu Başlat',
              onPressed: _startGame,
              isFullWidth: true,
              size: ButtonSize.large,
              icon: const Icon(Icons.play_arrow, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    return Column(
      children: [
        // Game Header
        Container(
          margin: const EdgeInsets.all(AppTheme.spacing20),
          padding: const EdgeInsets.all(AppTheme.spacing20),
          decoration: BoxDecoration(
            color: AppTheme.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skor: $score',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Soru: ${questionsAnswered + 1}/8',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sports_basketball,
                  color: AppTheme.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),

        // Basketball and Hoop Animation
        Expanded(
          flex: 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Basketball Hoop
              Positioned(
                top: 50,
                child: Container(
                  width: 120,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2691E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),

              // Basketball
              AnimatedBuilder(
                animation: _ballController,
                builder: (context, child) {
                  return Positioned(
                    top: 150 + (50 * sin(_ballController.value * 2 * pi)),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          colors: [Color(0xFFFF8C00), Color(0xFFD2691E)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sports_basketball,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Question Area
        if (questionVisible) ...[
          Container(
            margin: const EdgeInsets.all(AppTheme.spacing20),
            padding: const EdgeInsets.all(AppTheme.spacing20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                Text(
                  currentQuestion,
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing20),

                // Answer Options
                ...currentOptions.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;
                  bool isSelected = selectedAnswer == option;

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
                    child: GestureDetector(
                      onTap: () => _selectAnswer(option),
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacing16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryBlue.withOpacity(0.1)
                              : AppTheme.lightGrey,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryBlue : AppTheme.borderGrey,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGrey,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing16),
                            Expanded(
                              child: Text(
                                option,
                                style: AppTheme.textTheme.bodyLarge?.copyWith(
                                  color: isSelected ? AppTheme.primaryBlue : AppTheme.darkGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: AppTheme.spacing20),

                CustomButton.primary(
                  text: 'Basketi At!',
                  onPressed: selectedAnswer.isNotEmpty ? _submitAnswer : null,
                  isFullWidth: true,
                  icon: const Icon(Icons.sports_basketball, size: 20),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: AppTheme.spacing20),
      ],
    );
  }

  Widget _buildEndScreen() {
    final isWin = score >= 50;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: isWin ? AppTheme.accentGradient : AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                boxShadow: isWin ? AppTheme.accentShadow : AppTheme.primaryShadow,
              ),
              child: Icon(
                isWin ? Icons.emoji_events : Icons.refresh,
                size: 60,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

            Text(
              isWin ? 'Tebrikler!' : 'Oyun Bitti!',
              style: AppTheme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),

            Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  Text(
                    'Final Skoru',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    '$score Puan',
                    style: AppTheme.textTheme.displayMedium?.copyWith(
                      color: AppTheme.accentRed,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    'Seviye: $level',
                    style: AppTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing40),

            CustomButton.primary(
              text: 'Tekrar Oyna',
              onPressed: _restartGame,
              isFullWidth: true,
              size: ButtonSize.large,
              icon: const Icon(Icons.refresh, size: 24),
            ),
            const SizedBox(height: AppTheme.spacing16),
            CustomButton.outline(
              text: 'Ana Menüye Dön',
              onPressed: () => Navigator.pop(context),
              isFullWidth: true,
              size: ButtonSize.large,
              icon: const Icon(Icons.home, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  void _startGame() {
    setState(() {
      gameStarted = true;
      questionVisible = true;
      timeLeft = 30;
    });

    _ballController.repeat();
    _loadNextQuestion();
    _startTimer();
    HapticFeedback.lightImpact();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _endGame();
      }
    });
  }

  void _loadNextQuestion() {
    if (questionsAnswered < basketballQuestions.length) {
      final question = basketballQuestions[questionsAnswered];
      setState(() {
        currentQuestion = question['question'];
        currentOptions = List<String>.from(question['options']);
        correctAnswer = question['correct'];
        selectedAnswer = '';
      });
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
    HapticFeedback.lightImpact();
  }

  void _submitAnswer() {
    final isCorrect = selectedAnswer == correctAnswer;

    if (isCorrect) {
      setState(() {
        score += 10 * level;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Basket! +10 puan 🏀'),
          backgroundColor: AppTheme.accentRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kaçırdın! Doğru cevap: $correctAnswer'),
          backgroundColor: AppTheme.primaryBlue,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    setState(() {
      questionsAnswered++;
    });

    if (questionsAnswered >= basketballQuestions.length) {
      _endGame();
    } else {
      _loadNextQuestion();
    }

    HapticFeedback.lightImpact();
  }

  void _endGame() {
    _gameTimer.cancel();
    _ballController.stop();

    setState(() {
      gameEnded = true;
    });
  }

  void _restartGame() {
    setState(() {
      gameStarted = false;
      gameEnded = false;
      questionVisible = false;
      score = 0;
      level = 1;
      questionsAnswered = 0;
      timeLeft = 30;
      selectedAnswer = '';
    });

    _fadeController.reset();
    _fadeController.forward();
    HapticFeedback.lightImpact();
  }
}

class BasketballCourtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw court lines
    final center = Offset(size.width / 2, size.height / 2);

    // Center circle
    canvas.drawCircle(center, 50, paint);

    // Half court line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Side lines (simplified)
    canvas.drawRect(
      Rect.fromLTWH(20, 20, size.width - 40, size.height - 40),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}