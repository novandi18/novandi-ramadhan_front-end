class ResponseMessage {
  final String message;

  ResponseMessage({
    required this.message,
  });

  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    return ResponseMessage(
      message: json['message'],
    );
  }
}