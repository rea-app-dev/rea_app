import 'package:flutter/foundation.dart';
import '../data/models/property.dart';
import '../data/models/category.dart';
import '../data/services/mock_service.dart';

class PropertyProvider with ChangeNotifier {
  List<Property> _allProperties = [];
  List<Property> _filteredProperties = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filtres actuels
  String _searchQuery = '';
  PropertyType? _selectedType;
  Standing? _selectedStanding;
  String? _selectedCity;
  PropertyCategory? _selectedCategory;
  int? _minPrice;
  int? _maxPrice;
  int? _minRooms;
  int? _maxRooms;

  // Tri
  String _sortBy = 'recent'; // recent, price_asc, price_desc, rating

  // Getters
  List<Property> get properties => _filteredProperties;
  List<Property> get allProperties => _allProperties;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  PropertyType? get selectedType => _selectedType;
  Standing? get selectedStanding => _selectedStanding;
  String? get selectedCity => _selectedCity;
  PropertyCategory? get selectedCategory => _selectedCategory;
  int? get minPrice => _minPrice;
  int? get maxPrice => _maxPrice;
  int? get minRooms => _minRooms;
  int? get maxRooms => _maxRooms;
  String get sortBy => _sortBy;

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty ||
          _selectedType != null ||
          _selectedStanding != null ||
          _selectedCity != null ||
          _selectedCategory != null ||
          _minPrice != null ||
          _maxPrice != null ||
          _minRooms != null ||
          _maxRooms != null;

