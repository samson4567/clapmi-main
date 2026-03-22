import 'dart:convert';

import 'package:clapmi/features/app/data/models/user_model.dart';
import 'package:clapmi/features/brag/data/models/brag_challengers.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/fancy_text.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/generalSearchPage/general_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

//I AM PICKING THE MYSELF AS THE HOST SINCE MY POST IS BEING CHALLENGED
//I AM ALSO GETTING THE DETAILS OF THE CHALLENGER FROM THE BACKEND WHO IS
//THE USER CHALLENGING MY POST
class PostChallengeNotificationListBottom extends StatefulWidget {
  final String postId;
  final ProfileModel? host;
  final bool isStandard;
  const PostChallengeNotificationListBottom(
      {super.key,
      required this.postId,
      required this.host,
      required this.isStandard});

  @override
  State<PostChallengeNotificationListBottom> createState() =>
      _PostChallengeNotificationListBottomState();
}

class _PostChallengeNotificationListBottomState
    extends State<PostChallengeNotificationListBottom> {
  List<BragChallengersModel?> challengers = [];

  @override
  void initState() {
    context.read<BragBloc>().add(BragChallengersEvent(
          postId: widget.postId,
          contextType: widget.isStandard ? "standard" : "live",
          status: "pending",
          list: "recent",
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomSheet(
        onClosing: () {},
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.6, // limit height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FancyText(
                      "Brag Challengers",
                      size: 20,
                      weight: FontWeight.w600,
                    ),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              // Content area - challengers list or loading/error
              Expanded(
                child: BlocBuilder<BragBloc, BragState>(
                  builder: (context, state) {
                    if (state is SingleBragChallengersLoadingState) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ));
                    } else if (state is BragChallengersErrorState) {
                      return Center(
                        child: Text(
                          state.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is BragChallengersSuccessState) {
                      challengers = state.challengers;
                      print('THIS IS THE CHALLENGER STSTAES $challengers');

                      if (challengers.isEmpty) {
                        return const Center(
                            child: Text("No challengers found."));
                      }

                      return ListView.builder(
                        itemCount: challengers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: InkWell(
                              onTap: () {
                                print(
                                    "Getting the challengeId from the list is ${challengers[index]?.challenger.imageConvert}");
                                if (challengers[index]?.status == 'PENDING') {
                                  context.pop();
                                  context.pushNamed(
                                    MyAppRouteConstant
                                        .upcomingChallengeDetailPage,
                                    extra: {
                                      "host": widget.host,
                                      "challenge": challengers[index],
                                      "postId": widget.postId,
                                    },
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: Image.asset(
                                      "assets/icons/Live Combo.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: challengers[index]!
                                                  .challenger
                                                  .imageConvert !=
                                              null
                                          ? Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: MemoryImage(
                                                          challengers[index]!
                                                              .challenger
                                                              .imageConvert!))),
                                            )
                                          : CustomImageView(
                                              imagePath: challengers[index]!
                                                  .challenger
                                                  .image),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FancyText(
                                          "@${challengers[index]?.challenger.username}",
                                          size: 14,
                                          weight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 2),
                                        FancyText(
                                          "has challenged your brag",
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    "${challengers[index]?.status}",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      // Default state if none matched
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeButton extends StatefulWidget {
  String? text;
  Function()? action;
  double? height;
  double? width;
  double? radius;
  Widget? child;
  Color? color;
  ThemeButton(
      {super.key,
      this.text,
      this.action,
      this.color,
      this.height,
      this.width,
      this.radius,
      this.child});

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: widget.width ?? 115,
      height: widget.height ?? 40,
      decoration: BoxDecoration(
          color: widget.color ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(widget.radius ?? 20)),
      alignment: Alignment.center,
      child: widget.child ??
          Text(
            widget.text ?? '',
            style: const TextStyle(fontSize: 13),
          ),
    );
  }
}

class ChallengeRequestModel {
  final int? wierdID;
  final String? challengerID;
  final String? challengeeID;

  final String? postID;
  final String? bragID;

  final bool? isPostChallenge;
  final bool? isAccepted;

  ChallengeRequestModel({
    required this.wierdID,
    required this.challengerID,
    required this.postID,
    required this.bragID,
    required this.isPostChallenge,
    required this.challengeeID,
    this.isAccepted,
  });

  ChallengeRequestModel copyWith(
      {int? wierdID,
      String? challengerID,
      String? challengeeID,
      String? psotID,
      String? bragID,
      bool? isPostChallenge,
      bool? isAccepted}) {
    return ChallengeRequestModel(
      wierdID: wierdID ?? this.wierdID,
      bragID: bragID ?? this.bragID,
      challengerID: challengerID ?? this.challengerID,
      isPostChallenge: isPostChallenge ?? this.isPostChallenge,
      postID: psotID ?? postID,
      isAccepted: isAccepted ?? this.isAccepted,
      challengeeID: challengeeID ?? this.challengeeID,
    );
  }

  factory ChallengeRequestModel.fromSqlitejson(Map json) {
    return ChallengeRequestModel(
      wierdID: json['wierdID'],
      isPostChallenge: convertIntToBool(json['isPostChallenge'] ?? 0),
      isAccepted: convertIntToBool(json['isAccepted'] ?? 0),
      challengerID: json['challengerID'],
      bragID: json['bragID'],
      postID: json['postID'],
      challengeeID: json['challengeeID'],
    );
  }

  factory ChallengeRequestModel.fromOnlinejson(Map json) {
    return ChallengeRequestModel(
      wierdID: json['id'],
      bragID: json['bragID'],
      challengerID: json['challengerID'],
      challengeeID: json['challengeeID'],
      isPostChallenge: json['isPostChallenge'],
      isAccepted: json['isAccepted'],
      postID: json['postID'],
    );
  }

  Map toOnlineMap() {
    return {
      'id': wierdID,
      'bragID': bragID,
      'challengerID': challengerID,
      'challengeeID': challengeeID,
      'isPostChallenge': isPostChallenge,
      'isAccepted': isAccepted,
      'postID': postID,
    };
  }

  Map toSqliteMap() {
    return {
      'wierdID': wierdID,
      'bragID': jsonEncode(bragID),
      'challengerID': jsonEncode(challengerID),
      'challengeeID': jsonEncode(challengeeID),
      'isPostChallenge': (isPostChallenge ?? false) ? 1 : 0,
      'isAccepted': (isAccepted ?? false) ? 1 : 0,
      'postID': jsonEncode(postID),
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toOnlineMap()}";
  }
}
