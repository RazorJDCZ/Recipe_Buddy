import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String id;
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final String time;
  final String difficulty;
  final String portions;
  final String imageUrl;

  // Este valor YA NO viene de Firestore. Se asigna en RecipeService.
  bool isFavorite;

  final bool imageGenerated;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.time,
    required this.difficulty,
    required this.portions,
    required this.imageUrl,
    this.isFavorite = false,       // por defecto en falso
    required this.imageGenerated,
  });

  // Convertir Firestore → Recipe
  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Recipe(
      id: doc.id,
      title: data["title"] ?? "",
      ingredients: List<String>.from(data["ingredients"] ?? []),
      steps: List<String>.from(data["steps"] ?? []),
      time: data["time"] ?? "",
      difficulty: data["difficulty"] ?? "",
      portions: data["portions"] ?? "",
      imageUrl: data["imageUrl"] ?? "",
      imageGenerated: data["imageGenerated"] ?? false,

      // ⚠️ YA NO LEEMOS FAVORITES DE FIRESTORE
      // Este valor será asignado posteriormente por RecipeService.listenAllRecipes()
      isFavorite: false,
    );
  }

  // Convertir Recipe → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "ingredients": ingredients,
      "steps": steps,
      "time": time,
      "difficulty": difficulty,
      "portions": portions,
      "imageUrl": imageUrl,
      "imageGenerated": imageGenerated,

      // ⚠️ YA NO GUARDAMOS isFavorite AQUÍ
    };
  }
}
