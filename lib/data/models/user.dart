class User {
  final String id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final UserType userType;
  final String? profilePicture;
  final bool isKycVerified;
  final String location;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.userType,
    this.profilePicture,
    this.isKycVerified = false,
    required this.location,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userType: UserType.values.firstWhere(
            (type) => type.name == json['userType'],
      ),
      profilePicture: json['profilePicture'],
      isKycVerified: json['isKycVerified'] ?? false,
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'userType': userType.name,
      'profilePicture': profilePicture,
      'isKycVerified': isKycVerified,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';
}

enum UserType { proprietaire, locataire }
