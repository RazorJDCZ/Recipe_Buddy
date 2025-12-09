import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_buddy/services/openai_service.dart';
import './recipe_details_screen_from_ai.dart';

class GenerateRecipeScreen extends StatefulWidget {
  const GenerateRecipeScreen({super.key});

  @override
  State<GenerateRecipeScreen> createState() => _GenerateRecipeScreenState();
}

class _GenerateRecipeScreenState extends State<GenerateRecipeScreen> {
  final ingredientsController = TextEditingController();
  final List<String> ingredients = [];
  bool loading = false;

  // Colores del tema oscuro
  final Color primary = const Color(0xFF06F957);
  final Color backgroundDark = const Color(0xFF0F2316);
  final Color cardBgDark = const Color(0xFF183521);

  final OpenAIService _ai = OpenAIService();

  // Agregar ingrediente
  void _addIngredient() {
    final text = ingredientsController.text.trim();
    if (text.isNotEmpty && !ingredients.contains(text)) {
      setState(() {
        ingredients.add(text);
        ingredientsController.clear();
      });
    }
  }

  // Remover ingrediente
  void _removeIngredient(String ingredient) {
    setState(() {
      ingredients.remove(ingredient);
    });
  }

  // GENERATE RECIPE
  Future<void> _generateRecipe() async {
    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Agrega al menos un ingrediente",
            style: GoogleFonts.spaceGrotesk(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      // GENERAR TEXTO JSON DESDE OPENAI
      final ingredientsText = ingredients.join(", ");
      final jsonText = await _ai.generateRecipeText(ingredientsText);

      if (jsonText == null) {
        throw "OpenAI returned no JSON text.";
      }

      // PARSEAR JSON A MAPA SEGURO
      Map<String, dynamic> recipe = _ai.parseRecipeJson(jsonText);

      final String title = recipe["title"] ?? "Recipe";

      // Prompt más robusto
      final String prompt =
          "Professional food photography of ${recipe['title']}, ingredients: ${recipe['ingredients'].join(', ')}, high detail, soft lighting.";

      // GENERAR IMAGEN BASE64
      final base64Img = await _ai.generateImage(prompt);
      if (base64Img == null) {
        throw "Image generation failed.";
      }

      // SUBIR IMAGEN A FIREBASE STORAGE
      final imageUrl = await _ai.uploadImage(title, base64Img);
      if (imageUrl == null) {
        throw "Failed to upload image to Firebase.";
      }

      recipe["imageUrl"] = imageUrl;

      setState(() => loading = false);

      // IR A PANTALLA DE DETALLES CON LA RECETA
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RecipeDetailsScreenFromAI(recipeData: recipe),
        ),
      );
    } catch (e) {
      setState(() => loading = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error generando receta: $e",
            style: GoogleFonts.spaceGrotesk(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundDark,
          body: SafeArea(
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Generar Receta",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        // Pregunta
                        Text(
                          "¿Qué tienes en tu cocina?",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // TEXTFIELD
                        Container(
                          decoration: BoxDecoration(
                            color: cardBgDark,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: ingredientsController,
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText:
                                  "Introduce tus ingredientes (ej: pollo, arroz, tomate)",
                              hintStyle: GoogleFonts.spaceGrotesk(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                            ),
                            onSubmitted: (_) => _addIngredient(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Botón para agregar ingrediente
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _addIngredient,
                            icon: Icon(Icons.add, color: primary, size: 20),
                            label: Text(
                              "Agregar",
                              style: GoogleFonts.spaceGrotesk(
                                color: primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Lista de chips de ingredientes
                        if (ingredients.isNotEmpty) ...[
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: ingredients.map((ingredient) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: cardBgDark,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: primary.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ingredient,
                                      style: GoogleFonts.spaceGrotesk(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _removeIngredient(ingredient),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white.withOpacity(0.6),
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ],
                    ),
                  ),
                ),

                // BUTTON
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: backgroundDark,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: loading ? null : _generateRecipe,
                      child: Text(
                        "Generar Receta",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Loading overlay
        if (loading)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primary),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Generando tu receta...",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    ingredientsController.dispose();
    super.dispose();
}
}