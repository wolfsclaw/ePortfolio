import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// LoginPage provides user authentication using FirebaseAuth.
/// Users can sign in with an existing account or create a new one.
/// This page is the entry point for accessing the inventory system.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for email and password input fields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Attempts to sign the user in using Firebase Authentication.
  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      // Display an error message if login fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }

  /// Creates a new user account using Firebase Authentication.
  Future<void> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      // Display an error message if account creation fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar title for the login screen.
      appBar: AppBar(title: const Text("Login")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            // Email input field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),

            // Password input field
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true, // Hides password text
            ),
            const SizedBox(height: 20),

            // Sign In button
            ElevatedButton(
              onPressed: _login,
              child: const Text("Sign In"),
            ),

            const SizedBox(height: 12),

            // Create Account button
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}