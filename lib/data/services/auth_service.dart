import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _baseUrl = 'https://api.rea-app.com/v1';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'current_user';
  static const String _refreshTokenKey = 'refresh_token';

  // TODO: Remplacer par vraies APIs
  // static Future<AuthResult> login({
  //   required String phone,
  //   required String password,
  //   required UserType userType,
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$_baseUrl/auth/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         'phone': phone,
  //         'password': password,
  //         'userType': userType.name,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body)['data'];
  //       final user = User.fromJson(data['user']);
  //       final token = data['token'];
  //       final refreshToken = data['refreshToken'];
  //
  //       await _saveAuthData(user, token, refreshToken);
  //       return AuthResult.success(user);
  //     } else if (response.statusCode == 401) {
  //       return AuthResult.error('Identifiants incorrects');
  //     } else {
  //       return AuthResult.error('Erreur de connexion: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     return AuthResult.error('Erreur réseau: $e');
  //   }
  // }

  /// Connexion utilisateur (version mock)
  static Future<AuthResult> login({
    required String phone,
    required String password,
    required UserType userType,
  }) async {
    try {
      print('Etape 1');
      // Simulation de délai réseau
      await Future.delayed(const Duration(seconds: 1));

      // Validation basique (mock)
      if (phone.isEmpty || password.isEmpty) {
        return AuthResult.error('Téléphone et mot de passe requis');
      }

      if (phone.length < 9) {
        return AuthResult.error('Numéro de téléphone invalide');
      }

      if (password.length < 4) {
        return AuthResult.error('Mot de passe trop court');
      }

      print('Etape 2');

      // Simulation d'utilisateur mock basé sur le téléphone
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: '${phone.replaceAll('+', '').replaceAll(' ', '')}@example.com',
        phone: phone,
        firstName: _generateFirstName(phone),
        lastName: _generateLastName(phone),
        userType: userType,
        location: userType == UserType.locataire ? 'Douala' : 'Yaoundé',
        createdAt: DateTime.now(),
        isKycVerified: userType == UserType.proprietaire,
      );

      print('Etape 3');

      // Sauvegarder les données d'authentification
      await _saveAuthData(user, 'mock_token_${user.id}', 'mock_refresh_${user.id}');

      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.error('Erreur lors de la connexion: $e');
    }
  }

  // TODO: Remplacer par vraie API
  // static Future<AuthResult> register(Map<String, dynamic> userData) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$_baseUrl/auth/register'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(userData),
  //     );
  //
  //     if (response.statusCode == 201) {
  //       final data = json.decode(response.body)['data'];
  //       final user = User.fromJson(data['user']);
  //       final token = data['token'];
  //       final refreshToken = data['refreshToken'];
  //
  //       await _saveAuthData(user, token, refreshToken);
  //       return AuthResult.success(user);
  //     } else if (response.statusCode == 409) {
  //       return AuthResult.error('Cet utilisateur existe déjà');
  //     } else {
  //       return AuthResult.error('Erreur d\'inscription: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     return AuthResult.error('Erreur réseau: $e');
  //   }
  // }

  /// Inscription utilisateur (version mock)
  static Future<AuthResult> register(Map<String, dynamic> userData) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      // Validation des données
      final requiredFields = ['firstName', 'lastName', 'phone', 'userType'];
      for (String field in requiredFields) {
        if (userData[field] == null || userData[field].toString().isEmpty) {
          return AuthResult.error('Le champ $field est requis');
        }
      }

      final phone = userData['phone'] as String;
      if (phone.length < 9) {
        return AuthResult.error('Numéro de téléphone invalide');
      }

      // Simuler une vérification d'unicité
      if (phone == '+237677123456') {
        return AuthResult.error('Ce numéro de téléphone est déjà utilisé');
      }

      final user = User.fromJson({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'email': userData['email'] ?? '${phone.replaceAll('+', '').replaceAll(' ', '')}@example.com',
        'createdAt': DateTime.now().toIso8601String(),
        ...userData,
      });

      await _saveAuthData(user, 'mock_token_${user.id}', 'mock_refresh_${user.id}');
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.error('Erreur lors de l\'inscription: $e');
    }
  }

  // TODO: Remplacer par vraie API
  // static Future<bool> logout() async {
  //   try {
  //     final token = await getToken();
  //     if (token != null) {
  //       await http.post(
  //         Uri.parse('$_baseUrl/auth/logout'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     // Continue même en cas d'erreur API
  //   }
  //   
  //   await _clearAuthData();
  //   return true;
  // }

  /// Déconnexion
  static Future<bool> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await _clearAuthData();
      return true;
    } catch (e) {
      return false;
    }
  }

  // TODO: Remplacer par vraie API
  // static Future<AuthResult> refreshToken() async {
  //   try {
  //     final refreshToken = await getRefreshToken();
  //     if (refreshToken == null) {
  //       return AuthResult.error('Aucun token de rafraîchissement');
  //     }
  //
  //     final response = await http.post(
  //       Uri.parse('$_baseUrl/auth/refresh'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({'refreshToken': refreshToken}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body)['data'];
  //       final user = User.fromJson(data['user']);
  //       final newToken = data['token'];
  //       final newRefreshToken = data['refreshToken'];
  //
  //       await _saveAuthData(user, newToken, newRefreshToken);
  //       return AuthResult.success(user);
  //     } else {
  //       await _clearAuthData();
  //       return AuthResult.error('Session expirée');
  //     }
  //   } catch (e) {
  //     return AuthResult.error('Erreur lors du rafraîchissement: $e');
  //   }
  // }

  /// Rafraîchissement du token (mock)
  static Future<AuthResult> refreshToken() async {
    try {
      final user = await getCurrentUser();
      final refreshToken = await getRefreshToken();

      if (user == null || refreshToken == null) {
        return AuthResult.error('Session expirée');
      }

      await Future.delayed(const Duration(milliseconds: 300));

      // Simuler un nouveau token
      final newToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      final newRefreshToken = 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}';

      await _saveAuthData(user, newToken, newRefreshToken);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.error('Erreur lors du rafraîchissement: $e');
    }
  }

  /// Vérifier si l'utilisateur est connecté
  static Future<bool> isAuthenticated() async {
    try {
      final token = await getToken();
      final user = await getCurrentUser();
      return token != null && user != null;
    } catch (e) {
      return false;
    }
  }

  /// Récupérer le token d'authentification
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Récupérer le refresh token
  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Récupérer l'utilisateur actuel
  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return User.fromJson(json.decode(userJson));
      }
    } catch (e) {
      // Ignore errors
    }
    return null;
  }

  /// Sauvegarder les données d'authentification
  static Future<void> _saveAuthData(User user, String token, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  /// Effacer les données d'authentification
  static Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
  }

  /// Mettre à jour les informations utilisateur
  static Future<AuthResult> updateUserProfile(User updatedUser) async {
    try {
      // TODO: Appel API réel
      // final token = await getToken();
      // final response = await http.put(
      //   Uri.parse('$_baseUrl/users/${updatedUser.id}'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      //   body: json.encode(updatedUser.toJson()),
      // );

      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(updatedUser.toJson()));

      return AuthResult.success(updatedUser);
    } catch (e) {
      return AuthResult.error('Erreur lors de la mise à jour: $e');
    }
  }

  /// Changer le mot de passe
  static Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      // TODO: Appel API réel
      // final token = await getToken();
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/auth/change-password'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      //   body: json.encode({
      //     'oldPassword': oldPassword,
      //     'newPassword': newPassword,
      //   }),
      // );

      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Demander une réinitialisation de mot de passe
  static Future<bool> requestPasswordReset(String phone) async {
    try {
      // TODO: Appel API réel
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/auth/forgot-password'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({'phone': phone}),
      // );

      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Fonctions utilitaires pour mock
  static String _generateFirstName(String phone) {
    final lastDigits = phone.replaceAll(RegExp(r'[^\d]'), '').substring(phone.length - 3);
    final names = ['André', 'Paul', 'Marie', 'Nadia', 'Jean', 'Fatima', 'Albert', 'Sophie'];
    return names[int.parse(lastDigits.substring(0, 1)) % names.length];
  }

  static String _generateLastName(String phone) {
    final lastDigits = phone.replaceAll(RegExp(r'[^\d]'), '').substring(phone.length - 2);
    final names = ['TALLA', 'BIYA', 'NGUYEN', 'SEBASTIAN', 'DUPONT', 'KAMGA', 'MVONDO', 'ATEBA'];
    return names[int.parse(lastDigits) % names.length];
  }
}

/// Classe pour les résultats d'authentification
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
  });

  factory AuthResult.success(User user) {
    return AuthResult._(isSuccess: true, user: user);
  }

  factory AuthResult.error(String message) {
    return AuthResult._(isSuccess: false, errorMessage: message);
  }
}