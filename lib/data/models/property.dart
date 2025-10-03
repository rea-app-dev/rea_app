import 'category.dart';

class Property {
  final String id;
  final String title;
  final int price;
  final String currency;
  final PropertyType propertyType;
  final Standing standing;
  final int rooms;
  final int bathrooms;
  final int surface;
  final String location;
  final String quartier;
  final String ville;
  final String description;
  final List<String> images;
  final List<String> equipments;
  final bool isAvailable;
  final String ownerId;
  final double rating;
  final int viewsCount;
  final DateTime createdAt;
  final PropertyCategory category;
  final List<String>? tags; // Pour les caractéristiques supplémentaires

  Property({
    required this.id,
    required this.title,
    required this.price,
    this.currency = 'XAF',
    required this.propertyType,
    required this.standing,
    required this.rooms,
    required this.bathrooms,
    required this.surface,
    required this.location,
    required this.quartier,
    required this.ville,
    required this.description,
    required this.images,
    required this.equipments,
    required this.isAvailable,
    required this.ownerId,
    required this.rating,
    required this.viewsCount,
    required this.createdAt,
    this.category = PropertyCategory.residential,
    this.tags,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      currency: json['currency'] ?? 'XAF',
      propertyType: PropertyType.values.firstWhere(
            (type) => type.name == json['propertyType'],
        orElse: () => PropertyType.appartement,
      ),
      standing: Standing.values.firstWhere(
            (standing) => standing.name == json['standing'] ||
            standing.name == json['standing']?.replaceAll(' ', '').toLowerCase(),
        orElse: () => Standing.standard,
      ),
      rooms: json['rooms'],
      bathrooms: json['bathrooms'],
      surface: json['surface'],
      location: json['location'],
      quartier: json['quartier'],
      ville: json['ville'],
      description: json['description'],
      images: List<String>.from(json['images']),
      equipments: List<String>.from(json['equipments']),
      isAvailable: json['isAvailable'],
      ownerId: json['ownerId'],
      rating: json['rating'].toDouble(),
      viewsCount: json['viewsCount'],
      createdAt: DateTime.parse(json['createdAt']),
      category: json['category'] != null
          ? PropertyCategory.fromString(json['category'])
          : PropertyCategory.residential,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'currency': currency,
      'propertyType': propertyType.name,
      'standing': standing.name,
      'rooms': rooms,
      'bathrooms': bathrooms,
      'surface': surface,
      'location': location,
      'quartier': quartier,
      'ville': ville,
      'description': description,
      'images': images,
      'equipments': equipments,
      'isAvailable': isAvailable,
      'ownerId': ownerId,
      'rating': rating,
      'viewsCount': viewsCount,
      'createdAt': createdAt.toIso8601String(),
      'category': category.key,
      'tags': tags,
    };
  }

  String get formattedPrice {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M $currency';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K $currency';
    }
    return '$price $currency';
  }

  String get propertyTypeText {
    switch (propertyType) {
      case PropertyType.appartement:
        return 'Appartement';
      case PropertyType.maison:
        return 'Maison';
      case PropertyType.studio:
        return 'Studio';
      case PropertyType.chambre:
        return 'Chambre';
      case PropertyType.villa:
        return 'Villa';
      case PropertyType.duplex:
        return 'Duplex';
      case PropertyType.penthouse:
        return 'Penthouse';
    }
  }

  String get standingText {
    switch (standing) {
      case Standing.economique:
        return 'Économique';
      case Standing.standard:
        return 'Standard';
      case Standing.luxe:
        return 'Luxe';
      case Standing.hautStanding:
        return 'Haut Standing';
    }
  }

  Property copyWith({
    String? id,
    String? title,
    int? price,
    String? currency,
    PropertyType? propertyType,
    Standing? standing,
    int? rooms,
    int? bathrooms,
    int? surface,
    String? location,
    String? quartier,
    String? ville,
    String? description,
    List<String>? images,
    List<String>? equipments,
    bool? isAvailable,
    String? ownerId,
    double? rating,
    int? viewsCount,
    DateTime? createdAt,
    PropertyCategory? category,
    List<String>? tags,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      propertyType: propertyType ?? this.propertyType,
      standing: standing ?? this.standing,
      rooms: rooms ?? this.rooms,
      bathrooms: bathrooms ?? this.bathrooms,
      surface: surface ?? this.surface,
      location: location ?? this.location,
      quartier: quartier ?? this.quartier,
      ville: ville ?? this.ville,
      description: description ?? this.description,
      images: images ?? this.images,
      equipments: equipments ?? this.equipments,
      isAvailable: isAvailable ?? this.isAvailable,
      ownerId: ownerId ?? this.ownerId,
      rating: rating ?? this.rating,
      viewsCount: viewsCount ?? this.viewsCount,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }
}

// Enum étendu pour les types de propriétés
enum PropertyType {
  appartement,
  maison,
  studio,
  chambre,
  villa,
  duplex,
  penthouse,
}

// Enum étendu pour le standing
enum Standing {
  economique,
  standard,
  luxe,
  hautStanding, // Pour "haut standing"
}