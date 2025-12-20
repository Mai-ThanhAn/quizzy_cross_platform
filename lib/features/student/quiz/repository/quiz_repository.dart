import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/data/models/results_model.dart';
import 'package:quizzy_cross_platform/data/services/quiz_service.dart';

class QuizRepository {
  final QuizService _service = QuizService();

  Future<List<QuizModel>> getQuizzesByClass(String classId) async {
    try {
      return await _service.getPublishedQuizzes(classId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi khi tải danh sách bài kiểm tra',
      );
    }
  }

  Future<List<QuizModel>> getQuizzesByClassIds(List<String> classIds) async {
    try {
      return await _service.getQuizzesFromMultipleClasses(classIds);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi khi tải danh sách bài kiểm tra',
      );
    }
  }

  Future<void> submitResult(ResultsModel result) async {
    try {
      await _service.submitQuizResult(result);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Lỗi trong quá trình nộp bài');
    }
  }
}
