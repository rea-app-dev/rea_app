import 'package:flutter/foundation.dart';
import '../data/models/user.dart';
import '../data/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  /// Initialiser le provider au démarrage de l'app
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Vérifier si un utilisateur est déjà connecté
      final isAuth = await AuthService.isAuthenticated();
      if (isAuth) {
        _currentUser = await AuthService.getCurrentUser();
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation de l\'auth: $e');
      _errorMessage = 'Erreur d\'initialisation';
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Connexion utilisateur
  Future<bool> login(String phone, String password, UserType userType) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await AuthService.login(
        phone: phone,
        password: password,
        userType: userType,
      );

      if (result.isSuccess) {
        _currentUser = result.user;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.errorMessage;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur de connexion: $e';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inscription utilisateur
  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await AuthService.register(userData);

      if (result.isSuccess) {
        _currentUser = result.user;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.errorMessage;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur d\'inscription: $e';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Déconnexion utilisateur
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await AuthService.logout();
      _currentUser = null;
      _errorMessage = null;
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion: $e');
      // Forcer la déconnexion même en cas d'erreur
      _currentUser = null;
      _errorMessage = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Rafraîchir le token d'authentification
  Future<bool> refreshAuthToken() async {
    try {
      final result = await AuthService.refreshToken();

      if (result.isSuccess) {
        _currentUser = result.user;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        // Token invalide, déconnecter l'utilisateur
        await logout();
        return false;
      }
    } catch (e) {
      debugPrint('Erreur lors du rafraîchissement du token: $e');
      await logout();
      return false;
    }
  }

  /// Mettre à jour le profil utilisateur
  Future<bool> updateUserProfile(User updatedUser) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await AuthService.updateUserProfile(updatedUser);

      if (result.isSuccess) {
        _currentUser = result.user;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.errorMessage;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur de mise à jour: $e';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Changer le mot de passe
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await AuthService.changePassword(oldPassword, newPassword);

      if (!success) {
        _errorMessage = 'Erreur lors du changement de mot de passe';
      }

      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Erreur: $e';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Demander une réinitialisation de mot de passe
  Future<bool> requestPasswordReset(String phone) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await AuthService.requestPasswordReset(phone);

      if (!success) {
        _errorMessage = 'Erreur lors de la demande de réinitialisation';
      }

      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Erreur: $e';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Vérifier la validité du token en arrière-plan
  Future<void> checkTokenValidity() async {
    if (!isAuthenticated) return;

    try {
      final isValid = await AuthService.isAuthenticated();
      if (!isValid) {
        await refreshAuthToken();
      }
    } catch (e) {
      debugPrint('Erreur lors de la vérification du token: $e');
    }
  }

  /// Effacer les messages d'erreur
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Obtenir les informations utilisateur formatées
  String get userDisplayName {
    if (_currentUser == null) return '';
    return _currentUser!.fullName;
  }

  String get userInitials {
    if (_currentUser == null) return 'U';
    final names = _currentUser!.fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }

  bool get isOwner => _currentUser?.userType == UserType.proprietaire;
  bool get isTenant => _currentUser?.userType == UserType.locataire;
  bool get isKycVerified => _currentUser?.isKycVerified ?? false;

  /// Basculer le type d'utilisateur (pour les comptes pouvant être les deux)
  Future<bool> switchUserType(UserType newType) async {
    if (_currentUser == null || _currentUser!.userType == newType) {
      return false;
    }

    try {
      final updatedUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        firstName: _currentUser!.firstName,
        lastName: _currentUser!.lastName,
        userType: newType,
        profilePicture: _currentUser!.profilePicture,
        isKycVerified: _currentUser!.isKycVerified,
        location: _currentUser!.location,
        createdAt: _currentUser!.createdAt,
      );

      return await updateUserProfile(updatedUser);
    } catch (e) {
      debugPrint('Erreur lors du changement de type d\'utilisateur: $e');
      return false;
    }
  }

  /// Statistiques utilisateur (pour debug/admin)
  Map<String, dynamic> get userStats {
    return {
      'isAuthenticated': isAuthenticated,
      'isKycVerified': isKycVerified,
      'userType': _currentUser?.userType.name ?? 'none',
      'userId': _currentUser?.id ?? 'none',
      'location': _currentUser?.location ?? 'unknown',
      'lastError': _errorMessage,
    };
  }

  /// Reset complet du provider (pour tests)
  void reset() {
    _currentUser = null;
    _isLoading = false;
    _errorMessage = null;
    _isInitialized = false;
    notifyListeners();
  }
}