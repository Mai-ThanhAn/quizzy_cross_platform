import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/repository/teacher_exam_repository.dart';

class CreateExamViewModel extends ChangeNotifier {
  final TeacherExamRepository _examRepo = TeacherExamRepository();
  final AuthRepository _authRepo = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(days: 1));

  DateTime get startTime => _startTime;
  DateTime get endTime => _endTime;

  void setStartTime(DateTime date) {
    _startTime = date;
    notifyListeners();
  }

  void setEndTime(DateTime date) {
    _endTime = date;
    notifyListeners();
  }

  Future<bool> createQuiz({
    required String classId,
    required String title,
    required String description,
    required int durationMinutes,
    required int attemptLimit,
  }) async {
    if (_endTime.isBefore(_startTime)) {
      errorMessage = 'Thời gian kết thúc phải sau thời gian bắt đầu';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw Exception('Chưa đăng nhập');

      final settings = QuizSettings(
        durationMinutes: durationMinutes,
        startTime: _startTime,
        endTime: _endTime,
        attemptLimit: attemptLimit,
      );

      final newQuiz = QuizModel(
        id: '',
        title: title,
        description: description,
        classId: classId,
        lecturerId: user.uid,
        status: 'draft',
        createdAt: DateTime.now(),
        settings: settings,
        questions: [],
      );

      await _examRepo.createQuiz(newQuiz);
      return true;
    } on FirestoreException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = 'Lỗi không xác định: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
