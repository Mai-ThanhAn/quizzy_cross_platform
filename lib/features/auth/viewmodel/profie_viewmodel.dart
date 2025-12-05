import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/data/model/users_model.dart';
import 'package:quizzy_cross_platform/features/auth/repository/auth_repository.dart';
import 'package:quizzy_cross_platform/features/auth/repository/user_repository.dart';

class ProfieViewmodel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final UserRepository _userRepo = UserRepository();

  UserModel? _currentUser;
  bool isLoading = false;
  String? errorMessage;

  UserModel? get currentUser => _currentUser;
  Future<void> fechUserProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try{
      final user = _authRepo.currentUser;
      if(user == null){
        errorMessage = 'Người dùng không tồn tại';
      }
      else{
          final userModel = await _userRepo.getCurrentUser(user.uid);
          if (userModel != null) {
          _currentUser = userModel;
        }
      }
    }
    catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
