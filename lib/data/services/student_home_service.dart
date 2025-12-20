import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';

class StudentHomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<List<ClassModel>> getEnrolledClasses(List<String> classIds) async {
    if (classIds.isEmpty) return [];

    List<ClassModel> classes = [];
    for (var id in classIds) {
      final doc = await _firestore.collection('classes').doc(id).get();
      if (doc.exists) {
        classes.add(ClassModel.fromMap(doc.data()!, doc.id));
      }
    }
    return classes;
  }

  Future<List<QuizModel>> getUpcomingQuizzes(List<String> classIds) async {
    if (classIds.isEmpty) return [];

    List<QuizModel> allQuizzes = [];

    for (var classId in classIds) {
      final snapshot = await _firestore
          .collection('quizzes')
          .where('classId', isEqualTo: classId)
          .where('status', isEqualTo: 'published')
          .get();
      
      final quizzes = snapshot.docs
          .map((doc) => QuizModel.fromMap(doc.data(), doc.id))
          .toList();
      
      allQuizzes.addAll(quizzes);
    }

    return allQuizzes;
  }
}