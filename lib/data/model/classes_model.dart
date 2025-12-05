import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final String id;
  final String code;
  final String name;
  final String lecturerId;
  final String lecturerName;
  final String semester;
  final DateTime createdAt;
  final List<String> studentIds;

  ClassModel({
    required this.id,
    required this.code,
    required this.name,
    required this.lecturerId,
    required this.lecturerName,
    required this.semester,
    required this.createdAt,
    this.studentIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'semester': semester,
      'createdAt': Timestamp.fromDate(createdAt),
      'studentIds': studentIds,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ClassModel(
      id: documentId,
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      semester: map['semester'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      studentIds: List<String>.from(map['studentIds'] ?? []),
    );
  }
}