import 'package:clapmi/features/notification/domain/entities/notification_entity.dart';
import 'package:equatable/equatable.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

// GetNotificationList states
final class GetNotificationListLoadingState extends NotificationState {
  const GetNotificationListLoadingState();
}

final class GetNotificationListSuccessState extends NotificationState {
  final List<NotificationEntity> listOfNotificationEntity;

  const GetNotificationListSuccessState(
      {required this.listOfNotificationEntity});

  @override
  List<Object> get props => [listOfNotificationEntity];
}

final class GetNotificationListErrorState extends NotificationState {
  final String errorMessage;

  const GetNotificationListErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// MarkNotificationAsRead states
final class MarkNotificationAsReadLoadingState extends NotificationState {
  const MarkNotificationAsReadLoadingState();
}

final class MarkNotificationAsReadSuccessState extends NotificationState {
  final String message;

  const MarkNotificationAsReadSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class MarkNotificationAsReadErrorState extends NotificationState {
  final String errorMessage;

  const MarkNotificationAsReadErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// MarkAllNotificationAsRead states
final class MarkAllNotificationAsReadLoadingState extends NotificationState {
  const MarkAllNotificationAsReadLoadingState();
}

final class MarkAllNotificationAsReadSuccessState extends NotificationState {
  final String message;

  const MarkAllNotificationAsReadSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class MarkAllNotificationAsReadErrorState extends NotificationState {
  final String errorMessage;

  const MarkAllNotificationAsReadErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// ClearNotification states
final class ClearNotificationLoadingState extends NotificationState {
  const ClearNotificationLoadingState();
}

final class ClearNotificationSuccessState extends NotificationState {
  final String message;

  const ClearNotificationSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ClearNotificationErrorState extends NotificationState {
  final String errorMessage;

  const ClearNotificationErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// ClearAllNotifications states
final class ClearAllNotificationsLoadingState extends NotificationState {
  const ClearAllNotificationsLoadingState();
}

final class ClearAllNotificationsSuccessState extends NotificationState {
  final String message;

  const ClearAllNotificationsSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ClearAllNotificationsErrorState extends NotificationState {
  final String errorMessage;

  const ClearAllNotificationsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}



// ClearAllNotifications