import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionBankModel {
  final String id;
  final String name;
  final String description;
  final String lecturerId;
  final DateTime createdAt;
  final int totalQuestions;

  QuestionBankModel({
    required this.id,
    required this.name,
    required this.description,
    required this.lecturerId,
    required this.createdAt,
    this.totalQuestions = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'lecturerId': lecturerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'totalQuestions': totalQuestions,
    };
  }

  factory QuestionBankModel.fromMap(Map<String, dynamic> map, String id) {
    return QuestionBankModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalQuestions: map['totalQuestions'] ?? 0,
    );
  }
}