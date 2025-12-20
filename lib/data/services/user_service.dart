import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';

class UserService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await usersCollection.doc(uid).set(data);
  }

  Future<bool> checkEmailExists(String email) async {
    final query = await usersCollection.where('email', isEqualTo: email).get();
    return query.docs.isNotEmpty;
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await usersCollection.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}