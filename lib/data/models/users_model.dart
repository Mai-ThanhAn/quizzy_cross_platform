import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; // UID From Firebase Auth
  final String email;
  final String fullName;
  final String role; // 'student', 'lecturer', 'superadmin'
  final String? studentId; // Student ID, If role is 'student'
  final String? avatarUrl;
  final DateTime createdAt;
  final bool isActive;
  final List<String>
  enrolledClassIds; // Used for students, if student is enrolled in classes

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.studentId,
    this.avatarUrl,
    required this.createdAt,
    this.isActive = true,
    this.enrolledClassIds = const [],
  });

  // Transfer from Map (Firestore Document) to Object
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId, // Get UID from documentId
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      role: map['role'] ?? 'student',
      studentId: map['studentId'],
      avatarUrl: map['avatarUrl'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
      enrolledClassIds: List<String>.from(map['enrolledClassIds'] ?? []),
    );
  }

  // Transfer from Object to Map (for Firestore Document)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'role': role,
      'studentId': studentId,
      'avatarUrl': avatarUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
      'enrolledClassIds': enrolledClassIds,
    };
  }

  // Copy with method to create a modified copy of the UserModel
  UserModel copyWith({
    String? fullName,
    String? avatarUrl,
    bool? isActive,
    List<String>? enrolledClassIds,
  }) {
    return UserModel(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      role: role,
      studentId: studentId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
      enrolledClassIds: enrolledClassIds ?? this.enrolledClassIds,
    );
  }
}
