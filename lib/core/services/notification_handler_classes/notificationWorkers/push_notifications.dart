import 'dart:convert';
import 'dart:io';

import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/di/injector.dart';
import 'package:clapmi/core/services/notification_handler_classes/notificationWorkers/local_notification.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PushNotificationsService {
  //create an instance of the firebase messaging plugin
  static final _firebaseMessaging = FirebaseMessaging.instance;

  // Callback for when user logs in and we need to register the token
  static Function(String token)? onTokenReadyForRegistration;

  //initialize the firebase messaging (request permission for notifications)
  static Future<void> init() async {
    //request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    //check if the permission is granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Wait for APNS token to be available before getting FCM token
    // On iOS, we need to wait for the device to receive the APNS token from Apple
    await _waitForAPNSToken();

    //get the FCM (Firebase Cloud Messaging) token from the device
    String? token = await _firebaseMessaging.getToken();
    thetoken = token;
    print('FCM Token: $token');

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('FCM Token refreshed: $newToken');
      thetoken = newToken;
      // Register the new token with the backend
      _registerTokenWithBackend(newToken);
    });
  }

  // Wait for APNS token to be available (iOS requirement)
  static Future<void> _waitForAPNSToken(
      {int maxRetries = 10,
      Duration delay = const Duration(seconds: 1)}) async {
    // Check if APNS token is already available
    String? apnsToken = await _firebaseMessaging.getAPNSToken();
    if (apnsToken != null) {
      print('APNS Token already available: $apnsToken');
      return;
    }

    // APNS token not available yet, wait and retry
    print('Waiting for APNS token to be available...');
    for (int i = 0; i < maxRetries; i++) {
      await Future.delayed(delay);
      apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        print('APNS Token received after ${i + 1} attempt(s): $apnsToken');
        return;
      }
      print('APNS Token not yet available, retry ${i + 1}/$maxRetries');
    }

    // If we reach here, APNS token was not received after all retries
    // This can happen on simulators or if there's a configuration issue
    print('WARNING: APNS Token was not received after $maxRetries attempts. '
        'This is expected on iOS simulators. On physical devices, check '
        'that push notifications are properly configured.');
  }

  // Register FCM token with backend
  static Future<void> registerTokenWithBackend() async {
    if (thetoken != null) {
      await _registerTokenWithBackend(thetoken!);
    }
  }

  static Future<void> _registerTokenWithBackend(String token) async {
    try {
      final networkClient = getItInstance<ClapMiNetworkClient>();
      final deviceType = Platform.isIOS ? 'ios' : 'android';
      await networkClient.post(
        endpoint: EndpointConstant.registerFCMtoken,
        isAuthHeaderRequired: true,
        data: {
          'token': token,
          'device_type': deviceType,
        },
      );
      print('FCM Token registered successfully with backend');
    } catch (e) {
      print('Failed to register FCM token with backend: $e');
    }
  }

  // Unregister FCM token from backend (call on logout)
  static Future<void> unregisterTokenFromBackend() async {
    if (thetoken != null) {
      try {
        final networkClient = getItInstance<ClapMiNetworkClient>();
        await networkClient.post(
          endpoint: EndpointConstant.unregisterFCMtoken,
          isAuthHeaderRequired: true,
          data: {
            'token': thetoken!,
          },
        );
        print('FCM Token unregistered successfully from backend');
      } catch (e) {
        print('Failed to unregister FCM token from backend: $e');
      }
    }
  }

  // Function to store token (kept for compatibility)
  static void storeToken(String? token) {
    thetoken = token;
    if (token != null) {
      _registerTokenWithBackend(token);
    }
  }

  //funtion that will listen for incoming messages in background
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print('Background message received: ${message.notification!.title}');
    }
  }

  // on background notification tapped function (pass the payload data to the message opener screen)
  static Future<void> onBackgroundNotificationTapped(
      RemoteMessage message, GlobalKey<NavigatorState> navigatorKey) async {
    // Navigate to notification page with the message data
    final payloadData = jsonEncode(message.data);
    navigatorKey.currentState?.context.pushNamed(
      MyAppRouteConstant.notificationPage,
      extra: {'message': message, 'payload': payloadData},
    );
  }

  // Handle foreground notifications - fixed typo in method name
  static Future<void> onForegroundNotificationTapped(
    RemoteMessage message,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    String payloadData = jsonEncode(message.data);

    print("Got the message in foreground");
    print("String payloadData = jsonEncode(message.data);>>${message.data}");

    if (message.notification != null) {
      await LocalNotificationService.showInstantNotificationWithPayload(
        title: message.notification?.title ?? "Clapmi",
        body: message.notification?.body ?? "You have a new notification",
        payload: payloadData,
      );

      // Note: Navigation on tap is handled by onDidReceiveNotificationResponse
      // in LocalNotificationService.init() - the callback is set to navigate
      // to notificationPage when a notification with payload is tapped
    }
  }

  // Legacy method name kept for backwards compatibility
  @Deprecated('Use onForegroundNotificationTapped instead')
  static Future<void> onForeroundNotificationTapped(
    RemoteMessage message,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    return onForegroundNotificationTapped(message, navigatorKey);
  }
}

String? thetoken;
