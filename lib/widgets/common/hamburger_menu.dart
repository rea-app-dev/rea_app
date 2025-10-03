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
          SizedBox(height: 100,),
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