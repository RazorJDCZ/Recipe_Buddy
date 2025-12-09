import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // Colores actualizados para el nuevo diseño
  final Color primary = const Color(0xFF06F957);
  final Color backgroundDark = const Color(0xFF0A1612);
  final Color cardBgDark = const Color(0xFF152820);

  final RecipeService _service = RecipeService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el texto de búsqueda
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
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

  
  // HEADER con ícono de perfil en la derecha
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Título
          Text(
            "Mis Recetas",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          
          // Botón de perfil
          GestureDetector(
            onTap: _showProfileOptions,
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

  
  // SEARCH BAR 
  
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
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  
  // TAB CONTENT
  
  Widget _buildTabContent() {
    return selectedTab == 0 ? _allRecipesStream() : _favoritesStream();
  }

  
  // ALL RECIPES 
  
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

        // Filtrar recetas según la búsqueda
        if (_searchQuery.isNotEmpty) {
          recipes = recipes.where((recipe) {
            // Buscar en el título
            final titleMatch = recipe.title.toLowerCase().contains(_searchQuery);
            
            // Buscar en los ingredientes
            final ingredientsMatch = recipe.ingredients.any(
              (ingredient) => ingredient.toLowerCase().contains(_searchQuery),
            );
            
            return titleMatch || ingredientsMatch;
          }).toList();
        }

        if (recipes.isEmpty) {
          return _emptyState(
            _searchQuery.isNotEmpty
                ? "No se encontraron recetas\ncon '$_searchQuery'"
                : "No hay recetas aún.\n¡Crea tu primera receta!",
          );
        }

        return _recipeGrid(recipes);
      },
    );
  }

  
  // FAVORITES 
  
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

        // Filtrar favoritos según la búsqueda
        if (_searchQuery.isNotEmpty) {
          favorites = favorites.where((recipe) {
            // Buscar en el título
            final titleMatch = recipe.title.toLowerCase().contains(_searchQuery);
            
            // Buscar en los ingredientes
            final ingredientsMatch = recipe.ingredients.any(
              (ingredient) => ingredient.toLowerCase().contains(_searchQuery),
            );
            
            return titleMatch || ingredientsMatch;
          }).toList();
        }

        if (favorites.isEmpty) {
          return _emptyState(
            _searchQuery.isNotEmpty
                ? "No se encontraron favoritas\ncon '$_searchQuery'"
                : "Aún no tienes favoritas.\n❤ Marca tus recetas favoritas",
          );
        }

        return _recipeGrid(favorites);
      },
    );
  }

  
  // GRID VIEW (2 columnas como en la imagen)
  
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
      itemBuilder: (context, index) {
        return RecipeCard(recipe: recipes[index]);
      },
    );
  }

  
  // EMPTY STATE
  
  Widget _emptyState(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.2),
          ),
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

  
  // BOTTOM NAVIGATION BAR 
  
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
              _navBarItem(
                icon: Icons.restaurant_menu,
                label: "Recetas",
                index: 0,
              ),
              _navBarItem(
                icon: Icons.add_circle,
                label: "Generar",
                index: 2,
                isCenter: true,
              ),
              _navBarItem(
                icon: Icons.favorite,
                label: "Favoritos",
                index: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navBarItem({
    required IconData icon,
    required String label,
    required int index,
    bool isCenter = false,
  }) {
    final isActive = selectedTab == index;

    return GestureDetector(
      onTap: () {
        if (isCenter) {
          // Navegar a generar receta
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GenerateRecipeScreen()),
          );
        } else {
          // Cambiar tab (0 = Recetas, 1 = Favoritos)
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

  
  // PROFILE OPTIONS 
  
  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBgDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // User info (solo correo)
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
                      FirebaseAuth.instance.currentUser?.email ?? "Usuario",
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

              // Logout button
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  Navigator.pop(context);
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
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
                        style: GoogleFonts.spaceGrotesk(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Cancelar",
                            style: GoogleFonts.spaceGrotesk(color: Colors.white70),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
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
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, "/login");
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