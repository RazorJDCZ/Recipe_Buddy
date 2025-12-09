import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const RecipeBuddyApp());
}

class RecipeBuddyApp extends StatelessWidget {
  const RecipeBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Recipe Buddy",
      debugShowCheckedModeBanner: false,

      // Definición de rutas
      routes: {
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomePage(),
      },

      // GATE PRINCIPAL 
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Esperando conexión
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            ),
          );
        }

        // Usuario logueado → ir a Home
        if (snapshot.hasData) {
          return const HomePage();
        }

        // No logueado → ir a Login
        return const LoginScreen();
      },
    );
  }
}
