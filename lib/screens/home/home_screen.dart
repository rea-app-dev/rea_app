import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reaapp/widgets/common/custom_app_bar.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../data/models/user.dart';
import '../../data/models/property.dart';
import '../../widgets/common/hamburger_menu.dart';
import '../profile/profile_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  PropertyType? _selectedPropertyType;
  String _selectedFilter = 'residential';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _performSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(
          searchQuery: _searchController.text,
          country: _countryController.text,
          city: _cityController.text,
          district: _districtController.text,
          propertyType: _selectedPropertyType,
          budget: _budgetController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.currentUser!;

        return Scaffold(
          drawer: const HamburgerMenu(),
          appBar: const CustomAppBar(),
          body: Stack(
            children: [
              // Image de fond
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80'
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),

              // Contenu principal
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Badge plateforme
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'CM Plateforme #1 au Cameroun',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Titre principal
                    const Text(
                      'Trouvez Votre',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Logement Idéal',
                      style: TextStyle(
                        color: AppColors.orange,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Section blanche avec categories et pub
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre des catégories
                          const Text(
                            'Catégories populaires',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Filtres par catégorie
                          Row(
                            children: [
                              Expanded(
                                child: _buildFilterButton(
                                  l10n.residential,
                                  'residential',
                                  _selectedFilter == 'residential',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildFilterButton(
                                  l10n.commercial,
                                  'commercial',
                                  _selectedFilter == 'commercial',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildFilterButton(
                                  l10n.land,
                                  'terrain',
                                  _selectedFilter == 'terrain',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildFilterButton(
                                  l10n.special,
                                  'special',
                                  _selectedFilter == 'special',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Espace publicitaire
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: NetworkImage(
                                    'https://images.unsplash.com/photo-1582407947304-fd86f028f716?ixlib=rb-4.0.3&auto=format&fit=crop&w=2096&q=80'
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.orange,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Text(
                                      'Nouveauté',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Découvrez nos nouvelles\nfonctionnalités premium',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Points de pagination
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(3, (index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: index == 0 ? AppColors.orange : Colors.white.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Carte de recherche
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Localisation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          _buildSearchField(
                            controller: _cityController,
                            hint: 'Douala, Yaoundé...',
                            icon: Icons.location_on,
                          ),

                          const SizedBox(height: 7),

                          const Text(
                            'Type de bien',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          _buildPropertyTypeDropdown(),

                          const SizedBox(height: 7),

                          const Text(
                            'Budget (FCFA)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          _buildSearchField(
                            controller: _budgetController,
                            hint: 'Prix max...',
                            icon: Icons.monetization_on,
                          ),

                          const SizedBox(height: 15),

                          // Bouton rechercher
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: _performSearch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              icon: const Icon(Icons.search, color: Colors.white),
                              label: const Text(
                                'Rechercher',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(500),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(50),
      ),
      child: DropdownButtonFormField<PropertyType>(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          prefixIcon: Icon(Icons.home, color: Colors.grey[600], size: 20),
          hintText: 'Appartement',
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        items: PropertyType.values.map((type) {
          return DropdownMenuItem<PropertyType>(
            value: type,
            child: Text(_getPropertyTypeName(type)),
          );
        }).toList(),
        onChanged: (value) => setState(() => _selectedPropertyType = value),
      ),
    );
  }

  Widget _buildFilterButton(String label, String value, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? AppColors.orange : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  String _getPropertyTypeName(PropertyType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case PropertyType.appartement:
        return l10n.apartment;
      case PropertyType.maison:
        return l10n.house;
      case PropertyType.studio:
        return l10n.studio;
      case PropertyType.chambre:
        return l10n.room;
    }
  }
}