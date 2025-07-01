// screens/lessons_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({Key? key}) : super(key: key);

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String _selectedCategory = 'Tümü';
  String _searchQuery = '';
  bool _isSearching = false;

  final List<String> categories = [
    'Tümü',
    'Başlangıç',
    'Orta',
    'İleri',
    'Konuşma',
    'Dinleme',
    'Okuma',
    'Yazma',
  ];

  final List<Map<String, dynamic>> lessons = [
    {
      'title': 'Resimli Kelime Öğrenme',
      'subtitle': 'Görsel öğrenme',
      'description': 'Resimlerle kelime öğrenin',
      'color': AppTheme.primaryBlue,
      'icon': Icons.image_outlined,
      'route': AppRoutes.pictureWord,
      'progress': 0.6,
      'isLocked': false,
      'isCompleted': false,
      'timeEstimate': '15 dk',
      'difficulty': 'Başlangıç',
      'category': 'Başlangıç',
      'tags': ['kelime', 'görsel'],
      'badge': 'Popüler',
      'isFeatured': true,
    },
    {
      'title': 'Boşluk Doldurma',
      'subtitle': 'Cümle tamamlama',
      'description': 'Boşlukları doğru kelimelerle doldurun',
      'color': AppTheme.accentRed,
      'icon': Icons.edit_outlined,
      'route': AppRoutes.fillBlank,
      'progress': 0.3,
      'isLocked': false,
      'isCompleted': false,
      'timeEstimate': '20 dk',
      'difficulty': 'Orta',
      'category': 'Yazma',
      'tags': ['dilbilgisi', 'yazma'],
      'badge': null,
      'isFeatured': false,
    },
    {
      'title': 'Çoktan Seçmeli Test',
      'subtitle': 'Hızlı değerlendirme',
      'description': 'Bilginizi test edin',
      'color': AppTheme.primaryBlue,
      'icon': Icons.quiz_outlined,
      'route': AppRoutes.multipleChoice,
      'progress': 0.8,
      'isLocked': false,
      'isCompleted': true,
      'timeEstimate': '10 dk',
      'difficulty': 'Başlangıç',
      'category': 'Başlangıç',
      'tags': ['test', 'değerlendirme'],
      'badge': 'Tamamlandı',
      'isFeatured': false,
    },
    {
      'title': 'Dilbilgisi Dersi',
      'subtitle': 'Temel kurallar',
      'description': 'Türkçe dilbilgisi kurallarını öğrenin',
      'color': AppTheme.accentRed,
      'icon': Icons.school_outlined,
      'route': AppRoutes.grammar,
      'progress': 0.1,
      'isLocked': false,
      'isCompleted': false,
      'timeEstimate': '30 dk',
      'difficulty': 'Orta',
      'category': 'Okuma',
      'tags': ['dilbilgisi', 'kural'],
      'badge': 'Yeni',
      'isFeatured': false,
    },
    {
      'title': 'Sesli Okuma',
      'subtitle': 'Telaffuz geliştirme',
      'description': 'Sesli okuyarak telaffuzunuzu geliştirin',
      'color': AppTheme.primaryBlue,
      'icon': Icons.record_voice_over_outlined,
      'route': AppRoutes.voiceRecognition,
      'progress': 0.0,
      'isLocked': true,
      'isCompleted': false,
      'timeEstimate': '25 dk',
      'difficulty': 'İleri',
      'category': 'Konuşma',
      'tags': ['telaffuz', 'konuşma'],
      'badge': null,
      'isFeatured': false,
    },
    {
      'title': 'Kart Eşleştirme',
      'subtitle': 'Eğlenceli oyun',
      'description': 'Kartları eşleştirerek öğrenin',
      'color': AppTheme.accentRed,
      'icon': Icons.style_outlined,
      'route': AppRoutes.cardGame,
      'progress': 0.0,
      'isLocked': false,
      'isCompleted': false,
      'timeEstimate': '15 dk',
      'difficulty': 'Başlangıç',
      'category': 'Başlangıç',
      'tags': ['oyun', 'eşleştirme'],
      'badge': 'Eğlenceli',
      'isFeatured': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _scrollController = ScrollController();
    _fadeController = AnimationController(
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

    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildSliverAppBar(innerBoxIsScrolled),
              _buildSliverSearchBar(),
              _buildSliverCategories(),
            ],
            body: _buildLessonsList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: AnimatedOpacity(
          opacity: innerBoxIsScrolled ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            'Dersler',
            style: AppTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.darkGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppTheme.radiusXLarge),
              bottomRight: Radius.circular(AppTheme.radiusXLarge),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacing20,
              AppTheme.spacing20,
              AppTheme.spacing20,
              AppTheme.spacing32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dersler',
                  style: AppTheme.textTheme.displayMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Öğrenme yolculuğuna devam et',
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _searchQuery = '';
            });
          },
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: innerBoxIsScrolled ? AppTheme.darkGrey : AppTheme.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSliverSearchBar() {
    if (!_isSearching) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(AppTheme.spacing20),
        child: TextField(
          autofocus: true,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Ders ara...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: AppTheme.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing20,
              vertical: AppTheme.spacing16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverCategories() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = _selectedCategory == category;

            return GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = category);
                HapticFeedback.lightImpact();
              },
              child: Container(
                margin: const EdgeInsets.only(right: AppTheme.spacing12),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing20,
                  vertical: AppTheme.spacing12,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.primaryGradient : null,
                  color: isSelected ? null : AppTheme.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
                  boxShadow: isSelected ? AppTheme.primaryShadow : AppTheme.cardShadow,
                  border: Border.all(
                    color: isSelected ? Colors.transparent : AppTheme.borderGrey,
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      color: isSelected ? AppTheme.white : AppTheme.darkGrey,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLessonsList() {
    final filteredLessons = _getFilteredLessons();

    return CustomScrollView(
      slivers: [
        // Featured Lesson
        if (_selectedCategory == 'Tümü' && _searchQuery.isEmpty)
          SliverToBoxAdapter(
            child: _buildFeaturedSection(),
          ),

        // Continue Learning Section
        SliverToBoxAdapter(
          child: _buildContinueSection(),
        ),

        // Lessons Grid
        SliverPadding(
          padding: const EdgeInsets.all(AppTheme.spacing20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: AppTheme.spacing16,
              mainAxisSpacing: AppTheme.spacing16,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildLessonCard(filteredLessons[index]),
              childCount: filteredLessons.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildFeaturedSection() {
    final featuredLesson = lessons.firstWhere(
          (lesson) => lesson['isFeatured'] == true,
      orElse: () => lessons.first,
    );

    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Öne Çıkan Ders',
            style: AppTheme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacing16),
          _buildFeaturedCard(featuredLesson),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> lesson) {
    return GestureDetector(
      onTap: () => _navigateToLesson(lesson['route']),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing24),
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
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    lesson['icon'],
                    color: AppTheme.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson['title'],
                        style: AppTheme.textTheme.headlineSmall?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        lesson['description'],
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing12,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    lesson['timeEstimate'],
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                CustomButton.outline(
                  text: 'Başla',
                  onPressed: () => _navigateToLesson(lesson['route']),
                  size: ButtonSize.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueSection() {
    final continueLessons = lessons.where((lesson) =>
    lesson['progress'] > 0.0 && lesson['progress'] < 1.0
    ).take(3).toList();

    if (continueLessons.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Devam Et',
                style: AppTheme.textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {},
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
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: continueLessons.length,
              itemBuilder: (context, index) {
                final lesson = continueLessons[index];
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: AppTheme.spacing12),
                  child: _buildContinueCard(lesson),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueCard(Map<String, dynamic> lesson) {
    return GestureDetector(
      onTap: () => _navigateToLesson(lesson['route']),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
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
                Icon(
                  lesson['icon'],
                  color: lesson['color'],
                  size: 24,
                ),
                const Spacer(),
                Text(
                  '${(lesson['progress'] * 100).toInt()}%',
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: lesson['color'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              lesson['title'],
              style: AppTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              lesson['timeEstimate'],
              style: AppTheme.textTheme.bodySmall,
            ),
            const Spacer(),
            LinearProgressIndicator(
              value: lesson['progress'],
              backgroundColor: AppTheme.borderGrey,
              valueColor: AlwaysStoppedAnimation(lesson['color']),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(Map<String, dynamic> lesson) {
    return GestureDetector(
      onTap: lesson['isLocked'] ? null : () => _navigateToLesson(lesson['route']),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        decoration: BoxDecoration(
          color: lesson['isLocked'] ? AppTheme.lightGrey : AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: lesson['isLocked'] ? null : AppTheme.cardShadow,
          border: Border.all(
            color: lesson['isLocked']
                ? AppTheme.borderGrey
                : (lesson['color'] as Color).withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: lesson['isLocked']
                        ? AppTheme.mediumGrey.withOpacity(0.1)
                        : (lesson['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    lesson['isLocked'] ? Icons.lock : lesson['icon'],
                    color: lesson['isLocked'] ? AppTheme.mediumGrey : lesson['color'],
                    size: 24,
                  ),
                ),
                const Spacer(),
                if (lesson['badge'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: lesson['isCompleted']
                          ? AppTheme.success.withOpacity(0.1)
                          : AppTheme.accentRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Text(
                      lesson['badge'],
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: lesson['isCompleted'] ? AppTheme.success : AppTheme.accentRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              lesson['title'],
              style: AppTheme.textTheme.titleLarge?.copyWith(
                color: lesson['isLocked'] ? AppTheme.mediumGrey : AppTheme.darkGrey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              lesson['subtitle'],
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: lesson['isLocked'] ? AppTheme.mediumGrey : AppTheme.mediumGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacing12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: lesson['isLocked'] ? AppTheme.mediumGrey : AppTheme.mediumGrey,
                ),
                const SizedBox(width: AppTheme.spacing4),
                Text(
                  lesson['timeEstimate'],
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: lesson['isLocked'] ? AppTheme.mediumGrey : AppTheme.mediumGrey,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: lesson['isLocked']
                        ? AppTheme.mediumGrey.withOpacity(0.1)
                        : (lesson['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    lesson['difficulty'],
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: lesson['isLocked'] ? AppTheme.mediumGrey : lesson['color'] as Color,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredLessons() {
    return lessons.where((lesson) {
      final matchesCategory = _selectedCategory == 'Tümü' ||
          lesson['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          lesson['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lesson['description'].toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _navigateToLesson(String route) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, route);
  }
}