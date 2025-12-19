class ApiError {
  final String message;
  final int? stutusCode;

  ApiError({required this.message, this.stutusCode});

  @override
  String toString() {
    return 'error is : $message';
  }
}
