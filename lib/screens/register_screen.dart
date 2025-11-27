import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  final userController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RegisterScreen({super.key});

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
                    onPressed: () {},
                    child: const Text("Crear Cuenta")),

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
