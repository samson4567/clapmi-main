// import 'package:clapmi/Models/combo_model.dart';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/challenge_box.dart';
import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/post_challenge_notification_list_bottom.dart';
import 'package:clapmi/core/api/multi_env.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/authentication/data/models/logout_model.dart';
import 'package:clapmi/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:clapmi/features/brag/data/models/post_model.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_state.dart';
import 'package:clapmi/features/chats_and_socials/data/models/clap_request_model.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/data/models/edit_post_model.dart';
import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/fancy_text.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/Brag/brag_comment_section.dart';
import 'package:clapmi/screens/NetworkAndRewards/widgets/network_profile.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/feed.dart';
import 'package:clapmi/screens/feed/widget/live_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:url_launcher/url_launcher.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF181919), // Background color
        hintText: "Select Wallet",
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20), // Border radius 20
        ),
      ),
      initialValue: null, // Default value
      items: const [
        DropdownMenuItem(
          value: "web3",
          child: Text("Web 3 Wallet"),
        ),
        DropdownMenuItem(
          value: "clapmi",
          child: Text("Clapmi Wallet"),
        ),
      ],
      onChanged: (value) {
        // Handle wallet selection
      },
    );
  }
}

Color? getTagColor(String? colorString) {
  if (colorString == null) {
    return null;
  }
  List colorValueList =
      colorString.split("rgba(")[1].split(")")[0].split(",").map(
    (e) {
      if (colorString.split("rgba(")[1].split(")")[0].split(",").indexOf(e) <
          3) {
        return int.tryParse(e.trim());
      } else {
        return double.tryParse(e.trim());
      }
    },
  ).toList();

  return Color.fromRGBO(
    colorValueList[0],
    colorValueList[1],
    colorValueList[2],
    colorValueList[3],
  );
}

