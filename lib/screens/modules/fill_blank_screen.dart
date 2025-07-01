// screens/modules/fill_blank_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../widgets/widgets.dart';

class FillBlankScreen extends StatefulWidget {
  const FillBlankScreen({Key? key}) : super(key: key);

  @override
  State<FillBlankScreen> createState() => _FillBlankScreenState();
}

class _FillBlankScreenState extends State<FillBlankScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int currentQuestionIndex = 0;
  List<String> userAnswers = [];
  int score = 0;
  bool showResults = false;

  final List<Map<String, dynamic>> questions = [
    {
      'sentence': 'Ben her gün okula _____ gidiyorum.',
      'options': ['yürüyerek', 'koşarak', 'uçarak', 'yüzerek'],
      'correctAnswer': 'yürüyerek',
      'explanation': 'Okula normalde yürüyerek gidilir.',
    },
    {
      'sentence': 'Annem mutfakta yemek _____.',
      'options': ['pişiriyor', 'okuyor', 'yazıyor', 'uyuyor'],
      'correctAnswer': 'pişiriyor',
      'explanation': 'Mutfakta yemek pişirilir.',
    },
    {
      'sentence': 'Kitabı masanın _____ koydum.',
      'options': ['üstüne', 'altına', 'yanına', 'içine'],
      'correctAnswer': 'üstüne',
      'explanation': 'Kitap masa üstüne konur.',
    },
    {
      'sentence': 'Hava çok soğuk, _____ giy.',
      'options': ['mont', 'mayo', 'şort', 'terlik'],
      'correctAnswer': 'mont',
      'explanation': 'Soğuk havada mont giyilir.',
    },
    {
      'sentence': 'Sabah güneş _____ doğar.',
      'options': ['doğudan', 'batıdan', 'kuzeyden', 'güneyden'],
      'correctAnswer': 'doğudan',
      'explanation': 'Güneş her zaman doğudan doğar.',
    },
  ];

  @override
  void initState() {
    super.initState();
    userAnswers = List.filled(questions.length, '');

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
        title: const Text('Boşluk Doldurma'),
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
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: Text(
              '${currentQuestionIndex + 1}/${questions.length}',
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
        child: showResults ? _buildResultsScreen() : _buildQuestionScreen(),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final question = questions[currentQuestionIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        children: [
          // Progress Bar
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
                      'İlerleme',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    Text(
                      '${currentQuestionIndex + 1}/${questions.length}',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing12),
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: AppTheme.lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                  minHeight: 8,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Question Card
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              boxShadow: AppTheme.accentShadow,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 48,
                  color: AppTheme.white,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  'Cümleyi Tamamlayın',
                  style: AppTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Text(
                    question['sentence'],
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.white,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Options
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
            itemCount: question['options'].length,
            itemBuilder: (context, index) {
              final option = question['options'][index];
              final isSelected = userAnswers[currentQuestionIndex] == option;

              return GestureDetector(
                onTap: () => _selectOption(option),
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
                      option,
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.darkGrey,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
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
                onPressed: userAnswers[currentQuestionIndex].isNotEmpty ? _checkAnswer : null,
                isFullWidth: true,
                size: ButtonSize.large,
                icon: const Icon(Icons.check_circle, size: 24),
              ),
              const SizedBox(height: AppTheme.spacing12),
              Row(
                children: [
                  if (currentQuestionIndex > 0)
                    Expanded(
                      child: CustomButton.outline(
                        text: 'Önceki',
                        onPressed: _previousQuestion,
                        icon: const Icon(Icons.arrow_back, size: 20),
                      ),
                    ),
                  if (currentQuestionIndex > 0) const SizedBox(width: AppTheme.spacing12),
                  if (userAnswers[currentQuestionIndex].isNotEmpty)
                    Expanded(
                      child: CustomButton.accent(
                        text: currentQuestionIndex == questions.length - 1 ? 'Sonuçlar' : 'Sonraki',
                        onPressed: _nextQuestion,
                        icon: Icon(
                          currentQuestionIndex == questions.length - 1 ? Icons.assessment : Icons.arrow_forward,
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

  Widget _buildResultsScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        children: [
          // Score Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacing24),
            decoration: BoxDecoration(
              gradient: score >= questions.length * 0.7 ? AppTheme.accentGradient : AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              boxShadow: score >= questions.length * 0.7 ? AppTheme.accentShadow : AppTheme.primaryShadow,
            ),
            child: Column(
              children: [
                Icon(
                  score >= questions.length * 0.7 ? Icons.emoji_events : Icons.thumb_up,
                  size: 48,
                  color: AppTheme.white,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  score >= questions.length * 0.7 ? 'Mükemmel!' : 'İyi!',
                  style: AppTheme.textTheme.displayMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  'Puanınız: $score/${questions.length}',
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Results List
          Text(
            'Sonuçlar',
            style: AppTheme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing16),

          ...questions.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> question = entry.value;
            String userAnswer = userAnswers[index];
            bool isCorrect = userAnswer == question['correctAnswer'];

            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: isCorrect ? AppTheme.accentRed : AppTheme.primaryBlue,
                  width: 2,
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
                      Expanded(
                        child: Text(
                          question['sentence'].replaceAll('_____', userAnswer.isNotEmpty ? userAnswer : '_____'),
                          style: AppTheme.textTheme.bodyLarge?.copyWith(
                            color: isCorrect ? AppTheme.accentRed : AppTheme.primaryBlue,
                          ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Doğru cevap: ${question['correctAnswer']}',
                            style: AppTheme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.accentRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            question['explanation'],
                            style: AppTheme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: AppTheme.spacing32),

          // Action Buttons
          Column(
            children: [
              CustomButton.primary(
                text: 'Tekrar Dene',
                onPressed: _restartQuiz,
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

  void _selectOption(String option) {
    setState(() {
      userAnswers[currentQuestionIndex] = option;
    });
    HapticFeedback.lightImpact();
  }

  void _checkAnswer() {
    final question = questions[currentQuestionIndex];
    final isCorrect = userAnswers[currentQuestionIndex] == question['correctAnswer'];

    if (isCorrect) {
      score++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Doğru! ${question['explanation']}'),
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
          content: Text('Yanlış! Doğru cevap: ${question['correctAnswer']}'),
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

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
      HapticFeedback.lightImpact();
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      HapticFeedback.lightImpact();
    } else {
      setState(() {
        showResults = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      userAnswers = List.filled(questions.length, '');
      score = 0;
      showResults = false;
    });

    _animationController.reset();
    _animationController.forward();
    HapticFeedback.lightImpact();
  }
}