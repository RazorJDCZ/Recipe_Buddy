import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  // LOGIN
  
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _firebaseError(e);
    } catch (e) {
      throw "Unexpected error: $e";
    }
  }

  
  // REGISTER
  
  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _firebaseError(e);
    } catch (e) {
      throw "Unexpected error: $e";
    }
  }

  
  // RESET PASSWORD
  
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _firebaseError(e);
    } catch (e) {
      throw "Unexpected error: $e";
    }
  }

  
  // SIGN OUT
  
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw "Sign out failed: $e";
    }
  }

  
  // CURRENT USER ID
  
  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw "No user logged in";
    }
    return user.uid;
  }

  
  // ERROR PARSING HELPER
  
  String _firebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        return "The email address is invalid.";
      case "user-disabled":
        return "This account has been disabled.";
      case "user-not-found":
        throw UserNotRegisteredException("Usuario no registrado. ¡Crea una cuenta!");
      case "invalid-credential":
        throw UserNotRegisteredException("Usuario no registrado. ¡Crea una cuenta!");
      case "wrong-password":
        return "Incorrect password.";
      case "email-already-in-use":
        return "This email is already registered.";
      case "weak-password":
        return "Password is too weak. Try something stronger.";
      case "operation-not-allowed":
        return "Email/password accounts are not enabled.";
      default:
        return e.message ?? "Authentication error.";
    }
  }
}

// Excepción personalizada para usuario no registrado
class UserNotRegisteredException implements Exception {
  final String message;
  UserNotRegisteredException(this.message);
  @override
  String toString() => message;
}