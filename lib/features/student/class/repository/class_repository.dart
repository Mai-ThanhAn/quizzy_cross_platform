import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/data/services/student_class_service.dart';

class ClassRepository {
  final StudentClassService _service = StudentClassService();

  Future<List<ClassModel>> getEnrolledClasses(String studentId) async {
    try {
      return await _service.getEnrolledClasses(studentId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi khi tải danh sách lớp học',
      );
    }
  }

  Future<void> joinClass(String code, String studentId) async {
    try {
      await _service.joinClassTransaction(code, studentId);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.code, e.message ?? 'Lỗi kết nối');
    } catch (e) {
      final errorString = e.toString();

      if (errorString.contains('CLASS_NOT_FOUND')) {
        throw FirestoreException(
          'not-found',
          'Mã lớp không tồn tại. Vui lòng kiểm tra lại.',
        );
      }

      if (errorString.contains('ALREADY_JOINED')) {
        throw FirestoreException(
          'duplicate',
          'Bạn đã là thành viên của lớp học này rồi.',
        );
      }
      throw FirestoreException('unknown', 'Đã có lỗi xảy ra: $e');
    }
  }
}
