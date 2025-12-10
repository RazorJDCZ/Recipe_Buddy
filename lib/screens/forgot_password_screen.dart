import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final Color primary = const Color(0xFF06F957);
  final Color backgroundDark = const Color(0xFF0F2316);
  final Color cardBgDark = const Color(0xFF183521);

  final TextEditingController emailController = TextEditingController();
  bool showErrorBorder = false;
  bool loading = false;

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<void> _resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !isValidEmail(email)) {
      setState(() => showErrorBorder = true);
      _showErrorDialog(
        "Correo inválido",
        "Por favor introduce un correo electrónico válido.",
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() => loading = true);
    final ok = await auth.resetPassword(email);
    setState(() => loading = false);

    if (!ok) {
      _showErrorDialog(
        "Error",
        auth.errorMessage ?? "Ocurrió un error inesperado",
      );
      return;
    }

    _showSuccessDialog(
      "Correo enviado",
      "Hemos enviado un enlace para restablecer tu contraseña.",
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBgDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 28),
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

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBgDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: primary, size: 28),
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // regresar al login
            },
            child: Text(
              "Volver",
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // ÍCONO
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      color: primary,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "¿Olvidaste tu contraseña?",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Ingresa tu correo y te enviaremos un enlace\npara restablecer tu contraseña.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // INPUT
                  Container(
                    decoration: BoxDecoration(
                      color: cardBgDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: showErrorBorder
                            ? Colors.red
                            : Colors.white.withOpacity(0.1),
                        width: 1.2,
                      ),
                    ),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: "Introduce tu correo",
                        hintStyle: GoogleFonts.spaceGrotesk(
                          color: Colors.white.withOpacity(0.4),
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        contentPadding: const EdgeInsets.all(18),
                      ),
                      onChanged: (_) =>
                          setState(() => showErrorBorder = false),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Enviar enlace",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // OVERLAY
        if (loading)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Enviando enlace...",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
