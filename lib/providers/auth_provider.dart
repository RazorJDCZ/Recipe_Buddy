import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;
  bool loading = false;
  String? errorMessage;

  AuthProvider() {
    user = _auth.currentUser;
    _auth.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }

  // --------------------------------------------------
  // LOGIN
  // --------------------------------------------------
  Future<bool> login(String email, String password) async {
    try {
      loading = true;
      errorMessage = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapError(e);
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------
  // REGISTER
  // --------------------------------------------------
  Future<bool> register(String email, String password) async {
    try {
      loading = true;
      errorMessage = null;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapError(e);
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------
  // RESET PASSWORD
  // --------------------------------------------------
  Future<bool> resetPassword(String email) async {
    try {
      loading = true;
      errorMessage = null;
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapError(e);
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------
  // LOGOUT
  // --------------------------------------------------
  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }

  // --------------------------------------------------
  // ERROR PARSER CORREGIDO
  // --------------------------------------------------
  String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        return "Correo inválido.";
      case "user-disabled":
        return "Esta cuenta ha sido deshabilitada.";
      case "user-not-found":
        return "Usuario no registrado. ¡Crea una cuenta!";
      case "wrong-password":
        return "Contraseña incorrecta.";
      case "invalid-credential":
        return "Correo o contraseña incorrectos."; // YA NO DECIMOS “no registrado”
      case "email-already-in-use":
        return "Este correo ya está registrado.";
      case "weak-password":
        return "La contraseña es demasiado débil.";
      default:
        return e.message ?? "Error desconocido.";
    }
  }
}
