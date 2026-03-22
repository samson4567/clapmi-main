import 'dart:convert';

/// Represents the response from the 10k limit withdrawal endpoint.
class WithdrawalResponse {
  final bool success;
  final String message;
  final List<dynamic>? data; // Usually empty
  final List<dynamic>? errors; // Usually empty

  WithdrawalResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory WithdrawalResponse.fromMap(Map<String, dynamic> map) {
    return WithdrawalResponse(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      data: map['data'] != null ? List<dynamic>.from(map['data']) : null,
      errors: map['errors'] != null ? List<dynamic>.from(map['errors']) : null,
    );
  }

  factory WithdrawalResponse.fromJson(String source) =>
      WithdrawalResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'errors': errors,
    };
  }

  String toJson() => json.encode(toMap());
}
