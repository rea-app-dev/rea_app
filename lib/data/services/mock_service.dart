import 'dart:convert';
import 'dart:async';
import '../models/user.dart';
import '../models/property.dart';

class MockService {
  // Simulation de latence réseau
  static Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // TODO: Remplacer par vraie API
  // static Future<List<User>> getUsers() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/users'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body)['data'];
  //       return jsonData.map((json) => User.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load users');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching users: $e');
  //   }
  // }

  // Charger les utilisateurs mock
  static Future<List<User>> getUsers() async {
    await _simulateDelay();

    const usersJson = '''[
      {
        "id": "1",
        "email": "andre.marie@gmail.com",
        "phone": "+237677123456",
        "firstName": "André-Marie",
        "lastName": "TALLA",
        "userType": "proprietaire",
        "profilePicture": null,
        "isKycVerified": true,
        "location": "Yaoundé",
        "createdAt": "2024-01-15T10:30:00Z"
      },
      {
        "id": "2",
        "email": "biya.paul@outlook.com",
        "phone": "+237655987654",
        "firstName": "Paul",
        "lastName": "BIYA",
        "userType": "locataire",
        "profilePicture": null,
        "isKycVerified": false,
        "location": "Douala",
        "createdAt": "2024-02-20T14:15:00Z"
      },
      {
        "id": "3",
        "email": "nadia.sebastian@yahoo.fr",
        "phone": "+237698456789",
        "firstName": "Nadia",
        "lastName": "SEBASTIAN",
        "userType": "proprietaire",
        "profilePicture": null,
        "isKycVerified": true,
        "location": "Bafoussam",
        "createdAt": "2024-01-10T09:20:00Z"
      },
      {
        "id": "4",
        "email": "jeanne.irene@gmail.com",
        "phone": "+237674321098",
        "firstName": "Jeanne",
        "lastName": "IRÈNE",
        "userType": "locataire",
        "profilePicture": null,
        "isKycVerified": false,
        "location": "Douala",
        "createdAt": "2024-03-05T16:45:00Z"
      },
      {
        "id": "5",
        "email": "marie.dupont@gmail.com",
        "phone": "+237690123456",
        "firstName": "Marie",
        "lastName": "DUPONT",
        "userType": "proprietaire",
        "profilePicture": null,
        "isKycVerified": true,
        "location": "Kribi",
        "createdAt": "2024-01-20T08:15:00Z"
      }
    ]''';

    final List<dynamic> jsonList = json.decode(usersJson);
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

  // TODO: Remplacer par vraie API
  // static Future<List<Property>> getProperties() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/properties'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body)['data'];
  //       return jsonData.map((json) => Property.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load properties');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching properties: $e');
  //   }
  // }

  // Charger les propriétés mock
  static Future<List<Property>> getProperties() async {
    await _simulateDelay();

    const propertiesJson = '''[
      {
        "id": "1",
        "title": "Appartement 03 Chambres - Bonanjo",
        "price": 150000,
        "currency": "XAF",
        "propertyType": "appartement",
        "standing": "standard",
        "rooms": 3,
        "bathrooms": 2,
        "surface": 120,
        "location": "Bonanjo - Douala - CAMEROUN",
        "quartier": "Bonanjo",
        "ville": "Douala",
        "description": "Bel appartement moderne de 3 chambres avec vue sur le fleuve. Quartier calme et sécurisé avec accès facile aux commerces.",
        "images": ["https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400", "https://images.unsplash.com/photo-1505843513577-22bb7d21e455?w=400"],
        "equipments": ["eau courante", "electricite 24h", "securite", "parking"],
        "isAvailable": true,
        "ownerId": "1",
        "rating": 4.5,
        "viewsCount": 245,
        "createdAt": "2024-09-01T08:30:00Z",
        "category": "residential",
        "tags": ["vue fleuve", "moderne", "securise"]
      },
      {
        "id": "2",
        "title": "Studio Moderne - Bastos",
        "price": 65000,
        "currency": "XAF",
        "propertyType": "studio",
        "standing": "economique",
        "rooms": 1,
        "bathrooms": 1,
        "surface": 35,
        "location": "Bastos - Yaoundé - CAMEROUN",
        "quartier": "Bastos",
        "ville": "Yaoundé",
        "description": "Studio moderne et fonctionnel dans un quartier prisé. Idéal pour jeunes professionnels.",
        "images": ["https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=400"],
        "equipments": ["eau courante", "electricite", "internet"],
        "isAvailable": true,
        "ownerId": "3",
        "rating": 4.2,
        "viewsCount": 89,
        "createdAt": "2024-09-10T14:20:00Z",
        "category": "residential",
        "tags": ["fonctionnel", "quartier prise"]
      },
      {
        "id": "3",
        "title": "Villa 4 Chambres - Omnisport",
        "price": 250000,
        "currency": "XAF",
        "propertyType": "villa",
        "standing": "luxe",
        "rooms": 4,
        "bathrooms": 3,
        "surface": 200,
        "location": "Omnisport - Yaoundé - CAMEROUN",
        "quartier": "Omnisport",
        "ville": "Yaoundé",
        "description": "Magnifique villa familiale avec jardin. Construction récente avec finitions haut de gamme.",
        "images": ["https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400", "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400"],
        "equipments": ["eau courante", "electricite 24h", "securite", "parking", "jardin", "climatisation"],
        "isAvailable": true,
        "ownerId": "1",
        "rating": 4.8,
        "viewsCount": 156,
        "createdAt": "2024-08-25T11:45:00Z",
        "category": "residential",
        "tags": ["familiale", "jardin", "construction recente"]
      },
      {
        "id": "4",
        "title": "Chambre meublée - Akwa",
        "price": 35000,
        "currency": "XAF",
        "propertyType": "chambre",
        "standing": "economique",
        "rooms": 1,
        "bathrooms": 1,
        "surface": 15,
        "location": "Akwa - Douala - CAMEROUN",
        "quartier": "Akwa",
        "ville": "Douala",
        "description": "Chambre meublée dans maison familiale. Environnement calme, proche université.",
        "images": ["https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400"],
        "equipments": ["eau courante", "electricite", "meuble"],
        "isAvailable": false,
        "ownerId": "3",
        "rating": 3.8,
        "viewsCount": 67,
        "createdAt": "2024-09-05T16:10:00Z",
        "category": "residential",
        "tags": ["meublee", "proche universite"]
      },
      {
        "id": "5",
        "title": "Duplex 2 Chambres - New Bell",
        "price": 185000,
        "currency": "XAF",
        "propertyType": "duplex",
        "standing": "hautStanding",
        "rooms": 2,
        "bathrooms": 2,
        "surface": 95,
        "location": "New Bell - Douala - CAMEROUN",
        "quartier": "New Bell",
        "ville": "Douala",
        "description": "Duplex spacieux et lumineux au cœur de New Bell. Proche des transports en commun.",
        "images": ["https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=400"],
        "equipments": ["eau courante", "electricite", "balcon", "terrasse"],
        "isAvailable": true,
        "ownerId": "1",
        "rating": 4.1,
        "viewsCount": 123,
        "createdAt": "2024-09-12T09:15:00Z",
        "category": "residential",
        "tags": ["duplex", "terrasse", "transport"]
      },
      {
        "id": "6",
        "title": "Penthouse Vue Mer - Kribi",
        "price": 400000,
        "currency": "XAF",
        "propertyType": "penthouse",
        "standing": "luxe",
        "rooms": 3,
        "bathrooms": 2,
        "surface": 150,
        "location": "Kribi - Littoral - CAMEROUN",
        "quartier": "Centre Ville",
        "ville": "Kribi",
        "description": "Penthouse exceptionnel avec vue imprenable sur la mer. Idéal pour les vacances.",
        "images": ["https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=400"],
        "equipments": ["eau courante", "electricite 24h", "securite", "piscine", "vue mer", "ascenseur"],
        "isAvailable": true,
        "ownerId": "5",
        "rating": 4.9,
        "viewsCount": 340,
        "createdAt": "2024-08-15T11:30:00Z",
        "category": "special",
        "tags": ["vue mer", "vacances", "luxe"]
      },
      {
        "id": "7",
        "title": "Bureau Commercial - Centre Ville",
        "price": 120000,
        "currency": "XAF",
        "propertyType": "appartement",
        "standing": "standard",
        "rooms": 3,
        "bathrooms": 1,
        "surface": 80,
        "location": "Centre Ville - Yaoundé - CAMEROUN",
        "quartier": "Centre Ville",
        "ville": "Yaoundé",
        "description": "Bureau commercial idéalement situé en centre ville. Parfait pour les entreprises.",
        "images": ["https://images.unsplash.com/photo-1497366216548-37526070297c?w=400"],
        "equipments": ["eau courante", "electricite", "internet", "parking", "securite"],
        "isAvailable": true,
        "ownerId": "4",
        "rating": 4.3,
        "viewsCount": 156,
        "createdAt": "2024-09-08T14:20:00Z",
        "category": "commercial",
        "tags": ["bureau", "centre ville", "entreprise"]
      },
      {
        "id": "8",
        "title": "Terrain à Bâtir - Odza",
        "price": 15000000,
        "currency": "XAF",
        "propertyType": "maison",
        "standing": "standard",
        "rooms": 0,
        "bathrooms": 0,
        "surface": 500,
        "location": "Odza - Yaoundé - CAMEROUN",
        "quartier": "Odza",
        "ville": "Yaoundé",
        "description": "Terrain viabilisé de 500m² dans un quartier en développement. Idéal pour construction.",
        "images": ["https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400"],
        "equipments": ["eau courante", "electricite"],
        "isAvailable": true,
        "ownerId": "2",
        "rating": 4.0,
        "viewsCount": 89,
        "createdAt": "2024-09-01T10:00:00Z",
        "category": "land",
        "tags": ["terrain", "viabilise", "construction"]
      }
    ]''';

    final List<dynamic> jsonList = json.decode(propertiesJson);
    return jsonList.map((json) => Property.fromJson(json)).toList();
  }

  // TODO: Remplacer par vraie API avec filtres
  // static Future<List<Property>> getPropertiesByCity(String city) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/properties?city=$city'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body)['data'];
  //       return jsonData.map((json) => Property.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load properties for city: $city');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching properties by city: $e');
  //   }
  // }

  // Filtrer les propriétés par ville (pour différencier propriétaire/locataire)
  static Future<List<Property>> getPropertiesByCity(String city) async {
    final allProperties = await getProperties();
    return allProperties.where((p) =>
        p.ville.toLowerCase().contains(city.toLowerCase())
    ).toList();
  }

  // TODO: Remplacer par vraie API avec filtres avancés
  // static Future<List<Property>> getPropertiesWithFilters({
  //   String? city,
  //   PropertyType? type,
  //   Standing? standing,
  //   String? category,
  //   int? minPrice,
  //   int? maxPrice,
  //   int? minRooms,
  //   int? maxRooms,
  // }) async {
  //   try {
  //     final queryParams = <String, String>{};
  //     if (city != null) queryParams['city'] = city;
  //     if (type != null) queryParams['type'] = type.name;
  //     if (standing != null) queryParams['standing'] = standing.name;
  //     if (category != null) queryParams['category'] = category;
  //     if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
  //     if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
  //     if (minRooms != null) queryParams['minRooms'] = minRooms.toString();
  //     if (maxRooms != null) queryParams['maxRooms'] = maxRooms.toString();
  //
  //     final uri = Uri.parse('$baseUrl/properties').replace(queryParameters: queryParams);
  //     final response = await http.get(uri, headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body)['data'];
  //       return jsonData.map((json) => Property.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load filtered properties');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching filtered properties: $e');
  //   }
  // }

  // Filtrer les propriétés avec plusieurs critères (version mock)
  static Future<List<Property>> getPropertiesWithFilters({
    String? city,
    PropertyType? type,
    Standing? standing,
    String? category,
    int? minPrice,
    int? maxPrice,
    int? minRooms,
    int? maxRooms,
  }) async {
    final allProperties = await getProperties();

    return allProperties.where((property) {
      // Filtre par ville
      if (city != null && !property.ville.toLowerCase().contains(city.toLowerCase())) {
        return false;
      }

      // Filtre par type
      if (type != null && property.propertyType != type) {
        return false;
      }

      // Filtre par standing
      if (standing != null && property.standing != standing) {
        return false;
      }

      // Filtre par catégorie
      if (category != null && property.category.key != category) {
        return false;
      }

      // Filtre par prix
      if (minPrice != null && property.price < minPrice) {
        return false;
      }
      if (maxPrice != null && property.price > maxPrice) {
        return false;
      }

      // Filtre par nombre de chambres
      if (minRooms != null && property.rooms < minRooms) {
        return false;
      }
      if (maxRooms != null && property.rooms > maxRooms) {
        return false;
      }

      return true;
    }).toList();
  }

  // Recherche textuelle dans les propriétés
  static Future<List<Property>> searchProperties(String query) async {
    final allProperties = await getProperties();
    final searchQuery = query.toLowerCase();

    return allProperties.where((property) {
      return property.title.toLowerCase().contains(searchQuery) ||
          property.location.toLowerCase().contains(searchQuery) ||
          property.quartier.toLowerCase().contains(searchQuery) ||
          property.ville.toLowerCase().contains(searchQuery) ||
          property.description.toLowerCase().contains(searchQuery) ||
          (property.tags?.any((tag) => tag.toLowerCase().contains(searchQuery)) ?? false);
    }).toList();
  }

  // Récupérer une propriété par ID
  static Future<Property?> getPropertyById(String id) async {
    try {
      final allProperties = await getProperties();
      return allProperties.firstWhere((property) => property.id == id);
    } catch (e) {
      return null;
    }
  }

  // Récupérer les propriétés d'un propriétaire
  static Future<List<Property>> getPropertiesByOwner(String ownerId) async {
    final allProperties = await getProperties();
    return allProperties.where((property) => property.ownerId == ownerId).toList();
  }

  // Récupérer les propriétés les mieux notées
  static Future<List<Property>> getTopRatedProperties({int limit = 10}) async {
    final allProperties = await getProperties();
    allProperties.sort((a, b) => b.rating.compareTo(a.rating));
    return allProperties.take(limit).toList();
  }

  // Récupérer les propriétés les plus récentes
  static Future<List<Property>> getRecentProperties({int limit = 10}) async {
    final allProperties = await getProperties();
    allProperties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allProperties.take(limit).toList();
  }
}