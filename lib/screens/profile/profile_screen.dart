// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reaapp/screens/auth/kyc_verification_screen.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.white,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final user = auth.currentUser!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Photo de profil
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.lightGrey,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.grey,
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightGrey,
                    foregroundColor: AppColors.blue,
                  ),
                  child: const Text('MODIFIER LA PHOTO DE PROFIL'),
                ),

                const SizedBox(height: 24),

                // Type de compte
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text('TYPE DE COMPTE'),
                      Spacer(),
                      Icon(Icons.verified, color: AppColors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(user.userType.name.toUpperCase()),
                    ],
                  ),
                ),

                // Dans votre profile_screen.dart, ajoutez :
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.verified_user),
                    title: Text('Vérification KYC'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KYCVerificationScreen(),
                        ),
                      );
                    },
                  ),
                ),


                const SizedBox(height: 16),

                // Champs du profil
                _buildProfileField('IDENTITÉ', '${user.firstName} ${user.lastName}'),
                _buildProfileField('NOMS', user.lastName),
                _buildProfileField('PRÉNOMS', user.firstName),
                _buildProfileField('EMAIL', user.email, canChange: true),
                _buildProfileField('TÉLÉPHONE', user.phone, canChange: true),

                const SizedBox(height: 16),

                _buildProfileField('MOT DE PASSE', '••••••••', canChange: true),
                _buildProfileField('LOCALISATION', user.location),
                _buildProfileField('MES FAVORIS', '12 biens'),

                const SizedBox(height: 32),

                // Bouton déconnexion
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      auth.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    child: const Text('DÉCONNEXION'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileField(String label, String value, {bool canChange = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.blue,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: AppColors.grey),
            ),
          ),
          if (canChange)
            TextButton(
              onPressed: () {},
              child: const Text(
                'Changer',
                style: TextStyle(
                  color: AppColors.orange,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}