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

  @override
  void initState() {
    context.read<ChatsAndSocialsBloc>().add(GetPeopleNearLocationEvent());
    super.initState();
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
              displayedList = state.users;
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(children: [
                    ...displayedList.map(
                      (e) {
                        return ProfileCardForUserVeiw(
                          person: e,
                          onActionTaken: () {
                            setState(() {});
                          },
                        );
                      },
                    ),
                    SizedBox(height: 50)
                  ]),
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
