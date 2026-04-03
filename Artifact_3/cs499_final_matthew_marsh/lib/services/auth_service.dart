import 'package:firebase_auth/firebase_auth.dart';

/// AuthService provides a clean abstraction layer around Firebase Authentication.
/// This keeps authentication logic separate from UI code and makes the app
/// easier to maintain, test, and extend.
class AuthService {
  // FirebaseAuth instance used for all authentication operations.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// A stream that notifies listeners whenever the authentication state changes.
  /// This is typically used in an AuthGate or StreamBuilder to determine
  /// whether to show the login screen or the main application.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Signs in a user using an email and password.
  /// Throws a FirebaseAuthException if authentication fails.
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Signs the current user out of the application.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

