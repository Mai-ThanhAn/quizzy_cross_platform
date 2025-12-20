import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/data/models/results_model.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/repository/teacher_exam_repository.dart';

class StudentResultItem {
  final ResultsModel result;
  final UserModel? student;

  StudentResultItem({required this.result, this.student});
}

class QuizResultsViewModel extends ChangeNotifier {
  final TeacherExamRepository _repo = TeacherExamRepository();

  bool isLoading = false;
  String? errorMessage;
  
  List<StudentResultItem> _items = [];
  List<StudentResultItem> get items => _items;

  double averageScore = 0;
  int submittedCount = 0;

  Future<void> fetchResults(String quizId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await _repo.getQuizResults(quizId);
      submittedCount = results.length;

      if (results.isNotEmpty) {
        final total = results.fold(0.0, (sum, item) => sum + item.score);
        averageScore = total / results.length;
      } else {
        averageScore = 0;
      }

      final studentIds = results.map((e) => e.studentUid).toSet().toList();

      final students = await _repo.getStudentsInfo(studentIds);

      _items = results.map((res) {
        final student = students.cast<UserModel?>().firstWhere(
          (s) => s?.id == res.studentUid,
          orElse: () => null,
        );
        
        return StudentResultItem(result: res, student: student);
      }).toList();

    } catch (e) {
      errorMessage = 'Đã xảy ra lỗi.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}