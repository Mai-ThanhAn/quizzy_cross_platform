import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/auth/repository/user_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/classes/repository/teacher_class_repository.dart';

class CreateClassViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final UserRepository _userRepo = UserRepository();
  final TeacherClassRepository _classRepo = TeacherClassRepository();

  bool isLoading = false;
  String? errorMessage;

  String _generateClassCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  Future<bool> createClass({required String className, required String semester}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) {
        errorMessage = 'Bạn chưa đăng nhập.';
        return false;
      }

      UserModel? userProfile = await _userRepo.getCurrentUser(user.uid);
      if (userProfile == null) {
        errorMessage = 'Không tìm thấy thông tin giảng viên.';
        return false;
      }

      final newClass = ClassModel(
        id: '',
        code: _generateClassCode(),
        name: className,
        lecturerId: userProfile.id,
        lecturerName: userProfile.fullName,
        semester: semester,
        createdAt: DateTime.now(),
        studentIds: [],
      );

      await _classRepo.createClass(newClass);

      return true;
    } on FirestoreException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = 'Đã có lỗi xảy ra: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
