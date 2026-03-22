// // import 'package:clapmi/Models/combo_model.dart';
// // ignore_for_file: use_build_context_synchronously, deprecated_member_use
// import 'dart:async';
// import 'dart:ui';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:clapmi/Models/brag_model.dart';
// import 'package:clapmi/Models/comment_model.dart';
// import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/challenge_box.dart';
// import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/post_challenge_notification_list_bottom.dart';
// import 'package:clapmi/core/app_variables.dart';
// import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
// import 'package:clapmi/features/app/presentation/blocs/app/app_event.dart';
// import 'package:clapmi/features/app/presentation/blocs/app/app_state.dart';
// import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
// import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
// import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
// import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
// import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
// import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
// import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
// import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
// import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
// import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_bloc.dart';
// import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_event.dart';
// import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_state.dart';
// import 'package:clapmi/features/post/data/models/create_post_model.dart';
// import 'package:clapmi/features/post/data/models/post_model.dart';
// import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
// import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
// import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
// import 'package:clapmi/features/wallet/domain/entities/gift_user.dart';
// import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
// import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
// import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
// import 'package:clapmi/global_object_folder_jacket/global_object.dart';

// import 'package:clapmi/screens/Brag/brag_screen_tu_tu.dart';
// import 'package:clapmi/screens/Brag/brag_util.dart';
// import 'package:clapmi/screens/BragVideoErrorAttemptRepairBackupFolder/brag_util.dart';
// import 'package:clapmi/screens/chatsection/chats_list_page.dart';
// import 'package:clapmi/screens/feed/feed_extraction_files/showcase_widget.dart';
// import 'package:clapmi/screens/feed/feed_extraction_files/tutorials_status_flows_lists.dart';
// import 'package:clapmi/screens/feed/widget/challenge_dialog.dart';
// import 'package:clapmi/screens/walletSystem/gifting/gifting_successful.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import 'package:uuid/uuid.dart';
// import '../feed/feed_extraction_files/extraction.dart';

// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// class FeedBackup extends StatefulWidget {
//   const FeedBackup({super.key});

//   @override
//   State<FeedBackup> createState() => _FeedBackupState();
// }

// class _FeedBackupState extends State<FeedBackup> {
//   List<ComboEntity> listOfLiveComboModel = [];
//   List<ComboEntity> listOfUpcomingComboModel = [];
//   List<PostModel> listOfPostModel = [];
//   List<PostModel> listOfFollowersPostModel = [];
//   bool isReconnecting = false;
//   bool isHomePage = false;

//   Map<String, dynamic> imageUrls = {};
//   double progressIndicator = 0.0;
//   bool isLoadingMore = false;
//   final ScrollController listController = ScrollController();
//   int notificationCount = 0;
//   String selectedComboId = '';
//   String selectedComboBragId = '';
//   bool liveLoading = false;

//   @override
//   void initState() {
//     print(
//         "-------------------INIT STATE OF THE FEEDSCREEN IS CALLED**************");
//     super.initState(); // Call super.initState first
//     detailsOfDeepLink = detailsOfDeepLinkDefault;
//     progressUpdate = StreamController<double>();

//     context.read<AppBloc>().add(GetMyProfileEvent());
//     // callAllInitializingEvents();
//     // getInitialData(context);
//     context.read<AppBloc>().add(GetPreviouslyStoredPostModelListEvent());
//     listController.addListener(_scrolListenerController);
//     // Assuming this fetches combo data
//     progressUpdate.stream.listen((data) {
//       setState(() {
//         progressIndicator = data;
//       });
//     });
//   }

//   callAllInitializingEvents() {
//     // Dispatch event to get posts when the screen initializes
//     context.read<PostBloc>().add(const GetClapmiVideosEvent());
//     context.read<PostBloc>().add(const GetAllPostsEvent(isRefresh: true));
//     context.read<ComboBloc>().add(GetLiveCombosEvent());
//     context.read<ComboBloc>().add(GetUpcomingCombosEvent());
//     context.read<ChatsAndSocialsBloc>().add(GetClapRequestEvent());
//     context.read<PostBloc>().add(const GetFollowersPostEvent());
//     context.read<ChatsAndSocialsBloc>().add(ConnectToSocketEvent());
//     context.read<NotificationBloc>().add(GetNotificationListEvent());
//     context.read<ChatsAndSocialsBloc>().add(GetClappersEvent());
//     context
//         .read<PostBloc>()
//         .add(GetAllVideoPostsEvent(isRefresh: true, index: 1));
//   }

//   List<PostModel> followersPost = [];

//   void _scrolListenerController() {
//     if (isLoadingMore) return;
//     if (listController.position.pixels ==
//         listController.position.maxScrollExtent) {
//       setState(() {
//         isLoadingMore = true;
//       });
//       context
//           .read<PostBloc>()
//           .add(CheckIfNeedMoreDataEvent(isVideoPost: false));
//     }
//   }

//   @override
//   void dispose() {
//     progressUpdate.close();
//     super.dispose();
//   }

