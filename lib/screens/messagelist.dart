import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musaafir/screens/userselection.dart';
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

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(
              builder: (_) => const UserSelectionScreen(),
            ),
          );
          
          if (result != null) {
            final chatId = await startChat(currentUser!.uid, result['userId']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  chatId: chatId,
                  otherUserId: result['userId'],
                ),
              ),
            );
          }
        },
        icon: const Icon(Icons.add_comment_rounded, color: Colors.white),
        label: const Text('New Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: DesignColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Messages', 
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.blockH! * 5,
          )
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: DesignColors.primaryColor,
            size: SizeConfig.blockH! * 6,
          ),
          onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: DesignColors.primaryColor,
              size: SizeConfig.blockH! * 6,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
              SizeConfig.blockH! * 5,
              SizeConfig.blockV! * 1,
              SizeConfig.blockH! * 5,
              SizeConfig.blockV! * 3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Conversations',
                  style: TextStyle(
                    fontSize: SizeConfig.blockH! * 4,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('users', arrayContains: currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: DesignColors.primaryColor,
                    ),
                  );
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: SizeConfig.blockH! * 20,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: SizeConfig.blockV! * 3),
                        Text(
                          "No conversations yet",
                          style: TextStyle(
                            fontSize: SizeConfig.blockH! * 5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockV! * 1),
                        Text(
                          "Start a new chat to connect with others",
                          style: TextStyle(
                            fontSize: SizeConfig.blockH! * 3.5,
                            color: Colors.black38,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: SizeConfig.blockH! * 20,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: SizeConfig.blockV! * 3),
                        Text(
                          "No conversations yet",
                          style: TextStyle(
                            fontSize: SizeConfig.blockH! * 5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockV! * 1),
                        Text(
                          "Start a new chat to connect with others",
                          style: TextStyle(
                            fontSize: SizeConfig.blockH! * 3.5,
                            color: Colors.black38,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                // Sort chats manually by lastTimestamp
                final chats = snapshot.data!.docs;
                chats.sort((a, b) {
                  final aTimestamp = a['lastTimestamp'] as Timestamp?;
                  final bTimestamp = b['lastTimestamp'] as Timestamp?;
                  
                  if (aTimestamp == null && bTimestamp == null) return 0;
                  if (aTimestamp == null) return 1;
                  if (bTimestamp == null) return -1;
                  
                  return bTimestamp.compareTo(aTimestamp);
                });
                
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockH! * 2),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final users = List<String>.from(chat['users']);
                    final otherUserId = users.firstWhere(
                      (id) => id != currentUser.uid,
                    );
                    
                    return FutureBuilder<Map<String, dynamic>?>(
                      future: getUserData(otherUserId),
                      builder: (context, userSnapshot) {
                        final userData = userSnapshot.data;
                        final userName = userData?['name'] ?? 'Unknown User';
                        final lastMessage = chat['lastMessage'] ?? "";
                        final timestamp = chat['lastTimestamp'];
                        
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: SizeConfig.blockV! * 0.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockH! * 4,
                              vertical: SizeConfig.blockV! * 1,
                            ),
                            leading: CircleAvatar(
                              radius: SizeConfig.blockH! * 6,
                              backgroundColor: DesignColors.primaryColor.withOpacity(0.1),
                              child: Text(
                                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                style: TextStyle(
                                  color: DesignColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.blockH! * 5,
                                ),
                              ),
                            ),
                            title: Text(
                              userName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockH! * 4,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              lastMessage.isEmpty ? "No messages yet" : lastMessage,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: SizeConfig.blockH! * 3.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  timestamp != null
                                      ? _formatTime(timestamp.toDate())
                                      : "Now",
                                  style: TextStyle(
                                    fontSize: SizeConfig.blockH! * 2.8,
                                    color: Colors.black38,
                                  ),
                                ),
                                SizedBox(height: SizeConfig.blockV! * 0.5),
                                if (lastMessage.isNotEmpty)
                                  Icon(
                                    Icons.done_all,
                                    color: Colors.green,
                                    size: SizeConfig.blockH! * 4,
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

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);
    
    if (difference.inDays == 0) {
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return "${dt.day}/${dt.month}/${dt.year}";
    }
  }
}