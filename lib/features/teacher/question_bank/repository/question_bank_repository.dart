import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/question_bank_model.dart';
import 'package:quizzy_cross_platform/data/services/teacher_question_bank_service.dart';

class QuestionBankRepository {
  final TeacherQuestionBankService _service = TeacherQuestionBankService();

  Future<void> createBank(QuestionBankModel bank) async {
    try {
      await _service.createBank(bank);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi khi tạo ngân hàng câu hỏi',
      );
    }
  }

  Future<List<QuestionBankModel>> getMyBanks(String lecturerId) async {
    try {
      return await _service.getBanksByLecturer(lecturerId);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Lỗi tải dữ liệu');
    }
  }

  Future<void> deleteBank(String bankId) async {
    try {
      await _service.deleteBank(bankId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi khi xóa ngân hàng câu hỏi',
      );
    }
  }
}
