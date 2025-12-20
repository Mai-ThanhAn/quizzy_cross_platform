import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/data/models/results_model.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';
import 'package:quizzy_cross_platform/data/services/teacher_exam_service.dart';

class TeacherExamRepository {
  final TeacherExamService _service = TeacherExamService();

  Future<void> createQuiz(QuizModel quiz) async {
    try {
      await _service.createQuiz(quiz);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Lỗi khi tạo bài kiểm tra');
    }
  }

  Future<List<QuizModel>> getQuizzesByClassId(String classId) async {
    try {
      return await _service.getQuizzesByClassId(classId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi khi tải danh sách bài kiểm tra',
      );
    }
  }

  Future<List<QuizModel>> getAllMyQuizzes(String lecturerId) async {
    try {
      return await _service.getQuizzesByLecturerId(lecturerId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi khi tải danh sách bài kiểm tra',
      );
    }
  }

  Future<void> updateQuiz(QuizModel quiz) async {
    try {
      await _service.updateQuiz(quiz);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi khi cập nhật bài kiểm tra',
      );
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      await _service.deleteQuiz(quizId);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Lỗi khi xóa bài kiểm tra');
    }
  }

  Future<QuizModel?> getQuizDetail(String quizId) async {
    try {
      return await _service.getQuizById(quizId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Không thể tải chi tiết bài thi.',
      );
    }
  }

  Future<void> addQuestionsToQuiz(
    String quizId,
    List<QuizQuestion> questions,
  ) async {
    try {
      await _service.addQuestionsToQuiz(quizId, questions);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Lỗi khi thêm câu hỏi');
    }
  }

  Future<List<ResultsModel>> getQuizResults(String quizId) async {
    try {
      return await _service.getResultsByQuizId(quizId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Không thể tải kết quả thi',
      );
    }
  }

  Future<List<UserModel>> getStudentsInfo(List<String> ids) async {
    try {
      return await _service.getStudentsInfo(ids);
    } catch (e) {
      return [];
    }
  }

  Future<void> changeQuizStatus(String quizId, String status) async {
    try {
      await _service.updateQuizStatus(quizId, status);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Không thể đổi trạng thái bài thi',
      );
    }
  }
}
