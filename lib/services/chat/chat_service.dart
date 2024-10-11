import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatService {
  // Get instance of firestore
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

  // Receive message
}
