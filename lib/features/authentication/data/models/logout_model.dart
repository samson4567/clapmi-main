import 'package:clapmi/features/authentication/domain/entities/logoout_entity.dart';

class LogoutModel extends LogoutEntity {
  const LogoutModel({
    super.refreshToken,
  });

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      refreshToken: json['refresh_token'] as String?, // nullable cast
    );
  }

  /// Encode to JSON
  Map<String, dynamic> toJson() => {
        'refresh_token': refreshToken,
      };

  LogoutModel copyWith({
    String? refreshToken,
  }) {
    return LogoutModel(
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
