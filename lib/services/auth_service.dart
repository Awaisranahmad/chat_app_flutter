import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Signup with email/password
  Future<User?> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCredential.user!.uid,
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An unknown authentication error occurred.";
    }
  }

  // Login with email/password
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user status to online
      await _firestore.collection('users').doc(userCredential.user!.uid).update(
        {'isOnline': true, 'lastSeen': FieldValue.serverTimestamp()},
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An unknown authentication error occurred.";
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'isOnline': false,
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An unknown authentication error occurred.";
    }
  }
}
