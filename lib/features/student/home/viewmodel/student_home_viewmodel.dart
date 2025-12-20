import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/student/class/repository/student_home_repository.dart';

class StudentHomeViewModel extends ChangeNotifier {
  final StudentHomeRepository _repo = StudentHomeRepository();

  bool isLoading = false;
  String userName = 'Sinh viên';
  String? avatarUrl;
  
  List<ClassModel> myClasses = [];
  List<QuizModel> upcomingExams = [];

  Future<void> loadDashboard() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await _repo.getUserProfile();
      if (user != null) {
        userName = user.fullName.isNotEmpty ? user.fullName : 'Sinh viên';
        avatarUrl = user.avatarUrl;
        if (user.enrolledClassIds.isNotEmpty) {
          myClasses = await _repo.getClasses(user.enrolledClassIds);
          
          upcomingExams = await _repo.getUpcomingExams(user.enrolledClassIds);
        } else {
          myClasses = [];
          upcomingExams = [];
        }
      }
    } catch (e) {
      debugPrint("Lỗi load home: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isUrgent(QuizModel quiz) {
    final now = DateTime.now();
    final difference = quiz.settings.endTime.difference(now);
    return difference.inHours < 24 && difference.inSeconds > 0;
  }
}