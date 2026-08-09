import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './services/auth_service.dart';

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
        // initialData: initialData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
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
                onTap: () {
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
