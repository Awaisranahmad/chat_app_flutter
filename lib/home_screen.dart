import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App 💬'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isNotEqualTo: currentUser?.uid ?? '')
            .snapshots(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userDoc = users[index];
              final userData = userDoc.data() as Map<String, dynamic>;
              final isOnline = userData['isOnline'] ?? false;
              final userName = userData['name'] ?? 'Unknown User';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isOnline ? Colors.green : Colors.grey,
                  child: Text(
                    userName[0].toUpperCase(),
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
                trailing: isOnline
                    ? const Icon(Icons.circle, color: Colors.green, size: 12)
                    : null,
                onTap: () {
                  // 🔥 Kal chat screen banayenge, abhi sirf print karo
                  print('Tapped on: $userName');
                },
              );
            },
          );
        },
      ),
    );
  }
}
