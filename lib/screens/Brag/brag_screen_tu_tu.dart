import 'dart:io';
import 'dart:math';
import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/Brag/brag_detail_screen.dart';

import 'package:clapmi/screens/Brag/brag_screen_tu_controller.dart';
import 'package:clapmi/screens/Brag/brag_util.dart';
// import 'package:clapmi/screens/BragVideoErrorAttemptRepairBackupFolder/brag_util.dart';
import 'package:clapmi/screens/challenge/challenge_list.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/extraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class BragScreenTuTu extends StatefulWidget {
  const BragScreenTuTu({super.key});

  @override
  State<BragScreenTuTu> createState() => _BragScreenTuTuState();
}

class _BragScreenTuTuState extends State<BragScreenTuTu> {
  bool isthereInternet = true;
  StreamSubscription? internetSubscription;

  @override
  initState() {
    internetSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
        setState(() {
          isthereInternet = true;
        });
      } else {
        isthereInternet = false;
      }
    });

    super.initState();
    // context.read<ChatsAndSocialsBloc>().add(GetClappersEvent());
  }

  loadMoreIfItIsTime() {}

  bool loadingMore = false;
  List<ChatUser> friends = [];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VideoFeedProvider>();
    return BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
        listener: (context, state) {
      if (state is ClappersLoaded) {
        setState(() {
          friends = state.friends;
        });
      }
    }, builder: (context, _) {
      return BlocConsumer<PostBloc, PostState>(listener: (context, state) {
        if (state is GetAllVideoPostsLoadingState) {
          print("shdvhjdasdhvdvsahjdshd");
          loadingMore = true;
        } else {
          loadingMore = false;
        }
        if (state is GetAllVideoPostsSuccessState) {
          provider.theListOfBragModel.addAll(state.posts
              .map(
                (e) => BragModel.fromPostModel(e),
              )
              .toList());
          provider.pageNumber;
          // BragPageVideoIitialisationController()
          //     .changeDisplayedList(showFollowing, friends: friends);
          provider.pageNumber += 1;
        }

        if (state is GetAllVideoPostsErrorState) {}
      }, builder: (context, s) {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Builder(builder: (context) {
                    return (provider.theListOfBragModel.isEmpty)
                        ? Center(
                            child: Text(
                              "No Brags Yet",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : PageView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: provider.theListOfBragModel.length,
                            itemBuilder: (context, index) {
                              // final controller = provider.controllers[index];

                              // if (controller != null &&
                              //     controller.value.isInitialized) {
                              //   return VideoPlayer(controller);
                              return _buildBragWidget(index);
                              // }
                              // return Center(child: CircularProgressIndicator());
                            },
                            onPageChanged: (value) {
                              provider.updateIndex(
                                  value,
                                  provider.theListOfBragModel
                                      .where(
                                        (element) =>
                                            element.postVideoUrls?.isNotEmpty ??
                                            false,
                                      )
                                      .map(
                                        (e) => e.postVideoUrls!.first as String,
                                      )
                                      .toList());

                              loadMoreIfItIsTime();
                              setState(() {});
                            },
                          );
                  }),
                ),
                if (loadingMore)
                  Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
              ],
            ),
            _buildTopControls(),
            if (!isthereInternet)
              Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true,
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.black.withAlpha(150)),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "There is no Internet connection",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins'),
                          ),
                          Text(
                            "Reconnecting...",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],
        );
      });
    });
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 8,
      left: 0,
      right: 0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: AllFollowingCategoriesSelectorWidget(
            indexchangingFunction: (text) {
              showFollowing = text.toLowerCase().contains("follow");
              // BragPageVideoIitialisationController()
              //     .changeDisplayedList(showFollowing, friends: friends);
              if (mounted) setState(() {});
            },
          ),
        ),
      ),
    );
  }

  bool showFollowing = false;

  _buildBragWidget(
    int index,
  ) {
    final theProvider = context.read<VideoFeedProvider>();

    return FancyContainer(
      action: () async {
        theProvider.controllers[index]?.value.isPlaying ?? false
            ? await theProvider.controllers[index]?.pause()
            : await theProvider.controllers[index]?.play();

        // setState(() {});
      },
      child: Stack(
        children: [
          VideoPlayer(theProvider.controllers[index]!),
          Positioned(
            left: 10,
            right: 10,
            bottom: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child:
                        _buildVideoInfo(theProvider.theListOfBragModel[index])),
                const SizedBox(width: 10),
                _buildActions(index),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(int index) {
    final provider = context.read<VideoFeedProvider>();
    return SizedBox(
      height: 320,
      child: ReactionPanelVertical(
        model: provider.theListOfBragModel[index],
        updateModel: (updated) {
          provider.theListOfBragModel[index] = updated;
          if (mounted) setState(() {});
        },
        updatePostClappCount: (postInfo) {
          provider.theListOfBragModel[index].clapCount = int.tryParse(
              postInfo.claps ??
                  provider.theListOfBragModel[index].clapCount.toString());
        },
        updatePostCommentCount: (count) {
          provider.theListOfBragModel[index].commentCount = int.tryParse(count);
        },
        updatePostSharedCount: (_) {},
      ),
    );
  }

  Widget _buildProfileImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(Icons.person, color: Colors.white);
    }

    if (imageUrl.toLowerCase().endsWith('.svg')) {
      return const Icon(Icons.person, color: Colors.white);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildUserNugget(BragModel brag) {
    return GestureDetector(
      onTap: () {
        final theProvider = context.read<VideoFeedProvider>();
        theProvider.controllers.forEach(
          (key, value) {
            value.pause();
          },
        );

        context.read<PostBloc>().add(GetCurrentTabIndexEvent(index: 6));

        if (brag.author == profileModelG?.pid) {
          context.pushNamed(MyAppRouteConstant.myAccountPage);
        } else {
          context.pushNamed(
            MyAppRouteConstant.othersAccountPage,
            extra: {"userId": brag.author},
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getFigmaColor("006FCD"),
              ),
              height: 32.w,
              width: 32.w,
              child: _buildProfileImage(brag.authorImage),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  brag.authorName ?? "N/A",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  brag.humanReadableDate ?? "N/A",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo(BragModel brag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildUserNugget(brag),
        const SizedBox(height: 10),
        if (brag.content?.isNotEmpty == true)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              brag.content!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                shadows: [
                  Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 4,
                      color: Colors.black54),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
