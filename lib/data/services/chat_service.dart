// lib/data/services/chat_service.dart
import 'dart:convert';
import 'dart:math';
import '../models/conversation.dart';

class ChatService {
  static const String _baseUrl = 'https://api.rea-app.com'; // Remplacez par votre URL d'API

  /// Récupère toutes les conversations d'un utilisateur
  static Future<List<Conversation>> getUserConversations(String userId) async {
    try {
      // TODO: Remplacer par un vrai appel API
      // final response = await http.get(
      //   Uri.parse('$_baseUrl/conversations/$userId'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );

      // Simulation avec délai réseau
      await Future.delayed(const Duration(milliseconds: 500));

      // Retourne les données mock pour tous les utilisateurs (pour test)
      return _getMockConversations();
    } catch (e) {
      print('Erreur lors du chargement des conversations: $e');
      return [];
    }
  }

  /// Récupère une conversation spécifique avec tous ses messages
  static Future<Conversation?> getConversation(String conversationId) async {
    try {
      // TODO: Remplacer par un vrai appel API
      // final response = await http.get(
      //   Uri.parse('$_baseUrl/conversations/$conversationId'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );

      await Future.delayed(const Duration(milliseconds: 300));

      final conversations = _getMockConversations();
      return conversations.firstWhere(
            (conv) => conv.id == conversationId,
        orElse: () => conversations.first,
      );
    } catch (e) {
      print('Erreur lors du chargement de la conversation: $e');
      return null;
    }
  }

  /// Envoie un nouveau message
  static Future<bool> sendMessage(
      String conversationId,
      String senderId,
      String content,
      ) async {
    try {
      // TODO: Remplacer par un vrai appel API
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/conversations/$conversationId/messages'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      //   body: json.encode({
      //     'senderId': senderId,
      //     'content': content,
      //     'messageType': 'text',
      //   }),
      // );

      // Simulation d'envoi avec délai
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulation de succès (90% du temps)
      return Random().nextDouble() > 0.1;
    } catch (e) {
      print('Erreur lors de l\'envoi du message: $e');
      return false;
    }
  }

  /// Marque un message comme lu
  static Future<bool> markAsRead(String conversationId, String messageId) async {
    try {
      // TODO: Remplacer par un vrai appel API
      // final response = await http.patch(
      //   Uri.parse('$_baseUrl/messages/$messageId/read'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );

      await Future.delayed(const Duration(milliseconds: 200));
      return true;
    } catch (e) {
      print('Erreur lors du marquage comme lu: $e');
      return false;
    }
  }

  /// Marque toute une conversation comme lue
  static Future<bool> markConversationAsRead(String conversationId) async {
    try {
      // TODO: Remplacer par un vrai appel API
      await Future.delayed(const Duration(milliseconds: 300));
      return true;
    } catch (e) {
      print('Erreur lors du marquage de la conversation comme lue: $e');
      return false;
    }
  }

