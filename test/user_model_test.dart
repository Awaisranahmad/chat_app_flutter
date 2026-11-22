import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chat_app/models/user.dart';

void main() {
  group('UserModel.fromMap', () {
    test('maps every field', () {
      final createdAt = DateTime(2026, 11, 22, 11, 0);
      final lastSeen = DateTime(2026, 11, 22, 11, 30);

      final user = UserModel.fromMap({
        'name': 'Awais',
        'email': 'awais@example.com',
        'isOnline': true,
        'lastSeen': Timestamp.fromDate(lastSeen),
        'createdAt': Timestamp.fromDate(createdAt),
      }, 'uid-123');

      expect(user.uid, 'uid-123');
      expect(user.name, 'Awais');
      expect(user.email, 'awais@example.com');
      expect(user.isOnline, isTrue);
      expect(user.lastSeen, lastSeen);
      expect(user.createdAt, createdAt);
    });

    test('fills safe defaults for missing fields', () {
      final user = UserModel.fromMap({}, 'uid-456');

      expect(user.uid, 'uid-456');
      expect(user.name, '');
      expect(user.email, '');
      expect(user.isOnline, isFalse);
      expect(user.lastSeen, isNotNull);
      expect(user.createdAt, isNotNull);
    });
  });

  group('UserModel.toMap', () {
    test('round-trips through fromMap', () {
      final original = UserModel(
        uid: 'uid-789',
        name: 'Awais',
        email: 'awais@example.com',
        isOnline: true,
        lastSeen: DateTime(2026, 11, 22, 11, 30),
        createdAt: DateTime(2026, 11, 22, 11, 0),
      );

      final restored = UserModel.fromMap(original.toMap(), original.uid);

      expect(restored.uid, original.uid);
      expect(restored.name, original.name);
      expect(restored.email, original.email);
      expect(restored.isOnline, original.isOnline);
      expect(restored.lastSeen, original.lastSeen);
      expect(restored.createdAt, original.createdAt);
    });

    test('contains every field', () {
      final map = UserModel(
        uid: 'uid-000',
        name: 'Awais',
        email: 'awais@example.com',
        isOnline: false,
        lastSeen: DateTime(2026, 11, 22, 11, 30),
        createdAt: DateTime(2026, 11, 22, 11, 0),
      ).toMap();

      expect(
        map.keys,
        containsAll(['name', 'email', 'uid', 'isOnline', 'lastSeen', 'createdAt']),
      );
    });
  });
}
