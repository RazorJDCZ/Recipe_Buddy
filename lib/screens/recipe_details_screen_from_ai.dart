import 'package:flutter/material.dart';
import 'package:recipe_buddy/services/recipe_service.dart';
import 'package:recipe_buddy/widgets/ingredient_tile.dart';
import 'package:recipe_buddy/widgets/step_tile.dart';
import 'home_page.dart';

class RecipeDetailsScreenFromAI extends StatefulWidget {
  final Map<String, dynamic> recipeData;

  const RecipeDetailsScreenFromAI({
    super.key,
    required this.recipeData,
  });

  @override
  State<RecipeDetailsScreenFromAI> createState() =>
      _RecipeDetailsScreenFromAIState();
}

class _RecipeDetailsScreenFromAIState
    extends State<RecipeDetailsScreenFromAI> {
  final Color mint = const Color(0xFF4BC9A8);
  final Color mintSoft = const Color(0xFFDFF7F1);
  final Color dark = const Color(0xFF1B1D22);

  int selectedTab = 0;
  bool saving = false;

  /// Este será SIEMPRE el ID real en Firestore
  String internalId = "";

  @override
  void initState() {
    super.initState();
    _ensureRecipeIsSaved();
  }

  // ---------------------------------------------------------------------------
  // ⭐ GUARDA AUTOMÁTICAMENTE LA RECETA EN FIRESTORE SI NO EXISTE
  // ---------------------------------------------------------------------------
  Future<void> _ensureRecipeIsSaved() async {
    final existingId = widget.recipeData["id"];

    if (existingId != null && existingId.toString().isNotEmpty) {
      internalId = existingId;
      return;
    }

    final RecipeService service = RecipeService();
    final newId = await service.addRecipeFromAI(widget.recipeData);

    setState(() {
      internalId = newId;
      widget.recipeData["id"] = newId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.recipeData;

    final String title = (data["title"] ?? "Untitled Recipe").toString();
    final String time = (data["time"] ?? "N/A").toString();
    final String difficulty = (data["difficulty"] ?? "N/A").toString();
    final String portions = (data["portions"] ?? "N/A").toString();

    final List ingredients =
        (data["ingredients"] is List) ? data["ingredients"] : [];

    final List steps =
        (data["steps"] is List) ? data["steps"] : [];

    final String imgUrl = (data["imageUrl"] ?? "").toString();
    final bool isFavorite = data["isFavorite"] ?? false;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(title),
                const SizedBox(height: 14),
                _buildImage(imgUrl),
                const SizedBox(height: 16),
                _buildInfoBar(time, difficulty, portions),
                const SizedBox(height: 22),
                _buildTabs(),
                const SizedBox(height: 12),
                _buildContent(ingredients, steps),
                _buildFavoriteButton(isFavorite),
              ],
            ),
          ),
        ),

        if (saving)
          Container(
            color: Colors.black.withOpacity(0.35),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER — ir SIEMPRE a HomePage
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
      child: Row(
        children: [
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            },
            child: Icon(Icons.arrow_back_ios_new, color: dark, size: 22),
          ),
          const Spacer(),
          Expanded(
            flex: 4,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: dark,
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 22),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // IMAGE
  // ---------------------------------------------------------------------------
  Widget _buildImage(String imgUrl) {
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
          child: imgUrl.isEmpty
              ? const Center(child: Icon(Icons.image, size: 60))
              : Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INFO BAR
  // ---------------------------------------------------------------------------
  Widget _buildInfoBar(String time, String difficulty, String portions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(Icons.timer, size: 20, color: mint),
          const SizedBox(width: 6),
          Text(time),

          const SizedBox(width: 16),
          Icon(Icons.local_fire_department, size: 20, color: mint),
          const SizedBox(width: 6),
          Text(difficulty),

          const SizedBox(width: 16),
          Icon(Icons.person, size: 20, color: mint),
          const SizedBox(width: 6),
          Text("$portions servings"),
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
    bool active = selectedTab == index;

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
  Widget _buildContent(List ingredients, List steps) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedTab == 0)
              ...ingredients.map((ing) =>
                  IngredientTile(text: ing.toString(), mint: mint))
            else
              ...steps.asMap().entries.map(
                    (e) => StepTile(
                      number: e.key + 1,
                      text: e.value.toString(),
                    ),
                  ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FAVORITE BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildFavoriteButton(bool isFavorite) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: mint,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: saving ? null : () => _toggleFavorite(isFavorite),
          child: Text(
            isFavorite ? "Remove Favorite 💔" : "Save to Favorites ❤️",
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
  // ❤️ FAVORITE TOGGLE (USUARIO-ESPECÍFICO)
  // ---------------------------------------------------------------------------
  Future<void> _toggleFavorite(bool currentValue) async {
    if (internalId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saving recipe... try again.")),
      );
      return;
    }

    setState(() => saving = true);

    try {
      await RecipeService().toggleFavorite(internalId, currentValue);

      widget.recipeData["isFavorite"] = !currentValue;

      setState(() => saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentValue
                ? "Removed from favorites 💔"
                : "Added to favorites ❤️",
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
