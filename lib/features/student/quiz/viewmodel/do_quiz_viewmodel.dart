import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/data/models/results_model.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/student/quiz/repository/quiz_repository.dart';

class DoQuizViewModel extends ChangeNotifier {
  final QuizRepository _repo = QuizRepository();
  final AuthRepository _authRepo = AuthRepository();

  bool isLoading = false;
  bool isSubmitting = false;

  late QuizModel _quiz;
  
  Timer? _timer;
  int _remainingSeconds = 0;
  int get remainingSeconds => _remainingSeconds;
  
  String get timeString {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  final Map<String, List<String>> _userAnswers = {};

  bool isOptionSelected(String questionId, String optionId) {
    return _userAnswers[questionId]?.contains(optionId) ?? false;
  }

  void init(QuizModel quiz) {
    _quiz = quiz;
    _remainingSeconds = quiz.settings.durationMinutes * 60;
    _userAnswers.clear();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        submitQuiz(isAutoSubmit: true);
      }
    });
  }

  void selectOption(String questionId, String optionId, bool isSingleChoice) {
    if (isSingleChoice) {
      _userAnswers[questionId] = [optionId];
    } else {
      final current = _userAnswers[questionId] ?? [];
      if (current.contains(optionId)) {
        current.remove(optionId);
      } else {
        current.add(optionId);
      }
      _userAnswers[questionId] = current;
    }
    notifyListeners();
  }

  Future<void> submitQuiz({bool isAutoSubmit = false}) async {
    _timer?.cancel();
    isSubmitting = true;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw Exception("User not found");

      double totalScore = 0;
      final answerDetails = <AnswerDetail>[];

      for (var question in _quiz.questions) {
        final selectedOptionIds = _userAnswers[question.id] ?? [];
        
        final correctOptions = question.options
            .where((o) => o['isCorrect'] == true)
            .map((o) => o['id'])
            .toList();
        
        bool isCorrect = false;
        if (selectedOptionIds.length == correctOptions.length && 
            selectedOptionIds.every((id) => correctOptions.contains(id))) {
          isCorrect = true;
          totalScore += question.score;
        }

        answerDetails.add(AnswerDetail(
          questionId: question.id,
          selectedOptionId: selectedOptionIds.isNotEmpty ? selectedOptionIds.first : '',
          isCorrect: isCorrect,
        ));
      }

      final now = DateTime.now();
      
      final result = ResultsModel(
        id: '${_quiz.id}_${user.uid}',
        quizId: _quiz.id,
        studentUid: user.uid,
        score: totalScore,
        maxScore: _quiz.questions.fold(0, (sum, item) => sum + item.score),
        startedAt: now.subtract(Duration(seconds: (_quiz.settings.durationMinutes * 60) - _remainingSeconds)),
        submittedAt: now,
        isLate: now.isAfter(_quiz.settings.endTime),
        answers: answerDetails,
      );

      await _repo.submitResult(result);
      
    } catch (e) {
      debugPrint("Lỗi nộp bài: $e");
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}