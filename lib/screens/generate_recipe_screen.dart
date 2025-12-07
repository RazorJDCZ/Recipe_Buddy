import 'package:flutter/material.dart';
import 'package:recipe_buddy/services/openai_service.dart';
import './recipe_details_screen_from_ai.dart';

class GenerateRecipeScreen extends StatefulWidget {
  const GenerateRecipeScreen({super.key});

  @override
  State<GenerateRecipeScreen> createState() => _GenerateRecipeScreenState();
}

class _GenerateRecipeScreenState extends State<GenerateRecipeScreen> {
  final ingredientsController = TextEditingController();
  String dishType = "Main Course";
  bool loading = false;

  final Color mint = const Color(0xFF4BC9A8);
  final Color mintSoft = const Color(0xFFDFF7F1);
  final Color dark = const Color(0xFF1B1D22);

  final OpenAIService _ai = OpenAIService();

  // 🚀 GENERATE RECIPE
  Future<void> _generateRecipe() async {
    final ingredients = ingredientsController.text.trim();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter ingredients.")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      // -------------------------------------------------------------
      // 1️⃣ GENERAR TEXTO JSON DESDE OPENAI
      // -------------------------------------------------------------
      final jsonText = await _ai.generateRecipeText(ingredients);

      if (jsonText == null) {
        throw "OpenAI returned no JSON text.";
      }

      // -------------------------------------------------------------
      // 2️⃣ PARSEAR JSON A MAPA SEGURO
      // -------------------------------------------------------------
      Map<String, dynamic> recipe = _ai.parseRecipeJson(jsonText);

      final String title = recipe["title"] ?? "Recipe";

      // Prompt más robusto
      final String prompt =
          "Professional food photography of ${recipe['title']}, ingredients: ${recipe['ingredients'].join(', ')}, high detail, soft lighting.";

      // -------------------------------------------------------------
      // 3️⃣ GENERAR IMAGEN BASE64
      // -------------------------------------------------------------
      final base64Img = await _ai.generateImage(prompt);
      if (base64Img == null) {
        throw "Image generation failed.";
      }

      // -------------------------------------------------------------
      // 4️⃣ SUBIR IMAGEN A FIREBASE STORAGE
      // -------------------------------------------------------------
      final imageUrl = await _ai.uploadImage(title, base64Img);
      if (imageUrl == null) {
        throw "Failed to upload image to Firebase.";
      }

      recipe["imageUrl"] = imageUrl;

      setState(() => loading = false);

      // -------------------------------------------------------------
      // 5️⃣ IR A PANTALLA DE DETALLES CON LA RECETA
      // -------------------------------------------------------------
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RecipeDetailsScreenFromAI(recipeData: recipe),
        ),
      );
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error generating recipe: $e")),
      );
    }
  }

  // -------------------------------------------------------------
  // CHIPS DE TIPO DE PLATO
  // -------------------------------------------------------------
  Widget _buildChip(String text) {
    bool selected = dishType == text;

    return GestureDetector(
      onTap: () => setState(() => dishType = text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? mint : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: mint),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: mint.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // UI
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 24, bottom: 28),
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
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Generate a Recipe",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: dark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(Icons.auto_awesome, color: mint, size: 26),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Write the ingredients you have, and let the AI create a recipe for you.",
                          style: TextStyle(fontSize: 15, height: 1.4),
                        ),
                        const SizedBox(height: 20),

                        // TEXTFIELD
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: mintSoft.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: mint.withOpacity(0.35),
                              width: 1.2,
                            ),
                          ),
                          child: TextField(
                            controller: ingredientsController,
                            maxLines: 6,
                            decoration: const InputDecoration(
                              hintText:
                                  "Example: pasta, tomatoes, garlic, basil...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        const Text(
                          "Dish type",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildChip("Main Course"),
                            _buildChip("Dessert"),
                            _buildChip("Soup"),
                            _buildChip("Salad"),
                          ],
                        ),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),

                // BUTTON
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mint,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                      ),
                      onPressed: _generateRecipe,
                      child: const Text(
                        "Generate Recipe ✨",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (loading)
          Container(
            color: Colors.black.withOpacity(0.35),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
