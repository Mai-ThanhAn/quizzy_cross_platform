import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    Future<void> createUser(String uid, Map<String, dynamic> data) {
    return _db.collection('users').doc(uid).set(data);
  }
}