// screens/modules/picture_word_learning_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../widgets/widgets.dart';

class PictureWordLearningScreen extends StatefulWidget {
  const PictureWordLearningScreen({Key? key}) : super(key: key);

  @override
  State<PictureWordLearningScreen> createState() => _PictureWordLearningScreenState();
}

class _PictureWordLearningScreenState extends State<PictureWordLearningScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  int currentWordIndex = 0;
  bool showMeaning = false;
  int score = 0;
  int totalQuestions = 5;

  final List<Map<String, String>> words = [
    {
      'word': 'elma',
      'meaning': 'apple',
      'description': 'Kırmızı veya yeşil renkli, tatlı bir meyve',
      'image': '🍎',
    },
    {
      'word': 'kitap',
      'meaning': 'book',
      'description': 'Sayfaları olan, okumak için kullanılan nesne',
      'image': '📚',
    },
    {
      'word': 'araba',
      'meaning': 'car',
      'description': 'Dört tekerlekli, motor ile çalışan taşıt',
      'image': '🚗',
    },
    {
      'word': 'ev',
      'meaning': 'house',
      'description': 'İnsanların yaşadığı yapı',
      'image': '🏠',
    },
    {
      'word': 'güneş',
      'meaning': 'sun',
      'description': 'Gökyüzünde parlayan, ışık ve ısı veren yıldız',
      'image': '☀️',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
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
        title: const Text('Resimli Kelime Öğrenme'),
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
              '$score/$totalQuestions',
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
            child: Transform.translate(
              offset: Offset(_slideAnimation.value * 50, 0),
              child: _buildContent(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (currentWordIndex >= words.length) {
      return _buildCompletionScreen();
    }

    final currentWord = words[currentWordIndex];

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
                      '${currentWordIndex + 1}/${words.length}',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing12),
                LinearProgressIndicator(
                  value: (currentWordIndex + 1) / words.length,
                  backgroundColor: AppTheme.lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                  minHeight: 8,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Image Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacing32),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              boxShadow: AppTheme.primaryShadow,
            ),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Center(
                    child: Text(
                      currentWord['image']!,
                      style: const TextStyle(fontSize: 64),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing24),
                Text(
                  currentWord['word']!,
                  style: AppTheme.textTheme.displayMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (showMeaning) ...[
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    currentWord['meaning']!,
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Description Card
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
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
                        Icons.info_outline,
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
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  currentWord['description']!,
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing32),

          // Action Buttons
          Column(
            children: [
              CustomButton.accent(
                text: showMeaning ? 'Çeviriyi Gizle' : 'Çeviriyi Göster',
                onPressed: _toggleMeaning,
                isFullWidth: true,
                size: ButtonSize.large,
                icon: Icon(
                  showMeaning ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
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
                  Expanded(
                    child: CustomButton.primary(
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

  Widget _buildCompletionScreen() {
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
                Icons.emoji_events,
                size: 60,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

            Text(
              'Tebrikler!',
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
                    'Tüm kelimeleri öğrendiniz!',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing16,
                          vertical: AppTheme.spacing8,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                        ),
                        child: Text(
                          '${words.length} kelime',
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing40),

            CustomButton.primary(
              text: 'Tekrar Öğren',
              onPressed: _restartLesson,
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

  void _toggleMeaning() {
    setState(() {
      showMeaning = !showMeaning;
    });
    HapticFeedback.lightImpact();
  }

  void _previousWord() {
    if (currentWordIndex > 0) {
      setState(() {
        currentWordIndex--;
        showMeaning = false;
      });
      _animationController.reset();
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _nextWord() {
    if (currentWordIndex < words.length - 1) {
      setState(() {
        currentWordIndex++;
        showMeaning = false;
        if (showMeaning) score++;
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      setState(() {
        currentWordIndex++;
        if (showMeaning) score++;
      });
    }
    HapticFeedback.lightImpact();
  }

  void _restartLesson() {
    setState(() {
      currentWordIndex = 0;
      showMeaning = false;
      score = 0;
    });
    _animationController.reset();
    _animationController.forward();
    HapticFeedback.lightImpact();
  }
}