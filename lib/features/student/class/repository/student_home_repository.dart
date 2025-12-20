import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';
import 'package:quizzy_cross_platform/data/services/student_home_service.dart';

class StudentHomeRepository {
  final StudentHomeService _service = StudentHomeService();

  Future<UserModel?> getUserProfile() => _service.getCurrentUser();

  Future<List<ClassModel>> getClasses(List<String> ids) => _service.getEnrolledClasses(ids);

  Future<List<QuizModel>> getUpcomingExams(List<String> classIds) async {
    final quizzes = await _service.getUpcomingQuizzes(classIds);
    final now = DateTime.now();

    final upcoming = quizzes.where((q) => q.settings.endTime.isAfter(now)).toList();
    
    upcoming.sort((a, b) => a.settings.endTime.compareTo(b.settings.endTime));
    
    return upcoming;
  }
}