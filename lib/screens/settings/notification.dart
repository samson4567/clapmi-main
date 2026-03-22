import 'package:clapmi/core/services/notification_handler_classes/notificationWorkers/push_notifications.dart';
import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:clapmi/features/settings/presentation/bloc/notification_settings_bloc.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationSettingsBloc>().add(GetNotificationSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationSettingsBloc, NotificationSettingsState>(
      listener: (context, state) {
        if (state is NotificationSettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is NotificationSettingsLoaded) {
          // state.settings.;
          final toEnable = state.settings.any(
            (element) => element.userValue == "true",
          );

          context.read<AuthBloc>().add(ToogleNotificationStateEvent(
              token: thetoken!, toEnable: toEnable));
        }
        // MyAppRouteConstant.notification
      },
      builder: (context, state) {
        if (state is NotificationSettingsLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is NotificationSettingsLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Notification'),
              backgroundColor: Colors.black,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'Network Request',
                    value: state.settings
                            .firstWhere((setting) =>
                                setting.key == "network_request_alert")
                            .userValue ==
                        'true',
                    onChanged: (value) => context
                        .read<NotificationSettingsBloc>()
                        .add(UpdateNotificationSettings(
                            emailAlert: (state.settings
                                        .firstWhere((setting) =>
                                            setting.key == "email_alert")
                                        .userValue) ==
                                    "true"
                                ? 1
                                : 0,
                            networkRequestAlert: value ? 1 : 0)),
                  ),
                  _buildSwitchTile(
                    title: 'Email Alert',
                    value: state.settings
                            .firstWhere(
                                (setting) => setting.key == "email_alert")
                            .userValue ==
                        'true',
                    onChanged: (value) => context
                        .read<NotificationSettingsBloc>()
                        .add(UpdateNotificationSettings(
                            networkRequestAlert: (state.settings
                                        .firstWhere((setting) =>
                                            setting.key ==
                                            "network_request_alert")
                                        .userValue) ==
                                    "true"
                                ? 1
                                : 0,
                            emailAlert: value ? 1 : 0)),
                  ),
                  SizedBox(
                    height: 500.h,
                  ),
                  Center(
                    child: PillButton(
                      backgroundColor: Colors.blue,
                      borderColor: Colors.transparent,
                      width: 400,
                      height: 50,
                      onTap: () {
                        // Handle button press
                      },
                      child: Text(
                        'Update Account',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is NotificationSettingsError) {
          return Scaffold(
              appBar: AppBar(title: Text('Notification')),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text(state.message)),
              ));
        }
        return Container(); // Placeholder widget for other states, you can replace this with your own widget or stuf
      },
    );
  }
}

Widget _buildSwitchTile(
    {required String title,
    required bool value,
    required Function(bool) onChanged}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        Switch(value: value, onChanged: onChanged),
      ],
    ),
  );
}
