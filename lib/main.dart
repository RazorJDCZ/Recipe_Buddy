import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
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
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Recipe Buddy",
        // opcional: rutas por si las necesitas en otros lados
        routes: {
          "/login": (context) => const LoginScreen(),
          "/home": (context) => const HomePage(),
        },
        home: const AuthGate(),
      ),
    );
  }
}

/// Este widget decide si muestra el Login o el Home
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.user == null) {
      return const LoginScreen();
    }
    return const HomePage();
  }
}
