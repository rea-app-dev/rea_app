import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../data/models/user.dart';
import '../../data/models/property.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/hamburger_menu.dart';

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

  // FocusNodes
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _districtFocusNode = FocusNode();
  final FocusNode _budgetFocusNode = FocusNode();

  // États de focus
  bool _isSearchFocused = false;
  bool _isCountryFocused = false;
  bool _isCityFocused = false;
  bool _isDistrictFocused = false;
  bool _isBudgetFocused = false;
  bool _isPropertyTypeFocused = false;

  PropertyType? _selectedPropertyType;
  String _selectedFilter = 'residential';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        context.read<PropertyProvider>().loadProperties(city: user.location);
      }
    });

    // Ajoute ce listener pour détecter le focus
    // Listeners pour les focus
    _searchFocusNode.addListener(() {
      setState(() => _isSearchFocused = _searchFocusNode.hasFocus);
    });
    _countryFocusNode.addListener(() {
      setState(() => _isCountryFocused = _countryFocusNode.hasFocus);
    });
    _cityFocusNode.addListener(() {
      setState(() => _isCityFocused = _cityFocusNode.hasFocus);
    });
    _districtFocusNode.addListener(() {
      setState(() => _isDistrictFocused = _districtFocusNode.hasFocus);
    });
    _budgetFocusNode.addListener(() {
      setState(() => _isBudgetFocused = _budgetFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _budgetController.dispose();
    // Dispose des FocusNodes
    _searchFocusNode.dispose();
    _countryFocusNode.dispose();
    _cityFocusNode.dispose();
    _districtFocusNode.dispose();
    _budgetFocusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    AppRoutes.goToSearch(
      context,
      searchQuery: _searchController.text,
      city: _cityController.text,
      propertyType: _selectedPropertyType,
      budget: _budgetController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.currentUser!;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: const HamburgerMenu(),
          appBar: const CustomAppBar(),
          body: Stack(
            children: [
              // Image de fond avec overlay
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
                  children: [
                    const SizedBox(height: 10),

                    // Barre de recherche en haut avec icône menu et favoris
                    _buildTopSearchBar(l10n, isDark, user),

                    const SizedBox(height: 6),

                    // Filtres horizontaux (boutons ronds)
                    _buildCategoryFilters(l10n),

                    const SizedBox(height: 16),

                    // Espace publicitaire avec paysage
                    _buildAdvertisingSpace(l10n),

                    const SizedBox(height: 0),

                    // Carte de recherche détaillée
                    _buildDetailedSearchCard(l10n, isDark),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopSearchBar(AppLocalizations l10n, bool isDark, User user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône menu (hamburger)
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu,
                color: AppColors.blue,
                size: 23,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Champ de texte
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: user.location,
                hintStyle: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black45,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkGrey : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: AppColors.orange,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white70 : Colors.black54,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                    _searchFocusNode.unfocus();
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                setState(() {}); // Pour afficher/cacher l'icône de suppression
              },
            ),
          ),

          const SizedBox(width: 10),

          // Icône favoris
          GestureDetector(
            onTap: () {
              // TODO: Navigate to favorites
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                color: AppColors.orange,
                size: 23,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(l10n.residential, 'residential'),
          const SizedBox(width: 8),
          _buildFilterChip(l10n.commercial, 'commercial'),
          const SizedBox(width: 8),
          _buildFilterChip(l10n.land, 'terrain'),
          const SizedBox(width: 8),
          _buildFilterChip(l10n.special, 'special'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange : AppColors.blue,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildAdvertisingSpace(AppLocalizations l10n) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1582407947304-fd86f028f716?ixlib=rb-4.0.3&auto=format&fit=crop&w=2096&q=80'
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
              child: Text(
                l10n.newFeature,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.discoverPremiumFeatures,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            // Points de pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
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
    );
  }

  Widget _buildDetailedSearchCard(AppLocalizations l10n, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGrey : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pays
          _buildSearchFieldWithIcon(
            controller: _countryController,
            icon: Icons.location_on,
            label: l10n.country,
            isDark: isDark,
            focusNode: _countryFocusNode,
            isFocused: _isCountryFocused,
          ),

          const SizedBox(height: 10),

// Ville
          _buildSearchFieldWithIcon(
            controller: _cityController,
            icon: Icons.location_on,
            label: l10n.city,
            isDark: isDark,
            focusNode: _cityFocusNode,
            isFocused: _isCityFocused,
          ),

          const SizedBox(height: 10),

// Quartier
          _buildSearchFieldWithIcon(
            controller: _districtController,
            icon: Icons.location_on,
            label: l10n.district,
            isDark: isDark,
            focusNode: _districtFocusNode,
            isFocused: _isDistrictFocused,
          ),

          const SizedBox(height: 10),

          // Type de bien
          _buildPropertyTypeField(l10n, isDark),

          const SizedBox(height: 10),

          // Budget avec fond orange
          TextField(
            controller: _budgetController,
            focusNode: _budgetFocusNode,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: l10n.budgetFcfa,
              hintStyle: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              filled: true,
              fillColor: _isBudgetFocused
                  ? AppColors.orange.withOpacity(0.3)
                  : AppColors.orange.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: AppColors.orange,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: AppColors.orange,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: AppColors.orange,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isBudgetFocused
                      ? AppColors.orange.withOpacity(0.9)
                      : AppColors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.attach_money,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              suffixIcon: _budgetController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _budgetController.clear();
                  });
                  _budgetFocusNode.unfocus();
                },
              )
                  : null,
            ),
            onChanged: (value) {
              setState(() {}); // Pour afficher/cacher l'icône de suppression
            },
          ),

          const SizedBox(height: 10),

          // Bouton Recherche
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _performSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              icon: const Icon(Icons.search, color: Colors.white),
              label: Text(
                l10n.searchButton,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFieldWithIcon({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required bool isDark,
    required FocusNode focusNode,
    required bool isFocused,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          color: isDark ? Colors.white60 : Colors.black45,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkGrey : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: AppColors.orange,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isFocused ? AppColors.orange : AppColors.blue,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
          icon: Icon(
            Icons.close,
            color: isDark ? Colors.white70 : Colors.black54,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              controller.clear();
            });
            focusNode.unfocus();
          },
        )
            : null,
      ),
      onChanged: (value) {
        setState(() {}); // Pour afficher/cacher l'icône de suppression
      },
    );
  }

  Widget _buildPropertyTypeField(AppLocalizations l10n, bool isDark) {
    return GestureDetector(
      onTap: () {
        _showPropertyTypeDialog(l10n);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkGrey : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: _isPropertyTypeFocused ? AppColors.orange : Colors.grey.withOpacity(0.3),
            width: _isPropertyTypeFocused ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isPropertyTypeFocused ? AppColors.orange : AppColors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedPropertyType != null
                    ? _getPropertyTypeName(_selectedPropertyType!, l10n)
                    : l10n.propertyType,
                style: TextStyle(
                  color: _selectedPropertyType != null
                      ? (isDark ? Colors.white : Colors.black)
                      : (isDark ? Colors.white60 : Colors.black45),
                  fontWeight: _selectedPropertyType != null
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            ),
            if (_selectedPropertyType != null)
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _selectedPropertyType = null;
                  });
                },
              )
            else
              Icon(
                Icons.arrow_drop_down,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
          ],
        ),
      ),
    );
  }

  void _showPropertyTypeDialog(AppLocalizations l10n) {
    setState(() {
      _isPropertyTypeFocused = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.propertyType,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: PropertyType.values.map((type) {
              final isSelected = _selectedPropertyType == type;
              return InkWell(
                onTap: () {
                  setState(() => _selectedPropertyType = type);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.orange.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.orange
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: isSelected ? AppColors.orange : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getPropertyTypeName(type, l10n),
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.orange
                                : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.orange,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppColors.grey),
            ),
          ),
        ],
      ),
    ).then((_) {
      // Retire le focus quand la dialog est fermée
      setState(() {
        _isPropertyTypeFocused = false;
      });
    });
  }


  String _getPropertyTypeName(PropertyType type, AppLocalizations l10n) {
    switch (type) {
      case PropertyType.appartement:
        return l10n.apartment;
      case PropertyType.maison:
        return l10n.house;
      case PropertyType.studio:
        return l10n.studio;
      case PropertyType.chambre:
        return l10n.room;
      case PropertyType.villa:
        return 'Villa';
      case PropertyType.duplex:
        return 'Duplex';
      case PropertyType.penthouse:
        return 'Penthouse';
    }
  }
}