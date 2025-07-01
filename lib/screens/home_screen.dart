// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _selectedIndex = index),
          children: [
            _buildMainHome(),
            _buildLessonsPage(),
            _buildProgressPage(),
            _buildProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMainHome() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            // Quick Stats
            SliverToBoxAdapter(
              child: _buildQuickStats(),
            ),

            // Learning Modules
            SliverToBoxAdapter(
              child: _buildLearningModules(),
            ),

            // Daily Challenge
            SliverToBoxAdapter(
              child: _buildDailyChallenge(),
            ),

            // Recent Activity
            SliverToBoxAdapter(
              child: _buildRecentActivity(),
            ),

            // Bottom Spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppTheme.radiusXLarge),
          bottomRight: Radius.circular(AppTheme.radiusXLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Merhaba! 👋',
                    style: AppTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.white,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    'Bugün ne öğrenmek istiyorsun?',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.white.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  color: AppTheme.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Streak Counter
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentRed,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: AppTheme.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '7 Günlük Seri',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Harika gidiyorsun!',
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Tamamlanan', '12', 'Ders', Icons.school)),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(child: _buildStatCard('Öğrenilen', '89', 'Kelime', Icons.book)),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(child: _buildStatCard('Doğruluk', '87', '%', Icons.trending_up)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryBlue,
            size: 24,
          ),
          const SizedBox(height: AppTheme.spacing8),
          RichText(
            text: TextSpan(
              text: value,
              style: AppTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w700,
              ),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            label,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLearningModules() {
    final modules = [
      {
        'title': 'Resimli Kelime',
        'subtitle': 'Görsel öğrenme',
        'icon': Icons.image_outlined,
        'color': AppTheme.primaryBlue,
        'progress': 0.6,
        'route': AppRoutes.pictureWord,
      },
      {
        'title': 'Boşluk Doldurma',
        'subtitle': 'Cümle tamamlama',
        'icon': Icons.edit_outlined,
        'color': AppTheme.accentRed,
        'progress': 0.3,
        'route': AppRoutes.fillBlank,
      },
      {
        'title': 'Çoktan Seçmeli',
        'subtitle': 'Hızlı test',
        'icon': Icons.quiz_outlined,
        'color': AppTheme.primaryBlue,
        'progress': 0.8,
        'route': AppRoutes.multipleChoice,
      },
      {
        'title': 'Diyalog',
        'subtitle': 'Konuşma pratiği',
        'icon': Icons.chat_bubble_outline,
        'color': AppTheme.accentRed,
        'progress': 0.2,
        'route': AppRoutes.dialog,
      },
    ];

    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Öğrenme Modülleri',
                style: AppTheme.textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () => _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: Text(
                  'Tümünü Gör',
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: AppTheme.spacing12,
              mainAxisSpacing: AppTheme.spacing12,
            ),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return _buildModuleCard(module);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, module['route']);
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
          boxShadow: AppTheme.cardShadow,
          border: Border.all(
            color: (module['color'] as Color).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (module['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    module['icon'],
                    color: module['color'],
                    size: 24,
                  ),
                ),
                Text(
                  '${((module['progress'] as double) * 100).toInt()}%',
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: module['color'],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              module['title'],
              style: AppTheme.textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              module['subtitle'],
              style: AppTheme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacing12),
            LinearProgressIndicator(
              value: module['progress'],
              backgroundColor: AppTheme.borderGrey,
              valueColor: AlwaysStoppedAnimation(module['color']),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyChallenge() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Günlük Meydan Okuma',
            style: AppTheme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing20),
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.accentShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: AppTheme.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '20 Kelime Öğren',
                            style: AppTheme.textTheme.titleLarge?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '15/20 tamamlandı',
                            style: AppTheme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing16),
                LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: AppTheme.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation(AppTheme.white),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                const SizedBox(height: AppTheme.spacing16),
                CustomButton.outline(
                  text: 'Devam Et',
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.pictureWord),
                  size: ButtonSize.small,
                  icon: const Icon(Icons.play_arrow, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {
        'title': 'Resimli Kelime Modülü',
        'subtitle': '5 kelime öğrenildi',
        'time': '2 saat önce',
        'icon': Icons.image_outlined,
        'color': AppTheme.primaryBlue,
      },
      {
        'title': 'Çoktan Seçmeli Test',
        'subtitle': '8/10 doğru cevap',
        'time': '5 saat önce',
        'icon': Icons.quiz_outlined,
        'color': AppTheme.accentRed,
      },
    ];

    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Son Aktiviteler',
            style: AppTheme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacing16),
          ...activities.map((activity) => Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (activity['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title'] as String,
                        style: AppTheme.textTheme.titleMedium,
                      ),
                      Text(
                        activity['subtitle'] as String,
                        style: AppTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  activity['time'] as String,
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGrey,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildLessonsPage() {
    return const Center(
      child: Text('Dersler Sayfası'),
    );
  }

  Widget _buildProgressPage() {
    return const Center(
      child: Text('İlerleme Sayfası'),
    );
  }

  Widget _buildProfilePage() {
    return const Center(
      child: Text('Profil Sayfası'),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing20,
            vertical: AppTheme.spacing12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'Ana Sayfa', Icons.home, Icons.home_outlined),
              _buildNavItem(1, 'Dersler', Icons.school, Icons.school_outlined),
              _buildNavItem(2, 'İlerleme', Icons.analytics, Icons.analytics_outlined),
              _buildNavItem(3, 'Profil', Icons.person, Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData filledIcon, IconData outlinedIcon) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedIndex = index);
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGrey,
              size: 24,
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              label,
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}