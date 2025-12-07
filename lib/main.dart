import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
// Si generaste firebase_options.dart con flutterfire configure, importa:
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // usa firebase_options.dart
  );
  runApp(const RecipeBuddy());
}

class RecipeBuddy extends StatelessWidget {
  const RecipeBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const LoginScreen(),
    );
  }
}
