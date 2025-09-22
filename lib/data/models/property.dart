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
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      currency: json['currency'] ?? 'XAF',
      propertyType: PropertyType.values.firstWhere(
            (type) => type.name == json['propertyType'],
      ),
      standing: Standing.values.firstWhere(
            (standing) => standing.name == json['standing'],
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
    );
  }

  String get formattedPrice => '$price $currency';
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
    }
  }
}

enum PropertyType { appartement, maison, studio, chambre }
enum Standing { economique, standard, luxe }