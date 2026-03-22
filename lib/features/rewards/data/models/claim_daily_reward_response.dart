import 'dart:convert';

/// Represents the response from the claim daily reward endpoint.
class ClaimDailyRewardResponse {
  final int? code;
  final bool success;
  final String message;
  final String? nextClaim;
  final List<dynamic>? data; // Assuming data is always empty for success
  final List<dynamic>? errors; // Assuming errors is always empty for error

  ClaimDailyRewardResponse({
    this.code,
    required this.success,
    required this.message,
    this.nextClaim,
    this.data,
    this.errors,
  });

  factory ClaimDailyRewardResponse.fromMap(Map<String, dynamic> map) {
    return ClaimDailyRewardResponse(
      code: map['code'],
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      nextClaim: map['next_claim'],
      data: map['data'] != null ? List<dynamic>.from(map['data']) : null,
    );
  }

  factory ClaimDailyRewardResponse.fromJson(String source) =>
      ClaimDailyRewardResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'success': success,
      'message': message,
      'next_claim': nextClaim,
      'data': data,
      'errors': errors,
    };
  }

  String toJson() => json.encode(toMap());
}
