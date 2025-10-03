import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  static const String _baseUrl = 'https://api.rea-app.com/v1';

  // TODO: Remplacer par la vraie API
  // static Future<List<Category>> getCategories() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$_baseUrl/categories'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body)['data'];
  //       return jsonData.map((json) => Category.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load categories: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching categories: $e');
  //   }
  // }

  /// Récupère toutes les catégories (version mock)
  static Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      Category(
        id: '1',
        name: 'Résidentiel',
        description: 'Appartements, maisons, studios pour habitation',
        icon: 'home',
        color: '#2196F3',
        order: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '2',
        name: 'Commercial',
        description: 'Bureaux, magasins, entrepôts pour activités commerciales',
        icon: 'business',
        color: '#4CAF50',
        order: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '3',
        name: 'Terrain',
        description: 'Terrains à bâtir, agricoles ou industriels',
        icon: 'landscape',
        color: '#FF9800',
        order: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '4',
        name: 'Spécial',
        description: 'Locations de vacances, colocations, temporaires',
        icon: 'star',
        color: '#E91E63',
        order: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Récupère une catégorie par son ID
  static Future<Category?> getCategoryById(String id) async {
    try {
      final categories = await getCategories();
      return categories.firstWhere(
            (category) => category.id == id,
        orElse: () => throw Exception('Category not found'),
      );
    } catch (e) {
      return null;
    }
  }

  // TODO: API pour créer une catégorie (Admin seulement)
  // static Future<Category?> createCategory(Category category) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$_baseUrl/categories'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $adminToken',
  //       },
  //       body: json.encode(category.toJson()),
  //     );
  //
  //     if (response.statusCode == 201) {
  //       final jsonData = json.decode(response.body)['data'];
  //       return Category.fromJson(jsonData);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception('Error creating category: $e');
  //   }
  // }

  // TODO: API pour mettre à jour une catégorie
  // static Future<Category?> updateCategory(Category category) async {
  //   try {
  //     final response = await http.put(
  //       Uri.parse('$_baseUrl/categories/${category.id}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $adminToken',
  //       },
  //       body: json.encode(category.toJson()),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body)['data'];
  //       return Category.fromJson(jsonData);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception('Error updating category: $e');
  //   }
  // }

  // TODO: API pour supprimer une catégorie
  // static Future<bool> deleteCategory(String id) async {
  //   try {
  //     final response = await http.delete(
  //       Uri.parse('$_baseUrl/categories/$id'),
  //       headers: {
  //         'Authorization': 'Bearer $adminToken',
  //       },
  //     );
  //
  //     return response.statusCode == 200;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  /// Récupère les catégories actives uniquement
  static Future<List<Category>> getActiveCategories() async {
    final categories = await getCategories();
    return categories.where((category) => category.isActive).toList();
  }

  /// Filtre les catégories par nom
  static Future<List<Category>> searchCategories(String query) async {
    final categories = await getCategories();
    return categories.where((category) =>
    category.name.toLowerCase().contains(query.toLowerCase()) ||
        category.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}