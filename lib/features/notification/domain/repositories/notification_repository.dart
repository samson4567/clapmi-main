import 'package:clapmi/features/notification/domain/entities/notification_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotificationList();
  Future<Either<Failure, String>> markNotificationAsRead(
      {required String notificationID});
  Future<Either<Failure, String>> markAllNotificationAsRead();
  Future<Either<Failure, String>> clearNotification(
      {required String notificationID});
  Future<Either<Failure, String>> clearAllNotifications();

  // Future<String> clearNotification({required String notificationID});
}
