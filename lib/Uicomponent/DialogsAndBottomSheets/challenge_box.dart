import 'dart:convert';
import 'dart:typed_data';
import 'package:clapmi/features/app/data/models/user_model.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_state.dart';
import 'package:clapmi/features/combo/domain/entities/challenge_request_entity.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/feed/widget/challenge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChallengeBox extends StatefulWidget {
  //final SingleVdideoPostModel host;
  final String postId;
  final bool isPostChallenge;
  final ProfileModel? challenger;
  final String challengeId;

  const ChallengeBox({
    super.key,
    // required this.host,
    required this.postId,
    required this.isPostChallenge,
    required this.challenger,
    required this.challengeId,
  });

  @override
  State<ChallengeBox> createState() => _ChallengeBoxState();
}

class _ChallengeBoxState extends State<ChallengeBox> {
  String hostName = '';
  String hostAvatar = '';
  Uint8List? hostImageAvatar;
  bool isLoading = false;

  @override
  void initState() {
    context.read<BragBloc>().add(GetSingleBragEvent(widget.postId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BragBloc, BragState>(
      listener: (context, state) {
        if (state is SingleBragChallengersLoadingState) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is SingleBragState) {
          hostName = state.post.creator_name ?? '';
          hostAvatar = state.post.creator_image ?? '';
          hostImageAvatar = state.post.image;

          print("--------------uuuuuuu ${state.post.image}----");
          setState(() {
            isLoading = false;
          });
        }
        if (state is ChallengePostLoadingState) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is ChallengePostErrorState) {
          setState(() {
            isLoading = false;
          });
          context.pop();
          challengDialogErrorBox(context);
        }
        if (state is ChallengePostSuccessState) {
          setState(() {
            isLoading = false;
          });

          ChallengeRequestEntity challengeRequestEntity =
              ChallengeRequestEntity(
                  challengerAvatar: widget.challenger?.image,
                  challengerName: widget.challenger?.username,
                  challengerImageAvatar: widget.challenger?.myAvatar,
                  hostName: hostName,
                  hostAvatar: hostAvatar,
                  hostImageAvatar: hostImageAvatar);
          context.pop();

          context
              .push(MyAppRouteConstant.startChallengNowChalengerPage, extra: {
            'challengeRequestEntity': challengeRequestEntity,
            'challengeId': state.challengeId,
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const ChallengImage(),
            const Text("Confirm that you want to challenge this brag"),
            PillButton(
              width: 150,
              onTap: () async {
                //  context.pop();
                if (widget.isPostChallenge) {
                  ChallengeRequestEntity challengeRequestEntity =
                      ChallengeRequestEntity(
                          challengerAvatar: widget.challenger?.image,
                          challengerName: widget.challenger?.username,
                          challengerImageAvatar: widget.challenger?.myAvatar,
                          hostName: hostName,
                          hostAvatar: hostAvatar,
                          hostImageAvatar: hostImageAvatar);

                  context.pop();

                  context.push(MyAppRouteConstant.startChallengNowChalengerPage,
                      extra: {
                        'challengeRequestEntity': challengeRequestEntity,
                        'challengeId': widget.challengeId,
                      });
                } else {
                  context
                      .read<BragBloc>()
                      .add(ChallengePostEvent(postID: widget.postId));
                }
              },
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      "Challenge ${(widget.isPostChallenge) ? 'post' : 'brag'}"),
            ),
            FancyContainer(
              action: () {
                rootNavigatorKey.currentState!.context.pop();
              },
              backgroundColor: Colors.transparent,
              child: Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengImage extends StatelessWidget {
  const ChallengImage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Image.asset(
                    "assets/images/boxing_glove.png",
                    height: 45,
                    width: 45,
                  ),
                  const SizedBox(width: 50),
                  Image.asset(
                    "assets/images/boxing_glove-1.png",
                    height: 45,
                    width: 45,
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

//

class ThemeButton extends StatefulWidget {
  String? text;
  Function()? action;
  double? height;
  double? width;
  double? radius;
  Widget? child;
  Color? color;
  Color? borderColor;
  ThemeButton({
    super.key,
    this.text,
    this.action,
    this.color,
    this.height,
    this.width,
    this.radius,
    this.borderColor,
    this.child,
  });

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
          border:
              Border.all(width: 1, color: widget.borderColor ?? Colors.black),
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
