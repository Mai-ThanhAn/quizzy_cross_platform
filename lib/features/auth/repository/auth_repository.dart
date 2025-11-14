// Đây là tầng tiếp theo của kiến trúc MVVM [Repository], chịu trách nhiệm xử lý logic nghiệp vụ liên quan đến xác thực người dùng.
// AuthRepository xử lý luồng dữ liệu cho ViewModels, gọi các phương thức từ AuthService và có thể bao gồm các xử lý lỗi cơ bản.

import '../../../data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  // Đăng ký người dùng
  Future<UserCredential> registerUser(String email, String password) async {
    try {
      return await _service.register(email, password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Đăng nhập người dùng
  Future<UserCredential> loginUser(String email, String password) async {
    try {
      return await _service.login(email, password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Đăng xuất người dùng
  Future<void> logout() async {
    await _service.logout();
  }

  // Lấy người dùng hiện tại
  User? get currentUser => _service.currentUser;
}

