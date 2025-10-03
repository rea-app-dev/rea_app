import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reaapp/widgets/common/custom_app_bar.dart';
import 'package:reaapp/widgets/common/hamburger_menu.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../data/models/user.dart';
import '../home/home_screen.dart';
import '../home/search_screen.dart';
import '../chat/conversations_screen.dart';
import '../notifications/notifications_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.currentUser == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = auth.currentUser!;
        final screens = _getScreensForUser(user);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          floatingActionButton: _buildFloatingBottomNav(user, l10n),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget _buildFloatingBottomNav(User user, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.home,
            activeIcon: Icons.home,
            label: l10n.home,
            index: 0,
          ),
          _buildNavItem(
            icon: user.userType == UserType.locataire
                ? LucideIcons.layoutGrid
                : Icons.business_outlined,
            activeIcon: user.userType == UserType.locataire
                ? LucideIcons.layoutGrid
                : Icons.business,
            label: user.userType == UserType.locataire ? l10n.dashboard : l10n.myProperties,
            index: 1,
          ),
          _buildCenterAddButton(user, l10n),
          _buildNavItem(
            icon: LucideIcons.messageCircleMore,
            activeIcon: LucideIcons.messageCircleMore,
            label: l10n.chat,
            index: 3,
          ),
          _buildNavItem(
            icon: Icons.notifications,
            activeIcon: Icons.notifications,
            label: l10n.notifications,
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.orange : AppColors.grey,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterAddButton(User user, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.orange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _currentIndex == 2 ? Icons.add_circle : Icons.add_circle_outline,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getScreensForUser(User user) {
    return [
      const HomeScreen(),
      user.userType == UserType.locataire
          ? const TenantDashboardScreen()
          : const OwnerDashboardScreen(),
      user.userType == UserType.proprietaire
          ? const AddPropertyScreen()
          : const BecomeOwnerScreen(),
      const ConversationsScreen(),
      const NotificationsScreen(),
    ];
  }
}

// Écran Dashboard pour les Locataires
class TenantDashboardScreen extends StatelessWidget {
  const TenantDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const HamburgerMenu(),
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Section avec 4 cartes
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildDashboardCard(
                  l10n.searchHistory,
                  l10n.tenantSearchHistoryDesc,
                  Icons.history,
                  AppColors.blue,
                  context,
                ),
                _buildDashboardCard(
                  l10n.statistics,
                  l10n.tenantStatsDesc,
                  Icons.analytics,
                  AppColors.green,
                  context,
                ),
                _buildDashboardCard(
                  l10n.communications,
                  l10n.communicationsDesc,
                  Icons.message,
                  AppColors.orange,
                  context,
                ),
                _buildDashboardCard(
                  l10n.becomeOwner,
                  l10n.becomeOwnerDesc,
                  Icons.upgrade,
                  AppColors.blue,
                  context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.orange : AppColors.grey.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? AppColors.white : AppColors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String description, IconData icon, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title - Bientôt disponible'),
            backgroundColor: AppColors.blue,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Écran Dashboard pour les Propriétaires
class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const HamburgerMenu(),
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Barre de recherche
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Yaoundé...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Filtres
            Row(
              children: [
                Expanded(child: _buildFilterButton(l10n.residential, true)),
                const SizedBox(width: 8),
                Expanded(child: _buildFilterButton(l10n.commercial, false)),
                const SizedBox(width: 8),
                Expanded(child: _buildFilterButton(l10n.land, false)),
                const SizedBox(width: 8),
                Expanded(child: _buildFilterButton(l10n.special, false)),
              ],
            ),

            const SizedBox(height: 24),

            // Section avec 2 grandes cartes puis 2 en bas
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildOwnerCard(
                        l10n.myAnnouncements,
                        l10n.ownerAnnouncementsDesc,
                        Icons.home_work,
                        AppColors.blue,
                        context,
                        isLarge: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOwnerCard(
                        l10n.statistics,
                        l10n.ownerStatsDesc,
                        Icons.trending_up,
                        AppColors.green,
                        context,
                        isLarge: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildOwnerCard(
                        l10n.communications,
                        l10n.communicationsDesc,
                        Icons.message,
                        AppColors.orange,
                        context,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOwnerCard(
                        l10n.add,
                        l10n.addPropertyDesc,
                        Icons.add_circle,
                        AppColors.blue,
                        context,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.orange : AppColors.grey.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? AppColors.white : AppColors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildOwnerCard(String title, String description, IconData icon, Color color, BuildContext context, {bool isLarge = false}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title - Bientôt disponible'),
            backgroundColor: AppColors.blue,
          ),
        );
      },
      child: Container(
        height: isLarge ? 150 : 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.grey.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isLarge ? 32 : 24, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isLarge ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.grey,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Écran temporaire pour les propriétaires (ajout de bien)
class AddPropertyScreen extends StatelessWidget {
  const AddPropertyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const HamburgerMenu(),
      appBar: const CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_home, size: 64, color: AppColors.orange),
            const SizedBox(height: 16),
            Text(
              l10n.addNewAnnouncement,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.comingSoon,
              style: const TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Écran temporaire pour les locataires (devenir propriétaire)
class BecomeOwnerScreen extends StatelessWidget {
  const BecomeOwnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const HamburgerMenu(),
      appBar: const CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upgrade, size: 64, color: AppColors.orange),
            const SizedBox(height: 16),
            Text(
              l10n.becomeOwner,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.comingSoon,
              style: const TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}