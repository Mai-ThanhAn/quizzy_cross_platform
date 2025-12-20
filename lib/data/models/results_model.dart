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
  final String studentUid;
  final double score;
  final double maxScore;
  final DateTime startedAt;
  final DateTime submittedAt;
  final bool isLate;
  final List<AnswerDetail> answers;

  ResultsModel({
    required this.id,
    required this.quizId,
    required this.studentUid,
    required this.score,
    required this.maxScore,
    required this.startedAt,
    required this.submittedAt,
    required this.isLate,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'studentUid': studentUid,
      'score': score,
      'maxScore': maxScore,
      'startedAt': Timestamp.fromDate(startedAt),
      'submittedAt': Timestamp.fromDate(submittedAt),
      'isLate': isLate,
      'answers': answers.map((a) => a.toMap()).toList(),
    };
  }

  factory ResultsModel.fromMap(Map<String, dynamic> map, String docId) {
    return ResultsModel(
      id: docId,
      quizId: map['quizId'],
      studentUid: map['studentUid'],
      score: (map['score'] ?? 0).toDouble(),
      maxScore: (map['maxScore'] ?? 0).toDouble(),
      startedAt: (map['startedAt'] as Timestamp).toDate(),
      submittedAt: (map['submittedAt'] as Timestamp).toDate(),
      isLate: map['isLate'] ?? false,
      answers: List<AnswerDetail>.from(
        (map['answers'] ?? []).map((x) => AnswerDetail.fromMap(x)),
      ),
    );
  }
}
