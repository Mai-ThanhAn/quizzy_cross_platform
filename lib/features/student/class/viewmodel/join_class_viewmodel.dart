import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/student/class/repository/class_repository.dart';

class JoinClassViewModel extends ChangeNotifier {
  final ClassRepository _classRepo = ClassRepository();
  final AuthRepository _authRepo = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> joinClass(String code) async {
    if (code.trim().isEmpty) {
      errorMessage = 'Vui lòng nhập mã lớp';
      notifyListeners();
      return false;
    }

    if (code.trim().length < 6) {
      errorMessage = 'Mã lớp không hợp lệ (quá ngắn)';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) {
        errorMessage = 'Bạn chưa đăng nhập';
        return false;
      }

      await _classRepo.joinClass(code.trim(), user.uid);

      return true;
    } on FirestoreException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = 'Lỗi không xác định. Vui lòng thử lại sau';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