  /// Active/désactive l'état "Accord Trouvé" pour les propriétaires
  static Future<bool> markAccordTrouve(String conversationId, bool isAccord) async {
    try {
      // TODO: Remplacer par un vrai appel API
      // final response = await http.patch(
      //   Uri.parse('$_baseUrl/conversations/$conversationId/agreement'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      //   body: json.encode({'hasAgreement': isAccord}),
      // );

      await Future.delayed(const Duration(milliseconds: 600));
      return true;
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'accord: $e');
      return false;
    }
  }

  /// Crée une nouvelle conversation (quand un locataire contacte un propriétaire)
  static Future<String?> createConversation({
    required String senderId,
    required String receiverId,
    required String propertyId,
    required String propertyTitle,
    required String initialMessage,
  }) async {
    try {
      // TODO: Remplacer par un vrai appel API
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/conversations'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      //   body: json.encode({
      //     'participants': [senderId, receiverId],
      //     'propertyId': propertyId,
      //     'propertyTitle': propertyTitle,
      //     'initialMessage': initialMessage,
      //   }),
      // );

      await Future.delayed(const Duration(milliseconds: 1000));

      // Retourne l'ID de la nouvelle conversation
      return 'conv_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      print('Erreur lors de la création de la conversation: $e');
      return null;
    }
  }

  /// Supprime une conversation (pour le propriétaire seulement)
  static Future<bool> deleteConversation(String conversationId) async {
    try {
      // TODO: Remplacer par un vrai appel API
      // final response = await http.delete(
      //   Uri.parse('$_baseUrl/conversations/$conversationId'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );

      await Future.delayed(const Duration(milliseconds: 400));
      return true;
    } catch (e) {
      print('Erreur lors de la suppression de la conversation: $e');
      return false;
    }
  }

  /// Recherche dans les conversations
  static Future<List<Conversation>> searchConversations(
      String userId,
      String query,
      ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final allConversations = _getMockConversations();

      return allConversations.where((conversation) {
        // Recherche dans les noms des participants et le titre de la propriété
        final searchInParticipants = conversation.participantsInfo
            .any((p) => p.name.toLowerCase().contains(query.toLowerCase()));
        final searchInProperty = conversation.propertyTitle
            .toLowerCase().contains(query.toLowerCase());
        final searchInLastMessage = conversation.lastMessage
            .toLowerCase().contains(query.toLowerCase());

        return searchInParticipants || searchInProperty || searchInLastMessage;
      }).toList();
    } catch (e) {
      print('Erreur lors de la recherche: $e');
      return [];
    }
  }

  /// Récupère le nombre de messages non lus pour un utilisateur
  static Future<int> getUnreadCount(String userId) async {
    try {
      // TODO: Remplacer par un vrai appel API
      await Future.delayed(const Duration(milliseconds: 200));

      final conversations = _getMockConversations();
      return conversations.fold<int>(
        0,
            (total, conversation) => total + conversation.unreadCount,
      );
    } catch (e) {
      print('Erreur lors du comptage des messages non lus: $e');
      return 0;
    }
  }

  // DONNÉES MOCK - À remplacer par de vraies API calls
  static List<Conversation> _getMockConversations() {
    const conversationsJson = '''[
      {
        "id": "conv_1",
        "participants": ["1", "2"],
        "participantsInfo": [
          {
            "id": "1",
            "name": "Jean Dupont",
            "avatar": "",
            "userType": "proprietaire",
            "isVerified": true
          },
          {
            "id": "2",
            "name": "Marie Martin",
            "avatar": "",
            "userType": "locataire",
            "isVerified": false
          }
        ],
        "propertyId": "prop_1",
        "propertyTitle": "Appartement 2 pièces Yaoundé Centre",
        "lastMessage": "Parfait, je prends ! Les conditions me conviennent",
        "lastMessageTime": "2024-09-19T16:30:00Z",
        "lastMessageSenderId": "2",
        "unreadCount": 2,
        "isAccordTrouve": true,
        "isBlocked": false,
        "messages": [
          {
            "id": "msg1",
            "senderId": "2",
            "content": "Bonjour, je suis intéressée par votre appartement. Est-il toujours disponible ?",
            "timestamp": "2024-09-15T08:30:00Z",
            "isRead": true,
            "messageType": "text"
          },
          {
            "id": "msg5",
            "senderId": "2",
            "content": "Parfait, je prends ! Les conditions me conviennent",
            "timestamp": "2024-09-19T16:30:00Z",
            "isRead": false,
            "messageType": "text"
          }
        ]
      },
      {
        "id": "conv_2",
        "participants": ["1", "3"],
        "participantsInfo": [
          {
            "id": "1",
            "name": "Jean Dupont",
            "avatar": "",
            "userType": "proprietaire",
            "isVerified": true
          },
          {
            "id": "3",
            "name": "NADIA Sebastian",
            "avatar": "",
            "userType": "locataire",
            "isVerified": false
          }
        ],
        "propertyId": "prop_2",
        "propertyTitle": "Villa 4 pièces Douala Akwa",
        "lastMessage": "Bonjour Lic",
        "lastMessageTime": "2024-09-19T14:10:00Z",
        "lastMessageSenderId": "3",
        "unreadCount": 1,
        "isAccordTrouve": false,
        "isBlocked": false,
        "messages": [
          {
            "id": "msg8",
            "senderId": "3",
            "content": "Bonjour Lic",
            "timestamp": "2024-09-19T14:10:00Z",
            "isRead": false,
            "messageType": "text"
          }
        ]
      },
      {
        "id": "conv_3",
        "participants": ["1", "4"],
        "participantsInfo": [
          {
            "id": "1",
            "name": "Jean Dupont", 
            "avatar": "",
            "userType": "proprietaire",
            "isVerified": true
          },
          {
            "id": "4",
            "name": "ANDRE-MARIE TALLA",
            "avatar": "",
            "userType": "locataire",
            "isVerified": false
          }
        ],
        "propertyId": "prop_3",
        "propertyTitle": "Studio meublé Yaoundé Melen",
        "lastMessage": "Accord.",
        "lastMessageTime": "2024-09-18T20:09:00Z",
        "lastMessageSenderId": "4",
        "unreadCount": 0,
        "isAccordTrouve": true,
        "isBlocked": false,
        "messages": [
          {
            "id": "msg11",
            "senderId": "4",
            "content": "Accord.",
            "timestamp": "2024-09-18T20:09:00Z",
            "isRead": true,
            "messageType": "text"
          }
        ]
      }
    ]''';

    final List<dynamic> jsonList = json.decode(conversationsJson);
    return jsonList.map((json) => Conversation.fromJson(json)).toList();
  }
}