import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/student/quiz/repository/quiz_repository.dart';

class GetClassQuizzesUseCase {
  final QuizRepository _quizRepo;

  GetClassQuizzesUseCase(this._quizRepo);

  Future<List<QuizModel>> execute(String classId) async {
    return await _quizRepo.getQuizzesByClass(classId);
  }
}
