import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/repository/teacher_exam_repository.dart';

class TeacherExamListViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final TeacherExamRepository _examRepo = TeacherExamRepository();

  List<QuizModel> _quizzes = [];
  List<QuizModel> get quizzes => _quizzes;

  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchMyExams() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) {
        errorMessage = 'Bạn chưa đăng nhập';
        _quizzes = [];
        return;
      }

      _quizzes = await _examRepo.getAllMyQuizzes(user.uid);

    } on FirestoreException catch (e) {
      errorMessage = e.message;
      _quizzes = [];
    } catch (_) {
      errorMessage = 'Đã có lỗi xảy ra khi tải dữ liệu';
      _quizzes = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}