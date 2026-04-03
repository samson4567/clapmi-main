import 'package:clapmi/features/chats_and_socials/data/models/clap_request_model.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/NetworkAndRewards/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class MyNetworkPage extends StatefulWidget {
  const MyNetworkPage({super.key});

  @override
  State<MyNetworkPage> createState() => _MyNetworkPageState();
}

class _MyNetworkPageState extends State<MyNetworkPage> {
  List<ClapRequestModel> listClapRequestModel = [];
  List<ChatUser> friends = [];
  bool isLoading = true;
  List<ChatUserData> chatFriends = [];
  @override
  void initState() {
    super.initState();
    final chatsBloc = context.read<ChatsAndSocialsBloc>();
    friends = List<ChatUser>.from(chatsBloc.clappers);
    listClapRequestModel = [];
    chatFriends = List<ChatUserData>.from(chatsBloc.chatFriends);
    if (friends.isNotEmpty && chatFriends.isNotEmpty) {
      friends = friends
          .where(
            (element) => !chatFriends.any(
              (ele) => element.pid == ele.user?.pid,
            ),
          )
          .toList();
    }
    isLoading = friends.isEmpty;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!chatsBloc.isClappersFresh) {
        chatsBloc.add(
          GetClappersEvent(
            refreshInBackground: chatsBloc.hasClappers,
          ),
        );
      } else if (!chatsBloc.isChatFriendsFresh) {
        chatsBloc.add(
          GetChatFriendsEvent(
            refreshInBackground: chatsBloc.hasChatFriends,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
      listener: (context, state) {
        if (state is ClappersLoaded) {
          final chatsBloc = context.read<ChatsAndSocialsBloc>();
          chatsBloc.add(
            GetChatFriendsEvent(
              refreshInBackground: chatsBloc.hasChatFriends,
            ),
          );
          setState(() {
            friends = state.friends;
          });
        }
        if (state is ClappersLoading) {
          if (friends.isEmpty) {
            setState(() {
              isLoading = true;
            });
          }
        }
        if (state is ChatFriendsLoaded) {
          chatFriends = state.chatFriends;
          friends = friends
              .where(
                (element) => !chatFriends.any(
                  (ele) => element.pid == ele.user?.pid,
                ),
              )
              .toList();
          setState(() => isLoading = false);
        }

        if (state is GetFriendLoadingState) {
          if (friends.isEmpty) {
            setState(() => isLoading = true);
          }
        }
        if (state is GetFriendErrorState) {
          if (mounted) {
            setState(() => isLoading = false);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Row(
              children: [
                const Flexible(
                  child: Text(
                    "My Network",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    " (${friends.length} Clapped)",
                    style: TextStyle(
                      fontSize: 14, // reduced slightly from 16
                      fontWeight: FontWeight.w600,
                      color: fadedTextStyle.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.pop();
                  // context.read<ChatsAndSocialsBloc>().add(GetClappersEvent());
                },
                icon: const Icon(Icons.cancel_outlined),
              )
            ],
          ),
          body: isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[700]!,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  ),
                )
              : (friends.isNotEmpty)
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return GestureDetector(
                          onTap: () {
                            // context.pushNamed(MyAppRouteConstant.chatPage,
                            //     extra: {"user": friend});
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ProfileCardForUserVeiw2(
                              person: friend,
                              onActionTaken: () {
                                debugPrint(
                                    '🔍 Navigating to chat with user: $friend, pid: ${friend.pid}');
                                context.pushNamed(
                                  MyAppRouteConstant.chatPage,
                                  extra: {'newUser': friend},
                                );
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : const EmptyNetworkListWidget(),
          floatingActionButton: FloatingActionButton(
            heroTag: Object(),
            onPressed: () {
              try {
                context.pushNamed(MyAppRouteConstant.networkConnect);
              } catch (e) {
                Navigator.of(context).popUntil(
                  (route) =>
                      route.settings.name == MyAppRouteConstant.networkConnect,
                );
                context.pop();
                context.pushNamed(MyAppRouteConstant.networkConnect);
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class EmptyNetworkListWidget extends StatelessWidget {
  const EmptyNetworkListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/tt.png'),
            const SizedBox(height: 16),
            const Text(
              "You currently have no request!",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: Color(0xFF8F9090)),
            ),
            SizedBox(height: 60.h),
            PillButton(
              onTap: () {
                context.pushNamed(MyAppRouteConstant.networkConnect);
              },
              child: const Text("Connect to other people"),
            )
          ],
        ),
      ),
    );
  }
}
