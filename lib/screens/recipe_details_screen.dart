import 'package:flutter/material.dart';
import 'package:recipe_buddy/models/recipe.dart';
import 'package:recipe_buddy/widgets/ingredient_tile.dart';
import 'package:recipe_buddy/widgets/step_tile.dart';
import '../services/recipe_service.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final Color mint = const Color(0xFF4BC9A8);
  final Color mintSoft = const Color(0xFFDFF7F1);
  final Color dark = const Color(0xFF1B1D22);

  int selectedTab = 0;
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.recipe;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(r.title),

                const SizedBox(height: 14),
                _buildImage(r.imageUrl),

                const SizedBox(height: 16),
                _buildInfo(r),

                const SizedBox(height: 22),
                _buildTabs(),

                const SizedBox(height: 12),
                Expanded(child: _buildContent(r)),

                _buildFavoriteButton(r),
              ],
            ),
          ),
        ),

        if (saving)
          Container(
            color: Colors.black.withOpacity(0.40),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------
  Widget _buildHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 22),
      decoration: BoxDecoration(
        color: mintSoft,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: mint.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios_new, color: dark, size: 22),
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: dark,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // IMAGE
  // ---------------------------------------------------------------------------
  Widget _buildImage(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: url.isEmpty
              ? const Center(child: Icon(Icons.image, size: 60))
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image, size: 50)),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INFO
  // ---------------------------------------------------------------------------
  Widget _buildInfo(Recipe r) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(Icons.timer, size: 20, color: mint),
          const SizedBox(width: 6),
          Text(r.time, style: const TextStyle(fontSize: 14)),

          const SizedBox(width: 16),
          Icon(Icons.local_fire_department, size: 20, color: mint),
          const SizedBox(width: 6),
          Text(r.difficulty, style: const TextStyle(fontSize: 14)),

          const SizedBox(width: 16),
          Icon(Icons.person, size: 20, color: mint),
          const SizedBox(width: 6),
          Text("${r.portions} servings", style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TABS
  // ---------------------------------------------------------------------------
  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildTab("Ingredients", 0),
          const SizedBox(width: 30),
          _buildTab("Steps", 1),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final active = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: active ? mint : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: active ? 90 : 0,
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
  // CONTENT
  // ---------------------------------------------------------------------------
  Widget _buildContent(Recipe r) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedTab == 0)
            ...r.ingredients
                .map((ing) => IngredientTile(text: ing, mint: mint))
                .toList()
          else
            ...r.steps.asMap().entries.map(
                  (e) => StepTile(number: e.key + 1, text: e.value),
                ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FAVORITE BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildFavoriteButton(Recipe r) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          )
        ],
      ),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: mint,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: saving ? null : () => _toggleFavorite(r),
          child: Text(
            r.isFavorite ? "Remove Favorite 💔" : "Save to Favorites ❤️",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FAVORITE TOGGLE LOGIC
  // ---------------------------------------------------------------------------
  Future<void> _toggleFavorite(Recipe r) async {
    setState(() => saving = true);

    try {
      await RecipeService().toggleFavorite(r.id, r.isFavorite);

      setState(() {
        r.isFavorite = !r.isFavorite;
        saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            r.isFavorite ? "Added to favorites ❤️" : "Removed from favorites 💔",
          ),
        ),
      );
    } catch (e) {
      setState(() => saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating favorite: $e")),
      );
    }
  }
}
