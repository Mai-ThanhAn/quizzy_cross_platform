// Service layer for Firebase Authentication.
// This is the lowest layer of the MVVM architecture [Services], responsible for direct interaction with Firebase Authentication.
// Dont contain business logic, validation, or data processing; simply calls Firebase APIs.
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register User
  Future<UserCredential> register(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Login User
  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Forgot Pass
  Future<void> forgotpass(String email) async{
    return await _auth.sendPasswordResetEmail(email: email);
  }

  // Logout User
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get Current User
  User? get currentUser => _auth.currentUser;
}
