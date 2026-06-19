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

      // Save user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCredential.user!.uid,
        'isOnline': false,
        'lastSeen': DateTime.now(),
        'createdAt': DateTime.now(),
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Signup error: ${e.message}');
      return null;
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
        {'isOnline': true, 'lastSeen': DateTime.now()},
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'isOnline': false,
          'lastSeen': DateTime.now(),
        });
      }
      await _auth.signOut();
    } catch (e) {
      print('Logout error: $e');
    }
  }
}