//   String selectedCategory = "All";
//   List<ChatUser> friends = [];
//   // List<CreatePostModel> localListOfPost = []; // Removed old dummy list
//   @override
//   Widget build(BuildContext context) {
//     // bool dsdsds =
//     InternetConnection().hasInternetAccess.then(
//       (value) {
//         print("dbsfksdfkdbsf-get-build>>${value}");
//       },
//     );
//     ;
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<AppBloc, AppState>(
//           listener: (context, state) {
//             if (state is GetUserProfileError) {
//               ScaffoldMessenger.of(context)
//                   .showSnackBar(generalSnackBar(" ${state.errorMessage}"));
//             }
//             if (state is ProfileSuccess) {
//               print(
//                   "Successful profile call in this case --------****^^^^^^^^^^^^");
//               callAllInitializingEvents();
//             }
//           },
//         )
//       ],
//       child: BlocConsumer<PostBloc, PostState>(listener: (context, state) {
//         if (state is GetAllVideoPostsSuccessState) {
//           print(
//               "vajsasvavsjahsvhsvhasjhvasjhasj${BragModel.fromPostModel(state.posts.first).postVideoUrls}");
//           BragPageVideoIitialisationController()
//               .theListOfBragAndVideoModelAll
//               .addAll(state.posts
//                   .map(
//                     (e) => BragModel.fromPostModel(e),
//                   )
//                   .map(
//                     (e) => BragAndVideoModel(
//                         bragModel: e,
//                         videoUrl: e.postVideoUrls!.isNotEmpty
//                             ? e.postVideoUrls!.first
//                             : '',
//                         modelPageNumber:
//                             BragPageVideoIitialisationController().pageNumber),
//                   )
//                   .toList());
//           BragPageVideoIitialisationController()
//               .changeDisplayedList(false, friends: friends);
//           BragPageVideoIitialisationController().preinitializeFuturevideos(0);
//           try {
//             currentlyDisplayedVideoPlayerController =
//                 BragPageVideoIitialisationController()
//                     .theDisplayedListOfBragAndVideoModel[
//                         BragPageVideoIitialisationController().currentIndex]
//                     .theVideoPlayerController;
//           } catch (e) {}
//         }
//         if (state is GetAllVideoPostsLoadingState) {}
//       }, builder: (context, _) {
//         return BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
//           listener: (context, state) {
//             //**WHEN THE LISTENER IS CALLED TO LISTEN TO THE WEBSOCKET */
//             if (state is SocketConnected) {
//               context
//                   .read<ChatsAndSocialsBloc>()
//                   .add(ChatSubscriptionRequestEvent());
//             }
//             if (state is ClappersLoaded) {
//               setState(() {
//                 friends = state.friends;
//               });
//             }
//           },
//           builder: (context, state) {
//             return Scaffold(
//               key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
//               drawer:
//                   const DrawerList(), // Use const if DrawerList is stateless
//               body: RefreshIndicator(
//                 onRefresh: () async {
//                   context
//                       .read<PostBloc>()
//                       .add(const GetAllPostsEvent(isRefresh: true));
//                   context.read<PostBloc>().add(const GetFollowersPostEvent());
//                   // Optionally refresh combo data too
//                   context.read<ComboBloc>().add(GetLiveCombosEvent());
//                   context.read<ComboBloc>().add(GetUpcomingCombosEvent());
//                   context
//                       .read<NotificationBloc>()
//                       .add(GetNotificationListEvent());
//                   // });
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 25.h),
//                   child: Column(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(left: 8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 GestureDetector(
//                                   child: profileModelG?.myAvatar != null
//                                       ? Container(
//                                           width: 30.w,
//                                           height: 30.w,
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(30),
//                                               image: DecorationImage(
//                                                   image: MemoryImage(
//                                                       profileModelG!
//                                                           .myAvatar!))),
//                                         )
//                                       : Padding(
//                                           padding: EdgeInsets.only(top: 6.h),
//                                           child: ClipOval(
//                                             child: CachedNetworkImage(
//                                               height: 30.w,
//                                               width: 30.w,
//                                               imageUrl:
//                                                   profileModelG?.image ?? '',
//                                               fit: BoxFit.cover,
//                                               placeholder: (context, url) =>
//                                                   Container(
//                                                 color: Colors.grey[200],
//                                                 child: const Icon(Icons.person),
//                                               ),
//                                               errorWidget:
//                                                   (context, error, trace) =>
//                                                       Container(
//                                                 color: Colors.grey[300],
//                                                 child: const Icon(Icons.person),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                   onTap: () {
//                                     _scaffoldKey.currentState?.openDrawer();
//                                   },
//                                 ),
//                                 SizedBox(width: 15.h),
//                                 SvgPicture.asset(
//                                     height: 30.w,
//                                     "assets/images/logo_clapmi.svg")
//                               ],
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Container(
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: GestureDetector(
//                                       onTap: () {
//                                         context.pushNamed(
//                                             MyAppRouteConstant.generalSearch);
//                                       },
//                                       child: SvgPicture.asset(
//                                           height: 25.w,
//                                           "assets/images/search-normal.svg")),
//                                 ),
//                                 BlocConsumer<NotificationBloc,
//                                     NotificationState>(
//                                   listener: (context, state) {
//                                     if (state
//                                         is GetNotificationListSuccessState) {
//                                       notificationCount = state
//                                           .listOfNotificationEntity
//                                           .where((element) =>
//                                               element.readAt == null)
//                                           .length;
//                                     }
//                                   },
//                                   builder: (context, state) {
//                                     return GestureDetector(
//                                         onTap: () {
//                                           context.pushNamed(MyAppRouteConstant
//                                               .notificationPage);
//                                         },
//                                         child: Stack(
//                                           children: [
//                                             SvgPicture.asset(
//                                                 height: 25.w,
//                                                 "assets/images/notification.svg"),
//                                             Positioned(
//                                                 right: 4.w,
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               20),
//                                                       color: AppColors
//                                                           .primaryColor),
//                                                   child: Text(
//                                                     notificationCount
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontWeight:
//                                                             FontWeight.w400),
//                                                   ),
//                                                 ))
//                                           ],
//                                         ));
//                                   },
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                       //     //THIS IS TO SHOW WHEN THE VIDEO OR IMAGE UPLOADING IN ONGOING
//                       if (progressIndicator > 0.0 && progressIndicator < 1)
//                         SizedBox(
//                           width: 140,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: LinearProgressIndicator(
//                               value: progressIndicator,
//                               minHeight: 10,
//                               backgroundColor: Colors.grey.withOpacity(0.25),
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                   Colors.blueAccent),
//                             ),
//                           ),
//                         ),

//                       //THIS IS THE SEARCH ICON AT THE RIGHT SIDE OF THE FEED SCREEN
//                       Expanded(
//                         child: Stack(
//                           children: [
//                             SingleChildScrollView(
//                               controller: listController,
//                               physics:
//                                   const AlwaysScrollableScrollPhysics(), // Ensure scroll works for refresh
//                               child: Column(
//                                 children: [
//                                   Container(
//                                       margin: EdgeInsets.only(
//                                           bottom: 12.h,
//                                           left: 12.0,
//                                           right: 12.0,
//                                           top: 13.h),
//                                       child: Row(
//                                         children: [
//                                           RadioButtonForChat(
//                                             isSelected:
//                                                 selectedCategory == "All",
//                                             text: "All"
//                                             //  "${[profileModelG, userModelG]}",
//                                             ,
//                                             changeSelectedTab: () {
//                                               setState(() =>
//                                                   selectedCategory = "All");
//                                             },
//                                           ),
//                                           const SizedBox(width: 12),
//                                           RadioButtonForChat(
//                                             isSelected:
//                                                 selectedCategory == "Following",
//                                             text: "Following",
//                                             changeSelectedTab: () {
//                                               listOfFollowersPostModel =
//                                                   listOfPostModel.where(
//                                                 (element) {
//                                                   return friends.map((e) {
//                                                     return e.pid;
//                                                   }).contains(element.authorId);
//                                                 },
//                                               ).toList();
//                                               // if (listOfFollowersPostModel
//                                               //         .length <
//                                               //     10) {
//                                               //   context.read<PostBloc>().add(
//                                               //       CheckIfNeedMoreDataEvent(
//                                               //           isVideoPost: false));
//                                               // }

//                                               setState(() => selectedCategory =
//                                                   "Following");
//                                             },
//                                           ),
//                                         ],
//                                       )),

//                                   _buildFormerShowCase(),

