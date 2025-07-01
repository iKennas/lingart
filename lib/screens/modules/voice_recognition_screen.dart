// screens/modules/voice_recognition_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class VoiceRecognitionScreen extends StatefulWidget {
  const VoiceRecognitionScreen({Key? key}) : super(key: key);

  @override
  State<VoiceRecognitionScreen> createState() => _VoiceRecognitionScreenState();
}

class _VoiceRecognitionScreenState extends State<VoiceRecognitionScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  bool isRecording = false;
  bool isProcessing = false;
  String recognizedText = '';
  String targetText = '';
  int currentWordIndex = 0;
  int score = 0;
  double accuracy = 0.0;

  final List<Map<String, String>> pronunciationWords = [
    {
      'word': 'Merhaba',
      'meaning': 'Hello',
      'pronunciation': 'mer-ha-ba',
      'tip': 'Her heceyi net bir şekilde telaffuz edin',
    },
    {
      'word': 'Teşekkür ederim',
      'meaning': 'Thank you',
      'pronunciation': 'te-şek-kür e-de-rim',
      'tip': 'Ş ve R harflerini net çıkarın',
    },
    {
      'word': 'Nasılsınız',
      'meaning': 'How are you',
      'pronunciation': 'na-sıl-sı-nız',
      'tip': 'Son heceyi güçlü vurgulayın',
    },
    {
      'word': 'Günaydın',
      'meaning': 'Good morning',
      'pronunciation': 'gün-ay-dın',
      'tip': 'Ü harfini yuvarlak dudaklarla çıkarın',
    },
    {
      'word': 'Görüşürüz',
      'meaning': 'See you later',
      'pronunciation': 'gö-rü-şü-rüz',
      'tip': 'Ö ve Ü seslerini dikkatli telaffuz edin',
    },
  ];

  @override
  void initState() {
    super.initState();
    targetText = pronunciationWords[currentWordIndex]['word']!;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

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
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Ses Tanıma'),
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
              '$score/${pronunciationWords.length}',
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
        child: currentWordIndex >= pronunciationWords.length
            ? _buildCompletionScreen()
            : _buildPronunciationScreen(),
      ),
    );
  }

  Widget _buildPronunciationScreen() {
    final word = pronunciationWords[currentWordIndex];
    final progress = (currentWordIndex + 1) / pronunciationWords.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
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
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppTheme.borderGrey,
                  valueColor: const AlwaysStoppedAnimation(AppTheme.primaryBlue),
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
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              boxShadow: AppTheme.primaryShadow,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.record_voice_over,
                  size: 64,
                  color: AppTheme.white,
                ),
                const SizedBox(height: AppTheme.spacing24),
                Text(
                  word['word']!,
                  style: AppTheme.textTheme.displayLarge?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  word['meaning']!,
                  style: AppTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Text(
                    word['pronunciation']!,
                    style: AppTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Tip Card
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              border: Border.all(color: AppTheme.accentRed.withOpacity(0.2)),
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
                      'Telaffuz İpucu',
                      style: AppTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.accentRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  word['tip']!,
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing32),

          // Recording Section
          _buildRecordingSection(),

          const SizedBox(height: AppTheme.spacing24),

          // Recognition Result
          if (recognizedText.isNotEmpty) _buildRecognitionResult(),

          const SizedBox(height: AppTheme.spacing32),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildRecordingSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            isRecording ? 'Dinliyor...' : 'Kayda başlamak için mikrofona dokunun',
            style: AppTheme.textTheme.titleMedium?.copyWith(
              color: isRecording ? AppTheme.accentRed : AppTheme.mediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Microphone Button
          GestureDetector(
            onTap: isProcessing ? null : _toggleRecording,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isRecording ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: isRecording
                          ? AppTheme.accentGradient
                          : AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: isRecording
                          ? AppTheme.accentShadow
                          : AppTheme.primaryShadow,
                    ),
                    child: Icon(
                      isRecording ? Icons.stop : Icons.mic,
                      size: 48,
                      color: AppTheme.white,
                    ),
                  ),
                );
              },
            ),
          ),

          if (isProcessing) ...[
            const SizedBox(height: AppTheme.spacing16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppTheme.primaryBlue),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'İşleniyor...',
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecognitionResult() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: accuracy >= 0.8
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
                accuracy >= 0.8 ? Icons.check_circle : Icons.info,
                color: accuracy >= 0.8 ? AppTheme.accentRed : AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                'Tanıma Sonucu',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  color: accuracy >= 0.8 ? AppTheme.accentRed : AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),

          Row(
            children: [
              Text(
                'Söylediğiniz: ',
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                recognizedText,
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),

          Row(
            children: [
              Text(
                'Doğruluk: ',
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(accuracy * 100).round()}%',
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  color: accuracy >= 0.8 ? AppTheme.accentRed : AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          if (accuracy < 0.8) ...[
            const SizedBox(height: AppTheme.spacing12),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Text(
                'Daha net telaffuz etmeye çalışın. Hedef kelime: $targetText',
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGrey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomButton.accent(
          text: 'Örnek Dinle',
          onPressed: _playExample,
          isFullWidth: true,
          size: ButtonSize.large,
          icon: const Icon(Icons.volume_up, size: 20),
        ),
        const SizedBox(height: AppTheme.spacing12),

        if (recognizedText.isNotEmpty && accuracy >= 0.8)
          CustomButton.primary(
            text: currentWordIndex == pronunciationWords.length - 1 ? 'Tamamla' : 'Sonraki Kelime',
            onPressed: _nextWord,
            isFullWidth: true,
            size: ButtonSize.large,
            icon: Icon(
              currentWordIndex == pronunciationWords.length - 1
                  ? Icons.check
                  : Icons.arrow_forward,
              size: 20,
            ),
          ),

        if (recognizedText.isNotEmpty && accuracy < 0.8)
          CustomButton.outline(
            text: 'Tekrar Dene',
            onPressed: _retryPronunciation,
            isFullWidth: true,
            size: ButtonSize.large,
            icon: const Icon(Icons.refresh, size: 20),
          ),
      ],
    );
  }

  Widget _buildCompletionScreen() {
    final percentage = (score / pronunciationWords.length * 100).round();

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
                gradient: percentage >= 70 ? AppTheme.accentGradient : AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                boxShadow: percentage >= 70 ? AppTheme.accentShadow : AppTheme.primaryShadow,
              ),
              child: Icon(
                percentage >= 70 ? Icons.emoji_events : Icons.mic,
                size: 60,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

            Text(
              percentage >= 70 ? 'Harika Telaffuz!' : 'İyi Deneme!',
              style: AppTheme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),

            Text(
              'Skorunuz: $score/${pronunciationWords.length}',
              style: AppTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.mediumGrey,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),

            Text(
              '%$percentage doğruluk',
              style: AppTheme.textTheme.headlineMedium?.copyWith(
                color: percentage >= 70 ? AppTheme.accentRed : AppTheme.primaryBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTheme.spacing40),

            Column(
              children: [
                CustomButton.primary(
                  text: 'Tekrar Başla',
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
      ),
    );
  }

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });

    if (isRecording) {
      _pulseController.repeat(reverse: true);
      _startRecording();
    } else {
      _pulseController.stop();
      _stopRecording();
    }

    HapticFeedback.lightImpact();
  }

  void _startRecording() {
    // Simulate speech recognition
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && isRecording) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    setState(() {
      isRecording = false;
      isProcessing = true;
    });

    _pulseController.stop();

    // Simulate processing and recognition
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _simulateRecognition();
      }
    });
  }

  void _simulateRecognition() {
    // Simulate speech recognition results
    final targetWord = pronunciationWords[currentWordIndex]['word']!;
    final random = DateTime.now().millisecond % 100;

    // Simulate different accuracy levels
    if (random < 70) {
      // High accuracy
      setState(() {
        recognizedText = targetWord;
        accuracy = 0.85 + (random % 15) / 100;
        isProcessing = false;
      });
    } else if (random < 90) {
      // Medium accuracy
      setState(() {
        recognizedText = _generateSimilarWord(targetWord);
        accuracy = 0.6 + (random % 20) / 100;
        isProcessing = false;
      });
    } else {
      // Low accuracy
      setState(() {
        recognizedText = _generateDifferentWord();
        accuracy = 0.3 + (random % 30) / 100;
        isProcessing = false;
      });
    }
  }

  String _generateSimilarWord(String target) {
    // Generate a word similar to target (for simulation)
    switch (target.toLowerCase()) {
      case 'merhaba':
        return 'mehaba';
      case 'teşekkür ederim':
        return 'teşekür ederim';
      case 'nasılsınız':
        return 'nasilsiniz';
      case 'günaydın':
        return 'gunaydin';
      case 'görüşürüz':
        return 'gorusuruz';
      default:
        return target;
    }
  }

  String _generateDifferentWord() {
    final words = ['selam', 'hello', 'test', 'deneme'];
    return words[DateTime.now().millisecond % words.length];
  }

  void _playExample() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pronunciationWords[currentWordIndex]['word']} çalınıyor...'),
        backgroundColor: AppTheme.accentRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  void _nextWord() {
    if (accuracy >= 0.8) {
      score++;
    }

    setState(() {
      currentWordIndex++;
      recognizedText = '';
      accuracy = 0.0;
      isProcessing = false;
    });

    if (currentWordIndex < pronunciationWords.length) {
      targetText = pronunciationWords[currentWordIndex]['word']!;
    }

    HapticFeedback.lightImpact();
  }

  void _retryPronunciation() {
    setState(() {
      recognizedText = '';
      accuracy = 0.0;
      isProcessing = false;
    });
    HapticFeedback.lightImpact();
  }

  void _restartExercise() {
    setState(() {
      currentWordIndex = 0;
      score = 0;
      recognizedText = '';
      accuracy = 0.0;
      isRecording = false;
      isProcessing = false;
    });

    targetText = pronunciationWords[0]['word']!;
    _fadeController.reset();
    _fadeController.forward();
    HapticFeedback.lightImpact();
  }
}