import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'screens/inventory_list_page.dart';

/// Entry point of the application.
/// Ensures Firebase is initialized before the app starts.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using platform-specific configuration.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

/// Root widget of the application.
/// Sets global theming and determines the initial screen via AuthGate.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory App',

      // ⭐ Global Theme Configuration
      // Provides consistent styling across the entire application.
      theme: ThemeData(
        useMaterial3: true,

        // Color scheme generated from a seed color for visual consistency.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),

        // AppBar styling
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        // Default styling for text input fields
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),

        // Default styling for ElevatedButtons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Card styling for list items
        cardTheme: const CardThemeData(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),

        // Default ListTile spacing
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),

        // Global text styles
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),

      // AuthGate determines whether to show LoginPage or InventoryListPage.
      home: const AuthGate(),
    );
  }
}

/// AuthGate listens to FirebaseAuth's authentication state.
/// It decides which screen to show based on whether the user is logged in.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Stream emits events whenever the user's authentication state changes.
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        // Still waiting for Firebase to determine auth state.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User is logged in → show inventory list.
        if (snapshot.hasData) {
          return const InventoryListPage();
        }

        // User is NOT logged in → show login page.
        return const LoginPage();
      },
    );
  }
}