import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';

class TeacherClassService {
  final CollectionReference _classesCollection = FirebaseFirestore.instance
      .collection('classes');
  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection('users');

  // Create new class
  Future<void> createClass(ClassModel classModel) async {
    await _classesCollection.add(classModel.toMap());
  }

  // Get list class created by Lecture
  Future<List<ClassModel>> getClassesByLecturerId(String lecturerId) async {
    final querySnapshot = await _classesCollection
        .where('lecturerId', isEqualTo: lecturerId)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return ClassModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Delete class
  Future<void> deleteClass(String classId) async {
    await _classesCollection.doc(classId).delete();
  }

  // Get list student
  Future<List<UserModel>> getStudentsByIds(List<String> studentIds) async {
    if (studentIds.isEmpty) return [];
    // Loop fetch (not limit like whereIn
    List<UserModel> students = [];
    for (String id in studentIds) {
      final doc = await _usersCollection.doc(id).get();
      if (doc.exists) {
        students.add(
          UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        );
      }
    }
    return students;
  }
}