//                                   SizedBox(
//                                     height: 20.h,
//                                   ),
//                                   BlocConsumer<ComboBloc, ComboState>(
//                                       listener: (context, state) {
//                                     if (state is GetLiveCombosSuccessState) {
//                                       listOfLiveComboModel =
//                                           state.listOfComboEntity;
//                                     }
//                                     if (state
//                                         is GetUpcomingCombosSuccessState) {
//                                       listOfUpcomingComboModel =
//                                           state.listOfComboEntity;
//                                     }
//                                     if (state is GetLiveCombosErrorState) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(generalSnackBar(
//                                               state.errorMessage));
//                                     }
//                                     if (state is GetUpcomingCombosErrorState) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(generalSnackBar(
//                                               state.errorMessage));
//                                     }
//                                     if (state is GetComboDetailLoadingState) {
//                                       setState(() {
//                                         liveLoading = true;
//                                       });
//                                     }
//                                     if (state is GetComboDetailErrorState) {
//                                       setState(() {
//                                         liveLoading = false;
//                                       });
//                                     }
//                                     if (state is GetComboDetailSuccessState) {
//                                       print(
//                                           "------This is combo details succesful state-------${state.comboEntity}");
//                                       if (state.comboEntity.type == 'single') {
//                                         selectedComboId =
//                                             state.comboEntity.combo ?? '';
//                                         selectedComboBragId =
//                                             state.comboEntity.brag ?? '';
//                                         context.read<ComboBloc>().add(
//                                             GetLiveComboEvent(
//                                                 combo: state.comboEntity));
//                                       }
//                                     }
//                                     if (state is LiveComboLoaded) {
//                                       print(
//                                           "------This is the Live Loaded state of the application");
//                                       setState(() {
//                                         liveLoading = false;
//                                       });
//                                       if (state.liveCombo.type == "single") {
//                                         context.pushNamed(
//                                             MyAppRouteConstant
//                                                 .liveComboThreeImageScreen,
//                                             extra: {
//                                               'comboId': selectedComboId,
//                                               'liveCombo': state.liveCombo,
//                                               'brag': selectedComboBragId,
//                                             });
//                                       }
//                                     }
//                                   }, builder: (context, state) {
//                                     return SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 12.0),
//                                       child: (listOfLiveComboModel.isEmpty &&
//                                               listOfUpcomingComboModel.isEmpty)
//                                           ? SizedBox.shrink()
//                                           : Row(
//                                               children: [
//                                                 ...List.generate(
//                                                   listOfLiveComboModel.length,
//                                                   (index) => GestureDetector(
//                                                     onTap: () {
//                                                       print(
//                                                           "press live combo button or widget-----------------------");
//                                                       if (listOfLiveComboModel[
//                                                                   index]
//                                                               .type ==
//                                                           "single") {
//                                                         context
//                                                             .read<ComboBloc>()
//                                                             .add(GetComboDetailEvent(
//                                                                 listOfLiveComboModel[
//                                                                             index]
//                                                                         .combo ??
//                                                                     ''));
//                                                       } else {
//                                                         context.pushNamed(
//                                                             MyAppRouteConstant
//                                                                 .startOrjoin,
//                                                             extra:
//                                                                 listOfLiveComboModel[
//                                                                     index]);
//                                                       }
//                                                     },
//                                                     child: Container(
//                                                       margin: EdgeInsets.only(
//                                                           bottom: 8),
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               right: 8.0),
//                                                       child:
//                                                           LiveChallengeWidget(
//                                                         comboModel:
//                                                             listOfLiveComboModel[
//                                                                 index],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 ...List.generate(
//                                                   listOfUpcomingComboModel
//                                                       .length,
//                                                   (index) => GestureDetector(
//                                                     onTap: () {
//                                                       print(
//                                                           "This-------(((((((()))))))) ${listOfUpcomingComboModel[index].stake}");
//                                                       if (listOfUpcomingComboModel[
//                                                                       index]
//                                                                   .challenger
//                                                                   ?.profile ==
//                                                               profileModelG
//                                                                   ?.pid ||
//                                                           listOfUpcomingComboModel[
//                                                                       index]
//                                                                   .host
//                                                                   ?.profile ==
//                                                               profileModelG
//                                                                   ?.pid) {
//                                                         context.pushNamed(
//                                                             MyAppRouteConstant
//                                                                 .startOrjoin,
//                                                             extra:
//                                                                 listOfUpcomingComboModel[
//                                                                     index]);
//                                                       } else {}
//                                                     },
//                                                     child: Container(
//                                                       margin: EdgeInsets.only(
//                                                           bottom: 8),
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               right: 8.0),
//                                                       child:
//                                                           LiveChallengeWidget(
//                                                         comboModel:
//                                                             listOfUpcomingComboModel[
//                                                                 index],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                     );
//                                   }),
//                                   //**POST SECTION IN THE BLOC BUILDER */
//                                   BlocConsumer<PostBloc, PostState>(
//                                     listener: (context, state) {
//                                       if (state is GetAllPostsSuccessState) {
//                                         listOfPostModel += state.posts;
//                                         if (context
//                                                 .read<PostBloc>()
//                                                 .pageNumber ==
//                                             2)
//                                           context.read<AppBloc>().add(
//                                               SetPreviouslyStoredPostModelListEvent(
//                                                   listOfPostModel));
//                                         listOfFollowersPostModel =
//                                             listOfPostModel.where(
//                                           (element) {
//                                             return friends.map((e) {
//                                               return e.pid;
//                                             }).contains(element.authorId);
//                                           },
//                                         ).toList();
//                                         // if (listOfFollowersPostModel.length <
//                                         //     10) {
//                                         //   context.read<PostBloc>().add(
//                                         //       CheckIfNeedMoreDataEvent(
//                                         //           isVideoPost: false));
//                                         // }

//                                         setState(() {
//                                           isLoadingMore = false;
//                                         });
//                                       }
//                                       if (state
//                                           is EditPostContentSuccessState) {
//                                         listOfPostModel = state.postmodelItems;
//                                       }
//                                       if (state is DelPostUserSuccessState) {
//                                         listOfPostModel = state.postmodelItems;
//                                       }
//                                       if (state
//                                           is GetFollowersPostSuccessState) {
//                                         //listOfFollowersPostModel = state.posts;

//                                         setState(() {});
//                                       }
//                                       if (state is SavePostSuccessState) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                                 generalSnackBar(state.message));
//                                       }
//                                       if (state is SharePostSuccessState) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                                 generalSnackBar(state.message));
//                                       }
//                                       if (state
//                                           is CreateVideoPostSuccessState) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           generalSnackBar(
//                                             "Post has been created ",
//                                           ),
//                                         );
//                                         context.read<PostBloc>().add(
//                                             GetAllVideoPostsEvent(
//                                                 isRefresh: true));
//                                         // context.pop();
//                                       }
//                                     },
//                                     builder: (context, state) {
//                                       List<PostModel> listOfDisplayedPostModel =
//                                           (selectedCategory == "Following")
//                                               ? listOfFollowersPostModel
//                                               : listOfPostModel;
//                                       //**WIDGET SHIMMER LOADING SHOWING THE LOADING STATE OF THE FEEDS */
//                                       if (listOfDisplayedPostModel.isEmpty) {
//                                         if (theListOfPreviouslyStoredPostModelListG
//                                             .isNotEmpty) {
//                                           return ListView.builder(
//                                             padding: EdgeInsets.only(
//                                               bottom: 120.0,
//                                             ),
//                                             shrinkWrap:
//                                                 true, // Important inside SingleChildScrollView
//                                             physics:
//                                                 const NeverScrollableScrollPhysics(), // Disable inner scrolling
//                                             itemCount: isLoadingMore
//                                                 ? theListOfPreviouslyStoredPostModelListG
//                                                         .length +
//                                                     1
//                                                 : theListOfPreviouslyStoredPostModelListG
//                                                     .length,
//                                             itemBuilder: (context, index) {
//                                               //GETTING THE AVATAR DEFAULT VALUE AND THEN EXTRACT IT TO THE IMAGEURL
//                                               if (index <
//                                                   theListOfPreviouslyStoredPostModelListG
//                                                       .length) {
//                                                 // Use the new FeedItemWidget
//                                                 return Column(
//                                                   children: [
//                                                     //**THIS IS THE POST WIDGET AFTER TH FIRST THREE POST, THE VIDEO REELS */

//                                                     InkWell(
//                                                         onTap: () =>
//                                                             context.goNamed(
//                                                                 MyAppRouteConstant
//                                                                     .postScreen,
//                                                                 extra: {
//                                                                   "model": CreatePostModel
//                                                                       .fromPostModel(
//                                                                           theListOfPreviouslyStoredPostModelListG[
//                                                                               index])
//                                                                 }),
//                                                         child: PostWidget(
//                                                           isFromOffline: true,
//                                                           postModelItems:
//                                                               theListOfPreviouslyStoredPostModelListG,
//                                                           postIndex: index,
//                                                           postModel:
//                                                               theListOfPreviouslyStoredPostModelListG[
//                                                                   index],
//                                                           authorId: '',
//                                                           // updateClappCount
//                                                           updatePostClappCount:
//                                                               (postInfo) {
//                                                             setState(() {
//                                                               print(
//                                                                   '----This is the clapp count ${postInfo.claps}');
//                                                               // ${int.tryParse(postInfo.claps ?? '0').toString()}');
//                                                               theListOfPreviouslyStoredPostModelListG[
//                                                                       index]
//                                                                   .clapCount = int.tryParse(postInfo
//                                                                       .claps ??
//                                                                   theListOfPreviouslyStoredPostModelListG[
//                                                                           index]
//                                                                       .clapCount
//                                                                       .toString());
//                                                             });
//                                                           },
//                                                           //THIS IS THE COMMENT COUNT
//                                                           updatePostCommentCount:
//                                                               (commentCount) {
//                                                             theListOfPreviouslyStoredPostModelListG[
//                                                                         index]
//                                                                     .commentCount =
//                                                                 int.tryParse(
//                                                                     commentCount);
//                                                           },
//                                                           //THIS IS THE POST SHARED COUNT
//                                                           updatePostSharedCount:
//                                                               (sharedCount) {
//                                                             theListOfPreviouslyStoredPostModelListG[
//                                                                         index]
//                                                                     .sharedCount =
//                                                                 int.tryParse(
//                                                                     sharedCount);
//                                                           },
//                                                         )),
//                                                     Divider(
//                                                       thickness: 0.2,
//                                                       height: 0.2,
//                                                       color: const Color(
//                                                           0xFFE5E7EB), // soft gray like the UI
//                                                     )
//                                                   ],
//                                                 );
//                                               } else {
//                                                 return Center(
//                                                     child:
//                                                         CircularProgressIndicator
//                                                             .adaptive(
//                                                   backgroundColor: Colors.white,
//                                                 ));
//                                               }
//                                               //* PostWidget
//                                             },
//                                           );
//                                         }
//                                         return Skeletonizer(
//                                           effect: PulseEffect(
//                                             from: Colors.grey[600]!,
//                                             to: Colors.grey[100]!,
//                                           ),
//                                           child: ListView.builder(
//                                             padding: const EdgeInsets.only(
//                                                 bottom: 120.0),
//                                             shrinkWrap:
//                                                 true, // Important inside SingleChildScrollView
//                                             physics:
//                                                 const NeverScrollableScrollPhysics(), // Disable inner scrolling
//                                             itemCount: 4,
//                                             itemBuilder: (context, index) {
//                                               final post = PostModel(
//                                                   postId: 'postId',
//                                                   type: PostType.image,
//                                                   creatorId: 'creatorId',
//                                                   content: 'content');
//                                               //**EACH ITEM OF THE FEED OR POST ITET
//                                               return FeedItemWidget(
//                                                 postModel: post,
//                                                 isDummy: true,
//                                                 livePostIdCallback: (postId) {},
//                                               ); //* PostWidget
//                                             },
//                                           ),
//                                         );
//                                       }
//                                       //**ERROR WIDGET SHOWING WHEN THE FEED ENCOUNTER AN ERROR */
//                                       if (state is GetAllPostsErrorState) {
//                                         if (state.errorMessage ==
//                                             "No posts found") {
//                                           return Center(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(20.0),
//                                               child: Text(
//                                                 state.errorMessage,
//                                                 style: const TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 20),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                           );
//                                         }
//                                         return Center(
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(20.0),
//                                             child: Text(
//                                               'Failed to load posts: ${state.errorMessage}',
//                                               style: const TextStyle(
//                                                   color: Colors.red),
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         );
//                                       }

