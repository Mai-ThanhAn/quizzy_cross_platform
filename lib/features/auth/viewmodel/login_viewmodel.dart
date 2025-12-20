import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/auth_exeption.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/auth/repository/user_repository.dart';

class LoginViewmodel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final UserRepository _userRepo = UserRepository();

  bool isLoading = false;
  String? errorMessage;
  String? role;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final userCred = await _authRepo.loginUser(email, password);
      final uid = userCred.user?.uid;

      if (uid == null) {
        throw AuthException('Đăng nhập thất bại.');
      }

      final userModel = await _userRepo.getCurrentUser(uid);

      if (userModel == null || !userModel.isActive) {
        throw AuthException('Tài khoản không hợp lệ.');
      }

      role = userModel.role;
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Đã có lỗi xảy ra';
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
      errorMessage = 'Đã có lỗi xảy ra';
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
      errorMessage = 'Đã có lỗi xảy ra';
      return false;
    }
  }
}
