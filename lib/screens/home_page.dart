import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/recipe_card.dart';
import 'generate_recipe_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final searchController = TextEditingController();

  final Color mint = const Color(0xFF4BC9A8);
  final Color mintSoft = const Color(0xFFDFF7F1);
  final Color dark = const Color(0xFF1B1D22);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // 🔥 PRUEBA TEMPORAL DE FIREBASE
    FirebaseFirestore.instance
        .collection('test')
        .add({'message': 'Hola Isa!'});
  }

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
              padding: const EdgeInsets.only(top: 24, bottom: 34),
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
                    "Recipe Buddy",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(Icons.flatware_rounded, color: mint, size: 26),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ---------------- TABS ----------------
            TabBar(
              controller: _tabController,
              labelColor: mint,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              indicatorColor: mint,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: "All Recipes"),
                Tab(text: "Favorites"),
              ],
            ),

            const SizedBox(height: 14),

            // ---------------- SEARCH (CENTRADO PERFECTO) ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: mintSoft.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: mint.withOpacity(0.3),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: "Search recipes...",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 8),
                      child: Icon(Icons.search, color: mint, size: 22),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- CONTENT ----------------
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildRecipeGrid(),
                  buildFavoritesGrid(),
                ],
              ),
            ),
          ],
        ),
      ),

      // ---------------- ADD BUTTON ----------------
      floatingActionButton: SizedBox(
        height: 58,
        width: 58,
        child: FloatingActionButton(
          backgroundColor: mint,
          elevation: 9,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(Icons.add, size: 30, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GenerateRecipeScreen()),
            );
          },
        ),
      ),
    );
  }

  // ---------------- GRID ----------------
  Widget buildRecipeGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 24,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (_, i) => const RecipeCard(),
      ),
    );
  }

  Widget buildFavoritesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        itemCount: 3,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 24,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (_, i) => const RecipeCard(isFavorite: true),
      ),
    );
  }
}

