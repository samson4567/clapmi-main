import 'dart:math';
import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/utils.dart';
import 'package:clapmi/features/post/data/models/avatar_model.dart';
import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChallengeBragPage extends StatefulWidget {
  final CreatePostModel? postModel;
  final BragModel? bragModel;

  const ChallengeBragPage({super.key, this.postModel, this.bragModel});

  @override
  State<ChallengeBragPage> createState() => _ChallengeBragPageState();
}

class _ChallengeBragPageState extends State<ChallengeBragPage> {
  final TextEditingController _comboTitleController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _durationDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            try {
              context.pop();
            } catch (e) {
              context.go(MyAppRouteConstant.feedScreen);
            }
          },
          icon: const Icon(Icons.cancel_outlined),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text("Scheduling Accepted Brag"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Combo title",
                  style: fadedTextStyle,
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.withAlpha(50),
                  ),
                  child: TextField(
                    controller: _comboTitleController,
                    decoration: InputDecoration(
                      hintText: "E.g; Apple vs Samsung",
                      hintStyle: fadedTextStyle.copyWith(
                          color: getFigmaColor("464747")),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Start Date",
                  style: fadedTextStyle,
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.withAlpha(50),
                  ),
                  child: TextField(
                    controller: _startDateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? selectedStartDate = await pickDateTime(context);
                      if (selectedStartDate != null) {
                        _startDateController.text =
                            selectedStartDate.toString();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "2/11/2024",
                      hintStyle: fadedTextStyle.copyWith(
                          color: getFigmaColor("464747")),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Live Duration",
                  style: fadedTextStyle,
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.withAlpha(50),
                  ),
                  child: TextField(
                    controller: _durationDateController,
                    decoration: InputDecoration(
                      hintText: "in minutes",
                      hintStyle: fadedTextStyle.copyWith(
                          color: getFigmaColor("464747")),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
            //
            const SizedBox(height: 20),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: getFigmaColor("0D0E0E"),
                border: Border.all(
                  color: getFigmaColor("181919"),
                ),
              ),
              child: _buildChallengeImage(),
            ),
            const SizedBox(height: 40),
            BlocConsumer<PostBloc, PostState>(listener: (context, state) {
              if (state is CreateComboErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  generalErrorSnackBar(state.errorMessage),
                );
              }
              if (state is ChallengePostErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  generalErrorSnackBar(state.errorMessage),
                );
              }
              if (state is ChallengePostSuccessState) {
                // TODO: INCOMPLETE
                AvatarModel hostAvatarModel = listOfAvatarModelG[
                    Random().nextInt(listOfAvatarModelG.length)];
                AvatarModel challengerAvatarModel = listOfAvatarModelG[
                    Random().nextInt(listOfAvatarModelG.length)];
                while (challengerAvatarModel == hostAvatarModel) {
                  challengerAvatarModel = listOfAvatarModelG[
                      Random().nextInt(listOfAvatarModelG.length)];
                }

                CreateComboModel comboModel = CreateComboModel.fromOnlinejson(
                  {
                    "challenge":
                        widget.postModel?.uuid ?? widget.bragModel!.pid!,
                    "title": _comboTitleController.text,
                    "start-time": _startDateController.text,
                    "duration": "${_durationDateController.text} minutes",
                    "avatars[host]": hostAvatarModel.avatar,
                    "avatars[challenger]": challengerAvatarModel.avatar
                  },
                );
                context
                    .read<PostBloc>()
                    .add(CreateComboEvent(comboModel: comboModel));
              }

              if (state is CreateComboSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  generalSnackBar("post challenged successfully"),
                );
                context.goNamed(MyAppRouteConstant.feedScreen);
              }
            }, builder: (context, state) {
              return (state is ChallengePostLoadingState ||
                      state is CreateComboLoadingState)
                  ? const CircularProgressIndicator()
                  : FancyContainer(
                      action: () {
                        print("dsjdajbdkjsbadksajdbaskjb ${[
                          widget.postModel,
                          widget.bragModel?.pid
                        ]}");

                        context.read<PostBloc>().add(ChallengePostEvent(
                            postID: widget.postModel?.uuid ??
                                widget.bragModel!.pid!));
                      },
                      width: double.infinity,
                      height: 45,
                      radius: 50,
                      backgroundColor: AppColors.primaryColor,
                      child: Text("Done"),
                    );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeImage() {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Center(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/Frame 1000002049.png",
                        height: 45,
                        width: 45,
                      ),
                      const SizedBox(height: 5),
                      const Text("Rachel iikay")
                    ],
                  ),
                  const SizedBox(width: 50),
                  const Text(
                    "VS",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/Frame 1000002049.png",
                        height: 45,
                        width: 45,
                      ),
                      const SizedBox(height: 5),
                      const Text("Rachel iikay")
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/Group 48095618.png",
                  height: 110,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                ),
                Image.asset(
                  "assets/images/Group 48095616.png",
                  height: 110,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
