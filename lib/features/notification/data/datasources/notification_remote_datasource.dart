import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';

import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/features/notification/data/models/notification_model.dart';
import 'package:clapmi/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationRemoteDatasource {
  Future<List<NotificationEntity>> getNotificationList();
  Future<String> markNotificationAsRead({required String notificationID});
  Future<String> clearNotification({required String notificationID});

  Future<String> markAllNotificationAsRead();
  Future<String> clearAllNotifications();
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  // notificationList
  NotificationRemoteDatasourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
  });
  final AppPreferenceService appPreferenceService;

  final ClapMiNetworkClient networkClient;

  @override
  Future<List<NotificationModel>> getNotificationList() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.notificationList,
      isAuthHeaderRequired: true,
      data: {"recent": true},
    );
    List notifications =
        ((response.data as Map?)?["notifications"] as List?) ?? [];

    final result = notifications
        .map(
          (e) => NotificationModel.fromJson(json: e),
        )
        .toList();

    return result;
  }

  @override
  Future<String> markNotificationAsRead(
      {required String notificationID}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.markNotificationAsRead,
        isAuthHeaderRequired: true,
        data: {
          "notification": notificationID,
        });
    return response.message;
  }

  @override
  Future<String> markAllNotificationAsRead() async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.markAllNotificationAsRead,
      isAuthHeaderRequired: true,
    );

    return response.message;
  }

  @override
  Future<String> clearNotification({required String notificationID}) async {
    final response = await networkClient.delete(
        endpoint: EndpointConstant.clearNotification,
        isAuthHeaderRequired: true,
        data: {
          "notification": notificationID,
        });
    return response.message;
  }

  @override
  Future<String> clearAllNotifications() async {
    final response = await networkClient.delete(
      endpoint: EndpointConstant.clearAllNotifications,
      isAuthHeaderRequired: true,
    );

    return response.message;
  }
}
// markNotificationAsRead
