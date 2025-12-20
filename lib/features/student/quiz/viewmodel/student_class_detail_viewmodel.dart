import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/data/models/results_model.dart';
import 'package:quizzy_cross_platform/data/services/quiz_service.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';

class QuizWithStatus {
  final QuizModel quiz;
  final ResultsModel? result;

  QuizWithStatus({required this.quiz, this.result});

  bool get isCompleted => result != null;
}

class StudentClassDetailViewModel extends ChangeNotifier {
  final QuizService _service = QuizService();
  final AuthRepository _authRepo = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  List<QuizWithStatus> _quizzes = [];
  List<QuizWithStatus> get quizzes => _quizzes;

  Future<void> fetchQuizzes(String classId) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) return;

      final quizList = await _service.getPublishedQuizzes(classId);

      List<QuizWithStatus> tempList = [];
      for (var quiz in quizList) {
        final result = await _service.getQuizResult(quiz.id, user.uid);
        tempList.add(QuizWithStatus(quiz: quiz, result: result));
      }
      _quizzes = tempList;
    } on FirestoreException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Lỗi tải bài kiểm tra';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
