import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerDetail {
  final String questionId;
  final String selectedOptionId;
  final bool isCorrect;

  AnswerDetail({
    required this.questionId,
    required this.selectedOptionId,
    required this.isCorrect,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'selectedOptionId': selectedOptionId,
      'isCorrect': isCorrect,
    };
  }

  factory AnswerDetail.fromMap(Map<String, dynamic> map) {
    return AnswerDetail(
      questionId: map['questionId'] ?? '',
      selectedOptionId: map['selectedOptionId'] ?? '',
      isCorrect: map['isCorrect'] ?? false,
    );
  }

}
class ResultsModel {
  final String id;
  final String quizId;
  final String studentId;
  final String studentName;
  final String studentMssv;
  final double score;
  final double maxScore;
  final DateTime startedAt;
  final DateTime submittedAt;
  final bool isLate;
  final List<AnswerDetail> answers;

  ResultsModel({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.studentName,
    required this.studentMssv,
    required this.score,
    required this.maxScore,
    required this.startedAt,
    required this.submittedAt,
    required this.isLate,
    required this.answers,
  });

  // Getter tính toán số câu đúng
  int get correctCount => answers.where((a) => a.isCorrect).length;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quizId': quizId,
      'studentId': studentId,
      'studentName': studentName,
      'studentMssv': studentMssv,
      'score': score,
      'maxScore': maxScore,
      'startedAt': Timestamp.fromDate(startedAt),
      'submittedAt': Timestamp.fromDate(submittedAt),
      'isLate': isLate,
      'answers': answers.map((a) => a.toMap()).toList(),
    };
  }

  factory ResultsModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ResultsModel(
      id: documentId,
      quizId: map['quizId'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      studentMssv: map['studentMssv'] ?? '',
      score: (map['score'] ?? 0).toDouble(),
      maxScore: (map['maxScore'] ?? 0).toDouble(),
      startedAt: (map['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      submittedAt: (map['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isLate: map['isLate'] ?? false,
      answers: List<AnswerDetail>.from(
        (map['answers'] ?? []).map((x) => AnswerDetail.fromMap(x)),
      ),
    );
  }
}


