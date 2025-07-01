// screens/modules/teacher_lesson_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';  // Add this import for Timer
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class TeacherLessonScreen extends StatefulWidget {
  const TeacherLessonScreen({Key? key}) : super(key: key);

  @override
  State<TeacherLessonScreen> createState() => _TeacherLessonScreenState();
}

class _TeacherLessonScreenState extends State<TeacherLessonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scrollAnimation;

  final List<String> lessonContent = [
    'Merhaba! Bugün Türkçe dilbilgisini öğreneceğiz.',
    'İlk olarak isimleri ele alalım.',
    'İsimler varlık, kavram veya durumları adlandırır.',
    'Örneğin: ev, araba, kitap, sevgi...',
    'İsimler tekil veya çoğul olabilir.',
    'Çoğul eki -lar veya -ler\'dir.',
    'Şimdi fiillere geçelim.',
    'Fiiller hareket, durum veya oluş bildirir.',
    'git-, gel-, oku-, yaz- gibi...',
  ];

  int currentContentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _scrollAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    _startLesson();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startLesson() {
    _animationController.repeat();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && currentContentIndex < lessonContent.length - 1) {
        setState(() {
          currentContentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.teacherLesson),
        backgroundColor: AppColors.teacherModule,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.largePadding),
        child: Row(
          children: [
            // Teacher Avatar
            const TeacherAvatar(size: 120),
            SizedBox(width: AppConstants.largePadding),

            // Speech Bubble
            Expanded(
              child: Container(
                height: 200,
                padding: EdgeInsets.all(AppConstants.mediumPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.largeRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Audio Control
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Öğretmen Anlatımı',
                          style: AppTextStyles.cardTitle,
                        ),
                        AudioPlayerWidget(
                          audioUrl: 'teacher_lesson_audio',
                          iconColor: AppColors.teacherModule,
                        ),
                      ],
                    ),
                    Divider(color: AppColors.teacherModule.withOpacity(0.3)),

                    // Scrolling Text
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _scrollAnimation,
                        builder: (context, child) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0; i <= currentContentIndex; i++)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: AppConstants.smallPadding),
                                    child: Text(
                                      lessonContent[i],
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: i == currentContentIndex
                                            ? AppColors.teacherModule
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: AppColors.teacherModule,
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}