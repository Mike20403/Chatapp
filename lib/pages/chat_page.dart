import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/custom_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // Chat and Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Textfield focus node
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listener to focus node
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Delay and then scroll to the bottom
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _scrollToBottom(),
        );
      }
    });

    // Wait for the widget to build and then scroll to the bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      () => _scrollToBottom(),
    );
  }

  @override
  void dispose() {
    // Dispose of the focus node
    _focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Scroll Controller
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // Send message
  void sendMessage(BuildContext context) async {
    // If there is text in the message controller
    if (_messageController.text.isNotEmpty) {
      // Send message
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      // Clear message controller
      _messageController.clear();

      // Scroll to the bottom
      _scrollToBottom();
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.receiverEmail),
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
      stream: _chatService.getMessages(widget.receiverID, senderID),
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
          controller: _scrollController,
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
              focusNode: _focusNode,
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
