import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final currentUser = FirebaseAuth.instance.currentUser;
  String? otherUserName;
  bool isLoadingUserName = true;
  bool isOtherUserTyping = false;
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _loadOtherUserName();
    _setupTypingIndicator();
    _listenToTypingStatus();
    
    // Listen to text changes to update typing status
    _controller.addListener(_onTextChanged);
  }

  void _setupTypingIndicator() {
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _typingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _typingAnimationController,
      curve: Curves.easeInOut,
    ));
    _typingAnimationController.repeat(reverse: true);
  }

  void _onTextChanged() {
    if (_controller.text.isNotEmpty) {
      _updateTypingStatus(true);
    } else {
      _updateTypingStatus(false);
    }
  }

  void _updateTypingStatus(bool isTyping) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        '${currentUser!.uid}_typing': isTyping,
        '${currentUser!.uid}_typingTimestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating typing status: $e');
    }
  }

  void _listenToTypingStatus() {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final otherUserTyping = data['${widget.otherUserId}_typing'] ?? false;
        final typingTimestamp = data['${widget.otherUserId}_typingTimestamp'];
        
        // Check if typing status is recent (within last 3 seconds)
        bool isRecentTyping = false;
        if (typingTimestamp != null && otherUserTyping) {
          final timestamp = (typingTimestamp as Timestamp).toDate();
          final now = DateTime.now();
          isRecentTyping = now.difference(timestamp).inSeconds < 3;
        }
        
        if (mounted) {
          setState(() {
            isOtherUserTyping = isRecentTyping;
          });
        }
      }
    });
  }

  Future<void> _loadOtherUserName() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.otherUserId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          otherUserName = userData['name'] ?? 'Unknown User';
          isLoadingUserName = false;
        });
      } else {
        setState(() {
          otherUserName = 'Unknown User';
          isLoadingUserName = false;
        });
      }
    } catch (e) {
      setState(() {
        otherUserName = 'Unknown User';
        isLoadingUserName = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatMessageTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    
    final DateTime messageTime = timestamp.toDate();
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(messageTime);
    
    if (difference.inDays == 0) {
      return "${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return "Yesterday ${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}";
    } else {
      return "${messageTime.day}/${messageTime.month}/${messageTime.year}";
    }
  }

  void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    _controller.clear();
    _updateTypingStatus(false); // Stop typing when sending
    
    final messageRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'senderId': currentUser!.uid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'seen': false,
    });

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update({
          'lastMessage': text,
          'lastTimestamp': FieldValue.serverTimestamp(),
        });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _showDeleteMessageDialog(String messageId, String messageText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DesignColors.backgroundColorInactive,
          title: const Text('Delete Message'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to delete this message?'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: DesignColors.backgroundColorInactive,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  messageText,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteMessage(messageId);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMessage(String messageId) async {
    try {
      // Delete the message document
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .doc(messageId)
          .delete();

      // Update last message if this was the last message
      await _updateLastMessageAfterDeletion();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message deleted'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete message'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _updateLastMessageAfterDeletion() async {
    try {
      // Get the most recent message after deletion
      final messagesQuery = await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (messagesQuery.docs.isNotEmpty) {
        final lastMessage = messagesQuery.docs.first;
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId)
            .update({
          'lastMessage': lastMessage['text'],
          'lastTimestamp': lastMessage['timestamp'],
        });
      } else {
        // No messages left, clear last message
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatId)
            .update({
          'lastMessage': '',
          'lastTimestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating last message: $e');
    }
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 50, top: 4, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${otherUserName ?? 'User'} is typing",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: SizeConfig.blockH! * 3,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: _typingAnimation,
            builder: (context, child) {
              return Row(
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    child: Opacity(
                      opacity: (_typingAnimation.value + index * 0.3) % 1.0,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLoadingUserName
                  ? "Loading..."
                  : (otherUserName ?? "Unknown User"),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              isOtherUserTyping ? "typing..." : "Active Now",
              style: TextStyle(
                color: isOtherUserTyping ? DesignColors.primaryColor : Colors.green,
                fontSize: 12,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pushNamed(context, '/userselection'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final messages = snapshot.data!.docs;
                
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (messages.isNotEmpty || isOtherUserTyping) {
                    _scrollToBottom();
                  }
                });
                
                if (messages.isEmpty && !isOtherUserTyping) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: SizeConfig.blockH! * 15,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: SizeConfig.blockV! * 2),
                        Text(
                          "No messages yet",
                          style: TextStyle(
                            fontSize: SizeConfig.blockH! * 4,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockV! * 1),
                        Text(
                          "Start the conversation!",
                          style: TextStyle(
                            fontSize: SizeConfig.blockH! * 3,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (isOtherUserTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show typing indicator as last item
                    if (index == messages.length && isOtherUserTyping) {
                      return _buildTypingIndicator();
                    }
                    
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUser!.uid;
                    final messageText = msg['text'] ?? '';
                    
                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: isMe ? () => _showDeleteMessageDialog(msg.id, messageText) : null,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 4,
                                bottom: 2,
                                left: isMe ? 50 : 0,
                                right: isMe ? 0 : 50,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: isMe
                                    ? LinearGradient(
                                        colors: [
                                          DesignColors.primaryColor,
                                          DesignColors.primaryColor.withOpacity(0.8),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: isMe ? null : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: isMe
                                      ? const Radius.circular(20)
                                      : const Radius.circular(4),
                                  bottomRight: isMe
                                      ? const Radius.circular(4)
                                      : const Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                messageText,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: SizeConfig.blockH! * 3.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: isMe ? 0 : 16,
                              right: isMe ? 16 : 0,
                              top: 2,
                              bottom: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatMessageTime(msg['timestamp']),
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: SizeConfig.blockH! * 2.8,
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.done_all,
                                    size: SizeConfig.blockH! * 4,
                                    color: msg['seen'] == true ? Colors.blue : Colors.grey,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.blockH! * 2),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: DesignColors.primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    _updateTypingStatus(false); // Clear typing status when leaving
    super.dispose();
  }
}