  // TODO: Remplacer par vraie API
  // Future<void> loadProperties({String? city}) async {
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/properties${city != null ? '?city=$city' : ''}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body)['data'];
  //       _allProperties = jsonData.map((json) => Property.fromJson(json)).toList();
  //       _applyFiltersAndSort();
  //     } else {
  //       throw Exception('Failed to load properties: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     _errorMessage = 'Erreur lors du chargement des propriétés: $e';
  //     debugPrint(_errorMessage);
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> loadProperties({String? city}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (city != null) {
        _allProperties = await MockService.getPropertiesByCity(city);
      } else {
        _allProperties = await MockService.getProperties();
      }
      _applyFiltersAndSort();
    } catch (e) {
      _errorMessage = 'Erreur lors du chargement des propriétés: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Recherche textuelle
  void searchProperties(String query) {
    _searchQuery = query.trim();
    _applyFiltersAndSort();
  }

  // Filtres individuels
  void filterByType(PropertyType? type) {
    _selectedType = type;
    _applyFiltersAndSort();
  }

  void filterByStanding(Standing? standing) {
    _selectedStanding = standing;
    _applyFiltersAndSort();
  }

  void filterByCity(String? city) {
    _selectedCity = city?.trim();
    _applyFiltersAndSort();
  }

  void filterByCategory(PropertyCategory? category) {
    _selectedCategory = category;
    _applyFiltersAndSort();
  }

  void filterByPriceRange(int? minPrice, int? maxPrice) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _applyFiltersAndSort();
  }

  void filterByRoomsRange(int? minRooms, int? maxRooms) {
    _minRooms = minRooms;
    _maxRooms = maxRooms;
    _applyFiltersAndSort();
  }

  // Filtrage avancé avec tous les critères
  Future<void> applyAdvancedFilters({
    String? searchQuery,
    PropertyType? propertyType,
    Standing? standing,
    String? city,
    PropertyCategory? category,
    int? minPrice,
    int? maxPrice,
    int? minRooms,
    int? maxRooms,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _allProperties = await MockService.getPropertiesWithFilters(
        city: city,
        type: propertyType,
        standing: standing,
        category: category?.key,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRooms: minRooms,
        maxRooms: maxRooms,
      );

      // Mettre à jour les filtres actuels
      _searchQuery = searchQuery ?? '';
      _selectedType = propertyType;
      _selectedStanding = standing;
      _selectedCity = city;
      _selectedCategory = category;
      _minPrice = minPrice;
      _maxPrice = maxPrice;
      _minRooms = minRooms;
      _maxRooms = maxRooms;

      _applyFiltersAndSort();
    } catch (e) {
      _errorMessage = 'Erreur lors de l\'application des filtres: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tri
  void sortProperties(String sortType) {
    _sortBy = sortType;
    _applyFiltersAndSort();
  }

  // Effacer tous les filtres
  void clearFilters() {
    _searchQuery = '';
    _selectedType = null;
    _selectedStanding = null;
    _selectedCity = null;
    _selectedCategory = null;
    _minPrice = null;
    _maxPrice = null;
    _minRooms = null;
    _maxRooms = null;
    _applyFiltersAndSort();
  }

  // Application des filtres et tri
  void _applyFiltersAndSort() {
    List<Property> filtered = List.from(_allProperties);

    // Filtrage par recherche textuelle
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((property) {
        return property.title.toLowerCase().contains(query) ||
            property.location.toLowerCase().contains(query) ||
            property.quartier.toLowerCase().contains(query) ||
            property.ville.toLowerCase().contains(query) ||
            property.description.toLowerCase().contains(query) ||
            (property.tags?.any((tag) => tag.toLowerCase().contains(query)) ?? false);
      }).toList();
    }

    // Filtrage par type
    if (_selectedType != null) {
      filtered = filtered.where((p) => p.propertyType == _selectedType).toList();
    }

    // Filtrage par standing
    if (_selectedStanding != null) {
      filtered = filtered.where((p) => p.standing == _selectedStanding).toList();
    }

    // Filtrage par ville
    if (_selectedCity != null && _selectedCity!.isNotEmpty) {
      filtered = filtered.where((p) =>
          p.ville.toLowerCase().contains(_selectedCity!.toLowerCase())).toList();
    }

    // Filtrage par catégorie
    if (_selectedCategory != null) {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    // Filtrage par prix
    if (_minPrice != null) {
      filtered = filtered.where((p) => p.price >= _minPrice!).toList();
    }
    if (_maxPrice != null) {
      filtered = filtered.where((p) => p.price <= _maxPrice!).toList();
    }

    // Filtrage par nombre de chambres
    if (_minRooms != null) {
      filtered = filtered.where((p) => p.rooms >= _minRooms!).toList();
    }
    if (_maxRooms != null) {
      filtered = filtered.where((p) => p.rooms <= _maxRooms!).toList();
    }

    // Application du tri
    switch (_sortBy) {
      case 'price_asc':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'recent':
      default:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    _filteredProperties = filtered;
    notifyListeners();
  }

  // Méthodes utilitaires
  Future<void> refresh() async {
    await loadProperties();
  }

  Future<Property?> getPropertyById(String id) async {
    return await MockService.getPropertyById(id);
  }

  Future<List<Property>> getPropertiesByOwner(String ownerId) async {
    return await MockService.getPropertiesByOwner(ownerId);
  }

  Future<List<Property>> getTopRatedProperties({int limit = 10}) async {
    return await MockService.getTopRatedProperties(limit: limit);
  }

  Future<List<Property>> getRecentProperties({int limit = 10}) async {
    return await MockService.getRecentProperties(limit: limit);
  }

  // Statistiques
  int get totalProperties => _allProperties.length;
  int get filteredCount => _filteredProperties.length;
  int get availableCount => _filteredProperties.where((p) => p.isAvailable).length;

  double get averagePrice {
    if (_filteredProperties.isEmpty) return 0;
    final total = _filteredProperties.fold<double>(0, (sum, p) => sum + p.price);
    return total / _filteredProperties.length;
  }

  double get averageRating {
    if (_filteredProperties.isEmpty) return 0;
    final total = _filteredProperties.fold<double>(0, (sum, p) => sum + p.rating);
    return total / _filteredProperties.length;
  }

  // Reset complet
  void reset() {
    _allProperties.clear();
    _filteredProperties.clear();
    clearFilters();
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}