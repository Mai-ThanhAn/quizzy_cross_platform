import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/student/class/repository/class_repository.dart';
import 'package:quizzy_cross_platform/features/student/quiz/repository/quiz_repository.dart';

class GetAllStudentQuizzesUseCase {
  final ClassRepository _classRepo;
  final QuizRepository _quizRepo;

  GetAllStudentQuizzesUseCase(
    this._classRepo,
    this._quizRepo,
  );

  Future<List<QuizModel>> execute(String studentId) async {
    final classes = await _classRepo.getEnrolledClasses(studentId);
    if (classes.isEmpty) return [];

    final classIds = classes.map((c) => c.id).toList();
    return await _quizRepo.getQuizzesByClassIds(classIds);
  }
}
