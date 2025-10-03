import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property.dart';
import 'auth_service.dart';
import 'mock_service.dart';

class PropertyService {
  static const String _baseUrl = 'https://api.rea-app.com/v1';

  // TODO: Remplacer par vraies APIs
  // static Future<List<Property>> getProperties({
  //   int page = 1,
  //   int limit = 20,
  //   String? city,
  //   PropertyType? type,
  //   Standing? standing,
  //   String? category,
  //   int? minPrice,
  //   int? maxPrice,
  //   int? minRooms,
  //   int? maxRooms,
  //   String? sortBy,
  //   String? search,
  // }) async {
  //   try {
  //     final token = await AuthService.getToken();
  //     
  //     final queryParams = <String, String>{
  //       'page': page.toString(),
  //       'limit': limit.toString(),
  //     };
  //     
  //     if (city != null) queryParams['city'] = city;
  //     if (type != null) queryParams['type'] = type.name;
  //     if (standing != null) queryParams['standing'] = standing.name;
  //     if (category != null) queryParams['category'] = category;
  //     if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
  //     if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
  //     if (minRooms != null) queryParams['minRooms'] = minRooms.toString();
  //     if (maxRooms != null) queryParams['maxRooms'] = maxRooms.toString();
  //     if (sortBy != null) queryParams['sortBy'] = sortBy;
  //     if (search != null) queryParams['search'] = search;
  //
  //     final uri = Uri.parse('$_baseUrl/properties').replace(queryParameters: queryParams);
  //     final response = await http.get(uri, headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final List<dynamic> propertiesJson = data['data']['properties'];
  //       return propertiesJson.map((json) => Property.fromJson(json)).toList();
  //     } else if (response.statusCode == 401) {
  //       // Token expiré, essayer de le rafraîchir
  //       final refreshResult = await AuthService.refreshToken();
  //       if (refreshResult.isSuccess) {
  //         return getProperties(
  //           page: page, limit: limit, city: city, type: type,
  //           standing: standing, category: category, minPrice: minPrice,
  //           maxPrice: maxPrice, minRooms: minRooms, maxRooms: maxRooms,
  //           sortBy: sortBy, search: search,
  //         );
  //       } else {
  //         throw Exception('Session expirée');
  //       }
  //     } else {
  //       throw Exception('Erreur lors du chargement: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Erreur réseau: $e');
  //   }
  // }

  /// Récupérer les propriétés avec filtres (version mock utilisant MockService)
  static Future<PropertyResult> getProperties({
    int page = 1,
    int limit = 20,
    String? city,
    PropertyType? type,
    Standing? standing,
    String? category,
    int? minPrice,
    int? maxPrice,
    int? minRooms,
    int? maxRooms,
    String? sortBy,
    String? search,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Utiliser MockService pour les données
      final mockService = await MockService();

      List<Property> properties;
      if (search?.isNotEmpty == true) {
        // Utiliser la recherche textuelle du MockService
        properties = await MockService.searchProperties(search!);
      } else {
        // Utiliser les filtres avancés
        properties = await MockService.getPropertiesWithFilters(
          city: city,
          type: type,
          standing: standing,
          category: category,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRooms: minRooms,
          maxRooms: maxRooms,
        );
      }

      // Application du tri
      if (sortBy != null) {
        switch (sortBy) {
          case 'price_asc':
            properties.sort((a, b) => a.price.compareTo(b.price));
            break;
          case 'price_desc':
            properties.sort((a, b) => b.price.compareTo(a.price));
            break;
          case 'rating':
            properties.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          case 'recent':
          default:
            properties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            break;
        }
      }

      // Pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;
      final paginatedProperties = properties.length > startIndex
          ? properties.sublist(startIndex,
          endIndex > properties.length ? properties.length : endIndex)
          : <Property>[];

      return PropertyResult(
        properties: paginatedProperties,
        totalCount: properties.length,
        currentPage: page,
        totalPages: (properties.length / limit).ceil(),
        hasNextPage: endIndex < properties.length,
        hasPrevPage: page > 1,
      );
    } catch (e) {
      throw PropertyException('Erreur lors du chargement des propriétés: $e');
    }
  }

  // TODO: Remplacer par vraie API
  // static Future<Property?> getPropertyById(String id) async {
  //   try {
  //     final token = await AuthService.getToken();
  //     final response = await http.get(
  //       Uri.parse('$_baseUrl/properties/$id'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       return Property.fromJson(data['data']);
  //     } else if (response.statusCode == 404) {
  //       return null;
  //     } else {
  //       throw Exception('Erreur lors du chargement: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Erreur réseau: $e');
  //   }
  // }

