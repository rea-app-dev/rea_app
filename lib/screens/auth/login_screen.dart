import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../data/models/user.dart';
import '../../providers/auth_provider.dart';
import '../navigation/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  UserType _selectedUserType = UserType.locataire;
  bool _stayConnected = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;

    if (_phoneController.text.isEmpty || _codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillAllFields),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    await authProvider.login(
      _phoneController.text,
      _codeController.text,
      _selectedUserType,
    );

    // Navigation manuelle après connexion réussie
    if (authProvider.isAuthenticated && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.blue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
            builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - // hauteur écran
                      Scaffold.of(context).appBarMaxHeight!,       // - hauteur appBar
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.loginTitle,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.blue,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Champ numéro
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          labelText: l10n.phoneNumber,
                          hintText: l10n.phoneNumberHint,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Champ code
                      TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          labelText: l10n.code,
                          hintText: l10n.codeHint,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sélection du type d'utilisateur
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedUserType = UserType.proprietaire),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _selectedUserType == UserType.proprietaire
                                      ? AppColors.orange
                                      : null,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: _selectedUserType == UserType.proprietaire
                                        ? AppColors.orange
                                        : AppColors.grey,
                                  ),
                                ),
                                child: Text(
                                  l10n.owner,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _selectedUserType == UserType.proprietaire
                                        ? AppColors.white
                                        : null,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedUserType = UserType.locataire),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _selectedUserType == UserType.locataire
                                      ? AppColors.orange
                                      : null,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: _selectedUserType == UserType.locataire
                                        ? AppColors.orange
                                        : AppColors.grey,
                                  ),
                                ),
                                child: Text(
                                  l10n.tenant,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _selectedUserType == UserType.locataire
                                        ? AppColors.white
                                        : null,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Checkbox "Rester connecté(e)"
                      Row(
                        children: [
                          Checkbox(
                            value: _stayConnected,
                            onChanged: (value) => setState(() => _stayConnected = value!),
                            activeColor: AppColors.orange,
                          ),
                          Text(
                            l10n.stayConnected,
                            style: const TextStyle(color: AppColors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Bouton Connexion
                      SizedBox(
                        width: double.infinity,
                        child: Consumer<AuthProvider>(
                          builder: (context, auth, _) {
                            return ElevatedButton(
                              onPressed: auth.isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              child: auth.isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(AppColors.white),
                                ),
                              )
                                  : Text(l10n.login),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Séparateur "OU"
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.grey)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              l10n.or,
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: AppColors.grey)),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Lien "mot de passe oublié?"
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implémenter récupération mot de passe
                          },
                          child: Text(
                            l10n.forgotPassword,
                            style: const TextStyle(
                              color: AppColors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      // Boutons de connexion sociale
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.googleConnectionSoon),
                                    backgroundColor: AppColors.blue,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.g_mobiledata, size: 24),
                              label: Text(
                                l10n.continueWithGoogle,
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.appleConnectionSoon),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.apple, size: 20),
                              label: Text(
                                l10n.continueWithApple,
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}