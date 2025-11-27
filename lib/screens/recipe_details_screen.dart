import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen>
    with SingleTickerProviderStateMixin {
  int selectedTab = 0; // 0 = ingredientes, 1 = procedimiento

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
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new,
                        color: dark, size: 22),
                  ),
                  const Spacer(),
                  Text(
                    "Recipe Details",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: dark,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 22),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---------------- IMAGE ----------------
            Padding(
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
                child: const Center(child: Text("Image here")),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- TITLE + ICONS ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recipe Name",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Poppins",
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.timer, size: 20, color: mint),
                      const SizedBox(width: 6),
                      const Text("30 min",
                          style:
                              TextStyle(fontSize: 14, color: Colors.black87)),

                      const SizedBox(width: 20),

                      Icon(Icons.local_fire_department,
                          size: 20, color: mint),
                      const SizedBox(width: 6),
                      const Text("Easy",
                          style:
                              TextStyle(fontSize: 14, color: Colors.black87)),

                      const SizedBox(width: 20),

                      Icon(Icons.person, size: 20, color: mint),
                      const SizedBox(width: 6),
                      const Text("2 portions",
                          style:
                              TextStyle(fontSize: 14, color: Colors.black87)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------------- TABS ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // INGREDIENTS TAB
                  GestureDetector(
                    onTap: () => setState(() => selectedTab = 0),
                    child: Column(
                      children: [
                        Text(
                          "Ingredients",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                selectedTab == 0 ? mint : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 3,
                          width: 80,
                          decoration: BoxDecoration(
                            color:
                                selectedTab == 0 ? mint : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(width: 30),

                  // PROCEDURE TAB
                  GestureDetector(
                    onTap: () => setState(() => selectedTab = 1),
                    child: Column(
                      children: [
                        Text(
                          "Steps",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                selectedTab == 1 ? mint : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 3,
                          width: 55,
                          decoration: BoxDecoration(
                            color:
                                selectedTab == 1 ? mint : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- SCROLLABLE CONTENT ----------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedTab == 0) ...[
                      buildIngredient("Ingredient 1"),
                      buildIngredient("Ingredient 2"),
                      buildIngredient("Ingredient 3"),
                      buildIngredient("Ingredient 4"),
                      const SizedBox(height: 100),
                    ] else ...[
                      buildStep("Paso 1"),
                      buildStep("Paso 2"),
                      buildStep("Paso 3"),
                      buildStep("Paso 4"),
                      buildStep("Paso 5"),
                      const SizedBox(height: 100),
                    ]
                  ],
                ),
              ),
            ),

            // ---------------- SAVE BUTTON ----------------
            Container(
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
                  onPressed: () {},
                  child: const Text(
                    "Guardar Receta ❤",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
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

  Widget buildIngredient(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.circle_outlined, size: 20, color: mint),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ",
              style: TextStyle(fontSize: 20, height: 1.1)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
