import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const RecipeBuddyApp());
}

class RecipeBuddyApp extends StatelessWidget {
  const RecipeBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Recipe Buddy",
      debugShowCheckedModeBanner: false,
      
      routes: {
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomePage(),
      },

      home: const LoginScreen(),
    );
  }
}
