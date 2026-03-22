import 'dart:convert';

/// Represents the response from the claim referral reward endpoint.
class ClaimReferralRewardResponse {
  final bool success;
  final String message;
  final ReferralRewardData? data;

  ClaimReferralRewardResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ClaimReferralRewardResponse.fromMap(Map<String, dynamic> map) {
    return ClaimReferralRewardResponse(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      // Check if data is present and not an empty list before parsing
      data: map['data'] != null && map['data'] is Map<String, dynamic>
          ? ReferralRewardData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  factory ClaimReferralRewardResponse.fromJson(String source) =>
      ClaimReferralRewardResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

/// Represents the data structure within the successful claim referral reward response.
class ReferralRewardData {
  final int balance;

  ReferralRewardData({required this.balance});

  factory ReferralRewardData.fromMap(Map<String, dynamic> map) {
    return ReferralRewardData(
      balance: map['balance']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
    };
  }
}
