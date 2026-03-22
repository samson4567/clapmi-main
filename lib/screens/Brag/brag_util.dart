// import 'dart:io';
// import 'dart:math';
// import 'package:clapmi/Models/brag_model.dart';
// import 'package:clapmi/core/app_variables.dart';
// import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
// import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
// import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
// import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
// import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
// import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
// import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
// import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
// import 'package:clapmi/screens/Brag/brag_screen.dart';
// import 'package:clapmi/screens/challenge/challenge_list.dart';
// import 'package:clapmi/screens/feed/feed_extraction_files/extraction.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:video_player/video_player.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;

// class BragPageVideoIitialisationController {
//   static final BragPageVideoIitialisationController _instance =
//       BragPageVideoIitialisationController._internal();

//   BragPageVideoIitialisationController._internal();

//   factory BragPageVideoIitialisationController() {
//     return _instance;
//   }

//   int currentIndex = 0;
//   List<int> fetchedpages = [];
//   List<BragAndVideoModel> theListOfBragAndVideoModelFollowing = [];
//   List<BragAndVideoModel> theListOfBragAndVideoModelAll = [];

//   List<BragAndVideoModel> theDisplayedListOfBragAndVideoModel = [
//     "https://objectstore.nyc1.civo.com/clapmi.production/videos/68f909f5d0d78-8T44Zzy",
//     "https://objectstore.nyc1.civo.com/clapmi.production/videos/68fc64c56fddf-kTY3RDD",
//     "https://objectstore.nyc1.civo.com/clapmi.production/videos/69039c007cd99-yni7Kx4",
//     "https://objectstore.nyc1.civo.com/clapmi.production/videos/690530a144fe5-kUmcwGo",
//     "https://objectstore.nyc1.civo.com/clapmi.production/videos/69109bcdf37a3-UydpdID",
//     "https://objectstore.nyc1.civo.com/clapmi.production/videos/6912fcd9d2e15-ywP3gfm",
//     "https://objectstore.nyc1.civo.com/clapmi.production/videos/69133053c4707-aNHowVi",
//     "https://objectstore.nyc1.civo.com/clapmi.production/image_picker_31C672DE-E694-4295-92A9-1EEB4912EB45-13470-000001E312A33ACBtrim.B82418D6-34D2-40B0-85CB-92C7D6B059FE/69166b1bba4de-4Skkwe4",
//     "https://objectstore.nyc1.civo.com/clapmi.production/videos/6919e0de7699e-KBmdiwF",
//     "https://objectstore.nyc1.civo.com/clapmi.production/videos/691b2332a1a24-fQGhLlf",
//     "https://objectstore.nyc1.civo.com/clapmi.production/videos/691d13d3884dc-gN65rLF"
//         "https://videocdn.cdnpk.net/videos/b33ebf32-715e-4361-933c-ba2b0c0dad12/horizontal/previews/clear/large.mp4?token=exp=1767473798~hmac=f25376309b9dba847efacda7b6a5fba8c270253f4208381b0304f73bb479c000",
//   ].map(
//     (e) {
//       return BragAndVideoModel(
//           bragModel: BragModel.dummy(), videoUrl: e, modelPageNumber: 0);
//     },
//   ).toList();

//   bool showFollow = true;

//   changeDisplayedList(
//     bool isNowViewingFollowersBrags, {
//     List<ChatUser> friends = const [],
//   }) {
//     if (isNowViewingFollowersBrags) {
//       theDisplayedListOfBragAndVideoModel =
//           BragPageVideoIitialisationController()
//               .theListOfBragAndVideoModelAll
//               .where(
//                 (element) => friends.map((e) {
//                   return e.pid;
//                 }).contains(element.bragModel.authorPID),
//               )
//               .toList();
//     } else {
//       theDisplayedListOfBragAndVideoModel =
//           BragPageVideoIitialisationController().theListOfBragAndVideoModelAll;
//     }
//   }

//   // FIXED: Improved pauseAll method with error handling
//   pauseAll() {
//     for (var element in theDisplayedListOfBragAndVideoModel) {
//       try {
//         element.theVideoPlayerController?.pause();
//       } catch (e) {
//         print("Error pausing video: $e");
//       }
//     }
//   }

//   // FIXED: New method to dispose all video controllers
//   disposeAll() {
//     for (var element in theDisplayedListOfBragAndVideoModel) {
//       try {
//         element.theVideoPlayerController?.dispose();
//         element.theVideoPlayerController = null;
//       } catch (e) {
//         print("Error disposing video controller: $e");
//       }
//     }

//     // Also dispose controllers in the all list if they're different
//     for (var element in theListOfBragAndVideoModelAll) {
//       try {
//         if (element.theVideoPlayerController != null &&
//             !theDisplayedListOfBragAndVideoModel.contains(element)) {
//           element.theVideoPlayerController?.dispose();
//           element.theVideoPlayerController = null;
//         }
//       } catch (e) {
//         print("Error disposing video controller from all list: $e");
//       }
//     }
//   }

//   preinitializeFuturevideos(int? currentIndex) async {
//     currentIndex ??= 0;

//     int counttt = 0;

//     // Dispose gang
//     try {
//       if (theDisplayedListOfBragAndVideoModel[currentIndex - 3]
//               .theVideoPlayerController
//               ?.value
//               .isInitialized ??
//           false) {
//         await theDisplayedListOfBragAndVideoModel[currentIndex - 3]
//             .theVideoPlayerController
//             ?.dispose();
//         theDisplayedListOfBragAndVideoModel[currentIndex - 3]
//           ..theVideoPlayerController = null
//           ..createVideoPlayerController();
//       }
//     } catch (e) {}

