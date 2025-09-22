import 'package:flutter/foundation.dart';
import '../data/models/property.dart';
import '../data/services/mock_service.dart';

class PropertyProvider with ChangeNotifier {
  List<Property> _properties = [];
  List<Property> _filteredProperties = [];
  bool _isLoading = false;
  String _searchQuery = '';
  PropertyType? _selectedType;
  Standing? _selectedStanding;
  String? _selectedCity;

  List<Property> get properties => _filteredProperties;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadProperties({String? city}) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (city != null) {
        _properties = await MockService.getPropertiesByCity(city);
      } else {
        _properties = await MockService.getProperties();
      }

      _applyFilters();
    } catch (e) {
      debugPrint('Error loading properties: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchProperties(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByType(PropertyType? type) {
    _selectedType = type;
    _applyFilters();
  }

  void filterByStanding(Standing? standing) {
    _selectedStanding = standing;
    _applyFilters();
  }

  void filterByCity(String? city) {
    _selectedCity = city;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedType = null;
    _selectedStanding = null;
    _selectedCity = null;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProperties = _properties.where((property) {
      // Filtre par recherche textuelle
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!property.title.toLowerCase().contains(query) &&
            !property.location.toLowerCase().contains(query) &&
            !property.quartier.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Filtre par type
      if (_selectedType != null && property.propertyType != _selectedType) {
        return false;
      }

      // Filtre par standing
      if (_selectedStanding != null && property.standing != _selectedStanding) {
        return false;
      }

      // Filtre par ville
      if (_selectedCity != null &&
          !property.ville.toLowerCase().contains(_selectedCity!.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }
}