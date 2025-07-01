// screens/modules/balloon_game_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';

class BalloonGameScreen extends StatefulWidget {
  const BalloonGameScreen({Key? key}) : super(key: key);

  @override
  State<BalloonGameScreen> createState() => _BalloonGameScreenState();
}

class _BalloonGameScreenState extends State<BalloonGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _gameController;
  late AnimationController _balloonController;
  late List<AnimationController> _balloonAnimations;

  bool gameStarted = false;
  bool gameEnded = false;
  int score = 0;
  int lives = 3;
  int timeLeft = 60;
  Timer? _gameTimer;

  List<BalloonModel> balloons = [];
  String targetWord = '';

  final List<Map<String, String>> gameWords = [
    {'word': 'elma', 'translation': 'apple'},
    {'word': 'kitap', 'translation': 'book'},
    {'word': 'araba', 'translation': 'car'},
    {'word': 'ev', 'translation': 'house'},
    {'word': 'okul', 'translation': 'school'},
    {'word': 'su', 'translation': 'water'},
    {'word': 'güneş', 'translation': 'sun'},
    {'word': 'ay', 'translation': 'moon'},
    {'word': 'çiçek', 'translation': 'flower'},
    {'word': 'ağaç', 'translation': 'tree'},
  ];

  @override
  void initState() {
    super.initState();

    _gameController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _balloonController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _balloonAnimations = [];
    _gameController.forward();
  }

  @override
  void dispose() {
    _gameController.dispose();
    _balloonController.dispose();
    for (var controller in _balloonAnimations) {
      controller.dispose();
    }
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        title: Text(
          'Balon Oyunu',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ) ?? const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.gray700,
          ),
        ),
        actions: [
          if (gameStarted && !gameEnded)
            Padding(
              padding: const EdgeInsets.only(right: AppTheme.spacing16),
              child: Center(
                child: Text(
                  'Skor: $score',
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryNavy,
                  ) ?? const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryNavy,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: !gameStarted
            ? _buildStartScreen()
            : gameEnded
            ? _buildEndScreen()
            : _buildGameScreen(),
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
                borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
                boxShadow: AppTheme.strongShadow,
              ),
              child: const Icon(
                Icons.bubble_chart,
                size: 60,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

            Text(
              'Balon Oyunu',
              style: AppTheme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ) ?? const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing16),

            Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                children: [
                  Text(
                    'Nasıl Oynanır?',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryNavy,
                    ) ?? const TextStyle(
                      color: AppTheme.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    '🎈 Balonlara dokunarak patlatın\n'
                        '📝 Hedef kelimeyi bulun\n'
                        '⏰ Zamana karşı yarışın\n'
                        '💖 3 canınız var!',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ) ?? const TextStyle(
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
          margin: const EdgeInsets.all(AppTheme.spacing16),
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            children: [
              // Target Word
              Text(
                'Hedef Kelime: $targetWord',
                style: AppTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryNavy,
                ) ?? const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryNavy,
                ),
              ),
              const SizedBox(height: AppTheme.spacing12),

              // Game Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Skor', '$score', Icons.emoji_events),
                  _buildStatItem('Can', '$lives', Icons.favorite),
                  _buildStatItem('Süre', '$timeLeft', Icons.timer),
                ],
              ),
            ],
          ),
        ),

        // Game Area
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.lightPink,
                  AppTheme.white,
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
              border: Border.all(color: AppTheme.gray200),
            ),
            child: Stack(
              children: [
                // Balloons would be positioned here
                ...balloons.map((balloon) => _buildBalloon(balloon)),

                // Empty state
                if (balloons.isEmpty)
                  const Center(
                    child: Text(
                      'Balonlar yükleniyor...',
                      style: TextStyle(
                        color: AppTheme.gray500,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Bottom Actions
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Row(
            children: [
              Expanded(
                child: CustomButton.outline(
                  text: 'Duraklat',
                  onPressed: _pauseGame,
                  icon: const Icon(Icons.pause, size: 20),
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: CustomButton.accent(
                  text: 'Çıkış',
                  onPressed: _endGame,
                  icon: const Icon(Icons.stop, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEndScreen() {
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
                gradient: score > 50 ? AppTheme.accentGradient : AppTheme.softGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
                boxShadow: AppTheme.mediumShadow,
              ),
              child: Icon(
                score > 50 ? Icons.emoji_events : Icons.sentiment_satisfied,
                size: 60,
                color: AppTheme.white,
              ),
            ),

            const SizedBox(height: AppTheme.spacing32),

            Text(
              score > 50 ? 'Tebrikler!' : 'İyi Deneme!',
              style: AppTheme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ) ?? const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTheme.spacing16),

            Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                children: [
                  Text(
                    'Final Skorunuz',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.gray600,
                    ) ?? const TextStyle(
                      color: AppTheme.gray600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    '$score',
                    style: AppTheme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryNavy,
                    ) ?? const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryNavy,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing40),

            Row(
              children: [
                Expanded(
                  child: CustomButton.outline(
                    text: 'Ana Sayfa',
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    icon: const Icon(Icons.home, size: 20),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: CustomButton.primary(
                    text: 'Tekrar Oyna',
                    onPressed: _restartGame,
                    icon: const Icon(Icons.refresh, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryNavy.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryNavy,
            size: 20,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          value,
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ) ?? const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.gray500,
          ) ?? const TextStyle(
            color: AppTheme.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildBalloon(BalloonModel balloon) {
    return Positioned(
      left: balloon.x,
      top: balloon.y,
      child: GestureDetector(
        onTap: () => _popBalloon(balloon),
        child: Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            color: balloon.color,
            borderRadius: BorderRadius.circular(30),
            boxShadow: AppTheme.softShadow,
          ),
          child: Center(
            child: Text(
              balloon.word,
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ) ?? const TextStyle(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _startGame() {
    setState(() {
      gameStarted = true;
      gameEnded = false;
      score = 0;
      lives = 3;
      timeLeft = 60;
    });

    _setRandomTargetWord();
    _generateBalloons();
    _startTimer();
  }

  void _pauseGame() {
    _gameTimer?.cancel();
    // Show pause dialog
  }

  void _endGame() {
    setState(() {
      gameEnded = true;
    });
    _gameTimer?.cancel();
  }

  void _restartGame() {
    setState(() {
      gameStarted = false;
      gameEnded = false;
      balloons.clear();
    });
  }

  void _setRandomTargetWord() {
    final random = Random();
    final wordPair = gameWords[random.nextInt(gameWords.length)];
    setState(() {
      targetWord = wordPair['translation']!;
    });
  }

  void _generateBalloons() {
    balloons.clear();
    final random = Random();

    // Add target word balloon
    balloons.add(BalloonModel(
      word: gameWords.firstWhere((w) => w['translation'] == targetWord)['word']!,
      x: random.nextDouble() * 300,
      y: random.nextDouble() * 400,
      color: AppTheme.success,
      isTarget: true,
    ));

    // Add distractor balloons
    for (int i = 0; i < 4; i++) {
      final wordPair = gameWords[random.nextInt(gameWords.length)];
      balloons.add(BalloonModel(
        word: wordPair['word']!,
        x: random.nextDouble() * 300,
        y: random.nextDouble() * 400,
        color: AppTheme.accentCoral,
        isTarget: false,
      ));
    }

    setState(() {});
  }

  void _popBalloon(BalloonModel balloon) {
    HapticFeedback.lightImpact();

    if (balloon.isTarget) {
      setState(() {
        score += 10;
        balloons.remove(balloon);
      });
      _setRandomTargetWord();
      _generateBalloons();
    } else {
      setState(() {
        lives--;
        balloons.remove(balloon);
      });

      if (lives <= 0) {
        _endGame();
      }
    }
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });

      if (timeLeft <= 0) {
        _endGame();
      }
    });
  }
}

class BalloonModel {
  final String word;
  final double x;
  final double y;
  final Color color;
  final bool isTarget;

  BalloonModel({
    required this.word,
    required this.x,
    required this.y,
    required this.color,
    required this.isTarget,
  });
}