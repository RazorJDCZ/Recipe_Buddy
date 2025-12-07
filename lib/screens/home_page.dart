import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import './generate_recipe_screen.dart';
import '../widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;

  final Color mint = const Color(0xFF4BC9A8);
  final Color mintSoft = const Color(0xFFDFF7F1);
  final Color dark = const Color(0xFF1B1D22);

  final RecipeService _service = RecipeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _buildFloatingButton(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildTabs(),
            const SizedBox(height: 10),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER CON LOGOUT FUNCIONAL
  // ---------------------------------------------------------------------------
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 22, bottom: 28),
      decoration: BoxDecoration(
        color: mintSoft,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: mint.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🔥 BOTÓN DE LOGOUT — AHORA CON REDIRECCIÓN
          Positioned(
            left: 16,
            child: GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                if (!mounted) return;

                Navigator.pushReplacementNamed(context, "/login");
              },
              child: Icon(Icons.logout, color: dark, size: 28),
            ),
          ),

          // TÍTULO
          Column(
            children: [
              Text(
                "Recipe Buddy",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: dark,
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Your personal AI chef assistant",
                style: TextStyle(
                  fontSize: 14,
                  color: dark.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TABS
  // ---------------------------------------------------------------------------
  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton("All Recipes", 0),
        const SizedBox(width: 32),
        _tabButton("Favorites", 1),
      ],
    );
  }

  Widget _tabButton(String text, int index) {
    bool active = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: active ? mint : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: active ? 80 : 0,
            decoration: BoxDecoration(
              color: active ? mint : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB CONTENT
  // ---------------------------------------------------------------------------
  Widget _buildTabContent() {
    return selectedTab == 0 ? _allRecipesStream() : _favoritesStream();
  }

  // ---------------------------------------------------------------------------
  // ALL RECIPES
  // ---------------------------------------------------------------------------
  Widget _allRecipesStream() {
    return StreamBuilder<List<Recipe>>(
      stream: _service.listenAllRecipes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final recipes = snapshot.data!;

        if (recipes.isEmpty) {
          return _emptyState("No recipes yet.\nCreate your first one!");
        }

        return _recipeGrid(recipes);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // FAVORITES
  // ---------------------------------------------------------------------------
  Widget _favoritesStream() {
    return StreamBuilder<List<Recipe>>(
      stream: _service.listenFavoriteRecipes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final favorites = snapshot.data!;

        if (favorites.isEmpty) {
          return _emptyState("No favorites yet.");
        }

        return _recipeGrid(favorites);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // GRID VIEW
  // ---------------------------------------------------------------------------
  Widget _recipeGrid(List<Recipe> recipes) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .80,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeCard(recipe: recipes[index]);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------------------
  Widget _emptyState(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTÓN FLOATING
  // ---------------------------------------------------------------------------
  Widget _buildFloatingButton() {
    return FloatingActionButton(
      elevation: 6,
      backgroundColor: mint,
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GenerateRecipeScreen()),
        );
        setState(() {}); // refrescar al volver
      },
      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 26),
    );
  }
}
