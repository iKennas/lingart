// screens/modules/sentence_formation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../utils/app_theme.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class SentenceFormationScreen extends StatefulWidget {
  const SentenceFormationScreen({Key? key}) : super(key: key);

  @override
  State<SentenceFormationScreen> createState() => _SentenceFormationScreenState();
}

class _SentenceFormationScreenState extends State<SentenceFormationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> sentences = [
    {
      'words': ['Bu', 'bir', 'güzel', 'gün'],
      'correct': 'Bu güzel bir gün',
      'meaning': 'This is a beautiful day',
    },
    {
      'words': ['Kitap', 'masanın', 'üzerinde', 'duruyor'],
      'correct': 'Kitap masanın üzerinde duruyor',
      'meaning': 'The book is on the table',
    },
    {
      'words': ['Ben', 'okula', 'her', 'gün', 'gidiyorum'],
      'correct': 'Ben her gün okula gidiyorum',
      'meaning': 'I go to school every day',
    },
    {
      'words': ['Annem', 'mutfakta', 'yemek', 'pişiriyor'],
      'correct': 'Annem mutfakta yemek pişiriyor',
      'meaning': 'My mother is cooking in the kitchen',
    },
    {
      'words': ['Çiçekler', 'bahçede', 'çok', 'güzel'],
      'correct': 'Çiçekler bahçede çok güzel',
      'meaning': 'The flowers in the garden are very beautiful',
    },
  ];

  int currentSentenceIndex = 0;
  List<String> availableWords = [];
  List<String> selectedWords = [];
  bool isCompleted = false;
  int score = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _initializeSentence();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeSentence() {
    final currentSentence = sentences[currentSentenceIndex];
    setState(() {
      availableWords = List<String>.from(currentSentence['words']);
      availableWords.shuffle();
      selectedWords.clear();
      isCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSentence = sentences[currentSentenceIndex];

    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Cümle Oluşturma'),
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
              '${currentSentenceIndex + 1}/${sentences.length}',
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
        child: SingleChildScrollView(
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
                          'Puan: $score',
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.accentRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    LinearProgressIndicator(
                      value: (currentSentenceIndex + 1) / sentences.length,
                      backgroundColor: AppTheme.lightGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Instructions
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  boxShadow: AppTheme.accentShadow,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.build_circle,
                      size: 48,
                      color: AppTheme.white,
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    Text(
                      'Kelimeleri Sıraya Diz',
                      style: AppTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Aşağıdaki kelimeleri doğru sıraya dizarak anlamlı cümle oluşturun',
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Selected words area
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 120),
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  color: selectedWords.isEmpty
                      ? AppTheme.lightGrey.withOpacity(0.5)
                      : AppTheme.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  border: Border.all(
                    color: isCompleted
                        ? AppTheme.success
                        : selectedWords.isEmpty
                        ? AppTheme.borderGrey
                        : AppTheme.primaryBlue,
                    width: 2,
                  ),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: selectedWords.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 32,
                        color: AppTheme.mediumGrey,
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'Kelimeleri buraya sürükleyin',
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mediumGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                    : Wrap(
                  spacing: AppTheme.spacing8,
                  runSpacing: AppTheme.spacing8,
                  children: selectedWords.map((word) {
                    return GestureDetector(
                      onTap: () => _removeWord(word),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing12,
                          vertical: AppTheme.spacing8,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          boxShadow: AppTheme.primaryShadow,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              word,
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing4),
                            const Icon(
                              Icons.close,
                              color: AppTheme.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Available words
              if (availableWords.isNotEmpty) ...[
                Text(
                  'Kelimeler:',
                  style: AppTheme.textTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.spacing16),

                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Wrap(
                    spacing: AppTheme.spacing12,
                    runSpacing: AppTheme.spacing12,
                    children: availableWords.map((word) {
                      return GestureDetector(
                        onTap: () => _selectWord(word),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing16,
                            vertical: AppTheme.spacing12,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            border: Border.all(
                              color: AppTheme.accentRed,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            word,
                            style: AppTheme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.accentRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing32),
              ],

              // Action buttons
              if (selectedWords.isNotEmpty) ...[
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton.outline(
                            text: 'Temizle',
                            onPressed: _clearSelection,
                            icon: const Icon(Icons.clear, size: 20),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Expanded(
                          child: CustomButton.primary(
                            text: 'Kontrol Et',
                            onPressed: _checkAnswer,
                            icon: const Icon(Icons.check_circle, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing16),

                    if (isCompleted) ...[
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacing16),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(color: AppTheme.success),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppTheme.success,
                                  size: 24,
                                ),
                                const SizedBox(width: AppTheme.spacing8),
                                Text(
                                  'Doğru!',
                                  style: AppTheme.textTheme.titleMedium?.copyWith(
                                    color: AppTheme.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacing8),
                            Text(
                              'Anlam: ${currentSentence['meaning']}',
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.darkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing16),

                      CustomButton.accent(
                        text: currentSentenceIndex < sentences.length - 1 ? 'Sonraki Cümle' : 'Tamamla',
                        onPressed: _nextSentence,
                        isFullWidth: true,
                        size: ButtonSize.large,
                        icon: Icon(
                          currentSentenceIndex < sentences.length - 1 ? Icons.arrow_forward : Icons.check,
                          size: 24,
                        ),
                      ),
                    ],
                  ],
                ),
              ],

              if (currentSentenceIndex == sentences.length - 1 && isCompleted) ...[
                const SizedBox(height: AppTheme.spacing24),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: AppTheme.accentShadow,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 48,
                        color: AppTheme.white,
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      Text(
                        'Tebrikler!',
                        style: AppTheme.textTheme.headlineSmall?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'Tüm cümleleri başarıyla oluşturdunuz!',
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _selectWord(String word) {
    setState(() {
      availableWords.remove(word);
      selectedWords.add(word);
    });
    HapticFeedback.lightImpact();
  }

  void _removeWord(String word) {
    setState(() {
      selectedWords.remove(word);
      availableWords.add(word);
    });
    HapticFeedback.lightImpact();
  }

  void _clearSelection() {
    setState(() {
      availableWords.addAll(selectedWords);
      selectedWords.clear();
      isCompleted = false;
    });
    HapticFeedback.lightImpact();
  }

  void _checkAnswer() {
    final currentSentence = sentences[currentSentenceIndex];
    final userSentence = selectedWords.join(' ');
    final correctSentence = currentSentence['correct'];

    if (userSentence == correctSentence) {
      setState(() {
        isCompleted = true;
        score += 10;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Doğru cümle! +10 puan 🎉'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yanlış sıralama! Doğru cümle: $correctSentence'),
          backgroundColor: AppTheme.accentRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    }

    HapticFeedback.lightImpact();
  }

  void _nextSentence() {
    if (currentSentenceIndex < sentences.length - 1) {
      setState(() {
        currentSentenceIndex++;
      });
      _initializeSentence();
      _animationController.reset();
      _animationController.forward();
    } else {
      // Show completion dialog
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
                'Oyun Tamamlandı!',
                style: AppTheme.textTheme.headlineSmall,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Toplam Puanınız: $score',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.accentRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'Tüm cümleleri başarıyla oluşturdunuz!',
                style: AppTheme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            CustomButton.primary(
              text: 'Ana Menüye Dön',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              size: ButtonSize.small,
            ),
          ],
        ),
      );
    }

    HapticFeedback.lightImpact();
  }
}