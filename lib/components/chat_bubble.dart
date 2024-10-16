import 'package:chatapp/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    // Light theme and Dark theme
    bool isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).isDarkTheme;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDarkTheme ? Colors.green.shade600 : Colors.green.shade500)
            : (isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Text(
        message,
        style: TextStyle(
          color: isCurrentUser
              ? Colors.white
              : (isDarkTheme ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
