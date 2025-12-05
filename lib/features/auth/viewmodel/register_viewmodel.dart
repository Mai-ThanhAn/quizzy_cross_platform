// You can see detail architecture at this link:
// file: https://github.com/Mai-ThanhAn/quizzy_cross_platform/blob/ae1413a644a5e0bad1c6ef2e61c5a8f520151104/docs/MVVM-architecture.md

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/data/model/users_model.dart';
import 'package:quizzy_cross_platform/features/auth/repository/user_repository.dart';
import '../repository/auth_repository.dart';

// Use enum for role
enum UserRole { student, lecturer }

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final UserRepository _userRepo = UserRepository();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register(String fullname, String? studentid, String email, String password, UserRole role) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 1. Check the email exist in Firestore (Optional)
      bool exists = await _userRepo.checkEmailExists(email);
      if (exists) {
        errorMessage = 'Email đã được sử dụng trong hệ thống.';
        return false;
      }

      // 2. Using Authentication create new user
      UserCredential cred = await _authRepo.registerUser(email, password);
      User? user = cred.user;

      if (user != null) {
        // 3. Prepare data for Model
        // If lecture -> isActive = false
        bool isActive = (role == UserRole.student);

        UserModel newUser = UserModel(
          id: user.uid,
          email: email,
          fullName: fullname,
          role: role.name,
          isActive: isActive,
          createdAt:
              DateTime.now(),
          avatarUrl: 'default.jpg',
          studentId: role == UserRole.student ? studentid : null,
          enrolledClassIds: [],
        );

        // 4. Lưu vào Firestore thông qua UserRepo
        await _userRepo.saveUser(newUser);

        // 5. If lecture, logout
        if (role == UserRole.lecturer) {
          await _authRepo.logoutUser();
        }

        return true; // Thành công
      } else {
        errorMessage = "Không thể lấy thông tin người dùng sau khi đăng ký.";
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'Mật khẩu quá yếu.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email này đã được đăng ký.';
      } else {
        errorMessage = e.message;
      }
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
