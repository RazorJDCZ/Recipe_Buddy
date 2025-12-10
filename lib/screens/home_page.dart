import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/auth_provider.dart' as local_auth;
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

  final Color primary = const Color(0xFF06F957);
  final Color backgroundDark = const Color(0xFF0A1612);
  final Color cardBgDark = const Color(0xFF152820);

  final RecipeService _service = RecipeService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<local_auth.AuthProvider>(context);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(auth),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // HEADER ------------------------------------------------
  Widget _buildHeader(local_auth.AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Mis Recetas",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () => _showProfileOptions(auth),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cardBgDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SEARCH BAR --------------------------------------------
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Buscar recetas...",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.6)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: cardBgDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  // TAB CONTENT -------------------------------------------
  Widget _buildTabContent() {
    return selectedTab == 0 ? _allRecipesStream() : _favoritesStream();
  }

  // ALL RECIPES -------------------------------------------
  Widget _allRecipesStream() {
    return StreamBuilder<List<Recipe>>(
      stream: _service.listenAllRecipes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          );
        }

        var recipes = snapshot.data!;

        if (_searchQuery.isNotEmpty) {
          recipes = recipes.where((r) {
            return r.title.toLowerCase().contains(_searchQuery) ||
                r.ingredients.any(
                    (ingredient) => ingredient.toLowerCase().contains(_searchQuery));
          }).toList();
        }

        if (recipes.isEmpty) {
          return _emptyState(_searchQuery.isNotEmpty
              ? "No se encontraron recetas\ncon '$_searchQuery'"
              : "No hay recetas aún.\n¡Crea tu primera receta!");
        }

        return _recipeGrid(recipes);
      },
    );
  }

  // FAVORITES ---------------------------------------------
  Widget _favoritesStream() {
    return StreamBuilder<List<Recipe>>(
      stream: _service.listenFavoriteRecipes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          );
        }

        var favorites = snapshot.data!;

        if (_searchQuery.isNotEmpty) {
          favorites = favorites.where((r) {
            return r.title.toLowerCase().contains(_searchQuery) ||
                r.ingredients.any(
                    (ingredient) => ingredient.toLowerCase().contains(_searchQuery));
          }).toList();
        }

        if (favorites.isEmpty) {
          return _emptyState(_searchQuery.isNotEmpty
              ? "No se encontraron favoritas\ncon '$_searchQuery'"
              : "Aún no tienes favoritas.\n❤ Marca tus recetas favoritas");
        }

        return _recipeGrid(favorites);
      },
    );
  }

  // GRID VIEW ---------------------------------------------
  Widget _recipeGrid(List<Recipe> recipes) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) => RecipeCard(recipe: recipes[index]),
    );
  }

  // EMPTY STATE -------------------------------------------
  Widget _emptyState(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_outlined,
              size: 80, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.4),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // NAV BAR -----------------------------------------------
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: cardBgDark,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navBarItem(Icons.restaurant_menu, "Recetas", 0),
              _navBarItem(Icons.add_circle, "Generar", 2, isCenter: true),
              _navBarItem(Icons.favorite, "Favoritos", 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navBarItem(IconData icon, String label, int index,
      {bool isCenter = false}) {
    final isActive = selectedTab == index;

    return GestureDetector(
      onTap: () {
        if (isCenter) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GenerateRecipeScreen()),
          );
        } else {
          setState(() => selectedTab = index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isCenter ? 16 : 12),
            decoration: BoxDecoration(
              color: isCenter
                  ? primary
                  : (isActive ? primary.withOpacity(0.15) : Colors.transparent),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isCenter
                  ? Colors.black87
                  : (isActive ? primary : Colors.white.withOpacity(0.6)),
              size: isCenter ? 32 : 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isCenter
                  ? primary
                  : (isActive ? primary : Colors.white.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }

  // PROFILE OPTIONS ---------------------------------------
  void _showProfileOptions(local_auth.AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBgDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary.withOpacity(0.8), primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.black87,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      auth.user?.email ?? "Usuario",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                title: Text(
                  "Cerrar sesión",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  // Preguntamos si quiere salir
                  final confirm = await showDialog<bool>(
                    context: sheetContext,
                    builder: (dialogContext) => AlertDialog(
                      backgroundColor: cardBgDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        "Cerrar sesión",
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      content: Text(
                        "¿Estás seguro que deseas salir?",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white70,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext, false),
                          child: Text(
                            "Cancelar",
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext, true),
                          child: Text(
                            "Salir",
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await auth.signOut();
                    if (!mounted) return;
                    // cerramos el bottom sheet
                    Navigator.pop(sheetContext);
                    // NO navegamos manualmente; AuthGate mostrará LoginScreen
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
