
import 'package:flutter/material.dart';
import 'package:reaapp/data/models/category.dart';

import '../data/services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Category> get categories => _categories;
  List<Category> get activeCategories => _categories.where((c) => c.isActive).toList();
  Category? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Chargement des catégories
  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await CategoryService.getCategories();
      _categories.sort((a, b) => a.order.compareTo(b.order));
    } catch (e) {
      _errorMessage = 'Erreur lors du chargement des catégories: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sélection d'une catégorie
  void selectCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Sélection par ID
  void selectCategoryById(String? categoryId) {
    if (categoryId == null) {
      _selectedCategory = null;
    } else {
      _selectedCategory = _categories.firstWhere(
            (category) => category.id == categoryId,
        orElse: () => _categories.first,
      );
    }
    notifyListeners();
  }

  // Recherche de catégories
  Future<List<Category>> searchCategories(String query) async {
    try {
      return await CategoryService.searchCategories(query);
    } catch (e) {
      debugPrint('Erreur lors de la recherche de catégories: $e');
      return [];
    }
  }

  // Récupération d'une catégorie par ID
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // Reset de la sélection
  void clearSelection() {
    _selectedCategory = null;
    notifyListeners();
  }

  // Rechargement des catégories
  Future<void> refresh() async {
    await loadCategories();
  }

  // Vérification si une catégorie est sélectionnée
  bool isCategorySelected(String categoryId) {
    return _selectedCategory?.id == categoryId;
  }

  // Obtenir la couleur d'une catégorie
  String getCategoryColor(String categoryId) {
    final category = getCategoryById(categoryId);
    return category?.color ?? '#2196F3';
  }

  // Obtenir l'icône d'une catégorie
  String getCategoryIcon(String categoryId) {
    final category = getCategoryById(categoryId);
    return category?.icon ?? 'home';
  }
}