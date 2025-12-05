import 'package:cloud_firestore/cloud_firestore.dart';

class QuizSettings {
  final int durationMinutes;
  final DateTime startTime;
  final DateTime endTime;
  final int attemptLimit;

  QuizSettings({
    required this.durationMinutes,
    required this.startTime,
    required this.endTime,
    this.attemptLimit = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'durationMinutes': durationMinutes,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'attemptLimit': attemptLimit,
    };
  }

  factory QuizSettings.fromMap(Map<String, dynamic> map) {
    return QuizSettings(
      durationMinutes: map['durationMinutes'] ?? 15,
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      attemptLimit: map['attemptLimit'] ?? 1,
    );
  }
}

class QuizQuestion {
  final String id;
  final String content;
  final double score;
  final List<Map<String, dynamic>> options;

  QuizQuestion({
    required this.id,
    required this.content,
    required this.score,
    required this.options,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'content': content, 'score': score, 'options': options};
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      score: (map['score'] ?? 0).toDouble(),
      options: List<Map<String, dynamic>>.from(map['options'] ?? []),
    );
  }
}

class QuizModel {
  final String id;
  final String title;
  final String description;
  final String classId;
  final String lecturerId;
  final String status; // 'draft', 'published', 'closed'
  final DateTime createdAt;
  final QuizSettings settings;
  final List<QuizQuestion> questions;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.classId,
    required this.lecturerId,
    required this.status,
    required this.createdAt,
    required this.settings,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'classId': classId,
      'lecturerId': lecturerId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'settings': settings.toMap(),
      'questions': questions.map((x) => x.toMap()).toList(),
    };
  }

  factory QuizModel.fromMap(Map<String, dynamic> map, String documentId) {
    return QuizModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      classId: map['classId'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      status: map['status'] ?? 'draft',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      settings: QuizSettings.fromMap(map['settings'] ?? {}),
      questions: List<QuizQuestion>.from(
        (map['questions'] ?? []).map((x) => QuizQuestion.fromMap(x)),
      ),
    );
  }
}
