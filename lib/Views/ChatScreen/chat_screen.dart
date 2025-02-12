import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuri_application/Models/chat_message_model.dart';
import 'package:kuri_application/Models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();
      
      if (userDoc.exists) {
        setState(() {
          currentUser = UserModel.fromJson({
            'id': userDoc.id,
            ...userDoc.data()!
          });
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || currentUser == null) return;

    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: currentUser!.id,
        senderName: currentUser!.name,
        message: _messageController.text.trim(),
        timestamp: DateTime.now(),
      );

      await _firestore.collection('chats').add(message.toJson());
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  Widget _buildMessage(ChatMessage message) {
    final isCurrentUser = message.senderId == currentUser?.id;
    final time = DateFormat('HH:mm').format(message.timestamp);

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.primaryColor : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isCurrentUser)
              Text(
                message.senderName,
                style: TextStyle(
                  color: AppColors.textColorSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              message.message,
              style: TextStyle(
                color: isCurrentUser ? AppColors.whiteColor : AppColors.textColorPrimary,
                fontSize: 16,
              ),
            ),
            Text(
              time,
              style: TextStyle(
                color: isCurrentUser 
                    ? AppColors.whiteColor.withOpacity(0.7) 
                    : AppColors.textColorSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'You need to be logged in to access the chat',
            style: TextStyle(color: AppColors.textColorPrimary),
          ),
        ),
      );
    }

    if (!currentUser!.participatedDraws.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'Only contributors can access the chat',
            style: TextStyle(color: AppColors.textColorPrimary),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Contributors Chat'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                final messages = snapshot.data!.docs.map((doc) {
                  return ChatMessage.fromJson({
                    'id': doc.id,
                    ...doc.data() as Map<String, dynamic>
                  });
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(messages[index]);
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundColor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: AppColors.whiteColor),
                    onPressed: _sendMessage,
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
    _messageController.dispose();
    super.dispose();
  }
}
