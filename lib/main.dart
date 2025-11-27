import 'package:flutter/material.dart';
import 'package:recipe_buddy/screens/home_page.dart';
import 'theme.dart';
import 'screens/login_screen.dart';

void main() {
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
      home: LoginScreen(),
    );
  }
}
