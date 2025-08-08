import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';
import 'chatscreen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  Future<String> startChat(String userId1, String userId2) async {
    final chats = FirebaseFirestore.instance.collection('chats');
    final query = await chats.where('users', arrayContains: userId1).get();

    for (var doc in query.docs) {
      if ((doc['users'] as List).contains(userId2)) {
        return doc.id; // Chat already exists
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // For demo, use placeholder user ID. In production, fetch from user provider.
          final otherUserId = 'placeholdeUserId';
          startChat(currentUser!.uid, otherUserId).then((chatId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ChatScreen(chatId: chatId, otherUserId: otherUserId),
              ),
            );
          });
        },
        icon: const Icon(Icons.chat,color: Colors.white,),
        label: const Text('Start Chat',style: TextStyle(color: Colors.white),),
        backgroundColor: DesignColors.primaryColor, // Optional: your color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Change radius as needed
        ),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Messages', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(SizeConfig.blockH! * 2),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search for chats & messages",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final currentUser = userSnapshot.data!;
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .where('users', arrayContains: currentUser.uid)
                    .orderBy('lastTimestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final chats = snapshot.data!.docs;
                  if (chats.isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }
                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final users = List<String>.from(chat['users']);
                      final otherUserId = users.firstWhere(
                        (id) => id != currentUser.uid,
                      );
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/aaaa.webp'),
                        ),
                        title: Text(
                          "User $otherUserId",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(chat['lastMessage'] ?? ""),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              chat['lastTimestamp'] != null
                                  ? _formatTime(chat['lastTimestamp'].toDate())
                                  : "",
                              style: const TextStyle(fontSize: 12),
                            ),
                            const Icon(
                              Icons.done_all,
                              color: Colors.green,
                              size: 18,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                chatId: chat.id,
                                otherUserId: otherUserId,
                              ),
                            ),
                          );
                        },
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

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } else {
      return "${dt.day}/${dt.month}/${dt.year}";
    }
  }
}
