import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/custom_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // Chat and Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Send message
  void sendMessage(BuildContext context) async {
    // If there is text in the message controller
    if (_messageController.text.isNotEmpty) {
      // Send message
      await _chatService.sendMessage(receiverID, _messageController.text);

      // Clear message controller
      _messageController.clear();
    }

    // If there is no text in the message controller
    else {
      // Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // Error message
          content: Text("Please enter a message"),
          backgroundColor: Colors.red,
          // Duration
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(receiverEmail),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display all messages
          Expanded(child: _buildMessageList(context)),

          // Message input
          _buildMessageInput(context),
        ],
      ),
    );
  }

  // Build a list of messages
  Widget _buildMessageList(BuildContext context) {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Return listview of messages
        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc, context))
              .toList(),
        );
      },
    );
  }

  // Build a list item for each message
  Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context) {
    // Get message data
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Get message text
    String message = data['message'];

    // Get sender ID
    String senderID = data['senderID'];

    // Get current user ID
    String currentUserID = _authService.getCurrentUser()!.uid;

    // Check if the message is from the current user
    bool isCurrentUser = senderID == currentUserID;

    // Return message item
    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Chat bubble
          ChatBubble(
            message: message,
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  // Message input
  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          // Message input
          Expanded(
            child: CustomTextfield(
              controller: _messageController,
              hintText: "Enter a message",
              obscureText: false,
            ),
          ),

          // Send button
          Container(
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => sendMessage(context),
            ),
          ),
        ],
      ),
    );
  }
}
