import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

final class GetNotificationListEvent extends NotificationEvent {
  const GetNotificationListEvent();

  @override
  List<Object> get props => [];
}

final class MarkNotificationAsReadEvent extends NotificationEvent {
  final String notificationID;

  const MarkNotificationAsReadEvent({
    required this.notificationID,
  });

  @override
  List<Object> get props => [notificationID];
}

final class MarkAllNotificationAsReadEvent extends NotificationEvent {
  const MarkAllNotificationAsReadEvent();

  @override
  List<Object> get props => [];
}

final class ClearNotificationEvent extends NotificationEvent {
  final String notificationID;

  const ClearNotificationEvent({
    required this.notificationID,
  });

  @override
  List<Object> get props => [notificationID];
}

final class ClearAllNotificationsEvent extends NotificationEvent {
  const ClearAllNotificationsEvent();

  @override
  List<Object> get props => [];
}

// ClearAllNotifications
