import 'dart:convert';

// {
//     "error": false,
//     "success": true,
//     "message": "user signed in successfully",
//     "otp": 6059
// }
class OtpModel {
  bool error;
  bool success;
  String message;
  int? otp;
  OtpModel({
    required this.error,
    required this.success,
    required this.message,
    required this.otp,
  });

  Map<String, dynamic> toMap() {
    return {
      'error': error,
      'success': success,
      'message': message,
      'otp': otp,
    };
  }

  factory OtpModel.fromMap(Map<String, dynamic> map) {
    return OtpModel(
      error: map['error'] ?? false,
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      otp: map['otp']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory OtpModel.fromJson(String source) =>
      OtpModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OtpModel(error: $error, success: $success, message: $message, otp: $otp)';
  }
}
