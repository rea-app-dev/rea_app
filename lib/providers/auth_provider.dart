import 'package:flutter/foundation.dart';
import '../data/models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  Future<void> login(String phone, String code, UserType userType) async {
    _isLoading = true;
    notifyListeners();

    // Simulation d'une requête API
    await Future.delayed(const Duration(seconds: 1));

    // Mock user pour les tests
    _currentUser = User(
      id: '1',
      email: 'user@example.com',
      phone: phone,
      firstName: 'John',
      lastName: 'Doe',
      userType: userType,
      location: userType == UserType.locataire ? 'Sénégal' : 'Yaoundé',
      createdAt: DateTime.now(),
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();

    // Simulation d'une requête API
    await Future.delayed(const Duration(seconds: 2));

    _currentUser = User.fromJson({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'createdAt': DateTime.now().toIso8601String(),
      ...userData,
    });

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
