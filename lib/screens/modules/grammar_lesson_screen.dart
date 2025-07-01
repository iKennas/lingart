// screens/modules/grammar_lesson_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class GrammarLessonScreen extends StatefulWidget {
  const GrammarLessonScreen({Key? key}) : super(key: key);

  @override
  State<GrammarLessonScreen> createState() => _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends State<GrammarLessonScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int currentLessonIndex = 0;
  bool showExercise = false;
  int exerciseScore = 0;

  final List<Map<String, dynamic>> grammarLessons = [
    {
      'title': 'İsim Tamlaması',
      'description': 'Türkçede iki ismin yan yana gelerek oluşturdukları yapı',
      'content': '''
İsim tamlaması, Türkçede iki ismin yan yana gelerek oluşturdukları yapıdır. İki türü vardır:

1. **Belirtili İsim Tamlaması:**
   - Tamlayan ek alır: -(n)ın, -(n)in, -(n)un, -(n)ün
   - Tamlanan ek alır: -(s)ı, -(s)i, -(s)u, -(s)ü
   - Örnek: Ahmet'in kitabı, annemin arabası

2. **Belirtisiz İsim Tamlaması:**
   - Tamlayan ek almaz
   - Tamlanan ek alır: -(s)ı, -(s)i, -(s)u, -(s)ü
   - Örnek: okul müdürü, ev anahtarı

**Önemli Kurallar:**
- Belirtili tamlamada tamlayan mutlaka ek alır
- Belirtisiz tamlamada tamlayan ek almaz
- Tamlanan her iki durumda da ek alır
      ''',
      'examples': [
        'Öğretmenin defteri (belirtili)',
        'Masa üstü (belirtisiz)',
        'Çocuğun oyuncağı (belirtili)',
        'Ev işi (belirtisiz)',
      ],
      'exercise': {
        'question': 'Aşağıdaki hangi tamlamalar belirtili isim tamlamasıdır?',
        'options': [
          'okul bahçesi',
          'kedinin kuyruğu',
          'masa örtüsü',
          'annemin çantası'
        ],
        'correctAnswers': ['kedinin kuyruğu', 'annemin çantası'],
      }
    },
    {
      'title': 'Fiil Çekimi - Geniş Zaman',
      'description': 'Sürekli veya tekrarlanan eylemleri ifade eden zaman',
      'content': '''
**Geniş Zaman (-r/-ır/-ir/-ur/-ür eki):**

Geniş zaman, sürekli olan, tekrarlanan veya genel geçer durumları ifade eder.

**Olumlu Çekim:**
- Ben gel-ir-im
- Sen gel-ir-sin  
- O gel-ir
- Biz gel-ir-iz
- Siz gel-ir-siniz
- Onlar gel-ir-ler

**Olumsuz Çekim:**
- -maz/-mez eki kullanılır
- Ben gel-mez-im
- Sen gel-mez-sin
- O gel-mez

**Soru Çekimi:**
- Soru eki -mı/-mi/-mu/-mü kullanılır
- Gelir misin?
- Okur musun?

**Kullanım Alanları:**
1. Sürekli durumlar: "Her gün okula giderim"
2. Alışkanlıklar: "Çay içerim"
3. Genel doğrular: "Güneş doğudan doğar"
      ''',
      'examples': [
        'Her sabah erken kalkarım',
        'Kitap okumayı severim',
        'Onlar Türkçe konuşurlar',
        'Bu kurs çok faydalıdır',
      ],
      'exercise': {
        'question': 'Hangi cümle geniş zamanı doğru kullanır?',
        'options': [
          'Ben okula gidiyorum',
          'Sen kitap okursun',
          'O geldi',
          'Biz çalışacağız'
        ],
        'correctAnswers': ['Sen kitap okursun'],
      }
    },
    {
      'title': 'Sıfatlar ve Kullanımı',
      'description': 'İsimlerin özelliklerini belirten kelimeler',
      'content': '''
**Sıfat Türleri:**

1. **Niteleme Sıfatları:**
   - Renk: kırmızı, mavi, yeşil
   - Büyüklük: büyük, küçük, orta
   - Şekil: yuvarlak, kare, üçgen

2. **Belirtme Sıfatları:**
   - Sayı sıfatları: bir, iki, üç
   - İşaret sıfatları: bu, şu, o
   - Belirsizlik sıfatları: birkaç, bazı, her

3. **Soru Sıfatları:**
   - hangi, kaç, nasıl

**Sıfat Tamlaması:**
- Sıfat + İsim şeklinde kurulur
- Sıfat ek almaz: "güzel kız"
- İsim çoğul olabilir: "güzel kızlar"

**Pekiştirme:**
- "çok güzel", "en büyük" gibi yapılar
- Üstünlük derecesi: -en, en- ekleri
      ''',
      'examples': [
        'Mavi gömlek',
        'Bu kitap çok ilginç',
        'En güzel çiçek',
        'Kaç tane elma?',
      ],
      'exercise': {
        'question': 'Hangi kelime niteleme sıfatıdır?',
        'options': [
          'bu',
          'güzel',
          'kaç',
          'bazı'
        ],
        'correctAnswers': ['güzel'],
      }
    }
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
        title: const Text('Dilbilgisi Dersleri'),
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
              '${currentLessonIndex + 1}/${grammarLessons.length}',
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
              child: showExercise ? _buildExerciseScreen() : _buildLessonScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLessonScreen() {
    final lesson = grammarLessons[currentLessonIndex];
    final progress = (currentLessonIndex + 1) / grammarLessons.length;

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
                      'Ders ${currentLessonIndex + 1}',
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
          const SizedBox(height: AppTheme.spacing24),

          // Lesson Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacing24),
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              boxShadow: AppTheme.accentShadow,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 48,
                  color: AppTheme.white,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  lesson['title'],
                  style: AppTheme.textTheme.displayMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  lesson['description'],
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Lesson Content
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
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        color: AppTheme.primaryBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      'Ders İçeriği',
                      style: AppTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  lesson['content'],
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing20),

          // Examples Section
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
                      'Örnekler',
                      style: AppTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.accentRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing16),
                ...List.generate(
                  lesson['examples'].length,
                      (index) => Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                    padding: const EdgeInsets.all(AppTheme.spacing12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGrey,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppTheme.accentRed,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: AppTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Expanded(
                          child: Text(
                            lesson['examples'][index],
                            style: AppTheme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                text: 'Alıştırma Yap',
                onPressed: _startExercise,
                isFullWidth: true,
                size: ButtonSize.large,
                icon: const Icon(Icons.quiz, size: 20),
              ),
              const SizedBox(height: AppTheme.spacing12),
              Row(
                children: [
                  if (currentLessonIndex > 0)
                    Expanded(
                      child: CustomButton.outline(
                        text: 'Önceki',
                        onPressed: _previousLesson,
                        icon: const Icon(Icons.arrow_back, size: 20),
                      ),
                    ),
                  if (currentLessonIndex > 0) const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: CustomButton.primary(
                      text: currentLessonIndex == grammarLessons.length - 1 ? 'Tamamla' : 'Sonraki',
                      onPressed: _nextLesson,
                      icon: Icon(
                        currentLessonIndex == grammarLessons.length - 1 ? Icons.check : Icons.arrow_forward,
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

  Widget _buildExerciseScreen() {
    final exercise = grammarLessons[currentLessonIndex]['exercise'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Header
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
                Icon(
                  Icons.quiz_outlined,
                  size: 48,
                  color: AppTheme.white,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  'Alıştırma',
                  style: AppTheme.textTheme.displayMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Öğrendiklerinizi test edin',
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Question
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
                Text(
                  'Soru:',
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  exercise['question'],
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing20),

          // Options
          Text(
            'Seçenekler:',
            style: AppTheme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacing12),

          ...List.generate(
            exercise['options'].length,
                (index) => _buildExerciseOption(
              exercise['options'][index],
              index,
              exercise['correctAnswers'],
            ),
          ),

          const SizedBox(height: AppTheme.spacing32),

          CustomButton.primary(
            text: 'Derse Geri Dön',
            onPressed: _backToLesson,
            isFullWidth: true,
            size: ButtonSize.large,
            icon: const Icon(Icons.arrow_back, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseOption(String option, int index, List<String> correctAnswers) {
    final isCorrect = correctAnswers.contains(option);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: GestureDetector(
        onTap: () => _selectExerciseOption(option, isCorrect),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: AppTheme.borderGrey),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.mediumGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: Text(
                  option,
                  style: AppTheme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startExercise() {
    setState(() {
      showExercise = true;
      exerciseScore = 0;
    });

    _animationController.reset();
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _backToLesson() {
    setState(() {
      showExercise = false;
    });

    _animationController.reset();
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _selectExerciseOption(String option, bool isCorrect) {
    HapticFeedback.lightImpact();

    if (isCorrect) {
      exerciseScore++;
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
          content: const Text('Yanlış. Tekrar deneyin! 💪'),
          backgroundColor: AppTheme.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    }
  }

  void _previousLesson() {
    if (currentLessonIndex > 0) {
      setState(() {
        currentLessonIndex--;
        showExercise = false;
      });

      _animationController.reset();
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _nextLesson() {
    if (currentLessonIndex < grammarLessons.length - 1) {
      setState(() {
        currentLessonIndex++;
        showExercise = false;
      });

      _animationController.reset();
      _animationController.forward();
    } else {
      // Lesson completed
      Navigator.pop(context);
    }
    HapticFeedback.lightImpact();
  }
}