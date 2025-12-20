import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/auth/repository/user_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/classes/repository/teacher_class_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/repository/teacher_exam_repository.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';

class TeacherHomeViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final UserRepository _userRepo = UserRepository();
  final TeacherClassRepository _classRepo = TeacherClassRepository();
  final TeacherExamRepository _examRepo = TeacherExamRepository();

  bool isLoading = false;

  int totalClasses = 0;
  int totalExams = 0;
  String userName = 'Giảng viên';

  Future<void> loadDashboardData() async {
    isLoading = true;
    notifyListeners();

    try {
      final authUser = _authRepo.currentUser;
      if (authUser == null) return;

      final userId = authUser.uid;

      final UserModel? user = await _userRepo.getCurrentUser(userId);

      if (user != null) {
        userName = user.fullName.trim().isNotEmpty == true
            ? user.fullName
            : 'Giảng viên';
      }

      final results = await Future.wait([
        _classRepo.getCreatedClasses(userId),
        _examRepo.getAllMyQuizzes(userId),
      ]);

      totalClasses = (results[0] as List).length;
      totalExams = (results[1] as List).length;
    } catch (e) {
      debugPrint('❌ Load dashboard failed: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
