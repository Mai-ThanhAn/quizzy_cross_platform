import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/core/exceptions/firestore_exception.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';
import 'package:quizzy_cross_platform/data/services/teacher_class_service.dart';

class TeacherClassRepository {
  final TeacherClassService _service = TeacherClassService();

  Future<void> createClass(ClassModel newClass) async {
    try {
      await _service.createClass(newClass);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Không thể tạo lớp học. Vui lòng thử lại',
      );
    }
  }

  Future<List<ClassModel>> getCreatedClasses(String lecturerId) async {
    try {
      return await _service.getClassesByLecturerId(lecturerId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Lỗi khi tải danh sách lớp học',
      );
    }
  }

  Future<void> deleteClass(String classId) async {
    try {
      await _service.deleteClass(classId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        e.code,
        e.message ?? 'Không thể xóa lớp học này',
      );
    }
  }

  Future<List<UserModel>> getStudentsInClass(List<String> studentIds) async {
    try {
      return await _service.getStudentsByIds(studentIds);
    } catch (e) {
      return [];
    }
  }
}
