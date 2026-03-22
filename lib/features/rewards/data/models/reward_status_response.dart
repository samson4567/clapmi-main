import 'package:equatable/equatable.dart';

/// Represents the response structure for the reward status API.
class RewardStatusResponse extends Equatable {
  final bool success;
  final String message;
  final List<String> data;

  const RewardStatusResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a RewardStatusResponse instance from a JSON map.
  factory RewardStatusResponse.fromJson(Map<String, dynamic> json) {
    return RewardStatusResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      // Ensure data is always a List<String>, even if null or not a list
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  /// Converts the RewardStatusResponse instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }

  @override
  List<Object?> get props => [success, message, data];
}
