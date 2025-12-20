import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/questions_model.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/repository/question_repository.dart';

class EditQuestionViewModel extends ChangeNotifier {
  final QuestionRepository _questionRepo = QuestionRepository();

  bool isLoading = false;
  String? errorMessage;

  // State
  late String _questionId;
  late String _bankId;
  late String _lecturerId;
  late DateTime _createdAt;

  String _type = 'multiple_choice';
  String _difficulty = 'medium';
  List<OptionModel> _options = [];

  String get type => _type;
  String get difficulty => _difficulty;
  List<OptionModel> get options => _options;

  void initialize(QuestionModel question) {
    _questionId = question.id;
    _bankId = question.bankId;
    _lecturerId = question.lecturerId;
    _createdAt = question.createdAt;

    _type = question.type;
    _difficulty = question.difficulty;

    _options = question.options
        .map(
          (opt) =>
              OptionModel(id: opt.id, text: opt.text, isCorrect: opt.isCorrect),
        )
        .toList();
  }

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

  Future<bool> updateQuestion({required String content}) async {
    if (content.trim().isEmpty) {
      errorMessage = 'Nội dung không được để trống';
      notifyListeners();
      return false;
    }
    if (_options.any((opt) => opt.text.trim().isEmpty)) {
      errorMessage = 'Đáp án không được để trống';
      notifyListeners();
      return false;
    }
    final correctCount = _options.where((opt) => opt.isCorrect).length;
    if (correctCount == 0) {
      errorMessage = 'Phải có đáp án đúng';
      notifyListeners();
      return false;
    }
    if (_type == 'single_choice' && correctCount > 1) {
      errorMessage = 'Loại một đáp án chỉ được chọn 1 câu đúng';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final updatedQuestion = QuestionModel(
        id: _questionId,
        bankId: _bankId,
        lecturerId: _lecturerId,
        createdAt: _createdAt,
        content: content.trim(),
        type: _type,
        difficulty: _difficulty,
        options: _options,
      );

      await _questionRepo.updateQuestion(updatedQuestion);
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
