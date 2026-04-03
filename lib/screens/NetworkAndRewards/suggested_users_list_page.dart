import 'package:clapmi/features/chats_and_socials/data/models/user_model.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/screens/NetworkAndRewards/network.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';

class SuggestedUsersListPage extends StatefulWidget {
  const SuggestedUsersListPage({
    super.key,
  });

  @override
  State<SuggestedUsersListPage> createState() => _SuggestedUsersListPageState();
}

class _SuggestedUsersListPageState extends State<SuggestedUsersListPage> {
  List<UserNearLocationEntity> displayedList = [];
  Set<String> _alreadyClappedPids = <String>{};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final chatsBloc = context.read<ChatsAndSocialsBloc>();
    displayedList = List<UserNearLocationEntity>.from(chatsBloc.nearbyUsers);
    _alreadyClappedPids = Set<String>.from(NetworkViewCache.alreadyClappedPids);
    _isLoading = displayedList.isEmpty;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!chatsBloc.isNearbyUsersFresh) {
        chatsBloc.add(
          GetPeopleNearLocationEvent(
            refreshInBackground: chatsBloc.hasNearbyUsers,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //  displayedList = List.filled(4, UserModel.empty());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: buildBackArrow(context),
          title: Text(
            'Suggested Users',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
          listener: (context, state) {
            if (state is UserNearLocationLoaded) {
              setState(() {
                displayedList = state.users;
                _isLoading = false;
              });
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_isLoading && displayedList.isEmpty)
                        ...List.generate(
                          4,
                          (_) => Container(
                            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF181919),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2A2A2A),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2A2A2A),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 12,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2A2A2A),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...displayedList.map(
                          (e) {
                            return ProfileCardForUserVeiw(
                              person: e,
                              isAlreadyClapped:
                                  _alreadyClappedPids.contains(e.pid),
                              onActionTaken: () {
                                final pid = e.pid;
                                if (pid == null || pid.isEmpty) {
                                  return;
                                }
                                setState(() {
                                  _alreadyClappedPids = {
                                    ..._alreadyClappedPids,
                                    pid,
                                  };
                                  NetworkViewCache.alreadyClappedPids =
                                      Set<String>.from(_alreadyClappedPids);
                                });
                              },
                            );
                          },
                        ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    color: AppColors.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PillButton(
                            width: 100,
                            isAsync: true,
                            onTap: () async {
                              setState(() {});
                            },
                            child: Text("previous"),
                          ),
                          PillButton(
                            width: 100,
                            isAsync: true,
                            onTap: () async {
                              setState(() {});
                            },
                            child: Text("next"),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
