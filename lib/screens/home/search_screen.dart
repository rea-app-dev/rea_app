import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../providers/property_provider.dart';
import '../../data/models/property.dart';
import '../../widgets/property/property_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  final String? searchQuery;
  final String? country;
  final String? city;
  final String? district;
  final PropertyType? propertyType;
  final String? budget;

  const SearchScreen({
    Key? key,
    this.searchQuery,
    this.country,
    this.city,
    this.district,
    this.propertyType,
    this.budget,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  PropertyType? _activePropertyType;
  Standing? _activeStanding;
  String? _activeCity;
  String _activeFilter = 'all';
  String _sortBy = 'recent';
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _initializeFromParams();
    _loadResults();
  }

  void _initializeFromParams() {
    _searchController.text = widget.searchQuery ?? '';
    _activePropertyType = widget.propertyType;
    _activeCity = widget.city;
  }

  void _loadResults() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PropertyProvider>();
      provider.loadProperties();

      if (_searchController.text.isNotEmpty) {
        provider.searchProperties(_searchController.text);
      }

      if (_activePropertyType != null) {
        provider.filterByType(_activePropertyType);
      }

      if (_activeCity?.isNotEmpty == true) {
        provider.filterByCity(_activeCity!);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(l10n),
      body: Column(
        children: [
          _buildSearchBar(l10n),
          if (_showFilters) _buildAdvancedFilters(l10n),
          _buildFilterTabs(l10n),
          _buildResultsSection(l10n),
        ],
      ),
    );
  }

  AppBar _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.white
          : AppColors.blue,
      elevation: 0,
      title: const Text('Résultats de recherche'),
      actions: [
        IconButton(
          icon: Icon(_showFilters ? Icons.keyboard_arrow_up : Icons.tune),
          onPressed: () => setState(() => _showFilters = !_showFilters),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort),
          onSelected: (value) => setState(() => _sortBy = value),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'recent', child: Text('Plus récent')),
            const PopupMenuItem(value: 'price_asc', child: Text('Prix croissant')),
            const PopupMenuItem(value: 'price_desc', child: Text('Prix décroissant')),
            const PopupMenuItem(value: 'rating', child: Text('Mieux notés')),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
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
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Affiner la recherche...',
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: AppColors.grey),
            onPressed: () {
              _searchController.clear();
              context.read<PropertyProvider>().searchProperties('');
            },
          )
              : const Icon(Icons.mic, color: AppColors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: (value) {
          context.read<PropertyProvider>().searchProperties(value);
        },
      ),
    );
  }

  Widget _buildAdvancedFilters(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtres avancés',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.blue),
          ),
          const SizedBox(height: 16),

          // Types de biens
          const Text('Type de bien :', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip('Tous', _activePropertyType == null, () {
                setState(() => _activePropertyType = null);
                context.read<PropertyProvider>().filterByType(null);
              }),
              ...PropertyType.values.map((type) {
                return _buildFilterChip(
                  _getPropertyTypeName(type, l10n),
                  _activePropertyType == type,
                      () {
                    setState(() => _activePropertyType = type);
                    context.read<PropertyProvider>().filterByType(type);
                  },
                );
              }).toList(),
            ],
          ),

          const SizedBox(height: 16),

          // Standing
          const Text('Standing :', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip('Tous', _activeStanding == null, () {
                setState(() => _activeStanding = null);
                context.read<PropertyProvider>().filterByStanding(null);
              }),
              ...Standing.values.map((standing) {
                return _buildFilterChip(
                  _getStandingName(standing, l10n),
                  _activeStanding == standing,
                      () {
                    setState(() => _activeStanding = standing);
                    context.read<PropertyProvider>().filterByStanding(standing);
                  },
                );
              }).toList(),
            ],
          ),

          const SizedBox(height: 16),

          // Bouton effacer filtres
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _clearAllFilters,
              icon: const Icon(Icons.clear_all),
              label: const Text('Effacer les filtres'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.orange,
                side: const BorderSide(color: AppColors.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(AppLocalizations l10n) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTabChip('Tous', 'all'),
          const SizedBox(width: 8),
          _buildTabChip('Résidentiel', 'residential'),
          const SizedBox(width: 8),
          _buildTabChip('Commercial', 'commercial'),
          const SizedBox(width: 8),
          _buildTabChip('Terrain', 'terrain'),
          const SizedBox(width: 8),
          _buildTabChip('Spécial', 'special'),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, String value) {
    final isSelected = _activeFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() => _activeFilter = value);
        _applyTabFilter(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.orange : AppColors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.grey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _applyTabFilter(String filter) {
    final provider = context.read<PropertyProvider>();
    switch (filter) {
      case 'all':
        provider.filterByType(null);
        break;
      case 'residential':
        provider.filterByType(PropertyType.appartement);
        break;
      case 'commercial':
      // Créer un filtre commercial si nécessaire
        provider.filterByType(null);
        break;
      case 'terrain':
      // Créer un filtre terrain si nécessaire
        provider.filterByType(null);
        break;
      case 'special':
      // Créer un filtre spécial si nécessaire
        provider.filterByType(null);
        break;
    }
  }

  Widget _buildResultsSection(AppLocalizations l10n) {
    return Expanded(
      child: Consumer<PropertyProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.orange),
            );
          }

          final properties = provider.properties;

          if (properties.isEmpty) {
            return _buildEmptyState(l10n);
          }

          return Column(
            children: [
              // Header avec nombre de résultats
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      '${properties.length} résultat(s) trouvé(s)',
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (_hasActiveFilters())
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Filtres actifs',
                          style: TextStyle(
                            color: AppColors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Grille des résultats 2 colonnes
              Expanded(
                child: Wrap(
                  spacing: 12, // Espacement horizontal
                  runSpacing: 12, // Espacement vertical
                  children: properties.map((property) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 44) / 2, // 44 = padding + spacing
                      child: PropertyCard(property: property),
                    );
                  }).toList(),
                )
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucun résultat trouvé',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Essayez de modifier vos filtres pour élargir votre recherche',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _clearAllFilters,
              icon: const Icon(Icons.refresh),
              label: const Text('Effacer les filtres'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.orange : AppColors.grey.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.grey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _activePropertyType = null;
      _activeStanding = null;
      _activeCity = null;
      _activeFilter = 'all';
    });

    final provider = context.read<PropertyProvider>();
    provider.clearFilters();
    _searchController.clear();
  }

  bool _hasActiveFilters() {
    return _activePropertyType != null ||
        _activeStanding != null ||
        _activeCity != null ||
        _searchController.text.isNotEmpty;
  }

  String _getPropertyTypeName(PropertyType type, AppLocalizations l10n) {
    switch (type) {
      case PropertyType.appartement:
        return 'Appartement';
      case PropertyType.maison:
        return 'Maison';
      case PropertyType.studio:
        return 'Studio';
      case PropertyType.chambre:
        return 'Chambre';
    }
  }

  String _getStandingName(Standing standing, AppLocalizations l10n) {
    switch (standing) {
      case Standing.economique:
        return 'Économique';
      case Standing.standard:
        return 'Standard';
      case Standing.luxe:
        return 'Luxe';
    }
  }
}