class DrawerList extends StatelessWidget {
  const DrawerList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black, // Set the drawer background to black
      child: ListView(
        children: <Widget>[
          // Drawer Header with profile image and name
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black, // Ensure the header is also black
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profile Image
                Image.asset(
                  'assets/images/clapmi.png',
                  height: 100,
                  width: 100,
                ),
                GestureDetector(
                  child: profileModelG?.myAvatar != null
                      ? Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  image:
                                      MemoryImage(profileModelG!.myAvatar!))),
                        )
                      : CachedNetworkImage(
                          height: 30.w,
                          width: 30.w,
                          imageUrl: profileModelG?.image ?? '',
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageBuilder) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(image: imageBuilder)),
                            );
                          },
                          errorWidget: (context, error, trace) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: getFigmaColor("006FCD"),
                                    borderRadius: BorderRadius.circular(30)),
                                width: 30.w,
                                height: 30.w,
                                child:
                                    //CircularProgressIndicator.adaptive()
                                    Icon(Icons.person));
                          },
                          placeholder: (context, url) {
                            return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                                width: 45.w,
                                height: 45.w,
                                child: Icon(Icons.person));
                          },
                        ),
                ),

                // FancyContainer(
                //   radius: 40,
                //   height: 40,
                //   width: 40,
                //   child: CustomImageView(
                //     imagePath: null,
                //     height: double.infinity,
                //     width: double.infinity,
                //   ),
                // )
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/profile.png",
              width: 30,
              height: 30,
              color: Colors.white.withValues(alpha: 3.0),
            ),
            title: const Text(
              'Profile',
              style: TextStyle(
                  color: Color(0XFFFFFFFF),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(
                MyAppRouteConstant.myAccountPage,
              );
            },
          ),

          ListTile(
            leading: Image.asset(
              "assets/icons/Vector-27.png",
              width: 30,
              height: 30,
              color: Colors.white.withValues(alpha: 3.0),
            ),
            title: const Text(
              'Network',
              style: TextStyle(
                  color: Color(0XFFFFFFFF),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20), // Set text color to white
            ),
            onTap: () {
              context.pushNamed(MyAppRouteConstant.networkConnect);
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/marketeq_reward.png",
              width: 30,
              height: 30,
              color: Colors.white.withValues(alpha: 3.0),
            ),
            title: const Text(
              'Reward',
              style: TextStyle(
                  color: Color(0XFFFFFFFF),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            onTap: () {
              context.pushNamed(MyAppRouteConstant.clapReward);
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/ranking.png",
              width: 30,
              height: 30,
              color: Colors.white.withValues(alpha: 3.0),
            ),
            title: const Text(
              'Leaderboard',
              style: TextStyle(
                  color: Color(0XFFFFFFFF),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            onTap: () {
              context.pushNamed(MyAppRouteConstant.leaderboard);
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/like.png",
              width: 30,
              height: 30,
              color: Colors.white.withValues(alpha: 3.0),
            ),
            title: const Text(
              'clapmi+',
              style: TextStyle(
                  color: Color(0XFFFFFFFF),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            onTap: () {
              context.pushNamed(MyAppRouteConstant.clapmiplus);
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/solar_settings-outline.png",
              width: 30,
              height: 30,
              color: Colors.white.withValues(alpha: 3.0),
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                  color: Color(0XFFFFFFFF),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            onTap: () {
              context.pushNamed(MyAppRouteConstant.settings);
            },
          ),

          ListTile(
            leading: Image.asset(
              "assets/icons/more.png",
              width: 30,
              height: 30,
              color: Colors.white.withValues(alpha: 3.0),
            ),
            title: const Text(
              'More',
              style: TextStyle(
                color: Color(0XFFFFFFFF),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Color(0XFF181919),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Image.asset('assets/icons/discord.png'),
                            title: const Text(
                              'Join our Discord',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () async {
                              await launchUrl(
                                  Uri.parse(MultiEnv().discordServer));
                            },
                          ),
                          ListTile(
                            leading: Image.asset('assets/icons/x.png'),
                            title: const Text(
                              'Join us on X',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () async {
                              await launchUrl(Uri.parse(MultiEnv().xHandle));
                            },
                          ),
                          const Divider(color: Color(0XFF3D3D3D)),
                          ListTile(
                            leading: Image.asset('assets/images/tube.png'),
                            title: GestureDetector(
                              onTap: () {
                                context
                                    .goNamed(MyAppRouteConstant.hwclapmiworks);
                              },
                              child: const Text(
                                'How Clapmi Works',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              // Navigate to “How Clapmi Works” page
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is LogOutStateSuccessState) {
                //  context.goNamed(MyAppRouteConstant.onboardingPage);
                context.goNamed(MyAppRouteConstant.login);
              } else if (state is LogOutErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: ListTile(
                leading: Image.asset(
                  "assets/icons/logout.png",
                  width: 30,
                  height: 30,
                  color: Colors.white.withValues(alpha: 3.0),
                ),
                title: const Text(
                  'Log Out',
                  style: TextStyle(
                      color: Color(0XFFFFFFFF),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
                onTap: () {
                  progressUpdate.close();
                  // context.goNamed(MyAppRouteConstant.login);
                  BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.goNamed(MyAppRouteConstant.hwclapmiworks);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 40),
              child: Image.asset(
                'assets/icons/how.png',
                height: 140.h,
                width: 240.w,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LiveChallengeWidget extends StatefulWidget {
  final ComboEntity comboModel;
  final int index;

  const LiveChallengeWidget({
    super.key,
    required this.comboModel,
    this.index = 0,
  });

  @override
  State<LiveChallengeWidget> createState() => _LiveChallengeWidgetState();
}

class _LiveChallengeWidgetState extends State<LiveChallengeWidget>
    with TickerProviderStateMixin {
  late AnimationController _borderController;
  late AnimationController _imageController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Border rotation controller
    _borderController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    // Image rotation controller
    _imageController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // Pulse animation for the border glow effect (like TikTok live)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Initial scale animation (entrance effect)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start entrance animation with stagger delay
    Future.delayed(Duration(milliseconds: widget.index * 200), () {
      if (mounted) {
        _scaleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _borderController.dispose();
    _imageController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: const GradientBoxBorder(
              width: 2,
              gradient: LinearGradient(
                colors: [Colors.red, Colors.blue],
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          height: 40.h,
          width: 250.w,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SvgPicture.asset(
                  height: 40.h,
                  width: 125.w,
                  "assets/images/pill_arrows.svg",
                ),
              ),
              Row(
                mainAxisAlignment: widget.comboModel.type == 'single'
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  //**THE HOST DETAILS */
                  //----------------------
                  _buildAvatar(widget.comboModel.host?.avatar, size: 31.w),
                  widget.comboModel.type == 'multiple'
                      ? nameIndicator(widget.comboModel.host?.username ?? '')
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            liveIndicator(widget.comboModel),
                            nameIndicator(
                                widget.comboModel.host?.username ?? '')
                          ],
                        ),
                  //**THIS IS THE MIDDLE INFORMATION SHOWING LIVE AND VS */
                  //--------------------------------------------------------
                  if (widget.comboModel.type == 'multiple')
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //**LIVE INDICATOR FOR MULTIPLE COMBO */
                        //----------------------------------------
                        liveIndicator(widget.comboModel),
                        const SizedBox(height: 1),
                        const Text(
                          "VS",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  //** THE CHALLENGER'S NAME INDICATOR AND AVATAR*/
                  //-----------------------------------------------
                  if (widget.comboModel.type == 'multiple')
                    nameIndicator(widget.comboModel.challenger?.username ?? ''),
                  if (widget.comboModel.type == 'multiple')
                    _buildAvatar(widget.comboModel.challenger?.avatar,
                        size: 31.w),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String? imagePath, {double size = 40}) {
    return RotationTransition(
      turns: _borderController,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          shape: BoxShape.circle,
        ),
        child: RotationTransition(
          turns: Tween<double>(begin: 0, end: -1).animate(_imageController),
          child: ClipOval(
            child: CustomImageView(
              imagePath: imagePath ?? "assets/default_avatar.png",
            ),
          ),
        ),
      ),
    );
  }
}

//**POST-WIDGET ITEM STARTS HERE */

class PostWidget extends StatelessWidget {
  final PostModel postModel;
  final int? postIndex;
  final List<PostModel> postModelItems;
  final String authorId;
  final bool isFromOffline;

  final Widget? image;
  final Function()? updateModel;
  final Function(PostClappedReaction)? updatePostClappCount;
  final Function(String)? updatePostCommentCount;
  final Function(String)? updatePostSharedCount;
  const PostWidget({
    super.key,
    this.image,
    this.updateModel,
    required this.postModel,
    required this.authorId,
    this.updatePostClappCount,
    this.updatePostSharedCount,
    this.postIndex,
    this.updatePostCommentCount,
    this.isFromOffline = false,
    this.postModelItems = const [],
  });

  void _showPostOptionsBottomSheet(
    BuildContext parentContext,
    PostModel postModel,
  ) {
    //final bool isPostOwner = authorId == postModel.authorId;
    showModalBottomSheet(
      context: parentContext,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        bool isClosed = false;

        void safeCloseSheet() {
          if (isClosed) return;
          isClosed = true;

          if (Navigator.of(sheetContext, rootNavigator: true).canPop()) {
            Navigator.of(sheetContext, rootNavigator: true).pop();
          }
        }

        void showSnack(String message) {
          ScaffoldMessenger.of(parentContext)
              .showSnackBar(generalSnackBar(message));
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// NOT INTERESTED
              BlocListener<PostBloc, PostState>(
                listener: (context, state) {
                  if (state is NotInterestedPostSuccessState) {
                    showSnack(state.message);
                    parentContext
                        .read<PostBloc>()
                        .add(GetAllPostsEvent(isRefresh: true));
                    safeCloseSheet();
                  }

                  if (state is NotInterestedPostErrorState) {
                    showSnack(state.errorMessage);
                    safeCloseSheet();
                  }
                },
                child: const SizedBox.shrink(),
              ),

              /// BLOCK USER
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is BlockUserLoadingState) {
                    showSnack('Blocking user...');
                  }

                  if (state is BlockUserSuccessState) {
                    showSnack(state.blockedUsers);
                    safeCloseSheet();
                  }

                  if (state is BlockUserErrorState) {
                    showSnack(state.errorMessage);
                    safeCloseSheet();
                  }
                },
                builder: (context, state) {
                  if (state is BlockUserLoadingState) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  return _bottomSheetItem(
                    sheetContext,
                    Icons.block,
                    "Block @${postModel.authorName}",
                    onTap: () {
                      context.read<AuthBloc>().add(
                            BlockUserEvent(
                              userId: postModel.authorId ?? '',
                            ),
                          );
                    },
                  );
                },
              ),

              /// FOLLOW
              _bottomSheetItem(
                parentContext, // 👈 NOT sheetContext
                Icons.double_arrow_rounded,
                "Follow @${postModel.authorName}",
                onTap: () {
                  parentContext.read<ChatsAndSocialsBloc>().add(
                        SendClapRequestToUsersEvent(
                          userPids: postModel.authorId ?? '',
                        ),
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPostOptionsBottomSheetOwner(
    BuildContext parentContext,
    PostModel postModel,
  ) {
    //final bool isPostOwner = authorId == postModel.authorId;
    showModalBottomSheet(
      context: parentContext,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        bool isClosed = false;

        void safeCloseSheet() {
          if (isClosed) return;
          isClosed = true;

          if (Navigator.of(sheetContext, rootNavigator: true).canPop()) {
            Navigator.of(sheetContext, rootNavigator: true).pop();
          }
        }

        void showSnack(String message) {
          ScaffoldMessenger.of(parentContext)
              .showSnackBar(generalSnackBar(message));
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// NOT INTERESTED
              BlocListener<PostBloc, PostState>(
                listener: (context, state) {
                  if (state is NotInterestedPostSuccessState) {
                    showSnack(state.message);
                    parentContext
                        .read<PostBloc>()
                        .add(GetAllPostsEvent(isRefresh: true));
                    safeCloseSheet();
                  }

                  if (state is NotInterestedPostErrorState) {
                    showSnack(state.errorMessage);
                    safeCloseSheet();
                  }
                },
                child: const SizedBox.shrink(),
              ),

              /// BLOCK USER
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is BlockUserLoadingState) {
                    showSnack('Blocking user...');
                  }

                  if (state is BlockUserSuccessState) {
                    showSnack(state.blockedUsers);
                    safeCloseSheet();
                  }

                  if (state is BlockUserErrorState) {
                    showSnack(state.errorMessage);
                    safeCloseSheet();
                  }
                },
                builder: (context, state) {
                  if (state is BlockUserLoadingState) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  return _bottomSheetItem(
                    sheetContext,
                    Icons.edit,
                    "Edit Post",
                    onTap: () {
                      Navigator.pop(sheetContext);

                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: parentContext,
                        isScrollControlled: true,
                        builder: (_) => BlocListener<PostBloc, PostState>(
                          listener: (context, state) {
                            if (state is EditPostContentSuccessState) {
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    state.message ??
                                        'Post updated successfully',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (state is EditPostContentErrorState) {
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                                SnackBar(
                                  content: Text(state.errorMessage),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              context
                                  .read<PostBloc>()
                                  .add(GetAllPostsEvent(isRefresh: isClosed));
                            }
                          },
                          child: EditPostBottomSheet(
                            initialContent: postModel.content ?? '',
                            onUpdate: (updatedContent) {
                              parentContext.read<PostBloc>().add(
                                    EditPostConntentEvent(
                                      postModelItems: postModelItems,
                                      postIndex: postIndex,
                                      editPost: EditPostContentModel(
                                        postId: postModel.postId,
                                        content: updatedContent,
                                      ),
                                    ),
                                  );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              /// FOLLOW
              _bottomSheetItem(
                parentContext,
                Icons.double_arrow_rounded,
                "Delete Post",
                onTap: () {
                  Navigator.pop(sheetContext);
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: parentContext,
                    isScrollControlled: true,
                    builder: (_) => DeletePostDialog(
                      onDelete: () {
                        parentContext.read<PostBloc>().add(
                              DelPostUserEvent(
                                postModelItems: postModelItems,
                                postIndex: postIndex,
                                postId: postModel.postId ?? '',
                              ),
                            );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomSheetItem(
    BuildContext parentContext, // 👈 IMPORTANT
    IconData iconPath,
    String title, {
    VoidCallback? onTap,
  }) {
    return BlocListener<ChatsAndSocialsBloc, ChatsAndSocialsState>(
      listener: (context, state) {
        /// ✅ SUCCESS
        if (state is SendClapRequestToUsersSuccessState) {
          ScaffoldMessenger.of(parentContext).showSnackBar(
            generalSnackBar(state.message),
          );

          if (Navigator.canPop(context)) {
            Navigator.pop(context); // close bottom sheet HERE
          }
        }

        /// ❌ ERROR
        if (state is SendClapRequestToUsersErrorState) {
          String errorMessage = state.errorMessage;

          if (errorMessage
              .contains('You have an existing pending request to User')) {
            errorMessage = 'You already have a pending request to this user';
          }

          ScaffoldMessenger.of(parentContext).showSnackBar(
            generalSnackBar(errorMessage),
          );

          if (Navigator.canPop(context)) {
            Navigator.pop(context); // close bottom sheet HERE
          }
        }
      },
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            children: [
              Icon(iconPath),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Callback when user clicks on @mention
  void _onMentionTapped(BuildContext context, String username) {
    // Remove @ symbol to get clean username
    final cleanUsername = username.replaceFirst('@', '');

    print('Clicked on username: $cleanUsername');

    // context.pushNamed(
    //   MyAppRouteConstant.othersAccountPage,
    //   extra: {},
    // );
  }

  // Helper method to build text with clickable blue @ mentions
  Widget _buildContentWithBlueMentions(BuildContext context, String content) {
    final List<InlineSpan> spans = [];
    final RegExp pattern = RegExp(r'(@\w+)'); // Only match @mentions
    final matches = pattern.allMatches(content);

    int lastMatchEnd = 0;

    for (final match in matches) {
      // Add normal text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: content.substring(lastMatchEnd, match.start),
          style: TextStyle(
            letterSpacing: 1,
            wordSpacing: 0.1,
            fontSize: 16,
            height: 1.3,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: getFigmaColor("FFFFFF"),
          ),
        ));
      }

      // Add the clickable @ mention in blue
      final mentionText = match.group(0)!;
      spans.add(
        TextSpan(
          text: mentionText,
          style: TextStyle(
            letterSpacing: 1,
            wordSpacing: 0.1,
            fontSize: 16,
            height: 1.3,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _onMentionTapped(context, mentionText);
            },
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text after last match
    if (lastMatchEnd < content.length) {
      spans.add(TextSpan(
        text: content.substring(lastMatchEnd),
        style: TextStyle(
          letterSpacing: 1,
          wordSpacing: 0.1,
          fontSize: 16,
          height: 1.3,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          color: getFigmaColor("FFFFFF"),
        ),
      ));
    }
    //   print("${postModel.listOfTagDetails}");

    return RichText(
      text:
          //  TextSpan(text: "${postModel.}")
          TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FancyContainer(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          radius: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //** THIS IS THE HEADER OF THE POST WIDGET CONTAINING THE HAMBURGER */
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        final userId = postModel.authorId;
                        print('${profileModelG?.username}');
                        print('${profileModelG?.email}');
                        if (userId != null) {
                          if (profileModelG?.pid == userId) {
                            context.pushNamed(
                              MyAppRouteConstant.myAccountPage,
                            );
                          } else {
                            context.pushNamed(
                              MyAppRouteConstant.othersAccountPage,
                              extra: {
                                "userId": userId,
                              },
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Could not load user profile.')),
                          );
                        }
                      },
                      child: postModel.imageAvatar != null
                          ? Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: MemoryImage(postModel.imageAvatar!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: getFigmaColor("006FCD"),
                                  shape: BoxShape.circle),
                              height: 32.w,
                              width: 32.w,
                              child: isFromOffline
                                  ? FutureBuilder<File>(
                                      future: () async {
                                        final file = await DefaultCacheManager()
                                            .getSingleFile(
                                                postModel.authorImage ?? "");
                                        return file;
                                      }.call(),
                                      builder: (context, asyncSnapshot) {
                                        if (asyncSnapshot.hasData) {
                                          return CustomImageView(
                                            imagePath:
                                                asyncSnapshot.data?.path ?? "",
                                            radius: BorderRadius.circular(12),
                                            fit: BoxFit.cover,
                                          );
                                        }
                                        if (asyncSnapshot.hasError) {
                                          return Placeholder();
                                        }
                                        return SizedBox.square(
                                          dimension: 40,
                                          child: CircularProgressIndicator
                                              .adaptive(),
                                        );
                                      })
                                  : CachedNetworkImage(
                                      imageUrl: postModel.authorImage ?? "",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                      errorWidget:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.person),
                                    ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 20.h,
                          child: Text(
                            postModel.authorName ?? "N/A",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Lato',
                                color: getFigmaColor("FFFFFF"), // Keep WHITE
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 20.h,
                          child: Text(
                            postModel.humanReadableDate ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: getFigmaColor("B5B5B5"),
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: postModel.user?['verified'] ?? false,
                      child: Align(
                        child: Image.asset("assets/icons/Vector (11).png"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: postModel.user?['sponsored'] ?? false,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: getFigmaColor("1666C5")),
                        height: 32,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: const Text(
                          "Sponsored",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    if (profileModelG?.pid != postModel.creatorId)
                      IconButton(
                          onPressed: () {
                            _showPostOptionsBottomSheet(context, postModel);
                          },
                          icon: Icon(Icons.more_horiz,
                              color: getFigmaColor("5C5D5D")))
                    else
                      IconButton(
                          onPressed: () {
                            _showPostOptionsBottomSheetOwner(
                                context, postModel);
                          },
                          icon: Icon(Icons.more_horiz,
                              color: getFigmaColor("5C5D5D")))
                  ],
                ),
              ),
              //** THIS IS THE CONTENT CONTAINER */
              GestureDetector(
                onTap: () {
                  context.goNamed(MyAppRouteConstant.postScreen,
                      extra: postModel.postId);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use the helper method to render content with clickable blue @mentions
                      _buildContentWithBlueMentions(context, postModel.content),
                      SizedBox(
                        height: 15.h,
                      ),
                      Visibility(
                        visible: postModel.imageUrls?.isNotEmpty ?? true,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: SizedBox(
                              width: double.infinity, child: _buildPostImage()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Hashtags at the bottom - NOW BLUE
              Row(
                children: List.generate(
                  postModel.listOfTagDetails?.length ?? 0,
                  (index) {
                    print(
                        "djbsdkfbdsfkbdsjf>>1234${postModel.listOfTagDetails}");
                    return Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        postModel.listOfTagDetails?[index]["name"],
                        style: TextStyle(
                            color: Colors.blue, // Hashtags in BLUE
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

              ReactionPanelHorizontal(
                model: CreatePostModel.fromPostModel(postModel),
                updatePostClappCount: updatePostClappCount,
                updatePostCommentCount: updatePostCommentCount,
                updatePostSharedCount: updatePostSharedCount,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostImage() {
    // Single or empty image list
    if ((postModel.imageUrls?.length == 1) ||
        (postModel.imageUrls?.isEmpty ?? true)) {
      return CustomImageView(
        radius: BorderRadius.circular(12),
        imagePath: postModel.imageUrls?.firstOrNull ?? "",
        fit: BoxFit.cover,
      );
    }

    // Two Images Layout
    if (postModel.imageUrls?.length == 2) {
      return Row(
        children: List.generate(
          2,
          (index) => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: isFromOffline
                  ? FutureBuilder<File>(
                      future: () async {
                        final file = await DefaultCacheManager()
                            .getSingleFile(postModel.imageUrls?[index] ?? "");
                        return file;
                      }.call(),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          return CustomImageView(
                            imagePath: asyncSnapshot.data?.path ?? "",
                            radius: BorderRadius.circular(12),
                            fit: BoxFit.cover,
                          );
                        }
                        if (asyncSnapshot.hasError) return Placeholder();
                        return SizedBox.square(
                          dimension: 40,
                          child: CircularProgressIndicator.adaptive(),
                        );
                      })
                  : CustomImageView(
                      imagePath: postModel.imageUrls?[index] ?? "",
                      radius: BorderRadius.circular(12),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      );
    }

    // Three Images Layout
    if (postModel.imageUrls?.length == 3) {
      final images = postModel.imageUrls!;

      return Container(
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageView(
                      imagePath: images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomImageView(
                            imagePath: images[1],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomImageView(
                            imagePath: images[2],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    // More than 3 Images Layout
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CustomImageView(
              imagePath: postModel.imageUrls?.firstOrNull ?? "",
              radius: BorderRadius.circular(12),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CustomImageView(
                    imagePath: postModel.imageUrls?[1] ?? "",
                    radius: BorderRadius.circular(12),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CustomImageView(
                        imagePath: postModel.imageUrls?[2] ?? "",
                        radius: BorderRadius.circular(12),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: FancyText(
                        "+${postModel.imageUrls!.length - 3}",
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
//**THE POST MODEL WIDGET ENDS AT THIS POINT */

// New Widget to display a single feed item based on PostModel
// ignore: must_be_immutable
class FeedItemWidget extends StatelessWidget {
  bool isDummy;
  final PostModel postModel;
  final Function(PostClappedReaction) livePostIdCallback;

  FeedItemWidget(
      {super.key,
      required this.postModel,
      this.isDummy = false,
      required this.livePostIdCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[850], // Dark background for the item
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (postModel.authorImage != null)
                CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(postModel.authorImage!),
                  radius: 20,
                ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postModel.authorName ??
                        postModel.creatorId, // Display author or creator ID
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    postModel.humanReadableDate ??
                        '', // Display date if available
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildContent(),
          const SizedBox(height: 8),
          ReactionPanelHorizontal(
            model: CreatePostModel.fromPostModel(postModel),
          )
        ],
      ),
    );
  }

  // Builds the content part based on the post type
  Widget _buildContent() {
    switch (postModel.type) {
      case PostType.image:
        String imageUrl = postModel.imageUrls?.first ?? ""; // Example logic
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: postModel.content.isNotEmpty,
                child: Text(
                  postModel.content,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                )),
            SizedBox(height: imageUrl.isNotEmpty ? 10 : 0),
            (isDummy)
                ? AspectRatio(
                    aspectRatio: 1,
                    child: SizedBox(
                      width: double.infinity,
                    ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl.isNotEmpty
                          ? imageUrl
                          : 'https://2.img-dpreview.com/files/p/E~C1000x0S4000x4000T1200x1200~articles/3925134721/0266554465.jpeg', // Placeholder if URL is empty
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator.adaptive()),
                      // Add error builder for robustness
                      errorWidget: (context, error, stackTrace) => Container(
                        height: 150,
                        color: Colors.grey[700],
                        child: const Center(
                            child: Text('Could not load image',
                                style: TextStyle(color: Colors.white70))),
                      ),
                    ),
                  ),
          ],
        );
      case PostType.text:
        return Text(
          postModel.content,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        );
      case PostType.video:
      case PostType.unknown:
        // Handle unknown or unsupported types (should have been filtered out)
        return const SizedBox.shrink(); // Don't display anything
    }
  }
}

class EditPostBottomSheet extends StatefulWidget {
  final String initialContent;
  final VoidCallback? onCancel;
  final ValueChanged<String>? onUpdate;

  const EditPostBottomSheet({
    super.key,
    required this.initialContent,
    this.onCancel,
    this.onUpdate,
  });

  @override
  State<EditPostBottomSheet> createState() => _EditPostBottomSheetState();
}

class _EditPostBottomSheetState extends State<EditPostBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Edit Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white24),

          /// CONTENT LABEL
          const SizedBox(height: 12),
          const Text(
            'Content',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          /// TEXT FIELD
          Container(
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white24),

          /// ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  widget.onCancel?.call();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  widget.onUpdate?.call(_controller.text);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Update Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeletePostDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeletePostDialog({
    super.key,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Delete post?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "This can’t be undone and it will be removed from your profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                /// DELETE (CONFIRM ACTION)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // close modal
                      onDelete(); // 🔥 delete happens HERE
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                /// CANCEL
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A3A3C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<ClapRequestModel> listOfClapRequest = [];

class UserCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;
  // final ClapRequestModel? clapRequest;

  const UserCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.role,
    //  required this.clapRequest,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
      listener: (context, state) {
        if (state is GetClapRequestSuccessState) {
          listOfClapRequest = state.listOfClapRequest;
        }
        if (state is GetClapRequestErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(generalSnackBar(state.errorMessage));
        }
      },
      builder: (context, state) {
        if (listOfClapRequest.isEmpty) {
          return buildEmptyWidget("No Request Yet");
        } else {
          return Row(
            children: listOfClapRequest.map((e) {
              return BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
                listener: (context, state) {
                  if (state is AcceptRequestSuccessState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(generalSnackBar(state.message));
                    listOfClapRequest.remove(e);
                  }
                  if (state is RejectRequestSuccessState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(generalSnackBar(state.message));
                    listOfClapRequest.remove(e);
                  }
                },
                builder: (context, state) {
                  //THE CARD SHOWING CLAP REQUESTS
                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    child: NetWorkProfile(
                      requestModel: e,
                      acceptRequest: () {
                        context
                            .read<ChatsAndSocialsBloc>()
                            .add(AcceptRequestEvent(e.id));
                      },
                      declineRequest: () {
                        context
                            .read<ChatsAndSocialsBloc>()
                            .add(RejectRequestEvent(e.id));
                      },
                    ),
                  );
                },
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class ReactionPanelVertical extends StatefulWidget {
  final Function(BragModel bragModel)? updateModel;
  final Function(PostClappedReaction)? updatePostClappCount;
  final Function(String)? updatePostCommentCount;
  final Function(String)? updatePostSharedCount;

  final BragModel model;
  const ReactionPanelVertical({
    super.key,
    this.updateModel,
    required this.model,
    this.updatePostClappCount,
    this.updatePostCommentCount,
    this.updatePostSharedCount,
  });

  @override
  State<ReactionPanelVertical> createState() => _ReactionPanelVerticalState();
}

class _ReactionPanelVerticalState extends State<ReactionPanelVertical> {
  int noOfClap = 0;
  int numberOfComment = 0;

  bool isClaped = false;
  bool isSaved = false;
  bool isComment = false;
  bool largeMode = false;

  // BragModel? bragModel;
  PostModel? postWithComments;
  SingleVideoPostModel? videoPost;
  @override
  void initState() {
    syncNumbers();
    super.initState();
  }

  syncNumbers({BragModel? model}) {
    setState(() {
      // Adapt these fields based on PostModel structure
      isClaped = widget.model.hasClapped ?? false;
      isSaved = widget.model.hasSaved ?? false;
      noOfClap = widget.model.clapCount ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BragBloc, BragState>(
      listener: (context, state) {
        if (state is SingleBragState) {
          setState(() {
            print(
                'This is the single state called ${state.post}-----------------------------------');
            if (isComment) {
              showModalBottomSheet(
                showDragHandle: true,
                enableDrag: true,
                // constraints: BoxConstraints(
                //   maxHeight: MediaQuery.of(context).size.height,
                // ),
                context: context,
                builder: (context) => CommentSheet(
                  model: widget.model,
                  post: state.post,
                ),
              );
            }
          });
        }
      },
      builder: (context, state) {
        return BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
          listener: (context, state) {
            //STATE TO UPDATE THE POST CLAPP COUNT
            if (state is PostClappCount) {
              if (state.reaction.post == widget.model.pid) {
                widget.updatePostClappCount!(state.reaction);
                if (isClaped) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    generalSnackBar("Post clapped successfully"),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    generalSnackBar("Post unclapped successfully"),
                  );
                }
              }
            }
            //STATE TO UPDATE THE SHARE COUNT
            if (state is PostSharedCount) {
              if (state.post.post == widget.model.pid) {
                widget.updatePostSharedCount!(state.post.shares ?? '');
              }
            }

            if (state is PostCommentCount) {
              if (state.postComment.post == widget.model.pid) {
                widget
                    .updatePostCommentCount!(state.postComment.comments ?? '');
              }
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //CLAP ICON...
                FancyContainer(
                  width: 45,
                  height: 45,
                  isAsync: true,
                  displayLoadingWidget: false,
                  action: () {
                    if (isClaped) {
                      // If already clapped, dispatch Unclap event

                      context.read<PostBloc>().add(
                            UnclapPostEvent(
                              postID: widget.model.pid ?? "",
                            ),
                          );
                      noOfClap--; // Decrement clap count optimistically
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   generalSnackBar("Unclapped successfully"),
                      // );
                    } else {
                      context.read<PostBloc>().add(
                            ClapPostEvent(
                              postID: widget.model.pid ?? "",
                            ),
                          );
                      noOfClap++;
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   generalSnackBar("Clapped successfully"),
                      // );
                      theclapAnimationController.reset();
                      theclapAnimationController.forward();
                    }
                    isClaped = !isClaped; // Toggle the clap status
                    if (mounted) {}
                    setState(() {}); // Update the UI
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        (isClaped)
                            ? "assets/icons/clapTrue.png"
                            : "assets/icons/clapFalse.png",
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 7),
                      Text("${widget.model.clapCount}"),
                    ],
                  ),
                ),
                //COMMENT ICON...
                FancyContainer(
                  isAsync: false,
                  height: 45,
                  width: 45,
                  action: () {
                    print('Comment icon is pressed....');
                    setState(() {
                      isComment = true;
                    });
                    context
                        .read<BragBloc>()
                        .add(GetSingleBragEvent(widget.model.pid ?? ''));
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/Vector.png",
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 7),
                      Text("${widget.model.commentCount ?? 0}"),
                    ],
                  ),
                ),
                //Save ICON...
                FancyContainer(
                  displayLoadingWidget: false,
                  action: () {
                    isSaved = !isSaved;
                    if (mounted) {
                      setState(() {});
                    }
                    context.read<PostBloc>().add(
                          SavePostEvent(
                            postID: widget.model.pid ?? "",
                          ),
                        );
                  },
                  height: 45,
                  width: 45,
                  child: Image.asset(
                    (isSaved)
                        ? "assets/icons/saveTrue.png"
                        : "assets/icons/saveFalse.png",
                    height: 20,
                    width: 20,
                  ),
                ),
                //SHARE ICON...
                FancyContainer(
                  height: 45,
                  width: 45,
                  loadingWidget: CircularProgressIndicator.adaptive(),
                  action: () async {},
                  child: Image.asset(
                    "assets/icons/Vector (13).png",
                    height: 20,
                    width: 20,
                  ),
                ),
                //BRAG ICON...
                FancyContainer(
                  height: 45,
                  width: 45,
                  action: () async {
                    print(
                        "THIS IS THE POST ID OF THE VIDEO POST ${widget.model.pid}");
                    setState(() {
                      isComment = false;
                    });
                    (widget.model.authorPID != profileModelG?.pid)
                        ? showModalBottomSheet(
                            context: context,
                            builder: (context) => ChallengeBox(
                                  challenger: profileModelG,
                                  postId: widget.model.pid ?? '',
                                  isPostChallenge: true,
                                  challengeId: '',
                                ))
                        : showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                PostChallengeNotificationListBottom(
                                  postId: widget.model.pid ?? '',
                                  host: profileModelG,
                                  isStandard: true,
                                ));
                  },
                  child: Image.asset(
                    "assets/icons/Live Combo.png",
                    height: 20,
                    width: 20,
                  ),
                ),
                //GIFT ICON ON THE REEL...
                if (widget.model.pid != profileModelG?.pid)
                  GestureDetector(
                    onTap: () {
                      print(widget.model.toString());
                      showGiftCapcoinBottomSheet(context,
                          recipientUsername: widget.model.authorName ?? '',
                          creatorID: widget.model.author ?? '');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0XFF003D71)
                        //  Colors.blue
                        , // Use your primary color if needed
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //${widget.model.hashCode}
                          Text("Gift"),
                          const SizedBox(width: 7),
                          Image.asset(
                            "assets/icons/Group (11).png",
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}










































// class BragsExtension extends StatelessWidget {
//   final String imagePath;
//   final String avatarPath;
//   final String name;
//   final String role;

//   const BragsExtension({
//     super.key,
//     required this.imagePath,
//     required this.avatarPath,
//     required this.name,
//     required this.role,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         context.pushNamed(MyAppRouteConstant.bragScreen);
//       },
//       child: Container(
//         width: 360,
//         height: 400,
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Stack(
//             children: [
//               // Background image
//               Image.asset(
//                 imagePath,
//                 width: 360,
//                 height: 400,
//                 fit: BoxFit.cover,
//               ),

//               Positioned(
//                 top: 12,
//                 left: 12,
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundImage: AssetImage(avatarPath),
//                     ),
//                     const SizedBox(width: 8),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           name,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const Text(
//                           '21 hours',
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               Positioned(
//                 bottom: 12,
//                 left: 12,
//                 child: Row(
//                   children: const [
//                     Icon(Icons.remove_red_eye, color: Colors.white70, size: 20),
//                     SizedBox(width: 4),
//                     Text(
//                       '1.7k',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

   // ListTile(
          //   leading: Image.asset("assets/icons/navbuttoncross.png",
          //       width: 30, height: 30),
          //   title: const Text(
          //     'Societies',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     context.pushNamed(MyAppRouteConstant.societyPage);
          //   },
          // ),
          // ListTile(
          //   leading: Image.asset("assets/icons/cup.png", width: 30, height: 30),
          //   title: const Text(
          //     'Competition',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),