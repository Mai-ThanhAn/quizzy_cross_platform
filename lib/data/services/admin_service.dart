import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';

class AdminService {
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection('users');

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _userCollection
        .where('role', whereIn: ['student', 'lecturer'])
        // .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<List<UserModel>> getPendingLecturers() async {
    final snapshot = await _userCollection
        .where('role', isEqualTo: 'lecturer')
        .where('isActive', isEqualTo: false)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<void> toggleUserStatus(String uid, bool currentStatus) async {
    await _userCollection.doc(uid).update({'isActive': !currentStatus});
  }

  Future<void> approveLecturer(String uid) async {
    await _userCollection.doc(uid).update({
      'isActive': true,
    });
  }
}