//     try {
//       if (theDisplayedListOfBragAndVideoModel[currentIndex - 2]
//               .theVideoPlayerController
//               ?.value
//               .isInitialized ??
//           false) {
//         await theDisplayedListOfBragAndVideoModel[currentIndex - 2]
//             .theVideoPlayerController
//             ?.dispose();
//         theDisplayedListOfBragAndVideoModel[currentIndex - 2]
//           ..theVideoPlayerController = null
//           ..createVideoPlayerController();
//       }
//     } catch (e) {}

//     bool isNetworkFat = await hasMinimumRequiredSpeed();

//     // Initialize gang
//     if (isNetworkFat) {
//       try {
//         await theDisplayedListOfBragAndVideoModel[currentIndex].initialize();
//       } catch (e) {}
//       try {
//         theDisplayedListOfBragAndVideoModel[currentIndex + 1].initialize();
//       } catch (e) {}
//       try {
//         theDisplayedListOfBragAndVideoModel[currentIndex + 2].initialize();
//       } catch (e) {}
//       try {
//         theDisplayedListOfBragAndVideoModel[currentIndex + 3].initialize();
//       } catch (e) {}
//     } else {
//       try {
//         await theDisplayedListOfBragAndVideoModel[currentIndex].initialize();
//       } catch (e) {}
//       try {
//         theDisplayedListOfBragAndVideoModel[currentIndex + 1]
//             .createVideoPlayerController();
//       } catch (e) {}
//       try {
//         theDisplayedListOfBragAndVideoModel[currentIndex + 2]
//             .createVideoPlayerController();
//       } catch (e) {}
//       try {
//         theDisplayedListOfBragAndVideoModel[currentIndex + 3]
//             .createVideoPlayerController();
//       } catch (e) {}
//     }
//   }

//   int pageNumber = 1;
// }

// Future<double> getDownloadSpeedMbps() async {
//   const String testUrl = 'https://speed.cloudflare.com/__down?bytes=1048576';

//   final stopwatch = Stopwatch()..start();

//   try {
//     final response = await http.get(Uri.parse(testUrl));

//     stopwatch.stop();

//     if (response.statusCode == 200) {
//       final int bytes = response.bodyBytes.length;

//       final double seconds = stopwatch.elapsedMilliseconds / 1000;

//       double speedMbps = (bytes * 8) / (1024 * 1024) / seconds;

//       return double.parse(speedMbps.toStringAsFixed(2));
//     } else {
//       throw Exception("Failed to connect to speed test server.");
//     }
//   } catch (e) {
//     print("Error measuring speed: $e");

//     return 0.0;
//   }
// }

// Future<bool> hasMinimumRequiredSpeed() async {
//   const double speedThreshold = 3.2;

//   double currentSpeed = await getDownloadSpeedMbps();

//   print("Detected speed: $currentSpeed Mbps");

//   if (currentSpeed >= speedThreshold) {
//     return true;
//   } else {
//     return false;
//   }
// }

// class BragAndVideoModel {
//   BragModel bragModel;
//   final String videoUrl;
//   final String? thumbnailUrl;
//   final int modelPageNumber;

//   String? videoFilePath;
//   final String? thumbnailFilePath;
//   VideoPlayerController? theVideoPlayerController;
//   bool isInitializing;

//   BragAndVideoModel(
//       {required this.bragModel,
//       required this.videoUrl,
//       this.thumbnailUrl,
//       this.videoFilePath,
//       this.thumbnailFilePath,
//       this.isInitializing = false,
//       required this.modelPageNumber});

//   createVideoPlayerController() {
//     if (videoFilePath != null) {
//       theVideoPlayerController = VideoPlayerController.file(
//         File(videoFilePath!),
//       );
//     } else {
//       cacheVideo();
//       theVideoPlayerController =
//           VideoPlayerController.networkUrl(Uri.parse(videoUrl));
//     }
//   }

//   initialize() async {
//     if (theVideoPlayerController?.value.isInitialized ?? false) return;
//     if (isInitializing) return;
//     isInitializing = true;

//     createVideoPlayerController();

//     theVideoPlayerController!.setLooping(true);
//     try {
//       await theVideoPlayerController!.initialize();
//       await theVideoPlayerController!.pause();
//     } catch (e) {
//       await Future.delayed(
//         2.seconds,
//         () async {
//           try {
//             await theVideoPlayerController!.initialize();
//             await theVideoPlayerController!.pause();
//           } catch (e) {
//             await Future.delayed(
//               2.seconds,
//               () async {
//                 try {
//                   await theVideoPlayerController!.initialize();
//                   await theVideoPlayerController!.pause();
//                 } catch (e) {}
//               },
//             );
//           }
//         },
//       );
//     }
//     isInitializing = false;
//   }

//   initialize_coming() async {
//     if (theVideoPlayerController?.value.isInitialized ?? false) return;
//     if (videoFilePath != null) {
//       theVideoPlayerController =
//           VideoPlayerController.file(File(videoFilePath!));
//     } else {
//       cacheVideo();

//       theVideoPlayerController =
//           VideoPlayerController.networkUrl(Uri.parse(videoUrl));
//     }
//     await theVideoPlayerController!.initialize();
//   }

//   cacheVideo() async {
//     print("dnfnfdfnfnkdnfndsfjndf${videoUrl}");
//     final file = await DefaultCacheManager().getSingleFile(videoUrl);
//     videoFilePath = file.path;
//   }

//   cacheThumbNail() async {
//     if (thumbnailUrl == null) return;
//     final file = await DefaultCacheManager().getSingleFile(thumbnailUrl!);
//     videoFilePath = file.path;
//   }
// }
