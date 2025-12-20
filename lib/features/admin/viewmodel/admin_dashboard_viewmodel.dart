import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';
import 'package:quizzy_cross_platform/features/admin/repository/admin_repository.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final AdminRepository _repo = AdminRepository();

  bool isLoading = false;
  String? errorMessage;

  List<UserModel> _allUsers = [];
  List<UserModel> get allUsers => _allUsers;

  List<UserModel> _pendingLecturers = [];
  List<UserModel> get pendingLecturers => _pendingLecturers;

  Future<void> loadDashboard() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repo.getAllUsers(),
        _repo.getPendingLecturers(),
      ]);

      _allUsers = results[0];
      _pendingLecturers = results[1];
      
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleUserStatus(UserModel user) async {
    try {
      final index = _allUsers.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _allUsers[index] = user.copyWith(isActive: !user.isActive);
        notifyListeners();
      }

      await _repo.toggleUserStatus(user.id, user.isActive);
    } catch (e) {
      await loadDashboard(); 
      errorMessage = 'Thao tác thất bại';
      notifyListeners();
    }
  }

  Future<void> approveLecturer(String uid) async {
    try {
      _pendingLecturers.removeWhere((u) => u.id == uid);
      notifyListeners();

      await _repo.approveLecturer(uid);
      
      _allUsers = await _repo.getAllUsers();
      notifyListeners();
    } catch (e) {
      await loadDashboard();
      errorMessage = 'Duyệt thất bại';
      notifyListeners();
    }
  }
}