//                                       return ListView.builder(
//                                         padding: EdgeInsets.only(
//                                           bottom: 120.0,
//                                         ),
//                                         shrinkWrap:
//                                             true, // Important inside SingleChildScrollView
//                                         physics:
//                                             const NeverScrollableScrollPhysics(), // Disable inner scrolling
//                                         itemCount: isLoadingMore
//                                             ? listOfDisplayedPostModel.length +
//                                                 1
//                                             : listOfDisplayedPostModel.length,
//                                         itemBuilder: (context, index) {
//                                           //GETTING THE AVATAR DEFAULT VALUE AND THEN EXTRACT IT TO THE IMAGEURL
//                                           if (index <
//                                               listOfDisplayedPostModel.length) {
//                                             // Use the new FeedItemWidget
//                                             return Column(
//                                               children: [
//                                                 //**THIS IS THE POST WIDGET AFTER TH FIRST THREE POST, THE VIDEO REELS */

//                                                 InkWell(
//                                                     onTap: () => context.goNamed(
//                                                             MyAppRouteConstant
//                                                                 .postScreen,
//                                                             extra: {
//                                                               "model": CreatePostModel
//                                                                   .fromPostModel(
//                                                                       listOfDisplayedPostModel[
//                                                                           index])
//                                                             }),
//                                                     child: PostWidget(
//                                                       postModelItems:
//                                                           listOfDisplayedPostModel,
//                                                       postIndex: index,
//                                                       postModel:
//                                                           listOfDisplayedPostModel[
//                                                               index],
//                                                       authorId: '',
//                                                       // updateClappCount
//                                                       updatePostClappCount:
//                                                           (postInfo) {
//                                                         setState(() {
//                                                           print(
//                                                               '----This is the clapp count ${postInfo.claps}');
//                                                           // ${int.tryParse(postInfo.claps ?? '0').toString()}');
//                                                           listOfDisplayedPostModel[
//                                                                       index]
//                                                                   .clapCount =
//                                                               int.tryParse(postInfo
//                                                                       .claps ??
//                                                                   listOfDisplayedPostModel[
//                                                                           index]
//                                                                       .clapCount
//                                                                       .toString());
//                                                         });
//                                                       },
//                                                       //THIS IS THE COMMENT COUNT
//                                                       updatePostCommentCount:
//                                                           (commentCount) {
//                                                         listOfDisplayedPostModel[
//                                                                     index]
//                                                                 .commentCount =
//                                                             int.tryParse(
//                                                                 commentCount);
//                                                       },
//                                                       //THIS IS THE POST SHARED COUNT
//                                                       updatePostSharedCount:
//                                                           (sharedCount) {
//                                                         listOfDisplayedPostModel[
//                                                                     index]
//                                                                 .sharedCount =
//                                                             int.tryParse(
//                                                                 sharedCount);
//                                                       },
//                                                     )),
//                                                 Divider(
//                                                   thickness: 0.2,
//                                                   height: 0.2,
//                                                   color: const Color(
//                                                       0xFFE5E7EB), // soft gray like the UI
//                                                 )
//                                               ],
//                                             );
//                                           } else {
//                                             return Center(
//                                                 child: CircularProgressIndicator
//                                                     .adaptive(
//                                               backgroundColor: Colors.white,
//                                             ));
//                                           }
//                                           //* PostWidget
//                                         },
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             if (liveLoading)
//                               Positioned.fill(
//                                 child: AbsorbPointer(
//                                   absorbing: true,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.black.withAlpha(200)),
//                                     child: Center(
//                                       child: Text("Loading...",
//                                           style: TextStyle(
//                                               fontFamily: 'Poppins',
//                                               fontWeight: FontWeight.w900,
//                                               fontSize: 20.sp)),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             Visibility(
//                               visible: state is SavePostLoadingState ||
//                                   state is SharePostLoadingState,
//                               child: Container(
//                                 color: Colors.black45,
//                                 alignment: Alignment.center,
//                                 child: CircularProgressIndicator.adaptive(),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // ... (FloatingActionButton remains the same)

//               // Add this at the top of your file

//               // Add this at the top of your file
//               floatingActionButton: FloatingActionButton(
//                 onPressed: () {
//                   showGeneralDialog(
//                     context: context,
//                     barrierColor: Colors.black
//                         .withOpacity(0.3), // Semi-transparent barrier
//                     barrierDismissible: true,
//                     barrierLabel: 'Dismiss',
//                     transitionDuration: const Duration(milliseconds: 200),
//                     pageBuilder: (context, animation, secondaryAnimation) {
//                       return SafeArea(
//                         child: Stack(
//                           children: [
//                             // BLUR OVERLAY - Blurs the content underneath
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.of(context)
//                                     .pop(); // Dismiss when tapping blur area
//                               },
//                               child: BackdropFilter(
//                                 filter:
//                                     ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                                 child: Container(
//                                   color: Colors.black
//                                       .withOpacity(0.1), // Slight dark tint
//                                 ),
//                               ),
//                             ),

