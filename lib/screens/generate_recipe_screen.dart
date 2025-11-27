import 'package:flutter/material.dart';

class GenerateRecipeScreen extends StatefulWidget {
  const GenerateRecipeScreen({super.key});

  @override
  State<GenerateRecipeScreen> createState() => _GenerateRecipeScreenState();
}

class _GenerateRecipeScreenState extends State<GenerateRecipeScreen> {
  final ingredientsController = TextEditingController();
  String dishType = "Main Course";

  final Color mint = const Color(0xFF4BC9A8);
  final Color mintSoft = const Color(0xFFDFF7F1);
  final Color dark = const Color(0xFF1B1D22);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // ---------------- HEADER ----------------
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

                    // ---------------- TEXTAREA ----------------
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: mintSoft.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: mint.withOpacity(0.35), width: 1.2),
                      ),
                      child: TextField(
                        controller: ingredientsController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          hintText: "Example: pasta, tomatoes, garlic, basil...",
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
                        buildChip("Main Course"),
                        buildChip("Dessert"),
                        buildChip("Soup"),
                        buildChip("Salad"),
                      ],
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            // ---------------- BUTTON ----------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                  onPressed: () {},
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
    );
  }

  // ---------------- CHIP BUILDER ----------------
  Widget buildChip(String text) {
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
}
