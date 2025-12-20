class FirestoreException implements Exception {
  final String code;
  final String message;

  FirestoreException(this.code, this.message);

  @override
  String toString() => message;
}