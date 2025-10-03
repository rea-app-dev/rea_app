import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/local_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.profile),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: isDark ? AppColors.white : AppColors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: isDark ? AppColors.white : AppColors.blue),
            onPressed: () => _showSettingsDialog(context, l10n),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final user = auth.currentUser!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Section photo de profil
                _buildProfilePictureSection(context, l10n, user.firstName),

                const SizedBox(height: 24),

                // Section informations principales
                _buildMainInfoSection(context, l10n, user, isDark),

                const SizedBox(height: 32),

                // Section actions
                _buildActionsSection(context, l10n, auth, isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePictureSection(BuildContext context, AppLocalizations l10n, String firstName) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.lightGrey,
              child: Text(
                firstName.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _handleProfilePictureChange(context, l10n),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightGrey,
            foregroundColor: AppColors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(l10n.modifyProfilePicture),
        ),
      ],
    );
  }

  Widget _buildMainInfoSection(BuildContext context, AppLocalizations l10n, user, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.personalInfo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.blue,
            ),
          ),
          const SizedBox(height: 20),

          // Type de compte avec badge vérifié
          _buildInfoRow(
            context,
            l10n.accountType,
            user.firstName.toUpperCase(),
            trailing: user.isKycVerified
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, color: AppColors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  l10n.verified,
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
                : TextButton(
              onPressed: () => AppRoutes.pushNamed(context, AppRoutes.kycVerification),
              child: Text(
                l10n.verify,
                style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const Divider(height: 24),

          _buildInfoRow(context, l10n.names, user.lastName, canEdit: true),
          _buildInfoRow(context, l10n.firstNames, user.firstName, canEdit: true),
          _buildInfoRow(context, l10n.email, user.email, canEdit: true),
          _buildInfoRow(context, l10n.telephone, user.phone, canEdit: true),
          _buildInfoRow(context, l10n.location, user.location, canEdit: true),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, AppLocalizations l10n, user, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statistics,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.blue,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  l10n.myFavorites,
                  "12",
                  Icons.favorite,
                  AppColors.error,
                  context,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  user.firstName == 'proprietaire' ? l10n.myAnnouncements : l10n.searchHistory,
                  user.firstName == 'proprietaire' ? "5" : "23",
                  user.firstName == 'proprietaire' ? Icons.home_work : Icons.history,
                  AppColors.blue,
                  context,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  l10n.communications,
                  "8",
                  Icons.message,
                  AppColors.orange,
                  context,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  l10n.trustScore,
                  "4.8",
                  Icons.star,
                  AppColors.green,
                  context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, AppLocalizations l10n, AuthProvider auth, bool isDark) {
    return Column(
      children: [
        // Bouton Aide
        _buildActionButton(
          icon: Icons.help_outline,
          title: l10n.help,
          subtitle: l10n.helpDescription,
          onTap: () => _showComingSoonDialog(context, l10n, l10n.help),
          color: AppColors.blue,
            context: context
        ),

        const SizedBox(height: 16),

        // Bouton À propos
        _buildActionButton(
          icon: Icons.info_outline,
          title: l10n.about,
          subtitle: l10n.aboutDescription,
          onTap: () => _showAboutDialog(context, l10n),
          color: AppColors.grey,
          context: context
        ),

        const SizedBox(height: 32),

        // Bouton déconnexion
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showLogoutDialog(context, l10n, auth),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.exit_to_app, color: AppColors.white),
            label: Text(
              l10n.logout,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {bool canEdit = false, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white
                    : Colors.black87,
              ),
            ),
          ),
          if (trailing != null)
            trailing
          else if (canEdit)
            TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.change,
                style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, BuildContext context,) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.grey, fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Event handlers
  void _handleProfilePictureChange(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.modifyProfilePicture,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.orange),
              title: Text(l10n.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, l10n, l10n.takePhoto);
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.blue),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, l10n, l10n.chooseFromGallery);
              },
            ),

            if (Navigator.canPop(context))
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: Text(l10n.removePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoonDialog(context, l10n, l10n.removePhoto);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.settings, color: AppColors.orange),
            const SizedBox(width: 8),
            Text(l10n.settings),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Changement de thème
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return SwitchListTile(
                  title: Text(l10n.darkMode),
                  subtitle: Text(
                    themeProvider.isDarkMode ? l10n.dark : l10n.light,
                    style: TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.themeChanged(value ? l10n.dark : l10n.light),
                        ),
                        backgroundColor: AppColors.blue,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  activeColor: AppColors.orange,
                );
              },
            ),

            const Divider(),

            // Changement de langue
            Consumer<LocaleProvider>(
              builder: (context, localeProvider, _) {
                return ListTile(
                  title: Text(l10n.language),
                  subtitle: Text(
                    localeProvider.isFrench ? l10n.french : l10n.english,
                    style: TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                  trailing: Switch(
                    value: localeProvider.isFrench,
                    onChanged: (value) {
                      localeProvider.toggleLocale();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.languageChanged(
                                value ? 'Français' : 'English'
                            ),
                          ),
                          backgroundColor: AppColors.green,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    activeColor: AppColors.orange,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.exit_to_app, color: AppColors.error),
            const SizedBox(width: 8),
            Text(l10n.logout),
          ],
        ),
        content: Text(l10n.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              auth.logout();
              AppRoutes.goToAuth(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(
              l10n.logout,
              style: const TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'REA',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(l10n.about),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.appTitle),
            const SizedBox(height: 8),
            Text(
              l10n.appDescription,
              style: TextStyle(color: AppColors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('${l10n.version}: ', style: const TextStyle(fontWeight: FontWeight.w500)),
                const Text('1.0.0'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, AppLocalizations l10n, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.construction, color: AppColors.orange),
            const SizedBox(width: 8),
            Text(l10n.comingSoon),
          ],
        ),
        content: Text(
          l10n.comingSoonMessage(feature),
          style: TextStyle(color: AppColors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}