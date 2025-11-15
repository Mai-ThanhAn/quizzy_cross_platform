// Đây là tầng tiếp theo của kiến trúc MVVM [ViewModel], chịu trách nhiệm xử lý logic nghiệp vụ liên quan đến đăng ký người dùng và lưu vai trò vào Firestore.

import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, lecturer }

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng ký tài khoản + lưu role
  Future<void> register(
      String email, String password, UserRole role, BuildContext context) async {
    try {
      final userCred = await _repo.registerUser(email, password);
      final uid = userCred.user?.uid;
      if (uid != null) {
        // Lưu role vào Firestore
        await _firestore.collection('users').doc(uid).set({
          'email': email,
          'role': role.toString().split('.').last,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Chuyển sang màn hình nhập thông tin cá nhân
        Navigator.pushReplacementNamed(context, '/profileSetup');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}