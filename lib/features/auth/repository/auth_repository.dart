// This is the next layer of the MVVM architecture [Repository], responsible for handling business logic related to user authentication.
// You can see detail at this link:
// file: https://github.com/Mai-ThanhAn/quizzy_cross_platform/blob/ae1413a644a5e0bad1c6ef2e61c5a8f520151104/docs/MVVM-architecture.md
// AuthRepository handles data flow for ViewModels, calls methods from AuthService and can include basic error handling.

import '../../../data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  // Register User
  Future<UserCredential> registerUser(String email, String password) async {
    try {
      return await _service.register(email, password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Login User
  Future<UserCredential> loginUser(String email, String password) async {
    try {
      return await _service.login(email, password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Forgot Pass
  Future<void> forgotpassUser(String email) async {
    try {
      return await _service.forgotpass(email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Logout User
  Future<void> logoutUser() async {
    await _service.logout();
  }

  // Get Current User
  User? get currentUser => _service.currentUser;
}
