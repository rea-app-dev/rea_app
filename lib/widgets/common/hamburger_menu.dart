import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../screens/home/home_screen.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header du menu avec logo REA
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.orange, AppColors.blue],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'REA',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.orange,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'PROPERTY MANAGEMENT',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.home_outlined,
                  title: 'Accueil',
                  onTap: () {
                    Navigator.pop(context); // Fermer le drawer
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.trending_up,
                  title: 'Rendements',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context, 'Rendements');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.star_outline,
                  title: 'Fonctionnalités avancées',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context, 'Fonctionnalités avancées');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.support_agent,
                  title: 'Services',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context, 'Services');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.category_outlined,
                  title: 'Catégories',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context, 'Catégories');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.payment,
                  title: 'Moyens de paiement acceptés',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context, 'Moyens de paiement');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'À propos',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context, 'À propos');
                  },
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.lightGrey, width: 1),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.phone, color: AppColors.grey, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '+237 6XX XXX XXX',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email, color: AppColors.grey, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'support@rea-app.com',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: AppColors.lightGrey,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
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
            const Text('Bientôt disponible'),
          ],
        ),
        content: Text(
          'La section "$feature" sera disponible dans une prochaine version.',
          style: TextStyle(color: AppColors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}