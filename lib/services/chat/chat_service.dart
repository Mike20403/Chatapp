import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService {
  // Get instance of firestore & auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*

  List<Map<String, dynamic>> = 

  [
  {
    'email' = test@gmail.com
    'id' = ...
  },
  {
    'email' = tent@gmail.com
    'id' = ...
  }
  ]

  */

  // Get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Get individual user
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // Send message
  Future<void> sendMessage(String receiverID, message) async {
    // Get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;

    // Timestamp
    final Timestamp timestamp = Timestamp.now();

    // Create new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // Construct chat room ID for 2 users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // Sort to ensure the same chat room ID for both users

    String chatRoomID = ids.join('_');

    // Add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(
          newMessage.toMap(),
        );
  }

  // Get message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // Construct chat room ID for 2 users (sorted to ensure uniqueness)
    List<String> ids = [userID, otherUserID];
    ids.sort(); // Sort to ensure the same chat room ID for both users

    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
