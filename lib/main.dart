import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe_buddy/firebase_options.dart';
import 'package:recipe_buddy/screens/home_page.dart';
import 'theme.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
      home: HomePage(),
    );
  }
}
