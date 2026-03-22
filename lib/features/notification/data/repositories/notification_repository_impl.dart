import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:clapmi/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:clapmi/features/notification/domain/entities/notification_entity.dart';
import 'package:clapmi/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required this.notificationLocalDatasource,
    required this.notificationRemoteDatasource,
  });

  final NotificationRemoteDatasource notificationRemoteDatasource;
  final NotificationLocalDatasource notificationLocalDatasource;

  @override
  Future<Either<Failure, List<NotificationEntity>>>
      getNotificationList() async {
    try {
      final result = await notificationRemoteDatasource.getNotificationList();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> markNotificationAsRead(
      {required String notificationID}) async {
    try {
      final result = await notificationRemoteDatasource.markNotificationAsRead(
          notificationID: notificationID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> markAllNotificationAsRead() async {
    try {
      final result =
          await notificationRemoteDatasource.markAllNotificationAsRead();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> clearNotification(
      {required String notificationID}) async {
    try {
      final result = await notificationRemoteDatasource.clearNotification(
          notificationID: notificationID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> clearAllNotifications() async {
    try {
      final result = await notificationRemoteDatasource.clearAllNotifications();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
