import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/data/models/questions_model.dart';

class QuestionService {
  final CollectionReference _questionsCol = FirebaseFirestore.instance
      .collection('questions');
  final CollectionReference _banksCol = FirebaseFirestore.instance.collection(
    'question_banks',
  );
  Future<List<QuestionModel>> getQuestionsByBankId(String bankId) async {
    final snapshot = await _questionsCol
        .where('bankId', isEqualTo: bankId)
        .get();

    return snapshot.docs.map((doc) {
      return QuestionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> createQuestion(QuestionModel question) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference newQuestionRef = _questionsCol.doc();
    batch.set(newQuestionRef, question.toMap());

    DocumentReference bankRef = _banksCol.doc(question.bankId);
    batch.update(bankRef, {'totalQuestions': FieldValue.increment(1)});

    await batch.commit();
  }

  Future<void> deleteQuestion(String questionId, String bankId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference questionRef = _questionsCol.doc(questionId);
    batch.delete(questionRef);

    DocumentReference bankRef = _banksCol.doc(bankId);
    batch.update(bankRef, {'totalQuestions': FieldValue.increment(-1)});

    await batch.commit();
  }

  Future<void> updateQuestion(QuestionModel question) async {
    await _questionsCol.doc(question.id).update(question.toMap());
  }
}