//                             // ACTION BUTTONS
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 30),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     // ===================== GO LIVE =====================
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         const Text(
//                                           'Go Live',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontFamily: 'Geist',
//                                             fontWeight: FontWeight.w700,
//                                             fontSize: 20,
//                                             decoration: TextDecoration.none,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 10),
//                                         GestureDetector(
//                                           onTap: () {
//                                             context.pop();
//                                             context.push(
//                                                 MyAppRouteConstant.challenge);
//                                           },
//                                           child: Image.asset(
//                                             'assets/images/golive.png',
//                                             height: 40,
//                                             width: 40,
//                                           ),
//                                         ),
//                                       ],
//                                     ),

//                                     const SizedBox(height: 20),

//                                     // ===================== BRAG =====================
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         FancyContainer(
//                                           isAsync: false,
//                                           radius: 12,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 16, vertical: 10),
//                                           backgroundColor:
//                                               Colors.white.withOpacity(0.15),
//                                           child: const Text(
//                                             'Brag',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontFamily: 'Geist',
//                                               fontWeight: FontWeight.w700,
//                                               fontSize: 18,
//                                               decoration: TextDecoration.none,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 10),
//                                         GestureDetector(
//                                           onTap: () {
//                                             context.pop();
//                                             context.push(
//                                                 MyAppRouteConstant.newBrag);
//                                           },
//                                           child: Image.asset(
//                                             'assets/images/brag.png',
//                                             height: 40,
//                                             width: 40,
//                                           ),
//                                         ),
//                                       ],
//                                     ),

//                                     const SizedBox(height: 20),
//                                     // ===================== CREATE POST =====================
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         FancyContainer(
//                                           isAsync: false,
//                                           radius: 12,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 16, vertical: 10),
//                                           backgroundColor:
//                                               Colors.white.withOpacity(0.15),
//                                           child: const Text(
//                                             'Create Post',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontFamily: 'Geist',
//                                               fontWeight: FontWeight.w700,
//                                               fontSize: 18,
//                                               decoration: TextDecoration.none,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 10),
//                                         GestureDetector(
//                                           onTap: () {
//                                             context.pop();
//                                             context.push(
//                                                 MyAppRouteConstant.postEmpty);
//                                           },
//                                           child: Image.asset(
//                                             'assets/images/my message.png',
//                                             height: 40,
//                                             width: 40,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },

//                     // ANIMATION
//                     transitionBuilder:
//                         (context, animation, secondaryAnimation, child) {
//                       return FadeTransition(
//                         opacity: CurvedAnimation(
//                           parent: animation,
//                           curve: Curves.easeOut,
//                         ),
//                         child: SlideTransition(
//                           position: Tween<Offset>(
//                             begin: const Offset(0, 0.05),
//                             end: Offset.zero,
//                           ).animate(animation),
//                           child: child,
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 backgroundColor: Colors.black,
//                 elevation: 0,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     FancyContainer(
//                       backgroundColor: AppColors.primaryColor,
//                       radius: 15,
//                       height: 50.h,
//                       width: 50.w,
//                     ),
//                     const Icon(
//                       Icons.add,
//                       color: Colors.white,
//                       size: 24.0,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }

//   SingleChildScrollView _buildFormerShowCase() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ShowcaseWidget(
//                         theShowCaseController: ShowCaseController(
//                             theListOfConfigurationDetails: howComboWorks),
//                       ),
//                     ));
//               },
//               child: Column(
//                 children: [
//                   AnimatedStatusBorder(
//                     child: Image.asset('assets/images/lie.png'),
//                   ),
//                   SizedBox(height: 6.h),
//                   Text('Combo Ground')
//                 ],
//               )),
//           const SizedBox(width: 12),
//           GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ShowcaseWidget(
//                         theShowCaseController: ShowCaseController(
//                             theListOfConfigurationDetails: singleLiveStream),
//                       ),
//                     ));
//               },
//               child: Column(
//                 children: [
//                   AnimatedStatusBorder(
//                     child: SvgPicture.asset('assets/images/singlelive.svg'),
//                   ),
//                   SizedBox(height: 6.h),
//                   Text('Livestream')
//                 ],
//               )),
//           const SizedBox(width: 12),
//           GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ShowcaseWidget(
//                         theShowCaseController: ShowCaseController(
//                             theListOfConfigurationDetails: challengeRequest),
//                       ),
//                     ));
//               },
//               child: Column(
//                 children: [
//                   AnimatedStatusBorder(
//                     child: Image.asset('assets/images/lie.png'),
//                   ),
//                   SizedBox(height: 6.h),
//                   Text('Challege')
//                 ],
//               )),
//           const SizedBox(width: 12),
//           GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ShowcaseWidget(
//                         theShowCaseController: ShowCaseController(
//                             theListOfConfigurationDetails: moneyDeposit),
//                       ),
//                     ));
//               },
//               child: Column(
//                 children: [
//                   AnimatedStatusBorder(
//                     child: Image.asset('assets/images/money.png'),
//                   ),
//                   SizedBox(height: 6.h),
//                   Text('Deposit')
//                 ],
//               )),
//           const SizedBox(width: 12),
//           GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ShowcaseWidget(
//                         theShowCaseController: ShowCaseController(
//                             theListOfConfigurationDetails: withdrawMoney),
//                       ),
//                     ));
//               },
//               child: Column(
//                 children: [
//                   AnimatedStatusBorder(
//                     child: Image.asset('assets/images/ri.png'),
//                   ),
//                   SizedBox(height: 6.h),
//                   Text('Withdrawal')
//                 ],
//               )),
//           const SizedBox(width: 12),
//           GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ShowcaseWidget(
//                         theShowCaseController: ShowCaseController(
//                             theListOfConfigurationDetails: howtoGift),
//                       ),
//                     ));
//               },
//               child: Column(
//                 children: [
//                   AnimatedStatusBorder(
//                     child: Image.asset('assets/images/co.png'),
//                   ),
//                   SizedBox(height: 6.h),
//                   Text('Gift coin')
//                 ],
//               )),
//           const SizedBox(width: 12),
//           GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ShowcaseWidget(
//                         theShowCaseController: ShowCaseController(
//                             theListOfConfigurationDetails: howtoBuypoint),
//                       ),
//                     ));
//               },
//               child: Column(
//                 children: [
//                   AnimatedStatusBorder(
//                       child: SvgPicture.asset('assets/icons/buy.svg')),
//                   SizedBox(height: 6.h),
//                   Text('Buy Point')
//                 ],
//               )),
//           const SizedBox(width: 12),
//           GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ShowcaseWidget(
//                         theShowCaseController: ShowCaseController(
//                             theListOfConfigurationDetails: wallet),
//                       ),
//                     ));
//               },
//               child: Column(
//                 children: [
//                   AnimatedStatusBorder(
//                       child: SvgPicture.asset('assets/icons/wallet2.svg')),
//                   SizedBox(height: 6.h),
//                   Text('Wallet')
//                 ],
//               )),
//           const SizedBox(width: 12),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ShowcaseWidget(
//                       theShowCaseController: ShowCaseController(
//                           theListOfConfigurationDetails: reward),
//                     ),
//                   ));
//             },
//             child: Column(
//               children: [
//                 AnimatedStatusBorder(
//                     child: SvgPicture.asset('assets/icons/reward.svg')),
//                 SizedBox(height: 6.h),
//                 Text('Reward')
//               ],
//             ),
//           ),
//           // AnimatedStatusBorder(
//           //   child: Image.asset('assets/images/tee.png'),
//           // ),
//           // const SizedBox(width: 12),
//           // AnimatedStatusBorder(
//           //   child: Image.asset('assets/images/shop.png'),
//           // ),
//           // AnimatedStatusBorder(
//           //   child: Image.asset('assets/images/dee.png'),
//           // ),
//           // AnimatedStatusBorder(
//           //   child: Image.asset('assets/images/block.png'),
//           // ),
//         ],
//       ),
//     );
//   }

//   ShowCaseController theShowCaseController = ShowCaseController();
//   bool loadingMore = true;
// }

// class ReactionPanelHorizontal extends StatefulWidget {
//   final CreatePostModel? model;
//   final Function(PostClappedReaction)? updatePostClappCount;
//   final Function(String)? updatePostCommentCount;
//   final Function(String)? updatePostSharedCount;
//   const ReactionPanelHorizontal({
//     super.key,
//     this.model,
//     this.updatePostClappCount,
//     this.updatePostCommentCount,
//     this.updatePostSharedCount,
//   });

//   @override
//   State<ReactionPanelHorizontal> createState() =>
//       _ReactionPanelHorizontalState();
// }

// class _ReactionPanelHorizontalState extends State<ReactionPanelHorizontal> {
//   bool isSaved = false;
//   bool isClaped = false;
//   //CreatePostModel? localPostModel; // Change to PostModel
//   String? liveReactionClappCount;

//   @override
//   void initState() {
//     // localPostModel = widget.model;
//     syncNumbers();

//     super.initState();
//   }

//   syncNumbers() {
//     // Adapt these fields based on PostModel structure
//     isClaped = widget.model?.hasClapped ?? false;
//     isSaved = widget.model?.hasSaved ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // BlocConsumer might need adjustments depending on how reactions are handled now
//     return BlocConsumer<PostBloc, PostState>(listener: (context, state) {
//       if (state is ClapPostErrorState) {
//         isClaped = false;
//         setState(() {});
//       }
//       // if(state is ClapPostSuccessState){
//       //   // print("SUCCESFULL CLAPP OF A POST");
//       //   context.read<ChatsAndSocialsBloc>().add(ChatSubscriptionRequestEvent());
//       // }
//     }, builder: (context, state) {
//       return BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
//         listener: (context, state) {
//           //**STATE UPDATING THE POST CLAPP NUMBER */
//           if (state is PostClappCount) {
//             if (state.reaction.post == widget.model?.uuid) {
//               print('This is the post that is being clapped');
//               widget.updatePostClappCount!(state.reaction);
//             }
//           }
//           //STATE TO UPDATE THE SHARE COUNT
//           if (state is PostSharedCount) {
//             if (state.post.post == widget.model?.uuid) {
//               widget.updatePostSharedCount!(state.post.shares ?? '');
//             }
//           }
//           //STATE TO UPDATE THE COMMENT COUNT
//           if (state is PostCommentCount) {
//             if (state.postComment.post == widget.model?.uuid) {
//               widget.updatePostCommentCount!(state.postComment.comments ?? '');
//             }
//           }
//         },
//         builder: (context, state) {
//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               /// crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 //**CLAP ICON */
//                 FancyContainer(
//                   isAsync: false,
//                   action: () async {
//                     // Safety: model must exist
//                     final model = widget.model;
//                     if (model == null) {
//                       debugPrint('Clap aborted: model is null');
//                       return;
//                     }
//                     final postId = model.uuid;
//                     if (postId == null || postId.isEmpty) {
//                       debugPrint('Clap aborted: postId is null or empty');
//                       return;
//                     }
//                     int currentClaps = model.clapCount ?? 0;
//                     int clapAmount = currentClaps;
//                     if (isClaped) {
//                       // UNCLAP
//                       debugPrint('UNCLAPPING A POST');

//                       clapAmount = currentClaps > 0 ? currentClaps - 1 : 0;
//                       debugPrint('This is the pressed decrement $clapAmount');
//                       context.read<PostBloc>().add(
//                             UnclapPostEvent(postID: postId),
//                           );
//                     } else {
//                       // CLAP
//                       debugPrint('CLAPPING THE POST');
//                       clapAmount = currentClaps + 1;
//                       debugPrint('This is the pressed increment $clapAmount');
//                       context.read<PostBloc>().add(
//                             ClapPostEvent(postID: postId),
//                           );
//                       theclapAnimationController.reset();
//                       theclapAnimationController.forward();
//                     }
//                     // ✅ SAFE callback call (NO CRASH)
//                     widget.updatePostClappCount?.call(
//                       PostClappedReaction(
//                         post: postId,
//                         claps: clapAmount.toString(),
//                       ),
//                     );
//                     // Toggle state
//                     isClaped = !isClaped;
//                     if (mounted) {
//                       setState(() {});
//                     }
//                   },
//                   height: 30,
//                   width: 50,
//                   child: Row(
//                     children: [
//                       FancyContainer(
//                         child: Image.asset(
//                           !isClaped
//                               ? "assets/icons/clapFalse.png"
//                               : "assets/icons/clapTrue.png",
//                           height: 20,
//                           width: 20,
//                           color: !isClaped
//                               ? getFigmaColor("8C8C8C")
//                               : getFigmaColor("006FCD"),
//                         ),
//                       ),
//                       const SizedBox(width: 7),
//                       Text(
//                         "${widget.model?.clapCount ?? 0}",
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           color: getFigmaColor("8C8C8C"),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 //**COMMENT ICON */
//                 GestureDetector(
//                   onTap: () {
//                     context.pushNamed(MyAppRouteConstant.postScreen,
//                         extra: widget.model?.uuid);
//                   },
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         "assets/images/comment.svg",
//                         color: getFigmaColor("8C8C8C"),
//                       ),
//                       const SizedBox(width: 7),
//                       Text(
//                         "${widget.model?.commentCount ?? 0}",
//                         style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13,
//                             color:
//                                 getFigmaColor("8C8C8C")), // Use PostModel field
//                       ),
//                     ],
//                   ),
//                 ),
//                 //**CHALLENGE POST ICON */
//                 FancyContainer(
//                     padding: EdgeInsets.zero,
//                     height: 30,
//                     width: 40,
//                     action: () async {
//                       (widget.model?.author != profileModelG?.pid)
//                           //OPEN THE CHALLENGE POST MODAL SHEET
//                           //I NEED A CHALLENGER AND THE HOST DETAILS TO BE PASSED HERE
//                           //THE USER HERE IS THE ONE CHALLENGING OTHER USERS POST
//                           ? widget.model?.challenger_properties
//                                       ?.has_created_combo ==
//                                   true
//                               ? challengDialogErrorBox(context)
//                               : showModalBottomSheet(
//                                   context: context,
//                                   builder: (context) => ChallengeBox(
//                                     challenger: profileModelG,
//                                     postId: widget.model?.uuid ?? '',
//                                     isPostChallenge: widget
//                                             .model
//                                             ?.challenger_properties
//                                             ?.has_challenged ??
//                                         false,
//                                     challengeId: widget
//                                             .model
//                                             ?.challenger_properties
//                                             ?.challenge ??
//                                         '',
//                                   ),
//                                 )
//                           //THE USER IS THE ONE WHOSE POST IS BEING CHALLENGED, HENCE; HE IS THE HOST
//                           : showModalBottomSheet(
//                               context: context,
//                               builder: (context) =>
//                                   PostChallengeNotificationListBottom(
//                                 postId: widget.model?.uuid ?? '',
//                                 host: profileModelG,
//                                 isStandard: true,
//                               ),
//                             );
//                     },
//                     child: Row(
//                       children: [
//                         Image.asset(
//                           "assets/icons/Live Combo.png",
//                           height: 20,
//                           width: 20,
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text(
//                           "${widget.model?.challenges ?? 0}",
//                           style: TextStyle(
//                             color: getFigmaColor("8C8C8C"),
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     )),

//                 //**SAVE POST ICON */
//                 FancyContainer(
//                   height: 30,
//                   width: 40,
//                   isAsync: false,
//                   action: () {
//                     // TODO: Implement save action using PostBloc and PostModel
//                     isSaved = !isSaved;
//                     if (mounted) {
//                       setState(() {});
//                     }
//                     context.read<PostBloc>().add(
//                           SavePostEvent(
//                             postID: widget.model?.uuid ?? "",
//                             //localPostModel?.uuid ?? "",
//                           ),
//                         );
//                   },
//                   child: Image.asset(
//                     (isSaved)
//                         ? "assets/icons/saveTrue.png"
//                         : "assets/icons/saveFalse.png",
//                     height: 20,
//                     width: 20,
//                     color: getFigmaColor("8C8C8C"),
//                   ),
//                 ),
//                 //**SHARE POST ICON */
//                 FancyContainer(
//                   isAsync: false,
//                   height: 30,
//                   width: 40,
//                   action: () async {
//                     final result = await SharePlus.instance.share(ShareParams(
//                         title: 'Check out the Post',
//                         text:
//                             'Check out the post on clapmi https://app.clapmi.com/posts/${widget.model?.uuid}'));

//                     if (result.status == ShareResultStatus.success) {
//                       context.read<PostBloc>().add(
//                             SharePostEvent(
//                               postID: widget.model?.uuid ?? "",
//                               //localPostModel?.uuid ?? "",
//                             ),
//                           );
//                     }
//                   },
//                   child: Row(
//                     mainAxisSize: MainAxisSize
//                         .min, // Prevents row from expanding unnecessarily
//                     children: [
//                       Image.asset(
//                         "assets/icons/Vector (13).png",
//                         height: 20,
//                         width: 20,
//                         color: getFigmaColor("8C8C8C"),
//                       ),
//                       const SizedBox(width: 7),
//                       Flexible(
//                         // Ensures text doesn't overflow
//                         child: Text(
//                           "${widget.model?.sharedCount ?? 0}",
//                           overflow:
//                               TextOverflow.ellipsis, // Clips if still too long
//                           style: TextStyle(
//                             color: getFigmaColor("8C8C8C"),
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 //**GIFT COIN ICON */
//                 if (widget.model?.author != profileModelG?.pid)
//                   GestureDetector(
//                     onTap: () {
//                       showGiftCapcoinBottomSheet(
//                         context,
//                         creatorID: widget.model?.author ?? "",
//                         // localPostModel?.author ?? '',
//                         recipientUsername: widget.model?.authorName ??
//                             '', // put the real username here
//                       ); // Call the showBottomSheet function here
//                     },
//                     child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 5, vertical: 5),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             color: Color(
//                                 0XFF003D71) // Use your primary color if needed
//                             ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Gift",
//                               style: TextStyle(
//                                 fontFamily: 'Geist',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 12,
//                                 color: getFigmaColor("FFFFFF"),
//                                 decoration: TextDecoration.none,
//                               ),
//                             ),
//                             Image.asset(
//                               "assets/images/lolo.png",
//                               height: 22,
//                               width: 22,
//                               fit: BoxFit.contain,
//                             ),
//                           ],
//                         )),
//                   ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }
// }

// class ReactionPanelHorizontalForComment extends StatefulWidget {
//   final CommentModel? model;
//   final Function(bool isVisible)? functionToMakeRepliesVisibleOrNot;
//   final Function()? functionToSetTextFieldBoxForReplying;
//   final Function(CommentModel commentModel) functionToSetComentModel;
//   final Function()? updateModel;

//   const ReactionPanelHorizontalForComment({
//     super.key,
//     this.model,
//     this.functionToMakeRepliesVisibleOrNot,
//     required this.updateModel,
//     this.functionToSetTextFieldBoxForReplying,
//     required this.functionToSetComentModel,
//   });

//   @override
//   State<ReactionPanelHorizontalForComment> createState() =>
//       _ReactionPanelHorizontalForCommentState();
// }

// class _ReactionPanelHorizontalForCommentState
//     extends State<ReactionPanelHorizontalForComment> {
//   bool isClaped = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // // FIRST ROW: Claps + Comments + Shares + Views
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.end,
//           //   children: [
//           //     _countText("Claps 4k"),
//           //     const SizedBox(width: 16),
//           //     _countText("Comments 3"),
//           //     const SizedBox(width: 16),
//           //     const SizedBox(width: 16),
//           //     _countText("Views 65"),
//           //   ],
//           // ),

//           const SizedBox(height: 8),
//           // SECOND ROW: Reaction Buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               // CLAP SECTION
//               GestureDetector(
//                 onTap: () {
//                   setState(() => isClaped = !isClaped);
//                   widget.updateModel?.call();
//                 },
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       isClaped
//                           ? "assets/icons/clapTrue.png"
//                           : "assets/icons/clapFalse.png",
//                       height: 20,
//                       width: 20,
//                       color: isClaped
//                           ? getFigmaColor("FFFFFF")
//                           : getFigmaColor("8C8C8C"),
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       "Clap",
//                       style: TextStyle(
//                         color: getFigmaColor("8C8C8C"),
//                         fontSize: 13,
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 30),

//               // COMMENT SECTION
//               GestureDetector(
//                 onTap: () {
//                   widget.functionToSetTextFieldBoxForReplying?.call();
//                   widget.functionToSetComentModel.call(widget.model!);
//                 },
//                 child: Row(
//                   children: [
//                     SvgPicture.asset(
//                       "assets/images/comment.svg",
//                       color: getFigmaColor("8C8C8C"),
//                       height: 18,
//                       width: 18,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       "Comment",
//                       style: TextStyle(
//                         color: getFigmaColor("8C8C8C"),
//                         fontSize: 13,
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 30),

