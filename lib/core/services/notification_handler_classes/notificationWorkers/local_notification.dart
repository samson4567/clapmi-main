// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:clapmi/core/services/notification_handler_classes/notificationWorkers/util_functions.dart';
import 'package:clapmi/core/services/notification_handler_classes/notificationWorkers/notification_navigation.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  //create an instace of the flutter local notification plugin
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Define proper channel IDs and names for Android
  static const String _defaultChannelId = 'clapmi_default_channel';
  static const String _defaultChannelName = 'Clapmi Notifications';
  static const String _defaultChannelDescription =
      'General notifications from Clapmi';

  static const String _pushChannelId = 'clapmi_push_channel';
  static const String _pushChannelName = 'Push Notifications';
  static const String _pushChannelDescription = 'Push notification alerts';

  static int _nextNotificationId() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  static Future<void> onDidReceiveBackgroundNotificationResponse(
      NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;
    if (payload != null) {
      print('Notification tapped with payload: $payload');
    }
    await NotificationNavigationService.openFromPayload(
      context: rootNavigatorKey.currentState?.context,
      payload: payload,
    );
  }

  //initialize the notification
  static Future<void> init() async {
    //initialize the android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //initialize the ios settings
    const DarwinInitializationSettings initializationSettingsIos =
        DarwinInitializationSettings();

    //combine the android and ios settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
    );

    //initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    //request permission to show notifications andriod
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  //show a notification (instant notification)

  static Future<void> showInstantNotification(
      {required String title, required String body}) async {
    //define the notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      //define the android notification details
      android: AndroidNotificationDetails(
        _defaultChannelId,
        _defaultChannelName,
        channelDescription: _defaultChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),

      //define the ios notification details
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    //show the notification
    await flutterLocalNotificationsPlugin.show(
      _nextNotificationId(),
      title,
      body,
      platformChannelSpecifics,
    );
  }

  //schedule a notification

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    //define the notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      //define the android notification details
      android: AndroidNotificationDetails(
        _defaultChannelId,
        _defaultChannelName,
        channelDescription: _defaultChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),

      //define the ios notification details
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    //schedule the notification

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  // Recurring Notification

  static Future<void> showRecurringNotification({
    required String title,
    required String body,
    required DateTime time,
    required Day day,
  }) async {
    //define the notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      //define the android notification details
      android: AndroidNotificationDetails(
        _defaultChannelId,
        _defaultChannelName,
        channelDescription: _defaultChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),

      //define the ios notification details
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    //schedule the notification

    await flutterLocalNotificationsPlugin.zonedSchedule(
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      0,
      title,
      body,
      // tz.TZDateTime
      // tz.TZDateTime.fromMillisecondsSinceEpoch(
      //     tz.TZDateTime.local(1995).location,
      //     DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch),

      UtilFunctions().nextInstanceOfTime(time, day),
      platformChannelSpecifics,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  //Big Picture Notification

  static Future<void> showBigPictureNotification(
      {required String title,
      required String body,
      required String imageUrl}) async {
    //define the notification details
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      DrawableResourceAndroidBitmap(imageUrl),
      largeIcon: DrawableResourceAndroidBitmap(imageUrl),
      contentTitle: title,
      summaryText: body,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      //define the android notification details
      android: AndroidNotificationDetails(
        _defaultChannelId,
        _defaultChannelName,
        channelDescription: _defaultChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyleInformation,
      ),

      //define the ios notification details
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        attachments: [DarwinNotificationAttachment(imageUrl)],
      ),
    );

    //show the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  //Image notification ( same as big picture notification)
  Future imageNotification() async {
    var bigPicture = const BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails(
      "id",
      "channel",
      styleInformation: bigPicture,
    );

    var platform = NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(
        0, "Demo Image notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Location-based Notification

  // The Loation based notification requires some prerequisites such as,
  // 1. The location package
  // 2. The geoflutterfire package
  // 3. The google_maps_flutter package

  //this is the logic to show a location-based notification from theese packages I will not include any code here but i will explain the logic
  // 1. Get the current location of the user
  // 2. Get the location of the place you want to show the notification
  // 3. Calculate the distance between the two locations
  // 4. If the distance is less than a certain value show the notification

  // we will implement this after we discuss the google maps section

  //Cancel notification

  Future cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //show a notification (instant notification) with a payload

  static Future<void> showInstantNotificationWithPayload({
    required String title,
    required String body,
    required String payload,
  }) async {
    //define the notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      //define the android notification details
      android: AndroidNotificationDetails(
        _pushChannelId,
        _pushChannelName,
        channelDescription: _pushChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),

      //define the ios notification details
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    //show the notification
    await flutterLocalNotificationsPlugin.show(
      _nextNotificationId(),
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