  /// Récupérer une propriété par ID
  static Future<Property?> getPropertyById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final mockService = await MockService();
      return await MockService.getPropertyById(id);
    } catch (e) {
      throw PropertyException('Erreur lors du chargement de la propriété: $e');
    }
  }

  // TODO: Remplacer par vraie API
  // static Future<Property> createProperty(Property property) async {
  //   try {
  //     final token = await AuthService.getToken();
  //     final response = await http.post(
  //       Uri.parse('$_baseUrl/properties'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: json.encode(property.toJson()),
  //     );
  //
  //     if (response.statusCode == 201) {
  //       final data = json.decode(response.body);
  //       return Property.fromJson(data['data']);
  //     } else {
  //       throw Exception('Erreur lors de la création: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Erreur réseau: $e');
  //   }
  // }

  /// Créer une nouvelle propriété (mock)
  static Future<Property> createProperty(Property property) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      // Validation des données
      if (property.title.trim().isEmpty) {
        throw PropertyException('Le titre est requis');
      }
      if (property.price <= 0) {
        throw PropertyException('Le prix doit être supérieur à 0');
      }
      if (property.location.trim().isEmpty) {
        throw PropertyException('La localisation est requise');
      }

      // Simuler la création avec un nouvel ID
      final createdProperty = property.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        rating: 0.0,
        viewsCount: 0,
      );

      return createdProperty;
    } catch (e) {
      if (e is PropertyException) rethrow;
      throw PropertyException('Erreur lors de la création: $e');
    }
  }

  // TODO: Remplacer par vraie API
  // static Future<Property> updateProperty(Property property) async {
  //   try {
  //     final token = await AuthService.getToken();
  //     final response = await http.put(
  //       Uri.parse('$_baseUrl/properties/${property.id}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: json.encode(property.toJson()),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       return Property.fromJson(data['data']);
  //     } else {
  //       throw Exception('Erreur lors de la mise à jour: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Erreur réseau: $e');
  //   }
  // }

  /// Mettre à jour une propriété (mock)
  static Future<Property> updateProperty(Property property) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // Validation des données
      if (property.title.trim().isEmpty) {
        throw PropertyException('Le titre est requis');
      }
      if (property.price <= 0) {
        throw PropertyException('Le prix doit être supérieur à 0');
      }

      // Simuler la mise à jour
      return property;
    } catch (e) {
      if (e is PropertyException) rethrow;
      throw PropertyException('Erreur lors de la mise à jour: $e');
    }
  }

  // TODO: Remplacer par vraie API
  // static Future<bool> deleteProperty(String id) async {
  //   try {
  //     final token = await AuthService.getToken();
  //     final response = await http.delete(
  //       Uri.parse('$_baseUrl/properties/$id'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     return response.statusCode == 200;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  /// Supprimer une propriété (mock)
  static Future<bool> deleteProperty(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      if (id.isEmpty) {
        throw PropertyException('ID de propriété invalide');
      }

      // Simuler la suppression
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Récupérer les propriétés d'un propriétaire
  static Future<List<Property>> getPropertiesByOwner(String ownerId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));


      return await MockService.getPropertiesByOwner(ownerId);
    } catch (e) {
      throw PropertyException('Erreur lors du chargement des propriétés du propriétaire: $e');
    }
  }

  /// Récupérer les propriétés les mieux notées
  static Future<List<Property>> getTopRatedProperties({int limit = 10}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));


      return await MockService.getTopRatedProperties(limit: limit);
    } catch (e) {
      throw PropertyException('Erreur lors du chargement des propriétés top: $e');
    }
  }

  /// Récupérer les propriétés les plus récentes
  static Future<List<Property>> getRecentProperties({int limit = 10}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));


      return await MockService.getRecentProperties(limit: limit);
    } catch (e) {
      throw PropertyException('Erreur lors du chargement des propriétés récentes: $e');
    }
  }

  /// Marquer une propriété comme favorite
  static Future<bool> toggleFavorite(String propertyId) async {
    try {
      // TODO: Appel API réel
      // final token = await AuthService.getToken();
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/properties/$propertyId/favorite'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      // );
      // return response.statusCode == 200;

      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Récupérer les propriétés favorites de l'utilisateur
  static Future<List<Property>> getFavoriteProperties() async {
    try {
      // TODO: Appel API réel
      // final token = await AuthService.getToken();
      // final response = await http.get(
      //   Uri.parse('$_baseUrl/users/favorites'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      // );

      await Future.delayed(const Duration(milliseconds: 400));

      // Retourner quelques propriétés mock comme favorites
      final allProperties = await MockService.getProperties();
      return allProperties.take(3).toList(); // Simuler 3 favorites
    } catch (e) {
      throw PropertyException('Erreur lors du chargement des favoris: $e');
    }
  }

  /// Incrémenter le compteur de vues d'une propriété
  static Future<bool> incrementViewCount(String propertyId) async {
    try {
      // TODO: Appel API réel
      // final token = await AuthService.getToken();
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/properties/$propertyId/view'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      // );

      await Future.delayed(const Duration(milliseconds: 200));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Recherche de propriétés avec suggestions
  static Future<List<String>> getSearchSuggestions(String query) async {
    try {
      // TODO: Appel API réel
      // final response = await http.get(
      //   Uri.parse('$_baseUrl/properties/search/suggestions?q=${Uri.encodeComponent(query)}'),
      //   headers: {'Content-Type': 'application/json'},
      // );

      await Future.delayed(const Duration(milliseconds: 300));

      // Suggestions mock basées sur la requête
      final suggestions = <String>[];
      final lowercaseQuery = query.toLowerCase();

      final mockSuggestions = [
        'Douala', 'Yaoundé', 'Bafoussam', 'Kribi',
        'Appartement', 'Maison', 'Villa', 'Studio',
        'Bonanjo', 'Akwa', 'Bastos', 'Omnisport',
        'Luxe', 'Standard', 'Économique'
      ];

      for (String suggestion in mockSuggestions) {
        if (suggestion.toLowerCase().contains(lowercaseQuery)) {
          suggestions.add(suggestion);
        }
      }

      return suggestions.take(5).toList();
    } catch (e) {
      return [];
    }
  }

  /// Obtenir les statistiques des propriétés
  static Future<PropertyStats> getPropertyStats({String? ownerId}) async {
    try {
      // TODO: Appel API réel
      // final token = await AuthService.getToken();
      // final queryParams = ownerId != null ? {'ownerId': ownerId} : <String, String>{};
      // final uri = Uri.parse('$_baseUrl/properties/stats').replace(queryParameters: queryParams);
      // final response = await http.get(uri, headers: {
      //   'Content-Type': 'application/json',
      //   'Authorization': 'Bearer $token',
      // });

      await Future.delayed(const Duration(milliseconds: 400));


      final properties = ownerId != null
          ? await MockService.getPropertiesByOwner(ownerId)
          : await MockService.getProperties();

      final totalProperties = properties.length;
      final availableProperties = properties.where((p) => p.isAvailable).length;
      final totalViews = properties.fold<int>(0, (sum, p) => sum + p.viewsCount);
      final averagePrice = properties.isEmpty
          ? 0.0
          : properties.fold<double>(0, (sum, p) => sum + p.price) / properties.length;
      final averageRating = properties.isEmpty
          ? 0.0
          : properties.fold<double>(0, (sum, p) => sum + p.rating) / properties.length;

      return PropertyStats(
        totalProperties: totalProperties,
        availableProperties: availableProperties,
        rentedProperties: totalProperties - availableProperties,
        totalViews: totalViews,
        averagePrice: averagePrice,
        averageRating: averageRating,
        topPerformingProperty: properties.isNotEmpty
            ? properties.reduce((a, b) => a.viewsCount > b.viewsCount ? a : b)
            : null,
      );
    } catch (e) {
      throw PropertyException('Erreur lors du chargement des statistiques: $e');
    }
  }

  /// Signaler une propriété
  static Future<bool> reportProperty(String propertyId, String reason, String? description) async {
    try {
      // TODO: Appel API réel
      // final token = await AuthService.getToken();
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/properties/$propertyId/report'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      //   body: json.encode({
      //     'reason': reason,
      //     'description': description,
      //   }),
      // );

      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Classe pour les résultats de propriétés avec pagination
class PropertyResult {
  final List<Property> properties;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  PropertyResult({
    required this.properties,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });
}

/// Classe pour les statistiques des propriétés
class PropertyStats {
  final int totalProperties;
  final int availableProperties;
  final int rentedProperties;
  final int totalViews;
  final double averagePrice;
  final double averageRating;
  final Property? topPerformingProperty;

  PropertyStats({
    required this.totalProperties,
    required this.availableProperties,
    required this.rentedProperties,
    required this.totalViews,
    required this.averagePrice,
    required this.averageRating,
    this.topPerformingProperty,
  });
}

/// Exception personnalisée pour les erreurs de propriétés
class PropertyException implements Exception {
  final String message;

  PropertyException(this.message);

  @override
  String toString() => 'PropertyException: $message';
}