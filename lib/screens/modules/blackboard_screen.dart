// screens/modules/blackboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../utils/app_theme.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class BlackboardScreen extends StatefulWidget {
  const BlackboardScreen({Key? key}) : super(key: key);

  @override
  State<BlackboardScreen> createState() => _BlackboardScreenState();
}

class _BlackboardScreenState extends State<BlackboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _chalkController;
  late Animation<double> _fadeAnimation;

  List<Offset> drawnPoints = [];
  List<String> writtenWords = [];
  String currentWord = '';
  String targetWord = '';
  int wordIndex = 0;
  int score = 0;
  bool isDrawing = false;

  final List<String> practiceWords = [
    'merhaba',
    'teşekkür',
    'lütfen',
    'özür dilerim',
    'günaydın',
    'iyi geceler',
    'hoş geldin',
    'güle güle',
    'nasılsın',
    'iyiyim',
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _chalkController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _setNewWord();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _chalkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F4F2F), // Dark green classroom color
      appBar: AppBar(
        title: const Text('Kara Tahta'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
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
              'Kelime: ${wordIndex + 1}/${practiceWords.length}',
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
              'Skor: $score',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Instructions
            Container(
              margin: const EdgeInsets.all(AppTheme.spacing20),
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacing8),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                        child: const Icon(
                          Icons.school,
                          color: AppTheme.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hedef Kelime',
                              style: AppTheme.textTheme.titleMedium?.copyWith(
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            Text(
                              targetWord,
                              style: AppTheme.textTheme.headlineSmall?.copyWith(
                                color: AppTheme.darkGrey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    'Kara tahtaya parmağınızla kelimeyi yazın',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mediumGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Blackboard
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C3A1C), // Dark blackboard green
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  border: Border.all(
                    color: const Color(0xFF8B4513), // Brown wooden frame
                    width: 8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  child: Stack(
                    children: [
                      // Blackboard texture
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF1C3A1C),
                              const Color(0xFF0F2A0F),
                            ],
                          ),
                        ),
                      ),

                      // Drawing area
                      GestureDetector(
                        onPanStart: _onPanStart,
                        onPanUpdate: _onPanUpdate,
                        onPanEnd: _onPanEnd,
                        child: CustomPaint(
                          painter: ChalkPainter(drawnPoints),
                          size: Size.infinite,
                        ),
                      ),

                      // Current word display (if any)
                      if (currentWord.isNotEmpty)
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.all(AppTheme.spacing8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            ),
                            child: Text(
                              'Yazılan: $currentWord',
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Control Buttons
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton.secondary(
                      text: 'Temizle',
                      onPressed: _clearBoard,
                      icon: const Icon(Icons.clear, size: 20),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: CustomButton.accent(
                      text: 'Kontrol Et',
                      onPressed: drawnPoints.isNotEmpty ? _checkWriting : null,
                      icon: const Icon(Icons.check_circle, size: 20),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: CustomButton.primary(
                      text: 'Sonraki',
                      onPressed: _nextWord,
                      icon: const Icon(Icons.arrow_forward, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      isDrawing = true;
      drawnPoints.add(details.localPosition);
    });
    _chalkController.forward();
    HapticFeedback.lightImpact();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      drawnPoints.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDrawing = false;
      drawnPoints.add(Offset.infinite); // Add separator for stroke end
    });
    _chalkController.reverse();
  }

  void _clearBoard() {
    setState(() {
      drawnPoints.clear();
      currentWord = '';
    });
    HapticFeedback.lightImpact();
  }

  void _checkWriting() {
    // Simulate handwriting recognition
    final random = Random();
    final similarity = _calculateSimilarity();

    if (similarity > 0.7) {
      setState(() {
        score += 10;
        currentWord = targetWord;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Harika yazı! 🎉'),
          backgroundColor: AppTheme.accentRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    } else if (similarity > 0.4) {
      setState(() {
        score += 5;
        currentWord = _generateSimilarWord(targetWord);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('İyi deneme! Biraz daha net yazın. ✏️'),
          backgroundColor: AppTheme.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    } else {
      setState(() {
        currentWord = _generateRandomWord();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Daha net yazmaya çalışın. 💪'),
          backgroundColor: AppTheme.mediumGrey,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    }

    HapticFeedback.lightImpact();
  }

  double _calculateSimilarity() {
    // Simulate handwriting analysis based on stroke complexity
    if (drawnPoints.isEmpty) return 0.0;

    final strokeCount = drawnPoints.where((point) => point == Offset.infinite).length + 1;
    final pointCount = drawnPoints.where((point) => point != Offset.infinite).length;

    // More complex analysis would go here
    // For demo, we'll use random values weighted by stroke data
    final random = Random();
    double baseScore = random.nextDouble();

    // Bonus for appropriate stroke count (rough estimate)
    if (strokeCount >= targetWord.length * 0.5 && strokeCount <= targetWord.length * 2) {
      baseScore += 0.3;
    }

    // Bonus for sufficient drawing
    if (pointCount > 20) {
      baseScore += 0.2;
    }

    return baseScore.clamp(0.0, 1.0);
  }

  String _generateSimilarWord(String target) {
    // Generate a word that's somewhat similar to target (for demo)
    final variations = {
      'merhaba': 'merhba',
      'teşekkür': 'teşekür',
      'lütfen': 'lutfen',
      'özür dilerim': 'ozur dilerim',
      'günaydın': 'gunaydin',
    };

    return variations[target] ?? target.replaceAll('ü', 'u').replaceAll('ğ', 'g');
  }

  String _generateRandomWord() {
    final randomWords = ['abc', 'test', '???', 'hmm'];
    return randomWords[Random().nextInt(randomWords.length)];
  }

  void _nextWord() {
    if (wordIndex < practiceWords.length - 1) {
      setState(() {
        wordIndex++;
        drawnPoints.clear();
        currentWord = '';
      });
      _setNewWord();
    } else {
      _showCompletionDialog();
    }
    HapticFeedback.lightImpact();
  }

  void _setNewWord() {
    setState(() {
      targetWord = practiceWords[wordIndex];
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: const Icon(
                Icons.emoji_events,
                color: AppTheme.white,
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Text(
              'Tebrikler!',
              style: AppTheme.textTheme.headlineSmall,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tüm kelimeleri yazdınız!',
              style: AppTheme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Final Skorunuz:',
                    style: AppTheme.textTheme.titleMedium,
                  ),
                  Text(
                    '$score',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.accentRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          CustomButton.outline(
            text: 'Tekrar Başla',
            onPressed: () {
              Navigator.pop(context);
              _restartPractice();
            },
          ),
          CustomButton.primary(
            text: 'Ana Menü',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _restartPractice() {
    setState(() {
      wordIndex = 0;
      score = 0;
      drawnPoints.clear();
      currentWord = '';
    });
    _setNewWord();
  }
}

class ChalkPainter extends CustomPainter {
  final List<Offset> points;

  ChalkPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        // Add slight randomness to simulate chalk texture
        final randomOffset = Offset(
          (Random().nextDouble() - 0.5) * 0.5,
          (Random().nextDouble() - 0.5) * 0.5,
        );

        canvas.drawLine(
          points[i] + randomOffset,
          points[i + 1] + randomOffset,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}