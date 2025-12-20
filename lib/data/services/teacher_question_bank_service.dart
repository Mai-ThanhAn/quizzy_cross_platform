import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/data/models/question_bank_model.dart';

class TeacherQuestionBankService {
  final CollectionReference _bankCollection = FirebaseFirestore.instance
      .collection('question_banks');

  Future<void> createBank(QuestionBankModel bank) async {
    await _bankCollection.add(bank.toMap());
  }

  Future<List<QuestionBankModel>> getBanksByLecturer(String lecturerId) async {
    final snapshot = await _bankCollection
        .where('lecturerId', isEqualTo: lecturerId)
        .get();

    return snapshot.docs.map((doc) {
      return QuestionBankModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  Future<void> deleteBank(String bankId) async {
    await _bankCollection.doc(bankId).delete();
  }
}
