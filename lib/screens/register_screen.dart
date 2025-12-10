import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
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

  bool showPassword = false;
  bool showConfirmPassword = false;

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _register() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirm = passwordConfirmController.text.trim();

    // VALIDACIONES
    if (email.isEmpty) {
      _showError("Correo requerido", "Por favor ingresa tu correo electrónico");
      return;
    }
    if (!isValidEmail(email)) {
      _showError("Email inválido", "Por favor ingresa un correo válido");
      return;
    }
    if (pass.isEmpty) {
      _showError("Contraseña requerida", "Por favor ingresa una contraseña");
      return;
    }
    if (pass.length < 6) {
      _showError("Contraseña muy corta", "Debe tener al menos 6 caracteres");
      return;
    }
    if (confirm.isEmpty) {
      _showError("Confirmación requerida", "Por favor confirma tu contraseña");
      return;
    }
    if (pass != confirm) {
      _showError("Contraseñas no coinciden",
          "Las contraseñas ingresadas no son iguales");
      return;
    }

    // EJECUTAR REGISTRO
    final ok = await auth.register(email, pass);

    if (!ok) {
      _showError("Error", auth.errorMessage ?? "Ocurrió un error inesperado");
      return;
    }

    if (!mounted) return;

    // DIALOGO DE ÉXITO
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
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
  }

  void _showError(String title, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
          msg,
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
    final auth = Provider.of<AuthProvider>(context);

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

                  // ICONO
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.restaurant_menu, color: primary, size: 50),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    "Crear Cuenta",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildInput(
                    label: "Correo electrónico",
                    controller: emailController,
                    hint: "Introduce tu correo electrónico",
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 24),

                  _buildInput(
                    label: "Contraseña",
                    controller: passwordController,
                    hint: "Introduce tu contraseña",
                    icon: Icons.lock_outlined,
                    obscure: !showPassword,
                    suffix: GestureDetector(
                      onTap: () => setState(() => showPassword = !showPassword),
                      child: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildInput(
                    label: "Confirmar Contraseña",
                    controller: passwordConfirmController,
                    hint: "Confirma tu contraseña",
                    icon: Icons.lock_outlined,
                    obscure: !showConfirmPassword,
                    suffix: GestureDetector(
                      onTap: () =>
                          setState(() => showConfirmPassword = !showConfirmPassword),
                      child: Icon(
                        showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: auth.loading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿Ya tienes una cuenta? ",
                        style: GoogleFonts.spaceGrotesk(color: Colors.white70),
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

        if (auth.loading) _loadingOverlay(),
      ],
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
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
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: GoogleFonts.spaceGrotesk(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.5)),
              suffixIcon: suffix,
              hintText: hint,
              hintStyle:
                  TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 15),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primary),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              "Creando tu cuenta...",
              style: GoogleFonts.spaceGrotesk(color: Colors.white),
            ),
          ],
        ),
      ),
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
