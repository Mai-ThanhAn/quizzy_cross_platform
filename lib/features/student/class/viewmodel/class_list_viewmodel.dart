import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/student/class/repository/class_repository.dart';

class EnrolledClassesViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final ClassRepository _classRepo = ClassRepository();

  List<ClassModel> _classes = [];
  List<ClassModel> get classes => _classes;

  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchEnrolledClasses() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;

      if (user == null) {
        errorMessage = 'Bạn chưa đăng nhập';
        return;
      }

      _classes = await _classRepo.getEnrolledClasses(user.uid);
    } on FirestoreException catch (e) {
      errorMessage = e.message;
      _classes = [];
    } catch (_) {
      errorMessage = 'Đã có lỗi xảy ra';
      _classes = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