//               // GIFT BUTTON
//               if (profileModelG?.pid != widget.model?.authorPID)
//                 GestureDetector(
//                   onTap: () {
//                     showGiftCapcoinBottomSheet(
//                       context,
//                       creatorID: widget.model?.author ?? '',
//                       recipientUsername: 'zuri', // replace dynamically later
//                     );
//                   },
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       color: getFigmaColor("003D71"),
//                     ),
//                     child: Row(
//                       children: [
//                         const Text(
//                           "Gift",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 13,
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         Image.asset(
//                           "assets/icons/Group (11).png",
//                           height: 18,
//                           width: 18,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// void showGiftCapcoinBottomSheet(BuildContext context,
//     {required String recipientUsername, required String creatorID}) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.black,
//     builder: (context) {
//       // Pass the existing WalletBloc down so the sheet can dispatch events
//       final walletBloc = context.read<WalletBloc>();
//       return BlocProvider.value(
//         value: walletBloc,
//         child: _GiftCapcoinSheet(
//           recipientUsername: recipientUsername,
//           creatorID: creatorID,
//         ),
//       );
//     },
//   );
// }

// class _GiftCapcoinSheet extends StatefulWidget {
//   const _GiftCapcoinSheet({
//     required this.recipientUsername,
//     required this.creatorID,
//   });

//   final String recipientUsername;
//   final String creatorID;

//   @override
//   State<_GiftCapcoinSheet> createState() => _GiftCapcoinSheetState();
// }

// class _GiftCapcoinSheetState extends State<_GiftCapcoinSheet> {
//   final _formKey = GlobalKey<FormState>();
//   final _amountCtrl = TextEditingController();
//   bool _isLoading = false;
//   late FocusNode _focusNode;
//   int? _quickAmountIndex;
//   String currentAmount = '0.00';
//   String? _balanceError;

//   @override
//   void dispose() {
//     _amountCtrl.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//     context.read<WalletBloc>().add(GetAvailableCoinEvent());
//   }

//   /// ✅ REAL-TIME BALANCE VALIDATION
//   void _validateBalance(String value) {
//     if (value.isEmpty) {
//       setState(() {
//         _balanceError = null;
//       });
//       return;
//     }

//     final amount = int.tryParse(value);
//     if (amount == null) {
//       setState(() {
//         _balanceError = null;
//       });
//       return;
//     }

//     // ✅ Parse available balance correctly
//     final availableBalance = double.tryParse(currentAmount) ?? 0.0;

//     if (amount < 10) {
//       setState(() {
//         _balanceError = 'Minimum gift is 10';
//       });
//     } else if (amount > availableBalance) {
//       setState(() {
//         _balanceError =
//             'Insufficient balance. You have ${availableBalance.toStringAsFixed(0)} CAPP';
//       });
//     } else {
//       setState(() {
//         _balanceError = null;
//       });
//     }
//   }

//   /// 🎉 SHOW SUCCESS MODAL
//   void _showSuccessModal(int giftedAmount) {
//     Navigator.pop(context); // Close the gift sheet first

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       isDismissible: true,
//       enableDrag: true,
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Container(
//           height: MediaQuery.of(context).size.height * 0.65,
//           decoration: BoxDecoration(
//             color: Theme.of(context).scaffoldBackgroundColor,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: GiftingSuccessful(
//             name: widget.recipientUsername,
//             selectedPoint: giftedAmount,
//           ),
//         ),
//       ),
//     );
//   }

//   bool isLoadingAmount = false;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         top: 20.h,
//         left: 20.w,
//         right: 20.w,
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: BlocConsumer<WalletBloc, WalletState>(
//         listener: (context, state) {
//           if (state is WalletLoading) {
//             isLoadingAmount = true;
//             setState(() {});
//           }
//           if (state is WalletError) {
//             isLoadingAmount = false;
//             setState(() {});
//           }
// // WalletError
//           /// ✅ AVAILABLE COIN LOADED

//           if (state is AvailableClappCoinLoaded) {
//             isLoadingAmount = false;
//             setState(() {
//               currentAmount = state.amount;
//             });
//             // Re-validate when balance updates
//             if (_amountCtrl.text.isNotEmpty) {
//               _validateBalance(_amountCtrl.text);
//             }
//           }

//           /// ❌ ERROR HANDLING
//           if (state is GiftUserErrorState) {
//             setState(() {
//               _isLoading = false;
//             });

//             String errorMessage = state.errorMessage;
//             print('$errorMessage ******');

//             /// 🔍 HANDLE INSUFFICIENT BALANCE
//             if (errorMessage.toLowerCase().contains('insufficient')) {
//               errorMessage =
//                   'You don\'t have enough Clapcoins to complete this gift';
//             }

//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 backgroundColor: Colors.red,
//                 content: Text(errorMessage),
//               ),
//             );
//           }

//           /// ✅ SUCCESS - SHOW SUCCESS MODAL
//           if (state is GiftUserSuccessState) {
//             setState(() {
//               _isLoading = false;
//             });

//             final giftedAmount = int.tryParse(_amountCtrl.text.trim()) ?? 0;
//             _showSuccessModal(giftedAmount);
//           }

//           /// ⏳ LOADING
//           if (state is GiftUserLoadingState) {
//             setState(() {
//               _isLoading = true;
//             });
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Center(
//                     child: Text(
//                       'Gift Clapcoin',
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 30.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Gift @${widget.recipientUsername}',
//                         style: TextStyle(fontSize: 14.sp),
//                       ),
//                       SizedBox(width: 20.w),
//                       Expanded(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: isLoadingAmount
//                               ? [
//                                   SizedBox.square(
//                                     dimension: 30,
//                                     child: CircularProgressIndicator.adaptive(),
//                                   )
//                                 ]
//                               : [
//                                   ClipOval(
//                                     child: Image.asset(
//                                       'assets/images/coin_big.png',
//                                       height: 24,
//                                       width: 24,
//                                     ),
//                                   ),
//                                   SizedBox(width: 4.w),
//                                   Text(
//                                     double.tryParse(currentAmount)
//                                             ?.toStringAsFixed(2) ??
//                                         '0.00',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .displayMedium
//                                         ?.copyWith(
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: 23,
//                                         ),
//                                   ),
//                                   Text(
//                                     'CAPP',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .displayMedium
//                                         ?.copyWith(
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: 23,
//                                         ),
//                                   ),
//                                 ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 8.h),

//                   !isLoadingAmount
//                       ? Align(
//                           alignment: Alignment.centerRight,
//                           child: Text(
//                             '\$ ${((double.tryParse(currentAmount) ?? 0.0) / 100).toStringAsFixed(2)} USD',
//                             style:
//                                 Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                       fontSize: 13,
//                                       color: const Color(0xFF8F9090),
//                                     ),
//                           ),
//                         )
//                       : SizedBox(
//                           height: 10,
//                         ),

//                   SizedBox(height: 15.h),

//                   /// QUICK AMOUNTS (START FROM 10)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: List.generate(3, (index) {
//                       const presetAmounts = [10, 20, 50];
//                       final amount = presetAmounts[index];
//                       final selected = _quickAmountIndex == index;

//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _quickAmountIndex = index;
//                             _amountCtrl.text = amount.toString();
//                           });
//                           // ✅ Validate immediately when quick amount is selected
//                           _validateBalance(amount.toString());
//                         },
//                         child: Container(
//                           width: 0.29.sw,
//                           height: 70.h,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(14),
//                             border: Border.all(
//                               color: selected ? Colors.blue : Colors.grey,
//                               width: 1.2,
//                             ),
//                           ),
//                           child: Center(
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Image.asset(
//                                   'assets/icons/mavin.png',
//                                   height: 22,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   '$amount',
//                                   style: TextStyle(
//                                     fontSize: 18.sp,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),

//                   SizedBox(height: 25.h),

//                   /// AMOUNT INPUT
//                   Text(
//                     'Amount',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Colors.white24,
//                     ),
//                   ),
//                   SizedBox(height: 10.h),

//                   TextFormField(
//                     controller: _amountCtrl,
//                     keyboardType: TextInputType.number,
//                     onChanged: (val) {
//                       // ✅ Clear quick amount selection when typing custom amount
//                       if (_quickAmountIndex != null) {
//                         setState(() {
//                           _quickAmountIndex = null;
//                         });
//                       }
//                       // ✅ VALIDATE IN REAL-TIME AS USER TYPES
//                       _validateBalance(val);
//                     },
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return 'Enter amount';
//                       }

//                       final amount = int.tryParse(val);
//                       if (amount == null || amount < 10) {
//                         return 'Minimum gift is 10';
//                       }

//                       final availableBalance =
//                           double.tryParse(currentAmount) ?? 0.0;
//                       if (amount > availableBalance) {
//                         return 'Insufficient balance. You have ${availableBalance.toStringAsFixed(0)} CAPP';
//                       }

//                       return null;
//                     },
//                     decoration: InputDecoration(
//                       hintText: '0',
//                       prefixIcon: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Image.asset(
//                           'assets/icons/mavin.png',
//                           height: 20,
//                         ),
//                       ),
//                       filled: true,
//                       fillColor: const Color(0xFF181919),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide.none,
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       errorStyle: const TextStyle(
//                         color: Colors.red,
//                       ),
//                     ),
//                   ),

//                   /// ✅ REAL-TIME ERROR MESSAGE DISPLAY
//                   if (_balanceError != null) ...[
//                     SizedBox(height: 8.h),
//                     Padding(
//                       padding: EdgeInsets.only(left: 12.w),
//                       child: Text(
//                         _balanceError!,
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 12.sp,
//                         ),
//                       ),
//                     ),
//                   ],

//                   SizedBox(height: 30.h),

//                   /// GIFT BUTTON
//                   GestureDetector(
//                     onTap: _isLoading || _balanceError != null ? null : _submit,
//                     child: Container(
//                       width: double.infinity,
//                       height: 56.h,
//                       decoration: BoxDecoration(
//                         color: _isLoading || _balanceError != null
//                             ? Colors.grey
//                             : Colors.blue,
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Center(
//                         child: _isLoading
//                             ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Text(
//                                 'Gift',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 15.h),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// 🚀 SUBMIT
//   void _submit() {
//     if (!_formKey.currentState!.validate()) return;

//     final amountInt = int.tryParse(_amountCtrl.text.trim());
//     if (amountInt == null || amountInt < 10) return;

//     final availableBalance = double.tryParse(currentAmount) ?? 0.0;
//     if (amountInt > availableBalance) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text('Insufficient balance'),
//         ),
//       );
//       return;
//     }

//     final giftEntity = GiftUserEntity(
//       amount: amountInt,
//       password: '',
//       to: widget.creatorID,
//       type: 'standard',
//     );

//     context.read<WalletBloc>().add(
//           GiftUserEvent(giftClapPointRequestEntity: giftEntity),
//         );
//   }
// }

// // Keep the getTagColor function as is
// Color? getTagColor(String? colorString) {
//   if (colorString == null) {
//     return null;
//   }
//   List colorValueList =
//       colorString.split("rgba(")[1].split(")")[0].split(",").map(
//     (e) {
//       if (colorString.split("rgba(")[1].split(")")[0].split(",").indexOf(e) <
//           3) {
//         return int.tryParse(e.trim());
//       } else {
//         return double.tryParse(e.trim());
//       }
//     },
//   ).toList();

//   return Color.fromRGBO(
//     colorValueList[0],
//     colorValueList[1],
//     colorValueList[2],
//     colorValueList[3],
//   );
// }

// class AnimatedStatusBorder extends StatefulWidget {
//   final Widget child;
//   final double size;
//   final double borderWidth;

//   const AnimatedStatusBorder({
//     super.key,
//     required this.child,
//     this.size = 52,
//     this.borderWidth = 2.5,
//   });

//   @override
//   State<AnimatedStatusBorder> createState() => _AnimatedStatusBorderState();
// }

// class _AnimatedStatusBorderState extends State<AnimatedStatusBorder>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (_, __) {
//         return Container(
//           height: widget.size,
//           width: widget.size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: SweepGradient(
//               startAngle: 0,
//               endAngle: 6.28,
//               colors: const [
//                 Color(0xFF006FCD),
//                 Color(0xFF00C6FF),
//                 Color(0xFF006FCD),
//               ],
//               transform: GradientRotation(_controller.value * 6.28),
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(widget.borderWidth),
//             child: Container(
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.black,
//               ),
//               child: widget.child,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
