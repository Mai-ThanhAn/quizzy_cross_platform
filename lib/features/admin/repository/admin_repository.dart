import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';
import 'package:quizzy_cross_platform/data/services/admin_service.dart';

class AdminRepository {
  final AdminService _service = AdminService();

  Future<List<UserModel>> getAllUsers() async {
    try {
      return await _service.getAllUsers();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi tải danh sách người dùng',
      );
    }
  }

  Future<List<UserModel>> getPendingLecturers() async {
    try {
      return await _service.getPendingLecturers();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi tải danh sách chờ duyệt',
      );
    }
  }

  Future<void> toggleUserStatus(String uid, bool currentStatus) async {
    try {
      await _service.toggleUserStatus(uid, currentStatus);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Lỗi cập nhật trạng thái');
    }
  }

  Future<void> approveLecturer(String uid) async {
    try {
      await _service.approveLecturer(uid);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Lỗi duyệt giảng viên');
    }
  }
}
