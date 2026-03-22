import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/challenge_box.dart';
import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/Models/live_stream_model.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/notification/domain/entities/notification_entity.dart';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_bloc.dart';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_event.dart';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_state.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/features/notification/data/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // List<NotificationModel> displayedNotification = [];

  @override
  void initState() {
    context.read<NotificationBloc>().add(const GetNotificationListEvent());
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<NotificationBloc>().add(MarkAllNotificationAsReadEvent());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.cancel_outlined)),
        //q
        actions: !(listOfNotificationEntityG!.isEmpty)
            ? []
            : [
                FancyContainer(
                  radius: 30,
                  backgroundColor: Colors.green,
                  nulledAlign: true,
                  action: () {
                    context
                        .read<NotificationBloc>()
                        .add(MarkAllNotificationAsReadEvent());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    child: Text("Read All"),
                  ),
                ),
                SizedBox(width: 10),
                FancyContainer(
                  radius: 30,
                  backgroundColor: Colors.red,
                  nulledAlign: true,
                  action: () {
                    context
                        .read<NotificationBloc>()
                        .add(ClearAllNotificationsEvent());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    child: Text("Clear All"),
                  ),
                ),
              ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
        if (state is MarkNotificationAsReadSuccessState) {
          context
              .read<NotificationBloc>()
              .add(const GetNotificationListEvent());
        }
        if (state is MarkNotificationAsReadErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(generalSnackBar(state.errorMessage));
        }
      }, builder: (context, state) {
        return listOfNotificationEntityG!.isEmpty
            ? Center(
                child: buildEmptyWidget("No Notification Yet"),
              )
            : SingleChildScrollView(
                child: Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    ...listOfNotificationEntityG!.map(
                      (notificationEntity) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: FancyContainer(
                            hasBorder: true,
                            backgroundColor: getFigmaColor("0C0D0D"),
                            radius: 10,
                            child: ListTile(
                              onTap: () {
                                context.read<NotificationBloc>().add(
                                    MarkNotificationAsReadEvent(
                                        notificationID:
                                            notificationEntity.id ?? ''));
                                if (notificationEntity.notificationType ==
                                    NotificationType.POST) {
                                  context.goNamed(MyAppRouteConstant.postScreen,
                                      extra: notificationEntity.data!['post']);
                                }
                              },
                              leading: Image.asset(
                                "assets/icons/Live Combo.png",
                                height: 36,
                                width: 36,
                              ),
                              subtitle: Text(
                                notificationEntity.body ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    //getFigmaColor("646565"),
                                    fontSize: 15),
                              ),
                              trailing: _buildTrailingWidget(
                                NotificationModel.fromEntity(
                                  notificationEntity,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ));
      }),
    );
  }

  Widget? _buildTrailingWidget(NotificationModel notificationModel) {
    Widget? result;
    switch (notificationModel.notificationType) {
      case NotificationType.CHALLENGE_REQUEST:
        result = PillButton(
          child: Text("Respond"),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => ChallengeRequestBottomSheet(
                  notificationModel: notificationModel),
            );
          },
        );

        break;
      case NotificationType.CHALLENGE_REQUEST_ANSWER:
        result = PillButton(
          child: Text("View"),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => ChallengeRequestAnswerBottomSheet(
                  notificationModel: notificationModel),
            );
          },
        );

        break;
      case NotificationType.LIVE:
        LiveStreamModel liveStreamModel = LiveStreamModel.fromOnlinejson(
            notificationModel.data?['model'] ?? {});
        result = PillButton(
          child: Text("Go Live"),
          onTap: () {
            context.pushNamed(
              MyAppRouteConstant.liveComboTwoImageScreen,
              extra: {
                "otherParticipant": UserModel.empty().id,
                "starterOpenedIt": false,
                "streamerOpenedIt": false,
                "comboModel": null,
              },
            );
          },
        );

        break;
      default:
    }
    return result;
  }
}

class ChallengeRequestBottomSheet extends StatelessWidget {
  final NotificationModel notificationModel;

  const ChallengeRequestBottomSheet({
    super.key,
    required this.notificationModel,
  });

  @override
  Widget build(BuildContext context) {
    ChallengeRequestModel challengeRequestModel =
        ChallengeRequestModel.fromOnlinejson(
            notificationModel.data?["model"] ?? {});
    UserModel? challenger;

    return FutureBuilder<Object?>(
        future: () async {
          return "done";
        }.call(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const ChallengImage(),
                  Text(
                      "Your brag has been challenged by @${challenger!.username ?? challenger.name}"),
                  PillButton(
                    isAsync: true,
                    width: 150,
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                          generalSnackBar(
                              "Challenge has been accepted successfully"));
                      context.pop();
                    },
                    child: Text("Accept"),
                  ),
                  FancyContainer(
                    isAsync: true,
                    action: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        generalSnackBar(
                          "Challenge has been Rejected",
                        ),
                      );
                      context.pop();
                    },
                    backgroundColor: Colors.transparent,
                    child: Text("Reject"),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("An error has occured \n ${snapshot.error}"),
            );
          }
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        });
  }
}

class ChallengeRequestAnswerBottomSheet extends StatelessWidget {
  final NotificationModel notificationModel;

  const ChallengeRequestAnswerBottomSheet({
    super.key,
    required this.notificationModel,
  });

  @override
  Widget build(BuildContext context) {
    ChallengeRequestModel challengeRequestModel =
        ChallengeRequestModel.fromOnlinejson(
            notificationModel.data?["model"] ?? {});
    UserModel? challenger;
    UserModel? challengee;
    BragModel? bragModel;

    return FutureBuilder<Object?>(
        future: () async {
          return "done";
        }.call(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const ChallengImage(),
                  Text(
                      "Your brag has been challenged by @${challenger!.username}"),
                  PillButton(
                    isAsync: true,
                    width: 150,
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                          generalSnackBar("CHallenge scheduled successfully"));
                    },
                    child: Text("Schedule"),
                  ),
                  FancyContainer(
                    isAsync: true,
                    action: () async {
                      context.pop();

                      context.pushNamed(MyAppRouteConstant.chatPage,
                          extra: {"user": challenger});
                    },
                    backgroundColor: Colors.transparent,
                    child: Text("Chat"),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("An error has occured \n ${snapshot.error}"),
            );
          }
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        });
  }
}
