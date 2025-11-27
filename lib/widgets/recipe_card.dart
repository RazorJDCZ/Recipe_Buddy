import 'package:flutter/material.dart';
import '../screens/recipe_details_screen.dart';

class RecipeCard extends StatelessWidget {
  final bool isFavorite;
  final String title;
  final String time;
  final String difficulty;
  final String imageUrl;

  const RecipeCard({
    super.key,
    this.isFavorite = false,
    this.title = "Recipe Name",
    this.time = "30 min",
    this.difficulty = "Easy",
    this.imageUrl = "",
  });

  @override
  Widget build(BuildContext context) {
    final Color mint = const Color(0xFF4BC9A8);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecipeDetailsScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------- IMAGE ----------------
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [

                  // Placeholder image or custom
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: imageUrl.isNotEmpty
                          ? Image.network(imageUrl, fit: BoxFit.cover)
                          : const Icon(Icons.restaurant_menu,
                              size: 48, color: Colors.grey),
                    ),
                  ),

                  // Favorite heart
                  if (isFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ---------------- TEXT INFO ----------------
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Title
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Time + Difficulty
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: mint),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Icon(Icons.local_fire_department,
                          size: 16, color: mint),
                      const SizedBox(width: 4),
                      Text(
                        difficulty,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
