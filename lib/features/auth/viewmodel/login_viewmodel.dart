import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/auth/repository/user_repository.dart';

class LoginViewmodel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final UserRepository _userRepo = UserRepository();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      bool exists = await _userRepo.checkEmailExists(email);

      if (!exists) {
        errorMessage = 'Bạn chưa có tài khoản trong hệ thống.';
        return false;
      }

      await _authRepo.loginUser(email, password);
      return true;
    } catch (e) {
      errorMessage = 'Đăng nhập thất bại: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> forgotpass(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      bool exists = await _userRepo.checkEmailExists(email);

      if (!exists) {
        errorMessage = 'Bạn chưa có tài khoản trong hệ thống.';
        return false;
      }

      await _authRepo.forgotpassUser(email);
      return true;
    } catch (e) {
      errorMessage = 'Lỗi trong quá trình xử lý: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    try {
      await _authRepo.logoutUser();
      return true;
    } catch (e) {
      errorMessage = 'Đăng xuất thất bại: $e';
      return false;
    }
  }
}
