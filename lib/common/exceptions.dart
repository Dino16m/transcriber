class ApplicationError extends Error {
  final String message;

  ApplicationError(this.message);

  @override
  String toString() {
    return '$runtimeType: $message';
  }
}
