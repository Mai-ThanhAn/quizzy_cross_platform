import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/questions_model.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/repository/question_repository.dart';

class QuestionListViewModel extends ChangeNotifier {
  final QuestionRepository _repo = QuestionRepository();

  List<QuestionModel> _questions = [];
  List<QuestionModel> get questions => _questions;

  bool isLoading = false;
  String? errorMessage;

  // Tải câu hỏi theo Bank ID
  Future<void> fetchQuestions(String bankId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _questions = await _repo.getQuestionsInBank(bankId);
    } on FirestoreException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Lỗi tải dữ liệu';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteQuestion(String id) async {
    // Tìm câu hỏi để lấy bankId trước khi xóa khỏi list local
    final index = _questions.indexWhere((q) => q.id == id);
    if (index == -1) return;

    final questionToDelete = _questions[index]; // Lưu lại object

    // Xóa UI tạm thời (Optimistic)
    _questions.removeAt(index);
    notifyListeners();

    try {
      // [UPDATED] Truyền thêm bankId
      await _repo.deleteQuestion(id, questionToDelete.bankId);
    } catch (e) {
      // Rollback
      _questions.insert(index, questionToDelete);
      errorMessage = 'Xóa thất bại';
      notifyListeners();
    }
  }
}
