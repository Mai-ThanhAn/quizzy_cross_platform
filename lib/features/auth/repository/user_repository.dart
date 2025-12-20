import 'package:firebase_core/firebase_core.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';
import 'package:quizzy_cross_platform/data/services/user_service.dart';

class UserRepository {
  final UserService _service = UserService();

  Future<void> saveUser(UserModel user) async {
    try {
      await _service.createUser(user.id, user.toMap());
    } on FirebaseException
    catch (e) {
      throw Exception(e.message);
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      return await _service.checkEmailExists(email);
    } on FirebaseException
    catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserModel?> getCurrentUser(String id) async {
    try {
      return await _service.getUser(id);
    } on FirebaseException
    catch (e) {
      throw Exception(e.message);
    }
  }
}