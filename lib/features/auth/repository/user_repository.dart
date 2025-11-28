import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/data/services/user_service.dart';

class UserRepository {
   final UserService _service = UserService();

   Future<void> saveUser(String uid, String email, String role) {
    return _service.createUser(uid, {
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}