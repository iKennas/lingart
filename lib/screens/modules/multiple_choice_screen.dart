// screens/modules/multiple_choice_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class MultipleChoiceScreen extends StatefulWidget {
  const MultipleChoiceScreen({Key? key}) : super(key: key);

  @override
  State<MultipleChoiceScreen> createState() => _MultipleChoiceScreenState();
}

class _MultipleChoiceScreenState extends State<MultipleChoiceScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int currentQuestionIndex = 0;
  int score = 0;
  String? selectedAnswer;
  bool showExplanation = false;
  bool quizCompleted = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Türkiye\'nin başkenti neresidir?',
      'options': ['İstanbul', 'Ankara', 'İzmir', 'Bursa'],
      'correctAnswer': 'Ankara',
      'explanation': 'Türkiye\'nin başkenti 1923\'ten beri Ankara\'dır.',
    },
    {
      'question': '"Merhaba" kelimesi hangi anlama gelir?',
      'options': ['Goodbye', 'Hello', 'Thank you', 'Please'],
      'correctAnswer': 'Hello',
      'explanation': 'Merhaba Türkçede "Hello" anlamına gelir.',
    },
    {
      'question': 'Türkçede "kitap" kelimesi ne demektir?',
      'options': ['Table', 'Chair', 'Book', 'Pen'],
      'correctAnswer': 'Book',
      'explanation': 'Kitap kelimesi İngilizcede "book" anlamına gelir.',
    },
    {
      'question': '"Ben okula gidiyorum" cümlesinde özne hangisidir?',
      'options': ['Ben', 'okula', 'gidiyorum', 'okul'],
      'correctAnswer': 'Ben',
      'explanation': 'Özne cümlede eylemi yapan kişi veya varlıktır. Bu cümlede "ben" öznedir.',
    },
    {
      'question': 'Türkçede kaç tane ünlü harf vardır?',
      'options': ['6', '8', '10', '12'],
      'correctAnswer': '8',
      'explanation': 'Türkçede a, e, ı, i, o, ö, u, ü olmak üzere 8 ünlü harf vardır.',
    },
  ];

  @override
  void initState() {
    super.initState();

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
        title: const Text('Çoktan Seçmeli Test'),
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
              '$score/${questions.length}',
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
        child: SlideTransition(
          position: _slideAnimation,
          child: quizCompleted ? _buildCompletionScreen() : _buildQuestionScreen(),
        ),
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
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacing24),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              boxShadow: AppTheme.primaryShadow,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: Text(
                    'Soru ${currentQuestionIndex + 1}',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing20),
                Text(
                  question['question'],
                  style: AppTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Options
          ...question['options'].asMap().entries.map((entry) {
            int index = entry.key;
            String option = entry.value;
            bool isSelected = selectedAnswer == option;
            bool isCorrect = option == question['correctAnswer'];
            bool showCorrectAnswer = showExplanation && isCorrect;
            bool showWrongAnswer = showExplanation && isSelected && !isCorrect;

            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
              child: GestureDetector(
                onTap: showExplanation ? null : () => _selectAnswer(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: showCorrectAnswer
                        ? AppTheme.accentRed.withOpacity(0.1)
                        : showWrongAnswer
                        ? AppTheme.primaryBlue.withOpacity(0.1)
                        : isSelected
                        ? AppTheme.primaryBlue.withOpacity(0.1)
                        : AppTheme.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(
                      color: showCorrectAnswer
                          ? AppTheme.accentRed
                          : showWrongAnswer
                          ? AppTheme.primaryBlue
                          : isSelected
                          ? AppTheme.primaryBlue
                          : AppTheme.borderGrey,
                      width: showExplanation || isSelected ? 2 : 1,
                    ),
                    boxShadow: showExplanation || isSelected ? AppTheme.primaryShadow : AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: showCorrectAnswer
                              ? AppTheme.accentRed
                              : showWrongAnswer
                              ? AppTheme.primaryBlue
                              : isSelected
                              ? AppTheme.primaryBlue
                              : AppTheme.borderGrey,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                        child: Center(
                          child: showExplanation
                              ? Icon(
                            isCorrect ? Icons.check : (isSelected ? Icons.close : null),
                            color: AppTheme.white,
                            size: 20,
                          )
                              : Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: AppTheme.textTheme.titleMedium?.copyWith(
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
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            color: showCorrectAnswer
                                ? AppTheme.accentRed
                                : showWrongAnswer
                                ? AppTheme.primaryBlue
                                : isSelected
                                ? AppTheme.primaryBlue
                                : AppTheme.darkGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          if (showExplanation) ...[
            const SizedBox(height: AppTheme.spacing24),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(color: AppTheme.accentRed.withOpacity(0.3)),
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
                          color: AppTheme.accentRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: AppTheme.accentRed,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing12),
                      Text(
                        'Açıklama',
                        style: AppTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.accentRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    question['explanation'],
                    style: AppTheme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppTheme.spacing32),

          // Action Buttons
          Column(
            children: [
              if (!showExplanation)
                CustomButton.primary(
                  text: 'Cevabı Kontrol Et',
                  onPressed: selectedAnswer != null ? _checkAnswer : null,
                  isFullWidth: true,
                  size: ButtonSize.large,
                  icon: const Icon(Icons.check_circle, size: 24),
                )
              else
                CustomButton.accent(
                  text: currentQuestionIndex == questions.length - 1 ? 'Sonuçları Gör' : 'Sonraki Soru',
                  onPressed: _nextQuestion,
                  isFullWidth: true,
                  size: ButtonSize.large,
                  icon: Icon(
                    currentQuestionIndex == questions.length - 1 ? Icons.assessment : Icons.arrow_forward,
                    size: 24,
                  ),
                ),
              const SizedBox(height: AppTheme.spacing12),
              if (currentQuestionIndex > 0 && !showExplanation)
                CustomButton.outline(
                  text: 'Önceki Soru',
                  onPressed: _previousQuestion,
                  isFullWidth: true,
                  icon: const Icon(Icons.arrow_back, size: 20),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    final percentage = (score / questions.length * 100).round();
    final isExcellent = percentage >= 80;

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
                gradient: isExcellent ? AppTheme.accentGradient : AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                boxShadow: isExcellent ? AppTheme.accentShadow : AppTheme.primaryShadow,
              ),
              child: Icon(
                isExcellent ? Icons.emoji_events : Icons.thumb_up,
                size: 60,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

            Text(
              isExcellent ? 'Mükemmel!' : 'İyi İş!',
              style: AppTheme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing16),

            Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  Text(
                    'Test Sonuçlarınız',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Doğru', '$score', AppTheme.accentRed),
                      _buildStatItem('Yanlış', '${questions.length - score}', AppTheme.primaryBlue),
                      _buildStatItem('Başarı', '%$percentage', isExcellent ? AppTheme.accentRed : AppTheme.primaryBlue),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing40),

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
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12,
            vertical: AppTheme.spacing8,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Text(
            value,
            style: AppTheme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          label,
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.mediumGrey,
          ),
        ),
      ],
    );
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
    HapticFeedback.lightImpact();
  }

  void _checkAnswer() {
    final question = questions[currentQuestionIndex];
    final isCorrect = selectedAnswer == question['correctAnswer'];

    if (isCorrect) {
      score++;
    }

    setState(() {
      showExplanation = true;
    });

    HapticFeedback.lightImpact();
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        showExplanation = false;
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      setState(() {
        quizCompleted = true;
      });
    }
    HapticFeedback.lightImpact();
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        selectedAnswer = null;
        showExplanation = false;
      });
      _animationController.reset();
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswer = null;
      showExplanation = false;
      quizCompleted = false;
    });

    _animationController.reset();
    _animationController.forward();
    HapticFeedback.lightImpact();
  }
}