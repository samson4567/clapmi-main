import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_event.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_state.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/extraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class OthersAccountPage extends StatefulWidget {
  final String userId;
  const OthersAccountPage({super.key, required this.userId});

  @override
  State<OthersAccountPage> createState() => _OthersAccountPageState();
}

class _OthersAccountPageState extends State<OthersAccountPage> {
  bool showCategories = false;
  List socials = [];
  UserModel? _userModel;
  List<PostModel> usersPost = [];
  List<PostModel> videoPost = [];
  bool? clappedOrNot;
  bool displayPost = true;
  bool displayBrag = false;
  bool clapButtonLoading = false;

  @override
  void initState() {
    super.initState();
    // Dispatch event to fetch user profile
    context.read<AppBloc>().add(GetUserProfileEvent(userId: widget.userId));
    context.read<PostBloc>().add(GetUserPostsEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<ChatsAndSocialsBloc, ChatsAndSocialsState>(
          listener: (context, state) {
            if (state is SendClapRequestToUsersLoadingState) {
              setState(() {
                clapButtonLoading = true;
              });
            }
            if (state is SendClapRequestToUsersSuccessState) {
              setState(() {
                clappedOrNot = true;
                clapButtonLoading = false;
              });
            }
            if (state is SendClapRequestToUsersErrorState) {
              setState(() {
                clapButtonLoading = false;
              });
            }
          },
          child: MultiBlocListener(
            listeners: [
              BlocListener<ChatsAndSocialsBloc, ChatsAndSocialsState>(
                listener: (context, state) {
                  print("bhdbsjdbsajbdksbdkbskd-stateNi-$state");

                  if (state is ConversationInitiated) {
                    //  _userModel = state.conversationId as UserModel?;
                    ChatUser friend = ChatUser(
                      pid: _userModel!.pid!,
                      username: _userModel?.username,
                      image: _userModel?.image,
                      email: _userModel?.email,
                      name: _userModel?.name,
                      occupation: _userModel?.occupation,
                    );
                    debugPrint('🔍 Initiating conversation with user: $friend');
                    context.pushNamed(
                      MyAppRouteConstant.chatPage,
                      extra: {'newUser': friend},
                    );
                  } else if (state is ConversationInitiatedFail) {
                    print("bhdbsjdbsajbdksbdkbskd");
                    context
                        .read<ChatsAndSocialsBloc>()
                        .add(GetChatFriendsEvent());
                  }
                  if (state is ChatFriendsLoaded) {
                    // chatFriends = state.chatFriends;
                    // setState(() => isLoading = false);
                    final friend = state.chatFriends.where(
                      (element) {
                        return element.user?.pid == _userModel!.pid!;
                      },
                    ).firstOrNull;
                    if (friend != null) {
                      context.pushNamed(
                        MyAppRouteConstant.chatPage,
                        extra: {'user': friend},
                      );
                    }
                  }
                },
              )
            ],
            child: BlocConsumer<AppBloc, AppState>(
              listener: (context, state) {
                if (state is GetUserProfileSuccess) {
                  _userModel = state.userProfile as UserModel?;
                } else if (state is GetUserProfileError) {
                  // Optionally show a snackbar or dialog on error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Error fetching profile: ${state.errorMessage}')),
                  );
                }
              },
              builder: (context, state) {
                if (state is GetUserProfileLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[700]!,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          // Banner placeholder
                          Container(
                            height: 200.h,
                            color: Colors.white,
                          ),
                          SizedBox(height: 60.h),
                          // Username placeholder
                          Container(
                            height: 20.h,
                            width: 150.w,
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            color: Colors.white,
                          ),
                          SizedBox(height: 8.h),
                          // Bio placeholder
                          Container(
                            height: 16.h,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            color: Colors.white,
                          ),
                          SizedBox(height: 24.h),
                          // Stats row placeholder
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              3,
                              (index) => Container(
                                height: 40.h,
                                width: 60.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is GetUserProfileError) {
                  return Center(
                      child: Text(
                          'Failed to load profile: ${state.errorMessage}'));
                } else if (_userModel != null) {
                  // Build UI using _userModel
                  return Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: _userModel!.banner ?? '',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: 120.h,
                        errorWidget: (context, url, error) {
                          return Container(
                            decoration:
                                BoxDecoration(color: getFigmaColor("006FCD")),
                          );
                        },
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.w, top: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                  height: 110
                                      .h), // Space for banner and profile pic overlap
                              Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.0.h),
                                color: AppColors.backgroundColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15),
                                    //THIS IS THE PROFILE IMAGE

                                    // Match profile pic height
                                    Row(
                                      children: [
                                        // Match profile pic height
                                        Container(
                                          height: 40.w,
                                          width: 40.w,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: CustomImageView(
                                            imagePath: _userModel!.image,
                                            height: double.infinity,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorWidget: const Icon(
                                                Icons.person,
                                                size: 40),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                _userModel?.name ??
                                                    "Name not provided",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        getFigmaColor("FFFFFF"),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 13),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _userModel!.occupation ??
                                                    "Occupation not provided",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Poppins',
                                                    color:
                                                        getFigmaColor("FFFFFF"),
                                                    fontSize: 13),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (_userModel!.verified ?? false)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                        "Verified",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 13),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Image.asset(
                                                        "assets/icons/Vector (11).png",
                                                        height:
                                                            14, // Adjust size as needed
                                                        width: 14,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        // ** THIS IS THE MESSAGE ICON BESIDE THE CLAP REQUEST BUTTON*/

                                        if (_userModel?.isFriend ?? false)
                                          GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<ChatsAndSocialsBloc>()
                                                  .add(
                                                      InitiateConversationEvent(
                                                          userPid: _userModel!
                                                              .pid!));
                                            },
                                            child: SvgPicture.asset(
                                                "assets/images/message.svg"),
                                          ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        //**THIS IS THE CLAP REQUEST BUTTON WITH THE STATE CHANGE */
                                        ClappedButton(
                                          userModel: _userModel!,
                                          onTap: () {
                                            if (clappedOrNot == true ||
                                                _userModel?.isFriend == true) {
                                              // Already clapped, do nothing
                                              return;
                                            }
                                            context
                                                .read<ChatsAndSocialsBloc>()
                                                .add(
                                                    SendClapRequestToUsersEvent(
                                                        userPids:
                                                            _userModel?.pid ??
                                                                ''));
                                          },
                                          clappedOrNot: clappedOrNot ??
                                              _userModel?.isFriend ??
                                              false,
                                          clapButtonLoading: clapButtonLoading,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),
                                    Text(
                                      _userModel!.bio ?? "Bio not available",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    BlocConsumer<PostBloc, PostState>(
                                        listener: (context, state) {
                                      if (state is GetUserPostsSuccessState) {
                                        usersPost = state.posts
                                            .where((element) =>
                                                element.type != PostType.video)
                                            .toList();

                                        videoPost = state.posts
                                            .where((element) =>
                                                element.type == PostType.video)
                                            .toList();
                                        //we might need to differentiate between videos and normal post.
                                        print(
                                            '$videoPost--------------------------------------');
                                      }
                                    }, builder: (context, state) {
                                      return Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          _buildInterests([
                                            // interests unfetched
                                          ]),
                                          const SizedBox(height: 10),
                                          _buildSocials(
                                              socials), // Assuming socials are fetched elsewhere or part of userModel
                                          const SizedBox(height: 15),
                                          _buildStats(_userModel!),
                                          const SizedBox(height: 15),
                                          _buildPostBragToggle(),
                                          const SizedBox(height: 15),
                                          _buildContentSection(),
                                        ],
                                      );
                                    })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Initial state or unexpected state
                  return const Center(child: Text('Loading profile...'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildInterests(List<dynamic>? interests) {
    if (interests == null || interests.isEmpty) {
      return const SizedBox.shrink(); // Return empty space if no interests
    }
    return Row(
      children: List.generate(
        interests.length,
        (index) => Padding(
          padding: const EdgeInsets.only(
              right: 8.0), // Add spacing between interests
          child: Text(
            interests[index]["name"] ?? '',
            style: TextStyle(
                color: getFigmaColor(interests[index]["color"] ??
                    "FFFFFF"), // Provide default color
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSocials(List<dynamic> socials) {
    if (socials.isEmpty) {
      return const SizedBox.shrink();
    }
    return Visibility(
      visible: true, // Controlled by socials list emptiness check above
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Check me on:", style: fadedTextStyle),
          const SizedBox(height: 5),
          ...List.generate(
            socials.length,
            (index) {
              Object? url = socials[
                  index]; // Assuming socials contain URLs or identifiers
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.link, // Using a generic link icon
                      size: 20,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$url", // Display the social link/identifier
                      style: TextStyle(color: linkColor),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildStats(UserModel user) {
    return Row(
      children: [
        Row(
          children: [
            Text('${_userModel?.clapped.toString()}'),
            const SizedBox(width: 4),
            Text("Clapped", style: fadedTextStyle)
          ],
        ),
        const SizedBox(width: 25),
        Row(
          children: [
            // TODO: Replace with actual clappers count from user model when available
            Text('${_userModel?.clappers.toString()}'),
            const SizedBox(width: 4),
            Text("Clappers", style: fadedTextStyle)
          ],
        )
      ],
    );
  }

  Widget _buildPostBragToggle() {
    return Row(
      children: [
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: displayPost
                  ? WidgetStatePropertyAll(getFigmaColor("006FCD"))
                  : WidgetStatePropertyAll(getFigmaColor("181919")),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            ),
            onPressed: () {
              setState(() {
                displayPost = true;
                displayBrag = false;
              });
            },
            child: Text(
              "Posts",
              style: TextStyle(
                color: !displayPost ? getFigmaColor("006FCD") : Colors.white,
              ),
            )),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: displayBrag
                ? WidgetStatePropertyAll(getFigmaColor("006FCD"))
                : WidgetStatePropertyAll(getFigmaColor("181919")),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
          ),
          onPressed: () {
            setState(() {
              displayPost = false;
              displayBrag = true;
            });
          },
          child: Text(
            "Brags",
            style: TextStyle(
              color: !displayBrag ? getFigmaColor("006FCD") : Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    // TODO: Fetch actual posts and brags based on _userModel.pid
    if (displayBrag) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10,
        spacing: 10,
        children: List.generate(videoPost.length, (index) {
          BragModel bragModel = BragModel.fromPostModel(videoPost[index]);
          print('${bragModel.thumbnail} --- $index');
          //LIST OF THE VIDEO THUMBNAILS
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3 -
                    16, // Adjusted width
                child: AspectRatio(
                  aspectRatio: 96 / 135,
                  child: CustomImageView(
                    imagePath: bragModel.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          );
        }),
      );
    }
    return Column(
      children: List.generate(usersPost.length, (index) {
        return Column(
          children: [
            PostWidget(postModel: usersPost[index], authorId: ''),
            if (index < usersPost.length - 1)
              Divider(
                color: Colors.grey.withOpacity(0.3),
                thickness: 1,
                height: 20,
              ),
          ],
        );
      }),
    );
  }

  // Removed _buildTags as it's incorporated into _buildInterests

  int getGivenClaps(UserModel user) {
    // Safely access lists and calculate length
    int givenClaps = 0;
    // (user.fullDetails?["given_claps"] as List?)?.length ?? 0;
    int postGivenClaps = 0;
    // (user.fullDetails?["post_given_claps"] as List?)?.length ??

    return givenClaps + postGivenClaps;
  }
}

// --- Clapped Button Widget --- (Keep as is, but ensure userModel is passed correctly)

class ClappedButton extends StatefulWidget {
  final UserModel userModel;
  final bool clappedOrNot;
  final VoidCallback onTap;
  final bool clapButtonLoading;

  const ClappedButton({
    super.key,
    required this.userModel,
    required this.clappedOrNot,
    required this.onTap,
    required this.clapButtonLoading,
  });

  @override
  State<ClappedButton> createState() => _ClappedButtonState();
}

class _ClappedButtonState extends State<ClappedButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement actual clap/unclap logic using a Bloc/Repository
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 100,
        height: 36, // Reduced height slightly
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: widget.clappedOrNot
              ? Border.all(color: AppColors.primaryColor)
              : null,
          color: !widget.clappedOrNot
              ? AppColors.primaryColor
              : Colors.transparent,
        ),
        child: widget.clapButtonLoading
            ? CircularProgressIndicator.adaptive()
            : Text(
                widget.clappedOrNot ? "Clapped" : "Clap",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: !widget.clappedOrNot
                      ? Colors.white
                      : AppColors.primaryColor,
                ),
              ),
      ),
    );
  }
}
