// This is the next layer of the MVVM architecture [Repository], responsible for handling business logic related to user authentication.
// You can see detail at this link:
// file: https://github.com/Mai-ThanhAn/quizzy_cross_platform/blob/ae1413a644a5e0bad1c6ef2e61c5a8f520151104/docs/MVVM-architecture.md
// AuthRepository handles data flow for ViewModels, calls methods from AuthService and can include basic error handling.

import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/auth_exeption.dart';
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
      debugPrint("Firebase Login Error: ${e.code}");

      String message = '';
      switch (e.code) {
        case 'user-not-found':
          message = 'Tài khoản không tồn tại.';
          break;
        case 'wrong-password':
          message = 'Mật khẩu không chính xác.';
          break;
        case 'invalid-credential':
          message = 'Email hoặc mật khẩu không chính xác.';
          break;
        case 'user-disabled':
          message = 'Tài khoản này đã bị vô hiệu hóa.';
          break;
        case 'too-many-requests':
          message =
              'Quá nhiều lần đăng nhập sai. Vui lòng thử lại sau ít phút.';
          break;
        case 'invalid-email':
          message = 'Định dạng email không hợp lệ.';
          break;
        default:
          message = 'Đăng nhập thất bại: ${e.message}';
      }
      throw AuthException(message);
    } catch (e) {
      throw Exception('Oops, Đã có lỗi xảy ra, Vui lòng thử lại.');
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
