// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(child: _buildProfileStats()),
            SliverToBoxAdapter(child: _buildAchievements()),
            SliverToBoxAdapter(child: _buildProfileOptions()),
            SliverToBoxAdapter(child: _buildSettings()),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppTheme.radiusXLarge),
              bottomRight: Radius.circular(AppTheme.radiusXLarge),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppTheme.spacing40),

                // Profile Picture
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _editProfilePicture,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppTheme.accentRed,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppTheme.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacing20),

                // User Info
                Text(
                  'Kullanıcı Adı',
                  style: AppTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'user@example.com',
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),

                // Edit Profile Button
                CustomButton.outline(
                  text: 'Profili Düzenle',
                  onPressed: _editProfile,
                  size: ButtonSize.small,
                  icon: const Icon(Icons.edit, size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showSettings,
          icon: const Icon(
            Icons.settings,
            color: AppTheme.white,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('15', 'Tamamlanan\nDers', Icons.school)),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(child: _buildStatCard('127', 'Öğrenilen\nKelime', Icons.book)),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(child: _buildStatCard('89%', 'Doğruluk\nOranı', Icons.trending_up)),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(child: _buildStatCard('7', 'Günlük\nSeri', Icons.local_fire_department)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
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
          Text(
            value,
            style: AppTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w700,
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

  Widget _buildAchievements() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Başarılar',
                style: AppTheme.textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: _viewAllAchievements,
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
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: AppTheme.spacing12),
                  child: _buildAchievementCard(achievement),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isUnlocked = achievement['unlocked'] as bool;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: isUnlocked
              ? AppTheme.accentRed.withOpacity(0.3)
              : AppTheme.borderGrey,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppTheme.accentRed.withOpacity(0.1)
                  : AppTheme.lightGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement['icon'] as IconData,
              color: isUnlocked ? AppTheme.accentRed : AppTheme.mediumGrey,
              size: 24,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            achievement['title'] as String,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: isUnlocked ? AppTheme.darkGrey : AppTheme.mediumGrey,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profil',
            style: AppTheme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacing16),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.person_outline,
                  title: 'Kişisel Bilgiler',
                  subtitle: 'Ad, e-posta ve diğer bilgiler',
                  onTap: _editPersonalInfo,
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.security_outlined,
                  title: 'Gizlilik ve Güvenlik',
                  subtitle: 'Şifre ve gizlilik ayarları',
                  onTap: _showPrivacySettings,
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.notifications_outlined,
                  title: 'Bildirimler',
                  subtitle: 'Bildirim tercihlerinizi yönetin',
                  onTap: _showNotificationSettings,
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                    activeColor: AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ayarlar',
            style: AppTheme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacing16),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.language_outlined,
                  title: 'Dil',
                  subtitle: 'Türkçe',
                  onTap: _showLanguageSettings,
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.volume_up_outlined,
                  title: 'Ses Ayarları',
                  subtitle: 'Ses efektleri ve müzik',
                  onTap: _showSoundSettings,
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                    activeColor: AppTheme.primaryBlue,
                  ),
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.help_outline,
                  title: 'Yardım ve Destek',
                  subtitle: 'SSS ve iletişim',
                  onTap: _showHelp,
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.info_outline,
                  title: 'Hakkında',
                  subtitle: 'Uygulama bilgileri',
                  onTap: _showAbout,
                ),
                _buildDivider(),
                _buildProfileOption(
                  icon: Icons.logout,
                  title: 'Çıkış Yap',
                  subtitle: 'Hesaptan çıkış yap',
                  onTap: _logout,
                  titleColor: AppTheme.accentRed,
                  iconColor: AppTheme.accentRed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    Color? titleColor,
    Color? iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.primaryBlue).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppTheme.primaryBlue,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.textTheme.titleMedium?.copyWith(
          color: titleColor ?? AppTheme.darkGrey,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: AppTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.mediumGrey,
        ),
      )
          : null,
      trailing: trailing ??
          Icon(
            Icons.chevron_right,
            color: AppTheme.mediumGrey,
            size: 20,
          ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing20,
        vertical: AppTheme.spacing8,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.borderGrey,
      indent: AppTheme.spacing20,
      endIndent: AppTheme.spacing20,
    );
  }

  // Achievement data
  List<Map<String, dynamic>> get achievements => [
    {
      'title': 'İlk Adım',
      'icon': Icons.start,
      'unlocked': true,
    },
    {
      'title': 'Kelime Ustası',
      'icon': Icons.book,
      'unlocked': true,
    },
    {
      'title': 'Hızlı Öğren',
      'icon': Icons.speed,
      'unlocked': false,
    },
    {
      'title': 'Mükemmel',
      'icon': Icons.star,
      'unlocked': false,
    },
  ];

  // Action methods
  void _editProfilePicture() {
    HapticFeedback.lightImpact();
    // Show photo picker
  }

  void _editProfile() {
    HapticFeedback.lightImpact();
    // Navigate to edit profile
  }

  void _showSettings() {
    HapticFeedback.lightImpact();
    // Show settings menu
  }

  void _viewAllAchievements() {
    HapticFeedback.lightImpact();
    // Navigate to achievements page
  }

  void _editPersonalInfo() {
    HapticFeedback.lightImpact();
    // Navigate to personal info edit
  }

  void _showPrivacySettings() {
    HapticFeedback.lightImpact();
    // Show privacy settings
  }

  void _showNotificationSettings() {
    HapticFeedback.lightImpact();
    // Show notification settings
  }

  void _showLanguageSettings() {
    HapticFeedback.lightImpact();
    // Show language selector
  }

  void _showSoundSettings() {
    HapticFeedback.lightImpact();
    // Show sound settings
  }

  void _showHelp() {
    HapticFeedback.lightImpact();
    // Navigate to help page
  }

  void _showAbout() {
    HapticFeedback.lightImpact();
    // Show about dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        title: Text(
          'Dil Öğrenme Uygulaması',
          style: AppTheme.textTheme.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Versiyon: 1.0.0',
              style: AppTheme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Türkçe öğrenme sürecinizi eğlenceli hale getiren modern bir uygulama.',
              style: AppTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          CustomButton.primary(
            text: 'Tamam',
            onPressed: () => Navigator.pop(context),
            size: ButtonSize.small,
          ),
        ],
      ),
    );
  }

  void _logout() {
    HapticFeedback.lightImpact();
    // Show logout confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        title: Text(
          'Çıkış Yap',
          style: AppTheme.textTheme.headlineSmall,
        ),
        content: Text(
          'Hesaptan çıkış yapmak istediğinize emin misiniz?',
          style: AppTheme.textTheme.bodyMedium,
        ),
        actions: [
          CustomButton.outline(
            text: 'İptal',
            onPressed: () => Navigator.pop(context),
            size: ButtonSize.small,
          ),
          CustomButton.primary(
            text: 'Çıkış Yap',
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
            },
            size: ButtonSize.small,
          ),
        ],
      ),
    );
  }
}