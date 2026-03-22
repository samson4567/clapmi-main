import 'package:equatable/equatable.dart';

abstract class NotificationSettingsEvent extends Equatable {
  const NotificationSettingsEvent();

  @override
  List<Object> get props => [];
}

final class FetchNotificationSettingsEvent extends NotificationSettingsEvent {
  final String userId;

  const FetchNotificationSettingsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

final class UpdateNotificationSettingsEvent extends NotificationSettingsEvent {
  final Map<String, dynamic> updatedSettings;

  const UpdateNotificationSettingsEvent(this.updatedSettings);

  @override
  List<Object> get props => [updatedSettings];
}
