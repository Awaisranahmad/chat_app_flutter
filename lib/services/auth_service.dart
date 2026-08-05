import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<User?> signUp(String email, String password, String name) async {
    try {
      print('🔹 SignUp: Creating user with email: $email');
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      print('🔹 SignUp: User created with UID: ${userCredential.user?.uid}');

      print('🔹 SignUp: Saving user data to Firestore...');
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCredential.user!.uid,
        'isOnline': false,
        'lastSeen': DateTime.now(),
        'createdAt': DateTime.now(),
      });
      print('🔹 SignUp: Firestore data saved successfully!');

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('🔴 FirebaseAuthException: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('🔴 Unexpected error: $e');
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).update(
        {'isOnline': true, 'lastSeen': DateTime.now()},
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      return null;
    }
  }

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
