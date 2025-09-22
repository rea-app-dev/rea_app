class Conversation {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final List<String> participants;
  final List<ParticipantInfo> participantsInfo;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final bool isAccordTrouve;
  final int unreadCount;
  final bool isBlocked;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.participants,
    required this.participantsInfo,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSenderId,
    required this.isAccordTrouve,
    required this.unreadCount,
    required this.isBlocked,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      propertyId: json['propertyId'],
      propertyTitle: json['propertyTitle'],
      participants: List<String>.from(json['participants']),
      participantsInfo: (json['participantsInfo'] as List)
          .map((p) => ParticipantInfo.fromJson(p))
          .toList(),
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      lastMessageSenderId: json['lastMessageSenderId'],
      isAccordTrouve: json['isAccordTrouve'],
      unreadCount: json['unreadCount'],
      isBlocked: json['isBlocked'],
      messages: (json['messages'] as List)
          .map((m) => Message.fromJson(m))
          .toList(),
    );
  }
}

class ParticipantInfo {
  final String id;
  final String name;
  final String? avatar;
  final String userType;
  final bool isVerified;

  ParticipantInfo({
    required this.id,
    required this.name,
    this.avatar,
    required this.userType,
    required this.isVerified,
  });

  factory ParticipantInfo.fromJson(Map<String, dynamic> json) {
    return ParticipantInfo(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      userType: json['userType'],
      isVerified: json['isVerified'],
    );
  }
}

class Message {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String messageType;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.messageType,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'],
      messageType: json['messageType'] ?? 'text',
    );
  }
}