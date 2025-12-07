import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Color mint = const Color(0xFF4BC9A8);
  final Color mintSoft = const Color(0xFFDFF7F1);
  final Color dark = const Color(0xFF1B1D22);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool loading = false;

  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = passwordConfirmController.text;

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await AuthService().register(email, password);
      setState(() => loading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // HEADER -----------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40, bottom: 36),
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
                      "Create Account",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: dark,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Sign up to get started",
                      style: TextStyle(
                        fontSize: 14,
                        color: dark.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // INPUT FIELDS --------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Email",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins")),
                    const SizedBox(height: 8),

                    _buildInputField(
                      controller: emailController,
                      hint: "example@email.com",
                      obscure: false,
                    ),

                    const SizedBox(height: 26),

                    const Text("Password",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins")),
                    const SizedBox(height: 8),

                    _buildInputField(
                      controller: passwordController,
                      hint: "••••••••",
                      obscure: true,
                    ),

                    const SizedBox(height: 26),

                    const Text("Confirm Password",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins")),
                    const SizedBox(height: 8),

                    _buildInputField(
                      controller: passwordConfirmController,
                      hint: "••••••••",
                      obscure: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // REGISTER BUTTON -----------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
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
                    onPressed: _register,
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // LOGIN LINK ----------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?",
                      style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: mint,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // LOADING OVERLAY -------------------------------------------------------
      if (loading)
        Container(
          color: Colors.black.withOpacity(0.35),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
    ]);
  }

  // ---------------------------------------------------------------------------
  // CUSTOM INPUT FIELD (preserving your design)
  // ---------------------------------------------------------------------------
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: mintSoft.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: mint.withOpacity(0.35)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
