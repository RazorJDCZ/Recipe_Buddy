import 'package:flutter/material.dart';
import 'package:recipe_buddy/services/auth_service.dart';
import 'login_screen.dart';
import 'home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    userController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    final username = userController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validación básica
    if (username.isEmpty) {
      _showErrorDialog('Por favor, ingresa un nombre de usuario');
      return;
    }
    if (email.isEmpty) {
      _showErrorDialog('Por favor, ingresa un correo electrónico');
      return;
    }
    if (password.isEmpty) {
      _showErrorDialog('Por favor, ingresa una contraseña');
      return;
    }
    if (password.length < 6) {
      _showErrorDialog('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService.registerUser(
        email: email,
        password: password,
        username: username,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      }
    } catch (e) {
      _showErrorDialog(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Únete a la Aventura Culinaria",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                TextField(
                  controller: userController,
                  decoration:
                      const InputDecoration(labelText: "Nombre de usuario"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailController,
                  decoration:
                      const InputDecoration(labelText: "Correo electrónico"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Contraseña"),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: isLoading ? null : _registerUser,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Crear Cuenta"),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text("¿Ya eres miembro? Inicia sesión"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
