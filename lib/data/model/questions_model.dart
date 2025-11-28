import 'package:cloud_firestore/cloud_firestore.dart';

// Class for OptionModel
class OptionModel {
  final String id;
  final String text;
  final bool isCorrect;

  OptionModel({required this.id, required this.text, required this.isCorrect});

  // Transfer from Object to Map (for Firestore Document)
  Map<String, dynamic> toMap() {
    return {'id': id, 'text': text, 'isCorrect': isCorrect};
  }

  // Transfer from Map (Firestore Document) to Object
  factory OptionModel.fromMap(Map<String, dynamic> map) {
    return OptionModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      isCorrect: map['isCorrect'] ?? false,
    );
  }
}

// Class for QuestionModel
class QuestionModel {
  final String id;
  final String content;
  final String type; // 'multiple_choice', 'single_choice'
  final String difficulty; // 'easy', 'medium', 'hard'
  final String lecturerId;
  final DateTime createdAt;
  final List<OptionModel> options; // List of options for the question

  QuestionModel({
    required this.id,
    required this.content,
    required this.type,
    this.difficulty = 'medium',
    required this.lecturerId,
    required this.createdAt,
    required this.options,
  });

  // Transfer from Object to Map (for Firestore Document)
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'type': type,
      'difficulty': difficulty,
      'lecturerId': lecturerId,
      'createdAt': Timestamp.fromDate(createdAt),
      // Lưu ý: Phải map list object sang list map
      'options': options.map((x) => x.toMap()).toList(),
    };
  }

  // Transfer from Map (Firestore Document) to Object
  factory QuestionModel.fromMap(Map<String, dynamic> map, String documentId) {
    return QuestionModel(
      id: documentId,
      content: map['content'] ?? '',
      type: map['type'] ?? 'multiple_choice',
      difficulty: map['difficulty'] ?? 'medium',
      lecturerId: map['lecturerId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      options: List<OptionModel>.from(
        (map['options'] ?? []).map((x) => OptionModel.fromMap(x)),
      ),
    );
  }
}
