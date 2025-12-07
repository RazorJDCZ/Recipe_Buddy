import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // REGISTER
  static Future<UserCredential> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateProfile(displayName: username);

      // Guardar en Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Este correo ya está registrado.');
      }
      if (e.code == 'weak-password') {
        throw Exception('La contraseña es muy débil.');
      }
      if (e.code == 'invalid-email') {
        throw Exception('Correo inválido.');
      }

      throw Exception('Error al registrar: ${e.message}');
    }
  }

  // LOGIN
  static Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotRegisteredException('No existe una cuenta con ese correo.');
      }
      if (e.code == 'invalid-credential') {
        throw UserNotRegisteredException('Usuario no registrado. ¡Crea una cuenta para continuar!');
      }
      if (e.code == 'wrong-password') {
        throw Exception('Contraseña incorrecta.');
      }
      if (e.code == 'invalid-email') {
        throw Exception('Correo electrónico inválido.');
      }
      throw Exception('Error al iniciar sesión: ${e.message}');
    } on FirebaseException catch (e) {
      throw Exception('Error de Firebase: ${e.message}');
    }
  }

  static Future<void> logoutUser() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() => _auth.currentUser;

  static Map<String, dynamic>? getCurrentUserInfo() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
    };
  }

  static Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception('Error al enviar correo de recuperación: ${e.message}');
    }
  }
}

// Excepción personalizada
class UserNotRegisteredException implements Exception {
  final String message;
  UserNotRegisteredException(this.message);
  @override
  String toString() => message;
}
