class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;
  final String? businessName;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final Map<String, dynamic> settings;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    this.businessName,
    this.isPremium = false,
    required this.createdAt,
    this.lastLogin,
    this.settings = const {},
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'],
      displayName: map['displayName'],
      phoneNumber: map['phoneNumber'],
      photoURL: map['photoURL'],
      businessName: map['businessName'],
      isPremium: map['isPremium'] ?? false,
      createdAt: (map['createdAt'] as dynamic).toDate(),
      lastLogin: map['lastLogin'] != null ? (map['lastLogin'] as dynamic).toDate() : null,
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'businessName': businessName,
      'isPremium': isPremium,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'settings': settings,
    };
  }
}
