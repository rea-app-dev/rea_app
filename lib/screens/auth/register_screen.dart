import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../data/models/user.dart';
import '../../providers/auth_provider.dart';
import '../navigation/main_navigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController();
  final _identityController = TextEditingController();
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  String _selectedIdentity = 'Mr';
  UserType _selectedUserType = UserType.locataire;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _countryController.dispose();
    _identityController.dispose();
    _nameController.dispose();
    _firstNameController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate() || !_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs et accepter les conditions'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    await authProvider.register({
      'email': '${_nameController.text.toLowerCase()}@example.com',
      'phone': _phoneController.text,
      'firstName': _firstNameController.text,
      'lastName': _nameController.text,
      'userType': _selectedUserType.name,
      'location': _countryController.text,
      'isKycVerified': false,
    });

    // Navigation manuelle après inscription réussie
    if (authProvider.isAuthenticated && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'REA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenue',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sélection pays
                  TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'Pays',
                      hintText: 'Sélectionnez votre pays',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Champ requis' : null,
                  ),

                  const SizedBox(height: 16),

                  // Sélection identité
                  DropdownButtonFormField<String>(
                    value: _selectedIdentity,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'Identité',
                    ),
                    items: ['Mr', 'Mme', 'Mlle'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedIdentity = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'NOM',
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Champ requis' : null,
                  ),

                  const SizedBox(height: 16),

                  // Prénom
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'PRENOM',
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Champ requis' : null,
                  ),

                  const SizedBox(height: 16),

                  // Numéro de téléphone
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'NUMERO OM/MOMO',
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Champ requis' : null,
                  ),

                  const SizedBox(height: 16),

                  // Code de vérification
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'CODE',
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Champ requis' : null,
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
                              'Propriétaire',
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
                              'Locataire',
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

                  // Checkbox acceptation des conditions
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) => setState(() => _acceptTerms = value!),
                        activeColor: AppColors.orange,
                      ),
                      const Expanded(
                        child: Text(
                          'J\'accepte le traitement de données personnelles',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Bouton Inscription
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        return ElevatedButton(
                          onPressed: auth.isLoading ? null : _handleRegister,
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
                              : const Text('INSCRIPTION'),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Séparateur "OU"
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.grey)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OU',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.grey)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Boutons de connexion sociale
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implémenter inscription Google
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Inscription Google bientôt disponible'),
                                backgroundColor: AppColors.blue,
                              ),
                            );
                          },
                          icon: Icon(Icons.g_mobiledata, size: 24),
                          label: const Text(
                            'Google',
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
                            // TODO: Implémenter inscription Apple
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Inscription Apple bientôt disponible'),
                              ),
                            );
                          },
                          icon: Icon(Icons.apple, size: 20),
                          label: const Text(
                            'Apple',
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

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}