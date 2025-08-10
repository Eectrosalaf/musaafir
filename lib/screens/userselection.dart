import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';
import 'chatscreen.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Future<String> startChat(String userId1, String userId2) async {
    final chats = FirebaseFirestore.instance.collection('chats');
    final query = await chats.where('users', arrayContains: userId1).get();

    for (var doc in query.docs) {
      if ((doc['users'] as List).contains(userId2)) {
        return doc.id;
      }
    }

    final docRef = await chats.add({
      'users': [userId1, userId2],
      'lastMessage': '',
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Select User', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: ()  =>  Navigator.pushNamed(context, '/message'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.blockH! * 4),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: DesignColors.backgroundColorInactive,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading users"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                final users = snapshot.data!.docs.where((doc) {
                  final userData = doc.data() as Map<String, dynamic>;
                  final userName = (userData['name'] ?? '').toString().toLowerCase();
                  final userEmail = (userData['email'] ?? '').toString().toLowerCase();
                  
                  return doc.id != currentUser!.uid && 
                         (userName.contains(_searchQuery) || userEmail.contains(_searchQuery));
                }).toList();

                if (users.isEmpty) {
                  return const Center(child: Text("No users match your search"));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userData = user.data() as Map<String, dynamic>;
                    final userName = userData['name'] ?? 'Unknown User';
                    final userEmail = userData['email'] ?? '';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: DesignColors.primaryColor.withOpacity(0.2),
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'User',
                          style: TextStyle(
                            color: DesignColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(userEmail),
                      onTap: () async {
                        final chatId = await startChat(currentUser!.uid, user.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              chatId: chatId,
                              otherUserId: user.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}