import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/questions_model.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/repository/question_repository.dart';

class CreateQuestionViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final QuestionRepository _questionRepo = QuestionRepository();

  bool isLoading = false;
  String? errorMessage;

  String _type = 'multiple_choice';
  String _difficulty = 'medium';
  final List<OptionModel> _options = [
    OptionModel(id: '1', text: '', isCorrect: false),
    OptionModel(id: '2', text: '', isCorrect: false),
  ];

  String get type => _type;
  String get difficulty => _difficulty;
  List<OptionModel> get options => _options;

  void setType(String? value) {
    if (value != null) {
      _type = value;
      if (_type == 'single_choice') {
        bool hasCorrect = false;
        for (var i = 0; i < _options.length; i++) {
          if (_options[i].isCorrect) {
            if (hasCorrect) {
              _options[i] = OptionModel(
                id: _options[i].id,
                text: _options[i].text,
                isCorrect: false,
              );
            }
            hasCorrect = true;
          }
        }
      }
      notifyListeners();
    }
  }

  void setDifficulty(String? value) {
    if (value != null) {
      _difficulty = value;
      notifyListeners();
    }
  }

  void addOption() {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    _options.add(OptionModel(id: newId, text: '', isCorrect: false));
    notifyListeners();
  }

  void removeOption(int index) {
    if (_options.length > 2) {
      _options.removeAt(index);
      notifyListeners();
    } else {
      errorMessage = 'Phải có ít nhất 2 đáp án';
      notifyListeners();
    }
  }

  void updateOptionText(int index, String text) {
    final old = _options[index];
    _options[index] = OptionModel(
      id: old.id,
      text: text,
      isCorrect: old.isCorrect,
    );
  }

  void toggleOptionCorrect(int index) {
    final old = _options[index];

    if (_type == 'single_choice') {
      for (var i = 0; i < _options.length; i++) {
        _options[i] = OptionModel(
          id: _options[i].id,
          text: _options[i].text,
          isCorrect: i == index,
        );
      }
    } else {
      _options[index] = OptionModel(
        id: old.id,
        text: old.text,
        isCorrect: !old.isCorrect,
      );
    }
    notifyListeners();
  }

  Future<bool> createQuestion({
    required String bankId,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      errorMessage = 'Nội dung câu hỏi không được để trống';
      notifyListeners();
      return false;
    }

    if (_options.any((opt) => opt.text.trim().isEmpty)) {
      errorMessage = 'Nội dung đáp án không được để trống';
      notifyListeners();
      return false;
    }

    final correctCount = _options.where((opt) => opt.isCorrect).length;
    if (correctCount == 0) {
      errorMessage = 'Phải chọn ít nhất 1 đáp án đúng';
      notifyListeners();
      return false;
    }

    if (_type == 'single_choice' && correctCount > 1) {
      errorMessage = 'Loại câu hỏi một đáp án chỉ được chọn 1 đáp án đúng';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw Exception('Chưa đăng nhập');

      final newQuestion = QuestionModel(
        id: '',
        content: content.trim(),
        type: _type,
        difficulty: _difficulty,
        lecturerId: user.uid,
        bankId: bankId,
        createdAt: DateTime.now(),
        options: _options,
      );

      await _questionRepo.createQuestion(newQuestion);
      return true;
    } on FirestoreException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = 'Lỗi: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
