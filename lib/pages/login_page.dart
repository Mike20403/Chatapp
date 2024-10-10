import 'package:chatapp/auth/auth_service.dart';
import 'package:chatapp/components/custom_button.dart';
import 'package:chatapp/components/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // Email and Password controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Page navigation
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  // Login Method
  void login(BuildContext context) {
    // Auth Service
    final authService = AuthService();

    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      authService.signInWithEmailPassword(email, password);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 25),

          // Welcome back text
          Text(
            "Welcome back, you've been missed!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          // Email textfield
          CustomTextfield(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
          ),

          const SizedBox(height: 10),

          // Password textfield
          CustomTextfield(
            hintText: "Password",
            obscureText: true,
            controller: _passwordController,
          ),

          const SizedBox(height: 25),

          // Login button
          CustomButton(
            text: "Login",
            onTap: () => login(context),
          ),

          const SizedBox(height: 25),

          // Register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Not a member? ",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Register now",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
