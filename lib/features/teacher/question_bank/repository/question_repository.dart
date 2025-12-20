import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/questions_model.dart';
import 'package:quizzy_cross_platform/data/services/teacher_question_service.dart';

class QuestionRepository {
  final QuestionService _service = QuestionService();

  Future<List<QuestionModel>> getQuestionsInBank(String bankId) async {
    try {
      return await _service.getQuestionsByBankId(bankId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi tải danh sách câu hỏi',
      );
    }
  }

  Future<void> createQuestion(QuestionModel question) async {
    try {
      await _service.createQuestion(question);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Lỗi khi tạo câu hỏi');
    }
  }

  Future<void> updateQuestion(QuestionModel question) async {
    try {
      await _service.updateQuestion(question);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Lỗi khi cập nhật câu hỏi');
    }
  }

  Future<void> deleteQuestion(String questionId, String bankId) async {
    try {
      await _service.deleteQuestion(questionId, bankId);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Không thể xóa câu hỏi');
    }
  }
}
