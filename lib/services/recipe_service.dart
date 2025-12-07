import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';

class RecipeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ---------------------------------------------------------------------------
  // STREAM: TODAS LAS RECETAS (CON FAVORITOS POR USUARIO)
  // ---------------------------------------------------------------------------
  Stream<List<Recipe>> listenAllRecipes() {
    final String uid = _auth.currentUser!.uid;

    // Escuchar recetas + favoritos del usuario en paralelo
    return _db.collection("recipes").orderBy("title").snapshots().asyncMap(
      (snapshot) async {
        // cargar recetas
        List<Recipe> recipes =
            snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();

        // cargar IDs favoritos del usuario
        final favSnapshot = await _db
            .collection("users")
            .doc(uid)
            .collection("favorites")
            .get();

        final favoriteIds = favSnapshot.docs.map((f) => f.id).toSet();

        // marcar recetas favoritas
        for (var r in recipes) {
          r.isFavorite = favoriteIds.contains(r.id);
        }

        return recipes;
      },
    );
  }

  // ---------------------------------------------------------------------------
  // STREAM: SOLO FAVORITOS DEL USUARIO
  // ---------------------------------------------------------------------------
  Stream<List<Recipe>> listenFavoriteRecipes() {
    final String uid = _auth.currentUser!.uid;

    return _db
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .snapshots()
        .asyncMap((favSnap) async {
      if (favSnap.docs.isEmpty) return [];

      final ids = favSnap.docs.map((d) => d.id).toList();

      final recipes = <Recipe>[];

      for (String id in ids) {
        final doc = await _db.collection("recipes").doc(id).get();
        if (doc.exists) {
          final recipe = Recipe.fromFirestore(doc);
          recipe.isFavorite = true;
          recipes.add(recipe);
        }
      }

      return recipes;
    });
  }

  // ---------------------------------------------------------------------------
  // ⭐ GUARDAR RECETA GENERADA POR IA
  // ---------------------------------------------------------------------------
  Future<String> addRecipeFromAI(Map<String, dynamic> data) async {
    try {
      final recipeData = {
        "title": data["title"] ?? "Untitled Recipe",
        "ingredients":
            (data["ingredients"] is List) ? data["ingredients"] : [],
        "steps": (data["steps"] is List) ? data["steps"] : [],
        "time": data["time"] ?? "N/A",
        "difficulty": data["difficulty"] ?? "N/A",
        "portions": data["portions"] ?? "N/A",
        "imageUrl": data["imageUrl"] ?? "",
        "imageGenerated": true,
        "createdAt": FieldValue.serverTimestamp(),
      };

      final docRef = await _db.collection("recipes").add(recipeData);

      print("🔥 AI recipe saved → ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("❌ ERROR saving AI recipe: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // ❤️ AGREGAR / QUITAR FAVORITO POR USUARIO
  // ---------------------------------------------------------------------------
  Future<void> toggleFavorite(String recipeId, bool isCurrentlyFav) async {
    final String uid = _auth.currentUser!.uid;

    final favRef =
        _db.collection("users").doc(uid).collection("favorites").doc(recipeId);

    try {
      if (isCurrentlyFav) {
        // ❌ quitar favorito
        await favRef.delete();
        print("💔 Removed from favorites: $recipeId");
      } else {
        // ❤️ agregar favorito
        await favRef.set({"addedAt": FieldValue.serverTimestamp()});
        print("❤️ Added to favorites: $recipeId");
      }
    } catch (e) {
      print("❌ ERROR toggling favorite: $e");
      rethrow;
    }
  }
}
