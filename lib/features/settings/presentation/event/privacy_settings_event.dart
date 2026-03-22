import 'package:equatable/equatable.dart';

abstract class PrivacySettingsEvent extends Equatable {
  const PrivacySettingsEvent();

  @override
  List<Object> get props => [];
}

final class FetchPrivacySettingsEvent extends PrivacySettingsEvent {
  final String userId;

  const FetchPrivacySettingsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

final class UpdatePrivacySettingsEvent extends PrivacySettingsEvent {
  final Map<String, dynamic> updatedSettings;

  const UpdatePrivacySettingsEvent(this.updatedSettings);

  @override
  List<Object> get props => [updatedSettings];
}
