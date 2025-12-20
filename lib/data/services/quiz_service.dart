import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/data/models/results_model.dart';

class QuizService {
  final CollectionReference _quizCollection = FirebaseFirestore.instance
      .collection('quizzes');
  final CollectionReference _resultCollection = FirebaseFirestore.instance
      .collection('quiz_results');

  // Get a list of published articles by classId
  Future<List<QuizModel>> getPublishedQuizzes(String classId) async {
    final querySnapshot = await _quizCollection
        .where('classId', isEqualTo: classId)
        .where('status', isEqualTo: 'published')
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return QuizModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Get a quiz from a list of Class IDs
  Future<List<QuizModel>> getQuizzesFromMultipleClasses(
    List<String> classIds,
  ) async {
    if (classIds.isEmpty) return [];
    List<Future<List<QuizModel>>> futures = [];

    for (String id in classIds) {
      futures.add(getPublishedQuizzes(id));
    }
    final List<List<QuizModel>> results = await Future.wait(futures);
    return results.expand((element) => element).toList();
  }

  Future<ResultsModel?> getQuizResult(String quizId, String studentUid) async {
    final querySnapshot = await _resultCollection
        .where('quizId', isEqualTo: quizId)
        .where('studentUid', isEqualTo: studentUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    return ResultsModel.fromMap(
      querySnapshot.docs.first.data() as Map<String, dynamic>,
      querySnapshot.docs.first.id,
    );
  }

  // Submit quiz
  Future<void> submitQuizResult(ResultsModel result) async {
    if (result.id.isNotEmpty) {
       await _resultCollection.doc(result.id).set(result.toMap());
    } else {
       await _resultCollection.add(result.toMap());
    }
  }
}
