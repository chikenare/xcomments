class SetUserException implements Exception {
  SetUserException(this.message);
  final String message;

  @override
  String toString() => message;
}
