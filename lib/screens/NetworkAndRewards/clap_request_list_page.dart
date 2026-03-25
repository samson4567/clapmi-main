import 'package:clapmi/features/chats_and_socials/data/models/clap_request_model.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/screens/NetworkAndRewards/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ClapRequestListPage extends StatefulWidget {
  const ClapRequestListPage({super.key});

  @override
  State<ClapRequestListPage> createState() => _ClapRequestListPageState();
}

class _ClapRequestListPageState extends State<ClapRequestListPage> {
  List<ClapRequestModel> displayedList = [];

  @override
  void initState() {
    super.initState();
    context.read<ChatsAndSocialsBloc>().add(GetClapRequestEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buildBackArrow(context),
        title: const Text(
          'Clap Request',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
        listener: (context, state) {
          if (state is GetClapRequestSuccessState) {
            setState(() {
              displayedList = state.listOfClapRequest;
            });
          }
          if (state is GetClapRequestErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(generalSnackBar(state.errorMessage));
          }
        },
        builder: (context, state) {
          if (state is GetClapRequestLoadingState) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 16,
                                width: double.infinity,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 12,
                                width: 100,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          if (displayedList.isEmpty) {
            return const Center(
              child: Text(
                "No clap requests yet",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...displayedList.map(
                  (request) => ProfileCard(
                    requestModel: request,
                    acceptRequestCallback: (id) {
                      setState(() {
                        displayedList.removeWhere((e) => e.id == id);
                      });
                    },
                    declineRequestCallback: (id) {
                      setState(() {
                        displayedList.removeWhere((e) => e.id == id);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}
