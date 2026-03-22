import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/models/notification_settings_model.dart';
import 'package:clapmi/models/privacy_settings_model.dart';

abstract class SettingsDataSource {
  Future<List<PrivacySettings>> getPrivacySettings();
  // Keep old method for compatibility or remove if unused
  // Future<String> updatePrivacySettings(String visibility);

  // New method to update a specific setting by key
  Future<String> updatePrivacySettingByKey(String key, dynamic value);

  Future<List<NotificationSettings>> getNotificationSettings();
  Future<String> updateNotificationSettings({
    required int networkRequestAlert,
    required int emailAlert,
  });
}

class SettingsDataSourceImpl implements SettingsDataSource {
  SettingsDataSourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
  });

  final AppPreferenceService appPreferenceService;

  final ClapMiNetworkClient networkClient;

  @override
  Future<List<PrivacySettings>> getPrivacySettings() async {
    final response = await networkClient.get(
        endpoint: EndpointConstant.privacySettings, isAuthHeaderRequired: true);
    print("debug_print_getPrivacy-result_fetched${[
      response.data,
      response.message
    ]}");
    return (response.data as List)
        .map((json) => PrivacySettings.fromJson(json))
        .toList();
  }

  @override
  // Keep old method implementation for compatibility or remove if unused
  // @override
  // Future<String> updatePrivacySettings(String visibility) async {
  //   final response = await networkClient.put(
  //       endpoint: EndpointConstant.privacySettings,
  //       isAuthHeaderRequired: true,
  //       data: {'who_can_see_my_post': visibility});
  //   print("debug_print_updatePrivacy-result_fetched${[
  //     response.data,
  //     response.message
  //   ]}");
  //   return response.message;
  // }

  // Implementation for the new method
  @override
  Future<String> updatePrivacySettingByKey(String key, dynamic value) async {
    // The endpoint might need adjustment if the API expects updates per key
    // differently. Assuming a generic update endpoint for now.
    // The backend needs to handle updates based on the key provided in the data.
    final response = await networkClient.put(
      endpoint: EndpointConstant
          .privacySettings, // Or a specific endpoint if available
      isAuthHeaderRequired: true,
      data: {key: value}, // Send the specific key-value pair to update
    );
    print("debug_print_updatePrivacyByKey($key: $value)-result_fetched${[
      response.data,
      response.message
    ]}");
    return response.message;
  }

  @override
  Future<List<NotificationSettings>> getNotificationSettings() async {
    final response = await networkClient.get(
        endpoint: EndpointConstant.notificationSettings,
        isAuthHeaderRequired: true);
    print("debug_print_getNotification-result_fetched${[
      response.data,
      response.message
    ]}");
    return (response.data as List)
        .map((json) => NotificationSettings.fromJson(json))
        .toList();
  }

  @override
  Future<String> updateNotificationSettings({
    required int networkRequestAlert,
    required int emailAlert,
  }) async {
    final response = await networkClient.put(
      endpoint: EndpointConstant.notificationSettings,
      isAuthHeaderRequired: true,
      data: {
        'network_request_alert': networkRequestAlert,
        'email_alert': emailAlert,
      },
    );
    print("debug_print_updateNotification-result_fetched${[
      response.data,
      response.message
    ]}");
    return response.message;
  }
}
