import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/property_provider.dart';
import '../../data/models/property.dart';
import '../../widgets/property/property_card.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(l10n, isDark),
      body: Column(
        children: [
          _buildSearchSection(l10n, isDark),
          if (_showFilters) _buildAdvancedFilters(l10n, isDark),
          _buildFilterTabs(l10n, isDark),
          _buildResultsSection(l10n, isDark),
        ],
      ),
    );
  }

  AppBar _buildAppBar(AppLocalizations l10n, bool isDark) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: isDark ? AppColors.white : AppColors.blue,
      elevation: 0,
      title: Text(l10n.searchResults),
      actions: [
        IconButton(
          icon: Icon(_showFilters ? Icons.keyboard_arrow_up : Icons.tune),
          onPressed: () => setState(() => _showFilters = !_showFilters),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort),
          onSelected: (value) => setState(() => _sortBy = value),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'recent', child: Text(l10n.sortRecent)),
            PopupMenuItem(value: 'price_asc', child: Text(l10n.sortPriceAsc)),
            PopupMenuItem(value: 'price_desc', child: Text(l10n.sortPriceDesc)),
            PopupMenuItem(value: 'rating', child: Text(l10n.sortRating)),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchSection(AppLocalizations l10n, bool isDark) {
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
          hintText: l10n.refineSearch,
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

  Widget _buildAdvancedFilters(AppLocalizations l10n, bool isDark) {
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
          Text(
            l10n.advancedFilters,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.blue),
          ),
          const SizedBox(height: 16),

          // Types de biens
          Text(
            l10n.propertyTypeColon,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip(l10n.all, _activePropertyType == null, () {
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
          Text(
            l10n.standingColon,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip(l10n.all, _activeStanding == null, () {
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
              label: Text(l10n.clearFilters),
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

  Widget _buildFilterTabs(AppLocalizations l10n, bool isDark) {
    return Container(
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTabChip(l10n.all, 'all'),
          const SizedBox(width: 8),
          _buildTabChip(l10n.residential, 'residential'),
          const SizedBox(width: 8),
          _buildTabChip(l10n.commercial, 'commercial'),
          const SizedBox(width: 8),
          _buildTabChip(l10n.land, 'terrain'),
          const SizedBox(width: 8),
          _buildTabChip(l10n.special, 'specialisé'),
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
          style: TextStyle(fontSize: 12,
            color: isSelected ? AppColors.white : AppColors.grey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection(AppLocalizations l10n, bool isDark) {
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
                      l10n.resultsFound(properties.length),
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
                        child: Text(
                          l10n.filtersActive,
                          style: const TextStyle(
                            color: AppColors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Grille des résultats
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.64,
                    ),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      return PropertyCard(property: properties[index]);
                    },
                  ),
                ),
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
            Text(
              l10n.noResultsFound,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noResultsMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _clearAllFilters,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.clearFiltersAndRetry),
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

  // Helper methods
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
      case 'terrain':
      case 'special':
      // Pour l'instant, on garde le même comportement
        provider.filterByType(null);
        break;
    }
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
        return l10n.apartment;
      case PropertyType.maison:
        return l10n.house;
      case PropertyType.studio:
        return l10n.studio;
      case PropertyType.chambre:
        return l10n.room;
      case PropertyType.villa:
        return 'Villa'; // TODO: Ajouter à l10n
      case PropertyType.duplex:
        return 'Duplex'; // TODO: Ajouter à l10n
      case PropertyType.penthouse:
        return 'Penthouse'; // TODO: Ajouter à l10n
    }
  }

  String _getStandingName(Standing standing, AppLocalizations l10n) {
    switch (standing) {
      case Standing.economique:
        return l10n.economical;
      case Standing.standard:
        return l10n.standard;
      case Standing.luxe:
        return l10n.luxury;
      case Standing.hautStanding:
        return 'Haut Standing'; // TODO: Ajouter à l10n
    }
  }
}