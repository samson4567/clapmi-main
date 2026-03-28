// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/services/notification_handler_classes/notificationWorkers/local_notification.dart';
import 'package:clapmi/core/services/notification_handler_classes/notificationWorkers/push_notifications.dart';
import 'package:clapmi/core/utils/app_logger.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_bloc.dart';
import 'package:clapmi/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/video_bloc/video_bloc.dart';
import 'package:clapmi/features/search/presentation/blocs/search_bloc.dart'; // Add SearchBloc import
import 'package:clapmi/features/livestream/presentation/blocs/recording/recording_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/firebase_options.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/Brag/brag_screen_tu_controller.dart';
import 'package:clapmi/utils/app_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_caching/flutter_video_caching.dart';
import 'package:go_router/go_router.dart';
// ignore: unused_import
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:fvp/fvp.dart' as fvp;
import 'core/di/injector.dart' as injector;
import 'core/di/injector.dart';
import 'features/rewards/presentation/blocs/reward_bloc.dart';
import 'features/settings/presentation/bloc/notification_settings_bloc.dart';
import 'features/settings/presentation/bloc/privacy_settings_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.info('Application starting...', tag: 'MAIN');

  // 1. Initialize the Proxy Server
  await VideoProxy.init();

  // 2. Initialize MediaKit
  MediaKit.ensureInitialized();
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
  isthereInternetG = !connectivityResult.contains(ConnectivityResult.none);
  // Note: Connectivity subscription is now managed in _MyAppState for proper cleanup
  try {
    // fvp.registerWith();
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to register FVP',
      tag: 'MAIN',
      error: e,
      stackTrace: stackTrace,
    );
  }

  await injector.init();
  await notificationFunctions();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => VideoFeedProvider(),
      ),
    ],
    child: MultiBlocProvider(providers: [
      BlocProvider(create: (_) => getItInstance<AuthBloc>()),
      BlocProvider(create: (_) => getItInstance<OnboardingBloc>()),
      BlocProvider(create: (_) => getItInstance<AppBloc>()),
      BlocProvider(create: (_) => getItInstance<NotificationSettingsBloc>()),
      BlocProvider(create: (_) => getItInstance<PrivacySettingsBloc>()),
      BlocProvider(create: (_) => getItInstance<UserBloc>()),
      BlocProvider(create: (_) => getItInstance<ChatsAndSocialsBloc>()),
      BlocProvider(create: (_) => getItInstance<PostBloc>()),
      BlocProvider(create: (_) => getItInstance<ComboBloc>()),
      BlocProvider(create: (_) => getItInstance<BragBloc>()),
      BlocProvider(create: (_) => getItInstance<NotificationBloc>()),
      BlocProvider(create: (_) => getItInstance<AppBloc>()),
      BlocProvider(create: (_) => getItInstance<WalletBloc>()),
      BlocProvider(create: (_) => getItInstance<VideoBloc>()),
      BlocProvider(
        create: (_) => getItInstance<RewardBloc>(),
      ), // Add RewardBloc provider
      BlocProvider(
        create: (_) => getItInstance<SearchBloc>(),
      ), // Add SearchBloc provider
      BlocProvider(
        create: (_) => getItInstance<RecordingBloc>(),
      ), // Add RecordingBloc provider
      // BlocProvider(
      //   create: (_) =>getItInstance <VideoFeedProvider>(),
      // )
    ], child: MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri>? _linkSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<String>? _fcmTokenRefreshSubscription;
  // FIXED: Properly track FCM message subscriptions to prevent memory leaks
  StreamSubscription<RemoteMessage>? _fcmMessageSubscription;
  StreamSubscription<RemoteMessage>? _fcmMessageOpenedAppSubscription;
  final appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    // Store subscriptions for proper cleanup
    ScreenSecurity.disableProtection();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (!result.contains(ConnectivityResult.none)) {
        isthereInternetG = true;
      } else {
        isthereInternetG = false;
      }
    });

    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _fcmTokenRefreshSubscription =
            FirebaseMessaging.instance.onTokenRefresh.listen(
          (event) {
            context.read<AuthBloc>().add(RegisterFCMtokenEvent(
                token: thetoken!,
                deviceType: Platform.isAndroid ? "android" : 'ios'));
          },
        );
      },
    );
  }

  late Timer eventRepeater;

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _connectivitySubscription?.cancel();
    _fcmTokenRefreshSubscription?.cancel();
    // FIXED: Cancel FCM message subscriptions to prevent memory leaks
    _fcmMessageSubscription?.cancel();
    _fcmMessageOpenedAppSubscription?.cancel();
    AppLogger.debug('MyAppState disposed - all subscriptions cancelled',
        tag: 'MAIN');
    super.dispose();
  }

  Future<void> initDeepLinks(BuildContext context) async {
    _linkSubscription = appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleIncomingLink(uri);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: customAppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: router,
      ),
    );
  }

  void _handleIncomingLink(Uri link) async {
    if (link.scheme == 'https') {
      if (link.host == 'google' && link.pathSegments.isNotEmpty) {
        context.goNamed(MyAppRouteConstant.walletGeneralPage);
      }
    }
  }
}

/// Initialize notifications and Firebase services.
/// Returns the subscriptions for proper cleanup in the calling widget.
notificationFunctions() async {
  //// notification Shenanigans

  // FIXED: These subscriptions should be stored at class level, not local to this function
  // The subscriptions will be managed by _MyAppState
  StreamSubscription<RemoteMessage>? fcmMessageOpenedAppSub;
  StreamSubscription<RemoteMessage>? fcmMessageSub;

  try {
    await LocalNotificationService.init();

    tz.initializeTimeZones();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await PushNotificationsService.init();

    //listen for incoming messages in background
    FirebaseMessaging.onBackgroundMessage(
        PushNotificationsService.onBackgroundMessage);

    // on background notification tapped
    fcmMessageOpenedAppSub = FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        if (message.notification != null) {
          print("Background Notification Tapped");
          await PushNotificationsService.onBackgroundNotificationTapped(
            message,
            rootNavigatorKey,
          );
        }
      },
    );

    // on foreground notification tapped
    fcmMessageSub =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await PushNotificationsService.onForegroundNotificationTapped(
        message,
        rootNavigatorKey,
      );
    });

    // for handling in terminated state
    final RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      // Use WidgetsBinding to ensure navigation happens after the app is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check if navigator is ready
        final navigatorState = rootNavigatorKey.currentState;
        if (navigatorState != null && navigatorState.mounted) {
          navigatorState.pushNamed(
            MyAppRouteConstant.notificationPage,
          );
        }
      });
    }
  } catch (e, stackTrace) {
    AppLogger.error(
      'Notification initialization failed',
      tag: 'NOTIFICATION',
      error: e,
      stackTrace: stackTrace,
    );
  }

  /// notification shens  ended ........
}

class ScreenSecurity {
  // Call this to BLOCK screenshots
  static Future<void> enableProtection() async {
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  // Call this to ALLOW screenshots
  static Future<void> disableProtection() async {
    // await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
