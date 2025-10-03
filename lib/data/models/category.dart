class Category {
  final String id;
  final String name;
  final String description;
  final String icon; // Nom de l'icône ou URL
  final String color; // Couleur hex
  final bool isActive;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.isActive = true,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      isActive: json['isActive'] ?? true,
      order: json['order'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'isActive': isActive,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    bool? isActive,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Enum pour les catégories prédéfinies
enum PropertyCategory {
  residential('residential', 'Résidentiel', 'Appartements, maisons, studios'),
  commercial('commercial', 'Commercial', 'Bureaux, magasins, entrepôts'),
  land('land', 'Terrain', 'Terrains à bâtir, agricoles'),
  special('special', 'Spécial', 'Locations de vacances, colocations');

  const PropertyCategory(this.key, this.displayName, this.description);

  final String key;
  final String displayName;
  final String description;

  static PropertyCategory fromString(String key) {
    return PropertyCategory.values.firstWhere(
          (category) => category.key == key,
      orElse: () => PropertyCategory.residential,
    );
  }
}