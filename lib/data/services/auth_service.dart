// Đây là tầng thấp nhất của kiến trúc MVVM [Services], chịu trách nhiệm tương tác trực tiếp với Firebase Authentication.
// Không chứa logic nghiệp vụ, validate hay xử lý dữ liệu, chỉ đơn thuần gọi các API của Firebase.

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng ký tài khoản
  Future<UserCredential> register(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Đăng nhập
  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
  }

  // User hiện tại
  User? get currentUser => _auth.currentUser;
}
