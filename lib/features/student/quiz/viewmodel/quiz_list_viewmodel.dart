import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/domain/usecases/get_all_student_quizzes_usecase.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';

class QuizListViewModel extends ChangeNotifier {
  final GetAllStudentQuizzesUseCase _useCase;
  final AuthRepository _authRepo = AuthRepository();

  QuizListViewModel(this._useCase);
  
  List<QuizModel> quizzes = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchAllQuizzes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) {
        errorMessage = 'Bạn chưa đăng nhập';
        return;
      }

      quizzes = await _useCase.execute(user.uid);

      quizzes.sort(
        (a, b) => b.settings.startTime.compareTo(a.settings.startTime),
      );
    } on FirestoreException catch (e) {
      errorMessage = e.message;
      quizzes = [];
    } catch (e) {
      errorMessage = 'Đã có lỗi xảy ra';
      quizzes = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
