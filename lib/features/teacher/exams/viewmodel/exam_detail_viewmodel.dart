import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/data/models/question_bank_model.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/repository/teacher_exam_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/repository/question_bank_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/repository/question_repository.dart';

class ExamDetailViewModel extends ChangeNotifier {
  final TeacherExamRepository _examRepo = TeacherExamRepository();
  final QuestionBankRepository _bankRepo = QuestionBankRepository();
  final QuestionRepository _questionRepo = QuestionRepository();
  final AuthRepository _authRepo = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  QuizModel? _quiz;
  QuizModel? get quiz => _quiz;

  List<QuestionBankModel> _availableBanks = [];
  List<QuestionBankModel> get availableBanks => _availableBanks;

  Future<void> fetchQuizDetail(String quizId) async {
    isLoading = true;
    notifyListeners();

    try {
      _quiz = await _examRepo.getQuizDetail(quizId);
    } catch (e) {
      errorMessage = 'Không thể tải thông tin bài kiểm tra';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteQuestion(int index) async {
    if (_quiz == null) return;
  }

  Future<void> fetchAvailableBanks() async {
    final user = _authRepo.currentUser;
    if (user != null) {
      _availableBanks = await _bankRepo.getMyBanks(user.uid);
      notifyListeners();
    }
  }

  Future<bool> importQuestionsFromBank({
    required String quizId,
    required String bankId,
    required int numberOfQuestions,
    required double scorePerQuestion,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final bankQuestions = await _questionRepo.getQuestionsInBank(bankId);

      if (bankQuestions.isEmpty) {
        errorMessage = 'Ngân hàng này không có câu hỏi nào.';
        return false;
      }
      final currentQuestionIds =
          _quiz?.questions.map((q) => q.id).toSet() ?? {};
      final availableQuestions = bankQuestions
          .where((q) => !currentQuestionIds.contains(q.id))
          .toList();

      if (availableQuestions.length < numberOfQuestions) {
        errorMessage =
            'Chỉ còn ${availableQuestions.length} câu hỏi khả dụng trong ngân hàng này (đã trừ các câu trùng).';
        return false;
      }

      availableQuestions.shuffle(Random());
      final selectedQuestions = availableQuestions
          .take(numberOfQuestions)
          .toList();

      final newQuizQuestions = selectedQuestions.map((q) {
        return QuizQuestion(
          id: q.id,
          content: q.content,
          score: scorePerQuestion,
          options: q.options
              .map(
                (opt) => {
                  'id': opt.id,
                  'content': opt.text,
                  'isCorrect': opt.isCorrect,
                },
              )
              .toList(),
        );
      }).toList();

      await _examRepo.addQuestionsToQuiz(quizId, newQuizQuestions);

      await fetchQuizDetail(quizId);

      return true;
    } catch (e) {
      errorMessage = 'Đã có lỗi xảy ra';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleQuizStatus() async {
    if (_quiz == null) return;

    if (_quiz!.status == 'draft' && _quiz!.questions.isEmpty) {
      errorMessage = 'Không thể xuất bản bài thi rỗng. Vui lòng thêm câu hỏi';
      notifyListeners();
      return; 
    }

    isLoading = true;
    notifyListeners();

    try {
      final newStatus = _quiz!.status == 'draft' ? 'published' : 'draft';
      await _examRepo.changeQuizStatus(_quiz!.id, newStatus);
      
      await fetchQuizDetail(_quiz!.id);
      
    } catch (e) {
      errorMessage = 'Đã có lỗi xảy ra';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
