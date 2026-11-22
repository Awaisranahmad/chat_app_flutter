import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.isOnline,
    required this.lastSeen,
    required this.createdAt,
  });

  /// Firestore returns [Timestamp] for date fields, while [toMap] stores
  /// [DateTime] — accept both so a map round-trips without a cast error.
  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: (data['name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      isOnline: (data['isOnline'] as bool?) ?? false,
      lastSeen: _toDateTime(data['lastSeen']),
      createdAt: _toDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
    };
  }
}
