import 'dart:convert';
import 'dart:async';
import '../models/user.dart';
import '../models/property.dart';

class MockService {
  // Simulation de latence réseau
  static Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

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
      }
    ]''';

    final List<dynamic> jsonList = json.decode(usersJson);
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

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
        "images": ["https://picsum.photos/400/300?random=1", "https://picsum.photos/400/300?random=2"],
        "equipments": ["eau courante", "electricite 24h", "securite", "parking"],
        "isAvailable": true,
        "ownerId": "1",
        "rating": 4.5,
        "viewsCount": 245,
        "createdAt": "2024-09-01T08:30:00Z"
      },
      {
        "id": "2",
        "title": "Studio Moderne",
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
        "images": ["https://picsum.photos/400/300?random=3"],
        "equipments": ["eau courante", "electricite", "internet"],
        "isAvailable": true,
        "ownerId": "3",
        "rating": 4.2,
        "viewsCount": 89,
        "createdAt": "2024-09-10T14:20:00Z"
      },
      {
        "id": "3",
        "title": "Maison 4 Chambres - Omnisport",
        "price": 250000,
        "currency": "XAF",
        "propertyType": "maison",
        "standing": "luxe",
        "rooms": 4,
        "bathrooms": 3,
        "surface": 200,
        "location": "Omnisport - Yaoundé - CAMEROUN",
        "quartier": "Omnisport",
        "ville": "Yaoundé",
        "description": "Magnifique maison familiale avec jardin. Construction récente avec finitions haut de gamme.",
        "images": ["https://picsum.photos/400/300?random=4", "https://picsum.photos/400/300?random=5"],
        "equipments": ["eau courante", "electricite 24h", "securite", "parking", "jardin", "climatisation"],
        "isAvailable": true,
        "ownerId": "1",
        "rating": 4.8,
        "viewsCount": 156,
        "createdAt": "2024-08-25T11:45:00Z"
      },
      {
        "id": "4",
        "title": "Appartement Meublé - Akwa",
        "price": 120000,
        "currency": "XAF",
        "propertyType": "appartement",
        "standing": "standard",
        "rooms": 2,
        "bathrooms": 1,
        "surface": 90,
        "location": "Akwa - Douala - CAMEROUN",
        "quartier": "Akwa",
        "ville": "Douala",
        "description": "Appartement meublé de 2 chambres avec balcon. Proche des commerces et des écoles.",
        "images": ["https://picsum.photos/400/300?random=6"],
        "equipments": ["eau courante", "electricite", "meubles", "wifi"],
        "isAvailable": true,
        "ownerId": "2",
        "rating": 4.1,
        "viewsCount": 102,
        "createdAt": "2024-09-05T09:00:00Z"
      },
      {
        "id": "5",
        "title": "Villa 5 Chambres avec Piscine - Bonapriso",
        "price": 450000,
        "currency": "XAF",
        "propertyType": "villa",
        "standing": "luxe",
        "rooms": 5,
        "bathrooms": 4,
        "surface": 350,
        "location": "Bonapriso - Douala - CAMEROUN",
        "quartier": "Bonapriso",
        "ville": "Douala",
        "description": "Superbe villa avec piscine privée et grand jardin. Quartier hautement résidentiel.",
        "images": ["https://picsum.photos/400/300?random=7", "https://picsum.photos/400/300?random=8", "https://picsum.photos/400/300?random=9"],
        "equipments": ["eau courante", "electricite 24h", "securite", "piscine", "jardin", "climatisation"],
        "isAvailable": true,
        "ownerId": "4",
        "rating": 4.9,
        "viewsCount": 300,
        "createdAt": "2024-07-30T16:15:00Z"
      },
      {
        "id": "6",
        "title": "Chambre Étudiante - Ngoa-Ekellé",
        "price": 35000,
        "currency": "XAF",
        "propertyType": "chambre",
        "standing": "economique",
        "rooms": 1,
        "bathrooms": 1,
        "surface": 20,
        "location": "Ngoa-Ekellé - Yaoundé - CAMEROUN",
        "quartier": "Ngoa-Ekellé",
        "ville": "Yaoundé",
        "description": "Chambre simple et économique à proximité de l’université. Idéal pour étudiants.",
        "images": ["https://picsum.photos/400/300?random=10"],
        "equipments": ["eau courante", "electricite"],
        "isAvailable": false,
        "ownerId": "5",
        "rating": 3.8,
        "viewsCount": 45,
        "createdAt": "2024-09-12T12:10:00Z"
      },
      {
        "id": "7",
        "title": "Duplex 3 Chambres - Santa Barbara",
        "price": 280000,
        "currency": "XAF",
        "propertyType": "duplex",
        "standing": "haut standing",
        "rooms": 3,
        "bathrooms": 3,
        "surface": 180,
        "location": "Santa Barbara - Yaoundé - CAMEROUN",
        "quartier": "Santa Barbara",
        "ville": "Yaoundé",
        "description": "Duplex moderne avec terrasse panoramique et espace de vie lumineux.",
        "images": ["https://picsum.photos/400/300?random=11", "https://picsum.photos/400/300?random=12"],
        "equipments": ["eau courante", "electricite 24h", "parking", "balcon", "climatisation"],
        "isAvailable": true,
        "ownerId": "6",
        "rating": 4.6,
        "viewsCount": 187,
        "createdAt": "2024-08-15T10:40:00Z"
      },
      {
        "id": "8",
        "title": "Maison Traditionnelle - Foumban",
        "price": 80000,
        "currency": "XAF",
        "propertyType": "maison",
        "standing": "standard",
        "rooms": 2,
        "bathrooms": 1,
        "surface": 85,
        "location": "Foumban - Ouest - CAMEROUN",
        "quartier": "Foumban",
        "ville": "Foumban",
        "description": "Maison traditionnelle avec architecture locale, idéale pour une immersion culturelle.",
        "images": ["https://picsum.photos/400/300?random=13"],
        "equipments": ["eau courante", "electricite"],
        "isAvailable": true,
        "ownerId": "7",
        "rating": 4.0,
        "viewsCount": 72,
        "createdAt": "2024-09-18T15:25:00Z"
      },
      {
        "id": "9",
        "title": "Appartement 2 Chambres - Makepe",
        "price": 100000,
        "currency": "XAF",
        "propertyType": "appartement",
        "standing": "standard",
        "rooms": 2,
        "bathrooms": 1,
        "surface": 75,
        "location": "Makepe - Douala - CAMEROUN",
        "quartier": "Makepe",
        "ville": "Douala",
        "description": "Appartement spacieux et lumineux, proche du marché et des transports.",
        "images": ["https://picsum.photos/400/300?random=14", "https://picsum.photos/400/300?random=15"],
        "equipments": ["eau courante", "electricite", "balcon"],
        "isAvailable": true,
        "ownerId": "8",
        "rating": 4.3,
        "viewsCount": 96,
        "createdAt": "2024-09-03T07:50:00Z"
      },
      {
        "id": "10",
        "title": "Penthouse 2 Chambres - Kribi Plage",
        "price": 300000,
        "currency": "XAF",
        "propertyType": "penthouse",
        "standing": "luxe",
        "rooms": 2,
        "bathrooms": 2,
        "surface": 150,
        "location": "Kribi - Littoral - CAMEROUN",
        "quartier": "Plage",
        "ville": "Kribi",
        "description": "Penthouse avec vue imprenable sur la mer, idéal pour vacances et séjours de luxe.",
        "images": ["https://picsum.photos/400/300?random=16", "https://picsum.photos/400/300?random=17"],
        "equipments": ["eau courante", "electricite 24h", "securite", "piscine", "vue mer"],
        "isAvailable": true,
        "ownerId": "9",
        "rating": 4.7,
        "viewsCount": 210,
        "createdAt": "2024-08-28T19:00:00Z"
      }
    ]''';


    final List<dynamic> jsonList = json.decode(propertiesJson);
    return jsonList.map((json) => Property.fromJson(json)).toList();
  }

  // Filtrer les propriétés par ville (pour différencier propriétaire/locataire)
  static Future<List<Property>> getPropertiesByCity(String city) async {
    final allProperties = await getProperties();
    return allProperties.where((p) => p.ville.toLowerCase().contains(city.toLowerCase())).toList();
  }
}