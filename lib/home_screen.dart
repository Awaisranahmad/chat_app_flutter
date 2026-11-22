import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './services/auth_service.dart';
import 'screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat App 🫟',
          style: TextStyle(
            color: Color.fromARGB(255, 118, 79, 226),
            fontSize: 43,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await _auth.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            icon: const Icon(Icons.logout, color: Colors.blueAccent),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isNotEqualTo: currentUser?.uid ?? '')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final bool isOnline = (userData['isOnline'] as bool?) ?? false;
              final String userName =
                  (userData['name'] as String?) ?? 'Unknown User';
              // The document id is the user's uid (see AuthService.signUp).
              final String receiverId =
                  (userData['uid'] as String?) ?? users[index].id;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isOnline ? Colors.green : Colors.grey,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(userName),
                subtitle: Text(
                  isOnline ? 'Online 🟢' : 'Offline ⚪',
                  style: TextStyle(
                    color: isOnline ? Colors.green : Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiverId: receiverId,
                        receiverName: userName,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
