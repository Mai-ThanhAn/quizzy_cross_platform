import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/question_bank_model.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/repository/question_bank_repository.dart';

class BankListViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final QuestionBankRepository _bankRepo = QuestionBankRepository();

  List<QuestionBankModel> _banks = [];
  List<QuestionBankModel> get banks => _banks;

  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchBanks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) {
        errorMessage = 'Bạn chưa đăng nhập';
        return;
      }
      _banks = await _bankRepo.getMyBanks(user.uid);
    } on FirestoreException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Lỗi tải danh sách ngân hàng';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBank(String name, String description) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) return false;

      final newBank = QuestionBankModel(
        id: '',
        name: name,
        description: description,
        lecturerId: user.uid,
        createdAt: DateTime.now(),
        totalQuestions: 0,
      );

      await _bankRepo.createBank(newBank);

      await fetchBanks();
      return true;
    } catch (e) {
      errorMessage = 'Tạo thất bại: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBank(String bankId) async {
    try {
      await _bankRepo.deleteBank(bankId);
      _banks.removeWhere((b) => b.id == bankId);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Xóa thất bại';
      notifyListeners();
    }
  }
}
