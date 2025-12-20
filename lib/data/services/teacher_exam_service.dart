import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/data/models/results_model.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';

class TeacherExamService {
  final CollectionReference _quizCollection = FirebaseFirestore.instance
      .collection('quizzes');
  final CollectionReference _resultCollection = FirebaseFirestore.instance
      .collection('quiz_results');
  final CollectionReference<Map<String, dynamic>> _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createQuiz(QuizModel quiz) async {
    await _quizCollection.add(quiz.toMap());
  }

  Future<List<QuizModel>> getQuizzesByClassId(String classId) async {
    final snapshot = await _quizCollection
        .where('classId', isEqualTo: classId)
        // .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return QuizModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<List<QuizModel>> getQuizzesByLecturerId(String lecturerId) async {
    final snapshot = await _quizCollection
        .where('lecturerId', isEqualTo: lecturerId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return QuizModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<QuizModel?> getQuizById(String quizId) async {
    final doc = await _quizCollection.doc(quizId).get();
    if (doc.exists) {
      return QuizModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateQuiz(QuizModel quiz) async {
    await _quizCollection.doc(quiz.id).update(quiz.toMap());
  }

  Future<void> deleteQuiz(String quizId) async {
    await _quizCollection.doc(quizId).delete();
  }

  Future<void> addQuestionsToQuiz(
    String quizId,
    List<QuizQuestion> newQuestions,
  ) async {
    await _quizCollection.doc(quizId).update({
      'questions': FieldValue.arrayUnion(
        newQuestions.map((q) => q.toMap()).toList(),
      ),
    });
  }

  Future<List<ResultsModel>> getResultsByQuizId(String quizId) async {
    final snapshot = await _resultCollection
        .where('quizId', isEqualTo: quizId)
        // .orderBy('score', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return ResultsModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<List<UserModel>> getStudentsInfo(List<String> userIds) async {
    if (userIds.isEmpty) return [];

    List<UserModel> users = [];

    for (var i = 0; i < userIds.length; i += 10) {
      final end = (i + 10 < userIds.length) ? i + 10 : userIds.length;
      final subList = userIds.sublist(i, end);

      final snapshot = await _userCollection
          .where(FieldPath.documentId, whereIn: subList)
          .get();

      users.addAll(
        snapshot.docs
            .map((d) => UserModel.fromMap(d.data(), d.id))
            .where((u) => u.role == 'student' && u.isActive == true),
      );
    }

    return users;
  }

  Future<void> updateQuizStatus(String quizId, String newStatus) async {
    await _quizCollection.doc(quizId).update({'status': newStatus});
  }
}
