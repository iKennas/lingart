// screens/progress_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = UserProgress(
      totalPoints: 1250,
      completedLessons: 15,
      totalLessons: 25,
      masteredWords: 85,
      totalWords: 120,
      streak: 7,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.progress,
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Progress Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppConstants.largePadding),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppConstants.largeRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Toplam İlerleme',
                    style: AppTextStyles.heading3.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: AppConstants.mediumPadding),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: progress.progressPercentage,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 8,
                        ),
                      ),
                      Text(
                        '${(progress.progressPercentage * 100).round()}%',
                        style: AppTextStyles.heading2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppConstants.largePadding),

            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppConstants.mediumPadding,
              mainAxisSpacing: AppConstants.mediumPadding,
              childAspectRatio: 1.1,
              children: [
                _buildStatCard(
                  icon: Icons.star,
                  title: 'Toplam Puan',
                  value: Helpers.formatNumber(progress.totalPoints),
                  color: AppColors.secondary,
                ),
                _buildStatCard(
                  icon: Icons.local_fire_department,
                  title: AppStrings.streak,
                  value: '${progress.streak} gün',
                  color: AppColors.accent,
                ),
                _buildStatCard(
                  icon: Icons.book,
                  title: AppStrings.completedLessons,
                  value: '${progress.completedLessons}/${progress.totalLessons}',
                  color: AppColors.primary,
                ),
                _buildStatCard(
                  icon: Icons.language,
                  title: AppStrings.masteredWords,
                  value: '${progress.masteredWords}/${progress.totalWords}',
                  color: AppColors.success,
                ),
              ],
            ),
            SizedBox(height: AppConstants.largePadding),

            // Progress Details
            _buildProgressDetails(progress),
            SizedBox(height: AppConstants.largePadding),

            // Recent Achievements
            _buildRecentAchievements(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppConstants.smallPadding),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.smallRadius),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          SizedBox(height: AppConstants.smallPadding),
          Text(
            value,
            style: AppTextStyles.heading4.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDetails(UserProgress progress) {
    return Container(
      padding: EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İlerleme Detayları',
            style: AppTextStyles.heading3,
          ),
          SizedBox(height: AppConstants.mediumPadding),
          _buildProgressItem(
            'Dersler',
            progress.completedLessons,
            progress.totalLessons,
            AppColors.primary,
          ),
          SizedBox(height: AppConstants.mediumPadding),
          _buildProgressItem(
            'Kelimeler',
            progress.masteredWords,
            progress.totalWords,
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, int completed, int total, Color color) {
    final percentage = completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLarge,
            ),
            Text(
              '$completed/$total',
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppConstants.smallPadding),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[300],
          color: color,
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildRecentAchievements() {
    final achievements = [
      {
        'title': 'İlk Ders Tamamlandı',
        'description': 'İlk dersinizi başarıyla tamamladınız!',
        'icon': Icons.star,
        'color': AppColors.secondary,
        'date': '2 gün önce',
      },
      {
        'title': '7 Günlük Seri',
        'description': '7 gün üst üste öğrenme gerçekleştirdiniz',
        'icon': Icons.local_fire_department,
        'color': AppColors.accent,
        'date': '1 gün önce',
      },
      {
        'title': '50 Kelime Öğrenildi',
        'description': 'Toplam 50 kelime öğrendiniz',
        'icon': Icons.language,
        'color': AppColors.success,
        'date': 'Bugün',
      },
    ];

    return Container(
      padding: EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Son Başarılar',
            style: AppTextStyles.heading3,
          ),
          SizedBox(height: AppConstants.mediumPadding),
          ...achievements.map((achievement) => _buildAchievementItem(achievement)),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Map<String, dynamic> achievement) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.smallPadding),
      padding: EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: (achievement['color'] as Color).withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        border: Border.all(
          color: (achievement['color'] as Color).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: achievement['color'],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              achievement['icon'],
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['title'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  achievement['description'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            achievement['date'],
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}