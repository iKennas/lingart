// screens/modules/missing_letter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class MissingLetterScreen extends StatefulWidget {
  const MissingLetterScreen({Key? key}) : super(key: key);

  @override
  State<MissingLetterScreen> createState() => _MissingLetterScreenState();
}

class _MissingLetterScreenState extends State<MissingLetterScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int currentWordIndex = 0;
  List<String> userAnswers = [];
  int score = 0;
  bool showResult = false;
  String selectedLetter = '';

  final List<Map<String, dynamic>> words = [
    {
      'word': 'k_tap',
      'missing': 'i',
      'options': ['ı', 'i', 'u', 'ü'],
      'meaning': 'book',
      'hint': 'Okumak için kullanılan nesne',
    },
    {
      'word': 'ar_ba',
      'missing': 'a',
      'options': ['a', 'e', 'ı', 'i'],
      'meaning': 'car',
      'hint': 'Dört tekerlekli taşıt',
    },
    {
      'word': 'ev_',
      'missing': 'i',
      'options': ['i', 'ı', 'e', 'a'],
      'meaning': 'house',
      'hint': 'İnsanların yaşadığı yer',
    },
    {
      'word': 'm_sa',
      'missing': 'a',
      'options': ['a', 'e', 'ı', 'i'],
      'meaning': 'table',
      'hint': 'Üzerinde yemek yenen mobilya',
    },
    {
      'word': 'pen_ere',
      'missing': 'c',
      'options': ['c', 'ç', 'j', 'ş'],
      'meaning': 'window',
      'hint': 'Odaya ışık giren açıklık',
    },
  ];

  @override
  void initState() {
    super.initState();
    userAnswers = List.filled(words.length, '');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Eksik Harf'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing12,
              vertical: AppTheme.spacing8,
            ),
            margin: const EdgeInsets.only(right: AppTheme.spacing16),
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: Text(
              '$score/${words.length}',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: showResult ? _buildResultScreen() : _buildWordScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWordScreen() {
    final word = words[currentWordIndex];
    final progress = (currentWordIndex + 1) / words.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Card
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kelime ${currentWordIndex + 1}',
                      style: AppTheme.textTheme.titleLarge,
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.accentRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppTheme.borderGrey,
                  valueColor: const AlwaysStoppedAnimation(AppTheme.accentRed),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing32),

          // Word Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacing32),
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              boxShadow: AppTheme.accentShadow,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.abc,
                  size: 64,
                  color: AppTheme.white,
                ),
                const SizedBox(height: AppTheme.spacing24),
                Text(
                  'Eksik harfi bulun',
                  style: AppTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing24,
                    vertical: AppTheme.spacing16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Text(
                    word['word'],
                    style: AppTheme.textTheme.displayLarge?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  word['meaning'],
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Hint Card
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: AppTheme.primaryBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      'İpucu',
                      style: AppTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  word['hint'],
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Letter Options
          Text(
            'Seçenekler:',
            style: AppTheme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: AppTheme.spacing12,
              mainAxisSpacing: AppTheme.spacing12,
            ),
            itemCount: word['options'].length,
            itemBuilder: (context, index) {
              final letter = word['options'][index];
              final isSelected = selectedLetter == letter;

              return GestureDetector(
                onTap: () => _selectLetter(letter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : AppTheme.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.borderGrey,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? AppTheme.primaryShadow : AppTheme.cardShadow,
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: AppTheme.textTheme.displaySmall?.copyWith(
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.darkGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppTheme.spacing32),

          // Action Buttons
          Column(
            children: [
              CustomButton.primary(
                text: 'Kontrol Et',
                onPressed: selectedLetter.isNotEmpty ? _checkAnswer : null,
                isFullWidth: true,
                size: ButtonSize.large,
                icon: const Icon(Icons.check_circle, size: 20),
              ),
              const SizedBox(height: AppTheme.spacing12),
              Row(
                children: [
                  if (currentWordIndex > 0)
                    Expanded(
                      child: CustomButton.outline(
                        text: 'Önceki',
                        onPressed: _previousWord,
                        icon: const Icon(Icons.arrow_back, size: 20),
                      ),
                    ),
                  if (currentWordIndex > 0) const SizedBox(width: AppTheme.spacing12),
                  if (userAnswers[currentWordIndex].isNotEmpty)
                    Expanded(
                      child: CustomButton.secondary(
                        text: currentWordIndex == words.length - 1 ? 'Bitir' : 'Sonraki',
                        onPressed: _nextWord,
                        icon: Icon(
                          currentWordIndex == words.length - 1 ? Icons.check : Icons.arrow_forward,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (score / words.length * 100).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        children: [
          // Results Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacing32),
            decoration: BoxDecoration(
              gradient: percentage >= 70 ? AppTheme.accentGradient : AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              boxShadow: percentage >= 70 ? AppTheme.accentShadow : AppTheme.primaryShadow,
            ),
            child: Column(
              children: [
                Icon(
                  percentage >= 70 ? Icons.emoji_events : Icons.refresh,
                  size: 64,
                  color: AppTheme.white,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  percentage >= 70 ? 'Harika!' : 'İyi Deneme!',
                  style: AppTheme.textTheme.displayMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Skorunuz: $score/${words.length} (%$percentage)',
                  style: AppTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Results Details
          ...List.generate(words.length, (index) {
            final word = words[index];
            final userAnswer = userAnswers[index];
            final isCorrect = userAnswer == word['missing'];

            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: isCorrect
                      ? AppTheme.accentRed.withOpacity(0.3)
                      : AppTheme.primaryBlue.withOpacity(0.3),
                ),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? AppTheme.accentRed : AppTheme.primaryBlue,
                        size: 24,
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Text(
                        word['word'].replaceAll('_', userAnswer.isNotEmpty ? userAnswer : '_'),
                        style: AppTheme.textTheme.titleLarge?.copyWith(
                          color: isCorrect ? AppTheme.accentRed : AppTheme.primaryBlue,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        word['meaning'],
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                  if (!isCorrect) ...[
                    const SizedBox(height: AppTheme.spacing8),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGrey,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Text(
                        'Doğru harf: ${word['missing']}',
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),

          const SizedBox(height: AppTheme.spacing32),

          // Action Buttons
          Column(
            children: [
              CustomButton.primary(
                text: 'Tekrar Dene',
                onPressed: _restartExercise,
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
        ],
      ),
    );
  }

  void _selectLetter(String letter) {
    setState(() {
      selectedLetter = letter;
    });
    HapticFeedback.lightImpact();
  }

  void _checkAnswer() {
    final word = words[currentWordIndex];
    final isCorrect = selectedLetter == word['missing'];

    setState(() {
      userAnswers[currentWordIndex] = selectedLetter;
    });

    if (isCorrect) {
      score++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Doğru! 🎉'),
          backgroundColor: AppTheme.accentRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yanlış! Doğru harf: ${word['missing']}'),
          backgroundColor: AppTheme.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    }

    HapticFeedback.lightImpact();
  }

  void _previousWord() {
    if (currentWordIndex > 0) {
      setState(() {
        currentWordIndex--;
        selectedLetter = userAnswers[currentWordIndex];
      });
      HapticFeedback.lightImpact();
    }
  }

  void _nextWord() {
    if (currentWordIndex < words.length - 1) {
      setState(() {
        currentWordIndex++;
        selectedLetter = userAnswers[currentWordIndex];
      });
      HapticFeedback.lightImpact();
    } else {
      setState(() {
        showResult = true;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      currentWordIndex = 0;
      userAnswers = List.filled(words.length, '');
      score = 0;
      showResult = false;
      selectedLetter = '';
    });

    _animationController.reset();
    _animationController.forward();
    HapticFeedback.lightImpact();
  }
}