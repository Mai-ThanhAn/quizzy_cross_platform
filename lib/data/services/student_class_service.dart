import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';

class StudentClassService {
  final CollectionReference classesCollection = FirebaseFirestore.instance
      .collection('classes');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ClassModel>> getEnrolledClasses(String studentId) async {
    final querySnapshot = await classesCollection
        .where('studentIds', arrayContains: studentId)
        // .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return ClassModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> joinClassTransaction(String code, String studentId) async {
    final querySnapshot = await _firestore
        .collection('classes')
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('CLASS_NOT_FOUND');
    }

    final classDocRef = querySnapshot.docs.first.reference;
    final userRef = _firestore.collection('users').doc(studentId);

    await _firestore.runTransaction((transaction) async {
      final classSnapshot = await transaction.get(classDocRef);
      final userSnapshot = await transaction.get(userRef);

      if (!classSnapshot.exists) {
        throw Exception('CLASS_NOT_FOUND');
      }

      if (!userSnapshot.exists) {
        throw Exception('USER_NOT_FOUND');
      }

      final data = classSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> students =
          (data['studentIds'] as List<dynamic>?) ?? [];

      if (students.contains(studentId)) {
        throw Exception('ALREADY_JOINED');
      }

      transaction.update(classDocRef, {
        'studentIds': FieldValue.arrayUnion([studentId]),
      });

      transaction.update(userRef, {
        'enrolledClassIds': FieldValue.arrayUnion([classSnapshot.id]),
      });
    });
  }
}
