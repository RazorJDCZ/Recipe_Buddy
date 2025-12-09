import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Color primary = const Color(0xFF06F957);
  final Color backgroundDark = const Color(0xFF0F2316);
  final Color cardBgDark = const Color(0xFF183521);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool loading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  // Validar email
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = passwordConfirmController.text;

    // Validar campos vacíos
    if (email.isEmpty) {
      _showErrorDialog("Correo requerido", "Por favor ingresa tu correo electrónico");
      return;
    }

    if (password.isEmpty) {
      _showErrorDialog("Contraseña requerida", "Por favor ingresa una contraseña");
      return;
    }

    if (confirm.isEmpty) {
      _showErrorDialog("Confirmación requerida", "Por favor confirma tu contraseña");
      return;
    }

    // Validar email
    if (!isValidEmail(email)) {
      _showErrorDialog("Email inválido", "Por favor ingresa un correo electrónico válido");
      return;
    }

    // Validar longitud de contraseña
    if (password.length < 6) {
      _showErrorDialog(
        "Contraseña muy corta",
        "La contraseña debe tener al menos 6 caracteres",
      );
      return;
    }

    // Validar coincidencia de contraseñas
    if (password != confirm) {
      _showErrorDialog(
        "Contraseñas no coinciden",
        "Las contraseñas ingresadas no son iguales",
      );
      return;
    }

    setState(() => loading = true);

    try {
      await AuthService().register(email, password);
      setState(() => loading = false);

      if (!mounted) return;

      // Mostrar diálogo de éxito
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: cardBgDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: primary, size: 28),
              const SizedBox(width: 10),
              Text(
                "¡Cuenta creada!",
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            "Tu cuenta ha sido creada exitosamente. Bienvenido a Recipe Buddy.",
            style: GoogleFonts.spaceGrotesk(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
              child: Text(
                "Continuar",
                style: GoogleFonts.spaceGrotesk(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => loading = false);
      _showErrorDialog("Error", "No se pudo crear la cuenta: $e");
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBgDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 28),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.spaceGrotesk(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Entendido",
              style: GoogleFonts.spaceGrotesk(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundDark,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // ICONO SUPERIOR
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      color: primary,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // TITULO
                  Text(
                    "Crear Cuenta",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // EMAIL
                  _buildLabeledInput(
                    label: "Correo electrónico",
                    controller: emailController,
                    hint: "Introduce tu correo electrónico",
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 24),

                  // PASSWORD
                  _buildLabeledInput(
                    label: "Contraseña",
                    controller: passwordController,
                    hint: "Introduce tu contraseña",
                    icon: Icons.lock_outlined,
                    obscure: !showPassword,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => showPassword = !showPassword),
                      child: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // CONFIRM PASSWORD
                  _buildLabeledInput(
                    label: "Confirmar contraseña",
                    controller: passwordConfirmController,
                    hint: "Confirma tu contraseña",
                    icon: Icons.lock_outlined,
                    obscure: !showConfirmPassword,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => showConfirmPassword = !showConfirmPassword),
                      child: Icon(
                        showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // REGISTER BUTTON
                  SizedBox(
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
                      onPressed: loading ? null : _register,
                      child: Text(
                        "Crear Cuenta",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // LOGIN LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿Ya tienes una cuenta? ",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        child: Text(
                          "Inicia sesión",
                          style: GoogleFonts.spaceGrotesk(
                            color: primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),

        // LOADING OVERLAY
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
                    "Creando tu cuenta...",
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

  Widget _buildLabeledInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
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
            controller: controller,
            obscureText: obscure,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.spaceGrotesk(
                color: Colors.white.withOpacity(0.4),
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(0.5),
                size: 22,
              ),
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: suffixIcon,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
}
}