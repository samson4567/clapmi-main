// // // ignore_for_file: deprecated_member_use, use_build_context_synchronously
// // import 'dart:async';
// // import 'dart:io';
// // import 'package:clapmi/core/api/multi_env.dart';
// // import 'package:clapmi/core/app_variables.dart';
// // import 'package:clapmi/core/services/notification_handler_classes/notificationWorkers/util_functions.dart';
// // import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
// // import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
// // import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
// // import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
// // import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
// // import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
// // import 'package:clapmi/screens/challenge/others/Single_livestream.dart';
// // import 'package:clapmi/screens/challenge/others/comment_box.dart';
// // import 'package:clapmi/screens/challenge/others/multiple_livestream_screen.dart';
// // import 'package:clapmi/screens/challenge/others/screenshare_service.dart';
// // import 'package:clapmi/screens/challenge/others/user_join_widget_animation.dart';
// // import 'package:clapmi/screens/challenge/widgets/challenge_view.dart';
// // import 'package:clapmi/screens/challenge/widgets/livestream%20_header.dart';
// // import 'package:clapmi/screens/challenge/widgets/livestream_widget.dart';
// // import 'package:clapmi/screens/challenge/widgets/progress_bar.dart';
// // import 'package:clapmi/screens/challenge/widgets/single_livestream_video_rendering.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// // import 'package:intl/intl.dart';
// // import 'package:mediasfu_mediasoup_client/mediasfu_mediasoup_client.dart';
// // import 'package:socket_io_client/socket_io_client.dart' as IO;
// // import 'package:wakelock_plus/wakelock_plus.dart';

// // class LiveComboThreeImageScreen extends StatefulWidget {
// //   const LiveComboThreeImageScreen(
// //       {super.key,
// //       required this.comboInfo,
// //       required this.comboId,
// //       required this.bragID});
// //   final LiveComboEntity comboInfo;
// //   final String comboId;
// //   final String bragID;

// //   @override
// //   State<LiveComboThreeImageScreen> createState() =>
// //       _LiveComboThreeImageScreenState();
// // }

// // class _LiveComboThreeImageScreenState extends State<LiveComboThreeImageScreen>
// //     with TickerProviderStateMixin {
// //   final List<Map<String, dynamic>> _comments = [];
// //   final ScrollController _scrollController = ScrollController();
// //   final List<AnimationController> _controllers = [];
// //   bool _userScrolling = false;
// //   bool _isLoading = true;
// //   Timer? _newCommentTimer;
// //   static const int visibleCount = 4;
// //   static const double commentHeight = 60.0;
// //   TextEditingController commentController = TextEditingController();
// //   bool showPopup = false;
// //   //media status
// //   bool isAudioOn = false, isVideoOn = false, isFrontCameraSelected = true;
// //   //LIVESTREAMS VARIABLES
// //   IO.Socket? socket;
// //   Device? device;
// //   Transport? _sendTransport;
// //   Transport? _recvTransport;
// //   RTCVideoRenderer? renderer;
// //   RTCVideoRenderer? hostRender;
// //   RTCVideoRenderer? challengerRender;
// //   RTCVideoRenderer? screenshareRender;
// //   RTCVideoRenderer? hostScreenShareRender;
// //   RTCVideoRenderer? challengerScreenShareRender;
// //   bool isLocalUserScreenShared = false;
// //   String roomId = '';
// //   String role = '';
// //   String micProducerId = '';
// //   String videoProducerId = '';
// //   MediaStream? audioStream;
// //   MediaStream? videoStream;
// //   MediaStream? shareScreenStream;
// //   MediaStreamTrack? localShareScreenTrack;
// //   MediaStreamTrack? localAudioTrack;
// //   MediaStreamTrack? localVideoTrack;
// //   String screenshareId = '';
// //   bool isFullScreen = false;
// //   num totalGiftingPot = 0.0;
// //   num hostCoin = 0;
// //   num challengerCoin = 0;
// //   bool userClappEvent = false;
// //   DateTime? targetTime;
// //   String? timerCountdown;
// //   int numberOfStreamers = 0;
// //   late AnimationController _controller;
// //   late Animation<double> _positionAnimation;
// //   late Animation<double> _opacityAnimation;
// //   bool? isComboOngoingNow;
// //   int numberOfChallenger = 0;
// //   LiveGifter? liveChallenger;
// //   ComboInLiveStream? liveChallengerData;
// //   Timer? _timer;
// //   bool isthereInternet = true;
// //   StreamSubscription? internetSubscription;
// //   bool isMobile = false;
// //   String mobilePlatForm = '';

// //   //LIVESTREAM SOCKET CONNECTION
// //   Future<void> connect() async {
// //     print('🔌 CONNECTING TO SERVER...');
// //     socket = IO.io(MultiEnv().socketIoUrl, <String, dynamic>{
// //       'transports': ['websocket'],
// //       'path': '/ss/socket.io',
// //     });

// //     socket?.onConnect((_) async {
// //       print("✅ Connected to SFU Server");
// //       socket?.off('new-producer');
// //       if (role == 'host' || role == 'challenger') {
// //         socket?.emitWithAck(
// //           'check-room',
// //           {'roomId': roomId},
// //           ack: (data) async {
// //             print('Does this room exist? : $data');
// //             if (!data['exists']) {
// //               socket?.emit('create-room', {
// //                 'roomId': roomId,
// //                 'device': Platform.isIOS ? "IOS" : "android"
// //               });
// //               await waitForResult('room-created');
// //               socket?.emit('join-room', {
// //                 'roomId': roomId,
// //                 'userId': profileModelG?.pid,
// //                 'device': Platform.isIOS ? "IOS" : "android"
// //               });
// //             }
// //           },
// //         );
// //       }
// //       print('DATA DO NOT EXIST THEN JOIN ROOM $roomId');
// //       //EMIT JOIN-ROOM FOR ACCESS
// //       socket?.emit('join-room', {
// //         'roomId': roomId,
// //         'userId': profileModelG?.pid,
// //         'device': Platform.isIOS ? 'IOS' : 'android'
// //       });
// //       //RESPONSE AFTER JOINING THE ROOM
// //       final transport = await waitForResult('joined-room');
// //       print("This is the trannsport care $transport");
// //       final routerCapabilities = RtpCapabilities.fromMap(
// //         transport['routerRtpCapabilities'],
// //       );
// //       final producers = transport['producers'];
// //       await loadDevice(routerCapabilities);
// //       if (role == 'host' || role == 'challenger') {
// //         print("creating send transport------------- $role");
// //         await createSendTransport(roomId, role);
// //       }
// //       await createRecvTransport(roomId);
// //       if (mounted) {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //       //CONSUME TRACKS FOR ALL ROLES
// //       for (var producer in producers) {
// //         try {
// //           print(
// //               "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@loopin through producers $producer");
// //           await consumeTrack(producer, roomId);
// //         } catch (error) {
// //           print('❌ Failed to consume producer ');
// //         }
// //       }
// //       socket?.on('new-producer', (data) async {
// //         print('!!!!!!!!!!!!!!!!!!!!!!!!!!!data coming from new-producer $data');
// //         try {
// //           //await createRecvTransport(roomId);
// //           await consumeTrack(data, roomId);
// //         } catch (error) {
// //           print(
// //             '❌ Failed to consume new producer ${data['producerId']}, and the error ${error.toString()}',
// //           );
// //         }
// //       });
// //     });
// //     socket?.on('screen-share-stopped', (data) async {
// //       try {
// //         if (data['role'] == 'host') {
// //           hostScreenShareRender?.srcObject = null;
// //         } else if (data['role'] == 'challenger') {
// //           challengerScreenShareRender?.srcObject = null;
// //         }
// //         setState(() {});
// //       } catch (e) {}
// //     });
// //     socket?.on('video-stream-stopped', (data) async {
// //       try {
// //         if (data['role'] == 'host') {
// //           hostRender?.srcObject = null;
// //         } else if (data['role'] == 'challenger') {
// //           challengerRender?.srcObject = null;
// //         }
// //         setState(() {});
// //       } catch (e) {}
// //     });
// //     //END OF CONNECTION WITH THE SOCKET... WHEN IT IS CONNECTED THE EVENTS ARE CALLED WITHIN THEM
// //     socket?.onConnectError((data) {
// //       print('❌ Connection Error: $data');
// //     });
// //     socket?.onDisconnect((data) {
// //       print('🛑 Disconnected: $data');
// //     });
// //   }

// //   assignRole() {
// //     //Check if there is an ongoingCombo inside combo
// //     if (widget.comboInfo.hasOngoingCombo == true) {
// //       isComboOngoingNow = widget.comboInfo.hasOngoingCombo;
// //       if (widget.comboInfo.onGoingCombo?.host?.profile == profileModelG?.pid) {
// //         role = 'host';
// //       } else if (widget.comboInfo.onGoingCombo?.challenger?.profile ==
// //           profileModelG?.pid) {
// //         role = 'challenger';
// //       } else {
// //         role = 'spectator';
// //         _isLoading = false;
// //       }
// //     }
// //     //**WHEN THERE IS NO ONGOING COMBO */
// //     else {
// //       isComboOngoingNow = false;
// //       if (widget.comboInfo.host?.profile == profileModelG?.pid) {
// //         role = 'host';
// //         _isLoading = true;
// //       } else if (widget.comboInfo.challenger?.profile == profileModelG?.pid) {
// //         role = 'challenger';
// //         _isLoading = true;
// //       } else {
// //         role = 'spectator';
// //         _isLoading = false;
// //       }
// //     }
// //     numberOfStreamers = widget.comboInfo.presence ?? 1;
// //   }

// //   initRenderers() async {
// //     renderer = RTCVideoRenderer();
// //     hostRender = RTCVideoRenderer();
// //     challengerRender = RTCVideoRenderer();
// //     screenshareRender = RTCVideoRenderer();
// //     await renderer?.initialize();
// //     await hostRender?.initialize();
// //     await challengerRender?.initialize();
// //     await screenshareRender?.initialize();
// //     assignRole();
// //     roomId = widget.comboInfo.combo ?? widget.comboId;
// //     //widget.comboInfo.onGoingCombo?.combo;
// //   }

// //   void countdownTimer(
// //       {required String? startTime, required String? durationTime}) {
// //     _timer?.cancel();
// //     _timer = Timer.periodic((Duration(seconds: 1)), (timer) {
// //       final now = DateTime.now();
// //       final duration = durationFromOption(durationTime ?? '');
// //       final remaining = DateFormat("yyyy-MM-dd HH:mm:ss")
// //           .parse(startTime ?? '', true)
// //           .toLocal()
// //           .add(duration)
// //           .difference(now);
// //       // targetTime?.difference(now);
// //       if (mounted) {
// //         if (remaining.isNegative || remaining.inSeconds == 0) {
// //           setState(() {
// //             timerCountdown = "00:00:00";
// //           });
// //           timer.cancel();
// //         } else {
// //           setState(() {
// //             timerCountdown = formatHHMMSS(remaining);
// //             //  "${remaining.inHours}:${remaining.inMinutes % 60}:${remaining.inSeconds % 60}";
// //           });
// //         }
// //       }
// //     });
// //   }

// //   @override
// //   void initState() {
// //     WakelockPlus.enable();
// //     internetSubscription =
// //         InternetConnection().onStatusChange.listen((InternetStatus status) {
// //       if (status == InternetStatus.connected) {
// //         setState(() {
// //           isthereInternet = true;
// //         });
// //       } else {
// //         isthereInternet = false;
// //       }
// //     });
// //     //TIME TICKING FOR WHEN THE COMBO WILL END.
// //     countdownTimer(
// //         startTime: widget.comboInfo.onGoingCombo?.startTime ??
// //             widget.comboInfo.metaData?.start_time,
// //         durationTime: widget.comboInfo.onGoingCombo?.duration ??
// //             widget.comboInfo.duration);
// //     //ANIMATION CONTROLLERS
// //     _controller =
// //         AnimationController(vsync: this, duration: Duration(seconds: 10));
// //     _positionAnimation = Tween<double>(begin: 0.5, end: 0.7)
// //         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
// //     _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
// //         CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));
// //     context.read<ChatsAndSocialsBloc>().add(SubscribeTochatEvent(
// //         conversationId: widget.comboId, isLiveComboSubscription: true));
// //     context
// //         .read<ChatsAndSocialsBloc>()
// //         .add(GetTotalGiftsEvent(comboId: widget.comboId));
// //     if (mounted) {
// //       setState(() {
// //         hostCoin = widget.comboInfo.gifts?.host ?? 0;
// //         if (isComboOngoingNow == true) {
// //           challengerCoin =
// //               widget.comboInfo.onGoingCombo?.gifts?.challenger ?? 0;
// //         } else {
// //           challengerCoin = widget.comboInfo.gifts?.challenger ?? 0;
// //         }
// //       });
// //     }
// //     initRenderers().then((_) {
// //       connect();
// //     });
// //     //**SWITCH THE ANIMATION STATUS WHEN IT IS COMPLETED */
// //     _controller.addStatusListener((status) {
// //       if (status.isCompleted) {
// //         setState(() {
// //           print("----STATUS IS COMPLETED");
// //           userClappEvent = false;
// //         });
// //       }
// //     });
// //     _scrollController.addListener(_handleScroll);
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     WakelockPlus.disable();
// //     for (var controller in _controllers) {
// //       controller.dispose();
// //     }
// //     internetSubscription?.cancel();
// //     socket?.disconnect();
// //     _timer?.cancel();
// //     socket?.dispose();
// //     _scrollController.dispose();
// //     _newCommentTimer?.cancel();
// //     _sendTransport?.close();
// //     _recvTransport?.close();
// //     renderer?.dispose();
// //     hostRender?.dispose();
// //     challengerRender?.dispose();
// //     shareScreenStream?.dispose();
// //     localShareScreenTrack?.dispose();
// //     localAudioTrack?.dispose();
// //     videoStream?.dispose();
// //     audioStream?.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom > 0;
// //     return Scaffold(
// //       resizeToAvoidBottomInset: false,
// //       body: SafeArea(
// //         child: BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
// //           listener: (context, state) {
// //             if (state is LiveCommentState) {
// //               _addComment({
// //                 'state': state.commentData,
// //                 'stateName': 'commentLive',
// //               });
// //             }
// //             if (state is ClappLiveState) {
// //               _controller.reset();
// //               _controller.forward();
// //             }
// //             if (state is ComboEnded) {
// //               //Handle the clearing of all resources for livestreaming...
// //               //Also show the dialog that streaming has ended...
// //               print("Combo has ended ${state.comboDetails.toString()}");
// //               if (isComboOngoingNow == true) {
// //                 //Revert back to single Livestream screen.
// //                 setState(() {
// //                   isComboOngoingNow = false;
// //                   print(
// //                       "This should change the state of the screen or something");
// //                   countdownTimer(
// //                       startTime: widget.comboInfo.metaData?.start_time,
// //                       durationTime: widget.comboInfo.duration);
// //                 });
// //               } else {
// //                 print("An host has left the livestream------------");
// //                 setState(() {
// //                   timerCountdown = "00:00:00";
// //                 });
// //                 _timer?.cancel();
// //                 // showDialogInforamtion(context, onPressed: () {
// //                 // context.pop();
// //                 // });
// //               }
// //               // if (state.comboDetails.wins?.winner == profileModelG?.pid) {
// //               //   // showWinnersBadge(context);
// //               // } else if (state.comboDetails.wins?.loser == profileModelG?.pid) {
// //               //   //  showLoosersBadge(context);
// //               // }
// //               // showDialogInforamtion(context, onPressed: () {
// //               //   context.pop();
// //               // });
// //             }
// //             if (state is PotAmount) {
// //               setState(() {
// //                 totalGiftingPot = state.totalAmount;
// //               });
// //             }
// //             if (state is UserJoined) {
// //               setState(() {
// //                 numberOfStreamers = numberOfStreamers + 1;
// //               });
// //               _controller.reset();
// //               _controller.forward();
// //               print(
// //                   'THE USERNAME OF THE USER IS ${state.userJoined.user?.username}');
// //               print("${state.userJoined.user?.pid}");
// //               print("${widget.comboInfo.host?.profile}");
// //               if (state.userJoined.user?.pid ==
// //                       widget.comboInfo.host?.profile ||
// //                   state.userJoined.user?.pid ==
// //                       widget.comboInfo.challenger?.profile) {
// //                 socket?.dispose();
// //                 connect();
// //               }
// //               //Check if a host or challenger is the one that joined.
// //               //Then you can reconnect but before then dispose the socket
// //               // socket?.dispose();
// //             }
// //             if (state is UserLeaveCombo) {
// //               if (state.user.user?.pid == profileModelG?.pid) {
// //                 print("HOST OR CHALLENGER LEAVING---");
// //                 // context.goNamed(MyAppRouteConstant.challenge);
// //                 context.pop();
// //                 context.pop();
// //               } else {
// //                 _addComment({
// //                   'state': state.user,
// //                   'stateName': 'userLeaves',
// //                 });
// //                 setState(() {
// //                   numberOfStreamers = numberOfStreamers - 1;
// //                 });
// //               }
// //             }
// //             if (state is GiftingState) {
// //               setState(() {
// //                 totalGiftingPot = totalGiftingPot +
// //                     num.parse(state.gifts.giftdata?.amount ?? '0');
// //                 if (state.gifts.giftdata?.receiver ==
// //                     widget.comboInfo.host?.profile) {
// //                   print('HOST GIFTITNG-----------');
// //                   hostCoin =
// //                       hostCoin + num.parse(state.gifts.giftdata?.amount ?? '0');
// //                 } else if (isComboOngoingNow == true &&
// //                     (state.gifts.giftdata?.receiver == liveChallenger?.pid ||
// //                         state.gifts.giftdata?.receiver ==
// //                             widget
// //                                 .comboInfo.onGoingCombo?.challenger?.profile)) {
// //                   challengerCoin = challengerCoin +
// //                       num.parse(state.gifts.giftdata?.amount ?? '0');
// //                 } else if (state.gifts.giftdata?.receiver ==
// //                     widget.comboInfo.challenger?.profile) {
// //                   print('CHALLENGER GIFTING.............');
// //                   challengerCoin = challengerCoin +
// //                       num.parse(state.gifts.giftdata?.amount ?? '0');
// //                 }
// //               });
// //               _controller.reset();
// //               _controller.forward();
// //             }
// //             if (state is ComboGroundInLive) {
// //               print("THE INNER COMBO IS ACTIVATED AND LIVE---****&&&&");
// //               setState(() {
// //                 isComboOngoingNow = true;
// //                 liveChallenger = state.comboData.challenger;
// //                 liveChallengerData = state.comboData;
// //                 countdownTimer(
// //                     startTime: state.comboData.comboGround?.start,
// //                     durationTime: state.comboData.comboGround?.duration);
// //               });
// //             }
// //             if (state is LiveBragInCombo) {
// //               print("Testing the liveBrag updating");
// //               if (state.challenge.action == 'add') {
// //                 setState(() {
// //                   numberOfChallenger = numberOfChallenger + 1;
// //                 });
// //               } else if (state.challenge.action == 'remove') {
// //                 numberOfChallenger =
// //                     numberOfChallenger - 1 < 1 ? 0 : numberOfChallenger - 1;
// //               }
// //             }
// //           },
// //           builder: (context, state) {
// //             //CONDITION TO SHOW THAT THE COMBO OR SINGLE IS NOT AVAILABLE AGAIN
// //             return timerCountdown == "00:00:00" && isComboOngoingNow == false
// //                 ? Center(
// //                     child: Container(
// //                       margin: EdgeInsets.symmetric(horizontal: 65.w),
// //                       padding:
// //                           EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
// //                       decoration: BoxDecoration(
// //                           color: getFigmaColor("121212"),
// //                           borderRadius: BorderRadius.circular(20.0)),
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Container(
// //                             width: 60,
// //                             height: 60,
// //                             decoration: BoxDecoration(
// //                               color: Colors.blue[700],
// //                               shape: BoxShape.circle,
// //                             ),
// //                             child: const Icon(
// //                               Icons.check,
// //                               color: Colors.white,
// //                               size: 36,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 24),
// //                           // "Challenge Sent" text
// //                           const Text(
// //                             'Stream has ended',
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 20,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 32),
// //                           SizedBox(
// //                             width: double.infinity,
// //                             child: ElevatedButton(
// //                               onPressed: () {
// //                                 context.pop();
// //                               },
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: Colors.blue[700],
// //                                 foregroundColor: Colors.white,
// //                                 padding:
// //                                     const EdgeInsets.symmetric(vertical: 16),
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                                 textStyle: const TextStyle(
// //                                   fontSize: 18,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                               child: const Text('close'),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   )
// //                 : _isLoading
// //                     ? Container(
// //                         decoration:
// //                             BoxDecoration(color: Colors.grey.withAlpha(10)),
// //                         child: Center(
// //                           child: CircularProgressIndicator(
// //                             color: Colors.blueAccent,
// //                           ),
// //                         ))
// //                     //** THIS IS THE STACK WITH THE HEADER **//
// //                     : Stack(children: <Widget>[
// //                         Container(
// //                           margin: EdgeInsets.only(top: 120.h, bottom: 20.h),
// //                           child: SizedBox(
// //                             //  height: MediaQuery.of(context).size.height / 2,
// //                             //**THIS IS THE STACK WITHOUT THE HEADER **//
// //                             //CHECK IF COMBO DOES NOT HAVE ONGOINGOCOMBO
// //                             child: isComboOngoingNow == false
// //                                 ?
// //                                 //CHECK IF THE TYPE OF COMBO IS SINGLE
// //                                 widget.comboInfo.type == 'single'
// //                                     ?
// //                                     //THEN CHECK IF THE USER IS THE HOST
// //                                     widget.comboInfo.host?.profile ==
// //                                             profileModelG?.pid
// //                                         //CHECK IF THE HOST(LOCAL USER) IS SHARING SCREEN
// //                                         ? screenshareRender?.srcObject != null
// //                                             ? ScreenShareView(
// //                                                 isHostLocalUser: widget
// //                                                         .comboInfo
// //                                                         .host
// //                                                         ?.profile ==
// //                                                     profileModelG?.pid,
// //                                                 role: 'host',
// //                                                 isMobile: isMobile,
// //                                                 mobilePlatForm: mobilePlatForm,
// //                                                 imageUrl: widget
// //                                                     .comboInfo.host?.avatar,
// //                                                 imageAvatar: widget.comboInfo
// //                                                     .host?.avatarConvert,
// //                                                 cameraRenderer: renderer,
// //                                                 isFullScreen: isFullScreen,
// //                                                 action: () {
// //                                                   stopScreenShare();
// //                                                 },
// //                                                 screenshareRender:
// //                                                     screenshareRender,
// //                                               )
// //                                             //**IF THE HOST(LOCAL USER) IS NOT SHARING SCREEN */
// //                                             : SingleVideoView(
// //                                                 aspectRatio: 0.8,
// //                                                 isMobile: isMobile,
// //                                                 mobilePlatForm: mobilePlatForm,
// //                                                 imageUrl: widget.comboInfo.host
// //                                                         ?.avatar ??
// //                                                     '',
// //                                                 imageAvatar: widget
// //                                                     .comboInfo.host?.avatarConvert,
// //                                                 renderer: renderer!,
// //                                                 profilePicMargin:
// //                                                     EdgeInsets.only(
// //                                                         top: 230.h,
// //                                                         left: 120.w),
// //                                                 profilePicHeight: 100.w,
// //                                                 profilePicWidth: 100.w,
// //                                                 shouldShowVideo:
// //                                                     renderer?.srcObject != null)
// //                                         :
// //                                         //IF THE USER IS NOT THE HOST(LOCAL USER) OF THE SINGLE LIVESTREM
// //                                         //IF THE HOST(REMOTE USER) IS SHARING SCREEN
// //                                         hostScreenShareRender?.srcObject != null
// //                                             ? ScreenShareView(
// //                                                 isHostLocalUser: widget
// //                                                         .comboInfo
// //                                                         .host
// //                                                         ?.profile ==
// //                                                     profileModelG?.pid,
// //                                                 isMobile: isMobile,
// //                                                 mobilePlatForm: mobilePlatForm,
// //                                                 role: 'host',
// //                                                 imageUrl: widget
// //                                                     .comboInfo.host?.avatar,
// //                                                 imageAvatar: widget.comboInfo
// //                                                     .host?.avatarConvert,
// //                                                 cameraRenderer: hostRender,
// //                                                 isFullScreen: isFullScreen,
// //                                                 action: () {},
// //                                                 screenshareRender:
// //                                                     hostScreenShareRender,
// //                                               )
// //                                             //**IF HOST AS THE (REMOTE USER) IS NOT SHARING SCREEN */
// //                                             : SingleVideoView(
// //                                                 aspectRatio: 0.8,
// //                                                 isMobile: isMobile,
// //                                                 mobilePlatForm: mobilePlatForm,
// //                                                 remoteRole: 'host',
// //                                                 imageUrl: widget.comboInfo.host
// //                                                         ?.avatar ??
// //                                                     '',
// //                                                 imageAvatar: widget.comboInfo
// //                                                     .host?.avatarConvert,
// //                                                 renderer: hostRender!,
// //                                                 profilePicMargin:
// //                                                     EdgeInsets.only(
// //                                                         top: 210.h,
// //                                                         left: 120.w),
// //                                                 profilePicHeight: 100.w,
// //                                                 profilePicWidth: 100.w,
// //                                                 shouldShowVideo:
// //                                                     hostRender?.srcObject !=
// //                                                         null)
// //                                     :
// //                                     //**LIVESTREAM IS MULTIPLE AND THERE IS NO ONGOING COMBO */
// //                                     MultipleLiveStreamScreen(
// //                                         isMobile: isMobile,
// //                                         mobilePlatForm: mobilePlatForm,
// //                                         hostScreenShareRender:
// //                                             hostScreenShareRender,
// //                                         challengerScreenShareRender:
// //                                             challengerScreenShareRender,
// //                                         hostRender: hostRender,
// //                                         widget: widget,
// //                                         isFullScreen: isFullScreen,
// //                                         challengerRender: challengerRender,
// //                                         screenshareRender: screenshareRender,
// //                                         renderer: renderer,
// //                                         hasOngoingCombo:
// //                                             isComboOngoingNow == true,
// //                                         // ??widget.comboInfo.hasOngoingCombo == true,
// //                                         role: role)
// //                                 :
// //                                 //**WHEN THE COMBOINFO HAS ONGOING COMBO */
// //                                 MultipleLiveStreamScreen(
// //                                     isMobile: isMobile,
// //                                     mobilePlatForm: mobilePlatForm,
// //                                     hostScreenShareRender: hostScreenShareRender,
// //                                     challengerScreenShareRender: challengerScreenShareRender,
// //                                     hostRender: hostRender,
// //                                     widget: widget,
// //                                     isFullScreen: isFullScreen,
// //                                     challengerRender: challengerRender,
// //                                     screenshareRender: screenshareRender,
// //                                     renderer: renderer,
// //                                     hasOngoingCombo: isComboOngoingNow == true,
// //                                     //  ??widget.comboInfo.hasOngoingCombo == true,
// //                                     role: role),
// //                           ),
// //                         ),
// //                         //THIS IS THE HEADER
// //                         LivestreamHeader(
// //                           comboInfo: widget.comboInfo,
// //                           comboId: widget.comboId,
// //                           totalGiftingPot: totalGiftingPot,
// //                           timerCountdown: timerCountdown,
// //                           bragID: widget.bragID,
// //                           streamersCount: numberOfStreamers,
// //                           numOfChallengers: numberOfChallenger,
// //                           liveChallenger: liveChallengerData,
// //                           isLiveGoingNow: isComboOngoingNow == true,
// //                           onLeaveComboEvent: (value) {
// //                             if (value) {
// //                               //**CHECK THAT IT IS A MULTIPLE COMBO AND ALSO THE USER IS */
// //                               //**EITHER A HOST OR A CHALLENGER */
// //                               // if (
// //                               //   //widget.comboInfo.type == "multiple" &&
// //                               //     (widget.comboInfo.host?.profile ==
// //                               //             profileModelG?.pid ||
// //                               //         widget.comboInfo.challenger?.profile ==
// //                               //             profileModelG?.pid)) {
// //                               showModalBottomSheet(
// //                                   context: context,
// //                                   builder: (context) {
// //                                     return EndliveStream(
// //                                       comboId: widget.comboId,
// //                                     );
// //                                   });
// //                               //  }
// //                             }
// //                           },
// //                         ),

// //                         //THIS IS THE PROGRESS BAR
// //                         //-----------------------------
// //                         if (widget.comboInfo.type == "multiple" ||
// //                             isComboOngoingNow == true)
// //                           Positioned(
// //                               top: role == 'spectator' ? 150.h : 150.h,
// //                               left: 8,
// //                               child: SizedBox(
// //                                 // padding: EdgeInsets.only(right: 15.w),
// //                                 child: ProgressBars(
// //                                   hostCoinAmount: hostCoin,
// //                                   challengerCoinAmount: challengerCoin,
// //                                   progress: hostCoin / totalGiftingPot,
// //                                 ),
// //                               )),
// //                         // THIS IS TO SHOW THE TEXT WIDGET...
// //                         if (state is UserJoined)
// //                           LiveNotification(
// //                             controller: _controller,
// //                             positionAnimation: _positionAnimation,
// //                             opacityAnimation: _opacityAnimation,
// //                             child: userJoin(
// //                                 imageUrl: state.userJoined.user?.image ?? '',
// //                                 message: state.userJoined.message,
// //                                 userName:
// //                                     state.userJoined.user?.username ?? ''),
// //                           ),
// //                         if (state is GiftingState)
// //                           LiveNotification(
// //                             controller: _controller,
// //                             positionAnimation: _positionAnimation,
// //                             opacityAnimation: _opacityAnimation,
// //                             child: giftWidget(
// //                                 imageUrl:
// //                                     state.gifts.giftdata?.sender?.avatar ?? '',
// //                                 message: state.gifts.message,
// //                                 userName:
// //                                     state.gifts.giftdata?.sender?.username ??
// //                                         '',
// //                                 amount: state.gifts.giftdata?.amount ?? ''),
// //                           ),
// //                         if (state is ClappLiveState)
// //                           LiveNotification(
// //                             controller: _controller,
// //                             positionAnimation: _positionAnimation,
// //                             opacityAnimation: _opacityAnimation,
// //                             child: clapLiveWidget(
// //                                 imageUrl: state.clapData.user?.avatar,
// //                                 message: state.clapData.message,
// //                                 userName: state.clapData.user?.username,
// //                                 myavatar: state.clapData.user?.avatarConvert),
// //                           ),
// //                         if (userClappEvent)
// //                           LiveNotification(
// //                             controller: _controller,
// //                             positionAnimation: _positionAnimation,
// //                             opacityAnimation: _opacityAnimation,
// //                             child: clapLiveWidget(
// //                                 imageUrl: profileModelG?.image ?? '',
// //                                 message: 'You sent a like \u2764\uFE0F',
// //                                 userName: profileModelG?.username ?? '',
// //                                 myavatar: profileModelG?.myAvatar),
// //                           ),

// //                         //THIS IS THE BOTTOM SECTION WITH THE COMMENT SESSION OF THE LIVESTREAM
// //                         //------------------------------------------------------------------------
// //                         Positioned(
// //                           bottom: MediaQuery.of(context).viewInsets.bottom,
// //                           child: SizedBox(
// //                             width: MediaQuery.of(context).size.width,
// //                             child: Column(
// //                               mainAxisSize: MainAxisSize.min,
// //                               mainAxisAlignment: MainAxisAlignment.start,
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 IgnorePointer(
// //                                     ignoring: true,
// //                                     child: Container(
// //                                       height: visibleCount * commentHeight,
// //                                       margin: EdgeInsets.only(bottom: 8.h),
// //                                       child: ListView.builder(
// //                                         shrinkWrap: true,
// //                                         controller: _scrollController,
// //                                         itemExtent: commentHeight,
// //                                         itemCount: _comments.length,
// //                                         itemBuilder: (context, index) =>
// //                                             _buildAnimatedComment(index),
// //                                       ),
// //                                     )),
// //                                 //** THE IDEA HERE IS TO ALWAYS REBUILD THE WIDGET WHENEVER THE
// //                                 //** ISCOMBOGOINGNOW CHANGES....
// //                                 if (isComboOngoingNow == true ||
// //                                     isComboOngoingNow == false)
// //                                   //**BOTTOM BUTTON SESSION OF THE LIVESTREAM SCREEN */
// //                                   LiveStreamBottomSession(
// //                                     comboId: widget.comboId,
// //                                     comboInfo: widget.comboInfo,
// //                                     bragID: widget.bragID,
// //                                     isLiveOngoing: isComboOngoingNow == true,
// //                                     liveChallenger: liveChallenger,
// //                                     sendComment: (comment) {
// //                                       _addComment({
// //                                         'state': comment,
// //                                         'stateName': 'commentLive',
// //                                       });
// //                                     },
// //                                     onUserClappEvent: (value) {
// //                                       if (value) {
// //                                         setState(() {
// //                                           _controller.reset();
// //                                           _controller.forward();
// //                                           userClappEvent = value;
// //                                         });
// //                                       }
// //                                     },
// //                                     onLiveMicPressed: (value) {
// //                                       value ? enableMic() : disableMic();
// //                                     },
// //                                     isMicEnabled: isAudioOn,
// //                                     onLiveCameraPressed: (value) {
// //                                       value
// //                                           ? enableCamera(false)
// //                                           : disableCamera();
// //                                     },
// //                                     isCameraEnable: isVideoOn,
// //                                     isLiveRecording: isFrontCameraSelected,
// //                                     onLiveRecordingPressed: (value) {
// //                                       if (value) {
// //                                         setState(() {
// //                                           isFrontCameraSelected = true;
// //                                         });
// //                                         enableCamera(true);
// //                                       }
// //                                     },
// //                                     isScreenShared:
// //                                         screenshareRender?.srcObject != null,
// //                                     onShareScreenPressed: (value) {
// //                                       value
// //                                           ? showModalBottomSheet(
// //                                               context: context,
// //                                               builder: (context) {
// //                                                 return ScreenSharingIcon(
// //                                                   onPress: () {
// //                                                     enableShareScreen();
// //                                                   },
// //                                                 );
// //                                               },
// //                                             )
// //                                           : stopScreenShare();
// //                                       //enableShareScreen() : stopScreenShare();
// //                                     },
// //                                     onEnlargeScreenPressed: (value) {},
// //                                     isScreenEnlarged: false,
// //                                     onExitPressed: (value) {
// //                                       if (value) {
// //                                         //  if (
// //                                         //widget.comboInfo.type == "multiple" &&
// //                                         // (widget.comboInfo.host?.profile ==
// //                                         //         profileModelG?.pid ||
// //                                         //     widget.comboInfo.challenger?.profile ==
// //                                         //         profileModelG?.pid)) {
// //                                         showModalBottomSheet(
// //                                             context: context,
// //                                             builder: (context) {
// //                                               return EndliveStream(
// //                                                 comboId: widget.comboId,
// //                                               );
// //                                             });
// //                                         //  }
// //                                       }
// //                                     },
// //                                     onTurnedOffPressed: (value) {},
// //                                   ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                         //INTERNET CONNECTION OVERLAY.
// //                         if (!isthereInternet)
// //                           Positioned.fill(
// //                             child: AbsorbPointer(
// //                               absorbing: true,
// //                               child: Container(
// //                                 decoration: BoxDecoration(),
// //                                 child: Align(
// //                                   alignment: Alignment(0, -.7),
// //                                   child: Container(
// //                                     // height: 40.h,
// //                                     padding: EdgeInsets.symmetric(
// //                                         horizontal: 10.w, vertical: 2.h),
// //                                     decoration: BoxDecoration(
// //                                         borderRadius: BorderRadius.circular(20),
// //                                         border: Border.all(
// //                                             // color: Colors.white,
// //                                             ),
// //                                         color:
// //                                             // Colors.red
// //                                             Colors.black.withAlpha(200)),
// //                                     child: Text(
// //                                       "Stream quality reduced due to unstable internet connection",
// //                                       textAlign: TextAlign.center,
// //                                       style: TextStyle(
// //                                           color: Colors.white,
// //                                           fontSize: 10.sp,
// //                                           fontWeight: FontWeight.w600,
// //                                           fontFamily: 'Poppins'),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                       ]);
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   //**CALCULATE THE HANDSCROLLING INTERACTION */
// //   void _handleScroll() {
// //     // If user scrolls away from bottom, pause auto-scroll
// //     final maxScroll = _scrollController.position.maxScrollExtent;
// //     final currentScroll = _scrollController.position.pixels;

// //     final isAtBottom = (maxScroll - currentScroll).abs() < 20;
// //     if (isAtBottom) {
// //       _userScrolling = false;
// //     } else {
// //       _userScrolling = true;
// //     }
// //   }

// //   //**LOGIC TO ADD LIVE COMMENT TO THE COMMENT LIST FOR REAL-TIME RENDERING */
// //   void _addComment(Map<String, dynamic> comment) {
// //     // Animation controller for intro
// //     final controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 500),
// //     );
// //     _controllers.add(controller);
// //     _comments.add(comment);
// //     controller.forward();
// //     setState(() {});
// //     // Scroll to bottom if user is not interacting
// //     if (!_userScrolling && _comments.length > visibleCount) {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         if (_scrollController.hasClients) {
// //           _scrollController.animateTo(
// //             _scrollController.position.maxScrollExtent,
// //             duration: const Duration(milliseconds: 300),
// //             curve: Curves.easeOut,
// //           );
// //         }
// //       });
// //     }
// //   }

// // //**THIS IS THE OPACITY CALCULATION */
// //   double _calculateOpacity(int index) {
// //     final scrollOffset = _scrollController.offset / commentHeight;
// //     final firstVisibleIndex = scrollOffset.floor();
// //     if (index < firstVisibleIndex ||
// //         index >= firstVisibleIndex + visibleCount) {
// //       return 0.0;
// //     }
// //     if (index == firstVisibleIndex) {
// //       return 1 - (scrollOffset - scrollOffset.floor());
// //     }
// //     if (index == firstVisibleIndex + visibleCount) {
// //       return (scrollOffset - scrollOffset.floor());
// //     }
// //     return 1.0;
// //   }

// //   //**THIS IS TO BUILD THE ANIMATED CONTENT */
// //   Widget _buildAnimatedComment(
// //     int index,
// //   ) {
// //     final comment = _comments[index];
// //     // Entry animation for first 4 comments
// //     if (_comments.length <= visibleCount && index < _controllers.length) {
// //       final animation = CurvedAnimation(
// //         parent: _controllers[index],
// //         curve: Curves.easeOut,
// //       );
// //       return FadeTransition(
// //         opacity: animation,
// //         child: SlideTransition(
// //           position: Tween<Offset>(
// //             begin: const Offset(0, 0.5),
// //             end: Offset.zero,
// //           ).animate(animation),
// //           child: BuildCommentBox(commentData: comment),
// //         ),
// //       );
// //     }
// //     // Normal comment with fade logic
// //     final opacity = _calculateOpacity(index);
// //     return Opacity(
// //       opacity: opacity.clamp(0.0, 1.0),
// //       child: BuildCommentBox(commentData: comment),
// //     );
// //   }

// //   //LIVESTREAMING FUNCTION
// //   //CREATE TRANSPORT
// //   Future<void> createSendTransport(roomId, role) async {
// //     print('Start creating transport and see what happend');
// //     socket?.emit('create-transport', {'roomId': roomId, 'direction': 'send'});

// //     final transportData = await waitForResult<Map<dynamic, dynamic>>(
// //       'transport-created',
// //     );

// //     _sendTransport = device?.createSendTransportFromMap(
// //       transportData,
// //       producerCallback: producerCallbackFunction,
// //     );

// //     _sendTransport!.on("connect", (transportData) async {
// //       socket?.emit('connect-transport', {
// //         'transportId': _sendTransport?.id,
// //         'dtlsParameters': transportData['dtlsParameters'].toMap(),
// //       });
// //       socket?.once('transport-connected', (data) {
// //         print(
// //           'This is calling the callback having gotten the transport connect',
// //         );
// //         transportData['callback']();
// //       });

// //       // _sendTransportConnected = true;
// //     });

// //     _sendTransport?.on('produce', (producedData) {
// //       socket?.emit('produce', {
// //         'transportId': _sendTransport?.id,
// //         'kind': producedData['kind'],
// //         'rtpParameters': producedData['rtpParameters'].toMap(),
// //         'appData': producedData['appData'],
// //       });
// //       socket?.once('produced', (response) async {
// //         // producers.add(response['producerId']);
// //         setState(() {
// //           if (producedData['appData'] == 'mic') {
// //             print(
// //                 'THE PRODUCE RESPONSE SHOWING THAT WE HAVE PRODUCERID IMPLEMENTED AND OPEN THE MICROPHONE');
// //             isAudioOn = true;
// //           }
// //           if (producedData['appData'] == 'cam') {
// //             isVideoOn = true;
// //           }
// //         });
// //         await producedData['callback'](response['producerId']);
// //       });
// //     });
// //   }

// //   //CREATE RECEIVE TRANSPORT ALSO
// //   Future<void> createRecvTransport(roomId) async {
// //     print('Start creating receiving transport and see what will happen');
// //     socket?.emit('create-transport', {'roomId': roomId, 'direction': 'recv'});
// //     final transportData = await waitForResult('transport-created');

// //     _recvTransport = device?.createRecvTransportFromMap(
// //       transportData,
// //       consumerCallback: consumerCallback,
// //     );

// //     _recvTransport?.on("connect", (recvData) {
// //       socket?.emit("connect-transport", {
// //         'transportId': _recvTransport?.id,
// //         'dtlsParameters': recvData['dtlsParameters'].toMap(),
// //       });
// //       recvData['callback']();

// //       print('✅ Recv transport connected successfully');

// //       socket?.once('transport-connected', (transportConnectData) async {
// //         try {
// //           if (recvData != null &&
// //               recvData.containsKey('callback') &&
// //               recvData['callback'] != null) {
// //             final callback = recvData['callback'];
// //             recvData.remove('callback');

// //             if (callback is Function) {
// //               await callback();
// //               print('✅ Recv transport connected successfully');
// //             }
// //           }
// //         } catch (e) {
// //           print('Already completed the furture ${e.toString()}');
// //         }
// //       });
// //     });
// //   }

// //   Future<T> waitForResult<T>(String event) {
// //     print('TESTING THE WAIT FOR WORKINGE HERE.... $event');
// //     final completer = Completer<T>();
// //     void handler(dynamic data) {
// //       socket?.off(event, handler);
// //       completer.complete(data as T);
// //     }

// //     socket?.once(event, handler);
// //     print('before finish for returning...');
// //     return completer.future;
// //   }

// //   //THE CALLBACKS
// //   //THE PRODUCER CALL BACK
// //   void producerCallbackFunction(Producer producer) async {
// //     print('🎬 Producer created: ${producer.id} (${producer.kind})');
// //     print('This is the producer appData----- ${producer.appData}');
// //     print(
// //         'This is the producer Track to get what is happening ${producer.stream.getTracks()}');
// //     if (producer.appData['mediaTag'] == 'mic') {
// //       micProducerId = producer.id;
// //       if (mounted) {
// //         setState(() {
// //           isAudioOn = true;
// //         });
// //       }
// //     } else if (producer.appData['mediaTag'] == 'cam') {
// //       videoProducerId = producer.id;
// //       if (mounted) {
// //         setState(() {
// //           renderer?.srcObject = producer.stream;
// //           isVideoOn = true;
// //         });
// //       }
// //     } else if (producer.appData['mediaTag'] == 'screen-share') {
// //       screenshareId = producer.id;
// //       print('✅ Screen share producer created: ${producer.id}');

// //       if (mounted) {
// //         setState(() {
// //           isLocalUserScreenShared = true;
// //           // Set the entire stream instead of specifying trackId
// //           screenshareRender?.srcObject = producer.stream;
// //         });
// //       }

// //       // Log track details
// //       print(
// //           '📹 Screen share tracks: ${producer.stream.getTracks().map((t) => '${t.kind}:${t.id}').join(', ')}');
// //     }
// //     producer.on('trackended', () {
// //       print('This is the dasabling of the microphone or video');
// //       producer.close();
// //     });
// //   }

// //   //THE CONSUMER CALLBACKS
// //   void consumerCallback(Consumer consumer, [dynamic accept]) async {
// //     print('🎬 Consumer callback fired ${consumer.appData}');
// //     // print('consumer being consumed is ${consumer.toString()}');
// //     // Get tracks by type instead of getTracks()
// //     final audioTracks = consumer.stream.getAudioTracks();
// //     final videoTracks = consumer.stream.getVideoTracks();

// //     print('Audio tracks: ${audioTracks.length}!!!$audioTracks');
// //     print('Video tracks: ${videoTracks.length}!!!$videoTracks');
// //     print('consumer being consumed is ${consumer.kind}');
// //     print('consumer track id is ${consumer.track.id}');
// //     print('Consumer is to get consumer ${consumer.stream.getTracks()}');
// //     await updatingUI(consumer);
// //   }

// //   Future<void> updatingUI(Consumer consumer) async {
// //     if (consumer.appData['role'] == 'host' && consumer.kind == 'video') {
// //       //----------------IF THE MEDIATAG IS CAMERA OR SOMETHING--------------
// //       if (consumer.appData['mediaTag'] == 'cam') {
// //         if (hostRender?.srcObject != null) {
// //           hostRender!.srcObject?.getTracks().forEach((track) {
// //             track.stop();
// //           });
// //           await hostRender?.dispose();
// //         }
// //         isMobile = (consumer.appData['device'] == "android") ||
// //             (consumer.appData['device'] == 'IOS');
// //         mobilePlatForm = consumer.appData['device'];
// //         hostRender = RTCVideoRenderer();
// //         await hostRender?.initialize();

// //         // FIX: Don't specify trackId, let it use the entire stream
// //         hostRender?.srcObject = consumer.stream;

// //         if (mounted) {
// //           setState(() {});
// //         }
// //         print(
// //             'This is the consumer in host track details ${consumer.stream.getTracks()}');
// //         print('${hostRender?.srcObject?.getTracks()} is now the host track');
// //       } else if (consumer.appData['mediaTag'] == 'screen-share' &&
// //           !isLocalUserScreenShared) {
// //         if (hostScreenShareRender?.srcObject != null) {
// //           hostScreenShareRender!.srcObject?.getTracks().forEach((track) {
// //             track.stop();
// //           });
// //           await hostScreenShareRender?.dispose();
// //         }

// //         print('🖥️ Setting up host screen share render...');
// //         hostScreenShareRender = RTCVideoRenderer();
// //         await hostScreenShareRender?.initialize();

// //         // Set the entire stream
// //         hostScreenShareRender?.srcObject = consumer.stream;

// //         print(
// //             '✅ Host screen share render set with ${consumer.stream.getTracks().length} tracks');

// //         if (mounted) {
// //           setState(() {
// //             isLocalUserScreenShared = false;
// //           });
// //         }
// //       }
// //     } else if (consumer.appData['role'] == 'challenger' &&
// //         consumer.kind == 'video') {
// //       if (consumer.appData['mediaTag'] == 'cam') {
// //         if (challengerRender?.srcObject != null) {
// //           challengerRender!.srcObject?.getTracks().forEach((track) {
// //             track.stop();
// //           });
// //           await challengerRender?.dispose();
// //         }
// //         isMobile = (consumer.appData['device'] == "android") ||
// //             (consumer.appData['device'] == 'IOS');
// //         mobilePlatForm = consumer.appData['device'];
// //         challengerRender = RTCVideoRenderer();
// //         await challengerRender?.initialize();

// //         // FIX: Don't specify trackId
// //         challengerRender?.srcObject = consumer.stream;

// //         if (mounted) {
// //           setState(() {});
// //         }
// //         print(
// //             'This is the consumer track details ${consumer.stream.getTracks()}');
// //         print(
// //             '${challengerRender?.srcObject?.getTracks()} is now the challenger track');
// //       } else if (consumer.appData['mediaTag'] == 'screen-share' &&
// //           !isLocalUserScreenShared) {
// //         if (challengerScreenShareRender?.srcObject != null) {
// //           challengerScreenShareRender!.srcObject?.getTracks().forEach((track) {
// //             track.stop();
// //           });
// //           await challengerScreenShareRender?.dispose();
// //         }

// //         print('🖥️ Setting up challenger screen share render...');
// //         challengerScreenShareRender = RTCVideoRenderer();
// //         await challengerScreenShareRender?.initialize();

// //         // Set the entire stream
// //         challengerScreenShareRender?.srcObject = consumer.stream;

// //         print(
// //             '✅ Challenger screen share render set with ${consumer.stream.getTracks().length} tracks');

// //         if (mounted) {
// //           setState(() {
// //             isLocalUserScreenShared = false;
// //           });
// //         }
// //       }
// //     }
// //   }

// //   //CONSUME TRACKS
// //   Future<void> consumeTrack(producer, String roomId) async {
// //     //Create a unique completer for this specific consume request

// //     final completer = Completer<void>();
// //     final producerId = producer['producerId'];

// //     void handler(dynamic data) {
// //       if (data['producerId'] != producerId) {
// //         return;
// //       }
// //       print("----------------This is the data coming from the backend: $data");
// //       socket?.off('consumed', handler);
// //       try {
// //         _recvTransport?.consume(
// //           id: data['id'],
// //           producerId: data['producerId'],
// //           peerId: producer['peerId'] ?? data['producerId'],
// //           kind: RTCRtpMediaTypeExtension.fromString(data['kind']),
// //           rtpParameters: RtpParameters.fromMap(data['rtpParameters']),
// //           appData: {
// //             'role': data['role'],
// //             'mediaTag': data['tag'],
// //             'device': producer['peerDevice']
// //           },
// //         );
// //         if (!completer.isCompleted) {
// //           completer.complete();
// //         }
// //       } catch (e) {
// //         print('❌ Failed to create consumer: $e');
// //         if (!completer.isCompleted) {
// //           completer.completeError(e);
// //         }
// //       }
// //     }

// //     socket?.on('consumed', handler);
// //     socket?.emit('consume', {
// //       'roomId': roomId,
// //       'rtpCapabilities': device?.rtpCapabilities.toMap(),
// //       'producerId': producer['producerId'],
// //     });
// //     //wait for this specific consume to complete with a timeout
// //     try {
// //       await completer.future.timeout(Duration(seconds: 10), onTimeout: () {
// //         socket?.off('consumed', handler);
// //         throw TimeoutException('Continue timeout for producer: $producerId');
// //       });
// //     } catch (e) {
// //       print("consumeTrack error: $e");
// //       rethrow;
// //     }
// //     // await completer.future;
// //   }

// //   //LAOD DEVICE FOR COMPARTILIBILITY
// //   Future<void> loadDevice(RtpCapabilities rtpCapabilities) async {
// //     print('📱 Loading device with RTP capabilities...');

// //     try {
// //       device = Device();
// //       await device?.load(routerRtpCapabilities: rtpCapabilities);
// //       print('✅ Device loaded successfully');
// //     } catch (e) {
// //       print('❌ Failed to load device: $e');
// //     }
// //   }

// //   void disableCamera() async {
// //     try {
// //       if (localVideoTrack != null) {
// //         localVideoTrack?.stop();
// //         localVideoTrack = null;
// //       }
// //       if (videoStream != null) {
// //         videoStream?.getTracks().forEach((track) {
// //           track.stop();
// //         });
// //         videoStream = null;
// //         socket?.emit('close-producer', {'producerId': videoProducerId});
// //         socket?.emit('video-stream-stopped', {'role': role});
// //         setState(() {
// //           isVideoOn = false;
// //           renderer?.srcObject = null;
// //           videoStream = null;
// //         });
// //       }
// //     } catch (e) {
// //       print('This is disabling the camera');
// //     }
// //   }

// //   //ENABLE CAMERA FOR SENDING TRACKS
// //   void enableCamera(bool frontCamera) async {
// //     print('🎥 enableCamera() called');
// //     if (device?.canProduce(RTCRtpMediaType.RTCRtpMediaTypeVideo) == false) {
// //       print('❌ Device cannot produce video');
// //       return;
// //     }
// //     if (_sendTransport == null) {
// //       print('❌ Send transport not available');
// //       return;
// //     }
// //     try {
// //       RtpCodecCapability? codec = device!.rtpCapabilities.codecs.firstWhere(
// //         (RtpCodecCapability c) => c.mimeType.toLowerCase() == 'video/vp8',
// //         orElse: () => throw 'VP8 codec not supported',
// //       );

// //       //LOGIC FOR SWITCHING THE CAMERA
// //       if (videoStream != null && frontCamera) {
// //         socket?.emit('close-producer', {'producerId': videoProducerId});
// //         if (isFrontCameraSelected && frontCamera) {
// //           videoStream!
// //               .getVideoTracks()
// //               .forEach((element) => element.switchCamera());
// //         } else {
// //           videoStream!
// //               .getVideoTracks()
// //               .forEach((element) => element.switchCamera());
// //         }
// //       } else if (!frontCamera) {
// //         videoStream = await createVideoStream();
// //       }
// //       localVideoTrack = videoStream?.getVideoTracks().first;
// //       setState(() {});
// //       print('🎬 Calling transport.produce()...');
// //       if (_sendTransport == null) {
// //         print('Calling on the one that is a null value __________________');
// //       }
// //       _sendTransport!.produce(
// //         track: localVideoTrack!,
// //         stream: videoStream!,
// //         codec: codec,
// //         codecOptions: ProducerCodecOptions(videoGoogleStartBitrate: 1000),
// //         source: 'cam',
// //         appData: {
// //           'mediaTag': 'cam',
// //           'role': role,
// //           'device': Platform.isIOS ? 'IOS' : "android"
// //         },
// //       );
// //       print("SendTransport for camera sharing------");
// //       socket?.emit('video-stream-started', {'role': role});
// //       //  _producerCreated = true;
// //     } catch (error) {
// //       print('❌ enableCamera error: $error');
// //       if (videoStream != null) {
// //         await videoStream?.dispose();
// //       }
// //     }
// //   }

// //   Future<MediaStream> createVideoStream() async {
// //     print('📹 Creating video stream...');
// //     Map<String, dynamic> mediaConstraints = <String, dynamic>{
// //       'video': true,
// //     };
// //     try {
// //       MediaStream stream =
// //           await navigator.mediaDevices.getUserMedia(mediaConstraints);
// //       return stream;
// //     } catch (e) {
// //       print('❌ Failed to create video stream: $e');
// //       rethrow;
// //     }
// //   }

// //   Future<MediaStream> createAudioStream() async {
// //     Map<String, dynamic> mediaConstraints = {'audio': true};
// //     MediaStream stream = await navigator.mediaDevices.getUserMedia(
// //       mediaConstraints,
// //     );
// //     return stream;
// //   }

// //   //THIS IS TO ENABLE THE MICROPHONE
// //   void enableMic() async {
// //     if (device?.canProduce(RTCRtpMediaType.RTCRtpMediaTypeAudio) == false) {
// //       return;
// //     }
// //     try {
// //       audioStream = await createAudioStream();
// //       localAudioTrack = audioStream?.getAudioTracks().first;
// //       _sendTransport?.produce(
// //         track: localAudioTrack!,
// //         // codecOptions: ProducerCodecOptions(opusStereo: 1, opusDtx: 1),
// //         stream: audioStream!,
// //         source: 'mic',
// //         appData: {'mediaTag': 'mic', 'role': role},
// //       );
// //       socket!.emit('mic-started', {'role': role});
// //     } catch (e) {
// //       if (audioStream != null) {
// //         await audioStream?.dispose();
// //       }
// //     }
// //   }

// //   //DISABLE MICROPHONE FOR SENDING TRACKS
// //   void disableMic() async {
// //     try {
// //       if (localAudioTrack != null) {
// //         print('This is the producerId $micProducerId');
// //         localAudioTrack?.stop();
// //         localAudioTrack = null;

// //         if (audioStream != null) {
// //           audioStream?.getTracks().forEach((track) {
// //             track.stop();
// //           });
// //           audioStream = null;
// //         }
// //         socket?.emit('close-producer', {'producerId': micProducerId});
// //         setState(() {
// //           isAudioOn = false;
// //           audioStream?.dispose();
// //         });
// //       }
// //     } catch (e) {
// //       print('This is the producerId');
// //     }
// //   }

// //   Future<MediaStream?> shareScreen() async {
// //     try {
// //       if (Platform.isAndroid) {
// //         // More specific constraints for better compatibility
// //         Map<String, dynamic> mediaConstraints = {
// //           'video': {
// //             'mandatory': {
// //               'minWidth': '1280',
// //               'minHeight': '720',
// //               'minFrameRate': '30',
// //             },
// //             'optional': [],
// //           }
// //         };

// //         MediaStream stream =
// //             await navigator.mediaDevices.getDisplayMedia(mediaConstraints);

// //         // Verify stream has active video tracks
// //         if (stream.getVideoTracks().isEmpty) {
// //           throw Exception('Screen capture stream has no video tracks');
// //         }

// //         print(
// //             '✅ Screen stream created with ${stream.getVideoTracks().length} video tracks');
// //         return stream;
// //       } else {
// //         // iOS - use simpler constraints
// //         Map<String, dynamic> mediaConstraints = {
// //           'video': true,
// //         };
// //         MediaStream stream =
// //             await navigator.mediaDevices.getDisplayMedia(mediaConstraints);

// //         if (stream.getVideoTracks().isEmpty) {
// //           throw Exception('Screen capture stream has no video tracks');
// //         }

// //         return stream;
// //       }
// //     } catch (e) {
// //       print("❌ Screen capture failed: $e");
// //       return null;
// //     }
// //   }

// //   void enableShareScreen() async {
// //     try {
// //       if (Platform.isAndroid) {
// //         print('📱 Starting Android screen capture service...');
// //         await ScreenCaptureService().startScreenShare();

// //         // Extended wait time for better compatibility (especially Samsung)
// //         print('⏳ Waiting for service to be ready...');
// //         await Future.delayed(
// //             Duration(milliseconds: 2500)); // Increased from 1000ms

// //         // Verify service is running
// //         final isRunning = await ScreenCaptureService().isServiceRunning();

// //         if (!isRunning) {
// //           throw Exception('Screen capture service failed to start');
// //         }

// //         print('✅ Screen capture service is ready');
// //       }

// //       // Get screen share stream
// //       shareScreenStream = await shareScreen();

// //       if (shareScreenStream == null) {
// //         throw Exception('Failed to get screen share stream');
// //       }

// //       // Verify stream has video tracks
// //       final videoTracks = shareScreenStream?.getVideoTracks();
// //       if (videoTracks == null || videoTracks.isEmpty) {
// //         throw Exception('Screen share stream has no video tracks');
// //       }

// //       localShareScreenTrack = videoTracks.first;

// //       // Verify track is enabled and active
// //       print('📹 Screen track enabled: ${localShareScreenTrack?.enabled}');
// //       print('📹 Screen track id: ${localShareScreenTrack?.id}');
// //       if (localShareScreenTrack == null || !localShareScreenTrack!.enabled!) {
// //         throw Exception('Screen share track is not active');
// //       }

// //       // Produce the screen share track
// //       print('🎬 Producing screen share track...');
// //       _sendTransport?.produce(
// //         track: localShareScreenTrack!,
// //         stream: shareScreenStream!,
// //         source: 'screen-share',
// //         appData: {
// //           'mediaTag': 'screen-share',
// //           'role': role,
// //           'device': Platform.isIOS ? 'IOS' : 'android'
// //         },
// //       );

// //       if (mounted) {
// //         context.pop();
// //       }

// //       socket!.emit('screen-share-started', {'role': role});

// //       print('✅ Screen sharing started successfully');

// //       // Listen for track ended
// //       localShareScreenTrack?.onEnded = () {
// //         print('🛑 Screen share track ended by user');
// //         stopScreenShare();
// //       };
// //     } catch (e) {
// //       print('❌ enableShareScreen error: $e');

// //       // Clean up on error
// //       if (shareScreenStream != null) {
// //         shareScreenStream?.getTracks().forEach((track) {
// //           track.stop();
// //         });
// //         await shareScreenStream?.dispose();
// //         shareScreenStream = null;
// //       }

// //       // Show error to user
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Screen sharing failed. Please try again.'),
// //             backgroundColor: Colors.red,
// //             duration: Duration(seconds: 3),
// //           ),
// //         );

// //         // Close the modal if it's open
// //         try {
// //           context.pop();
// //         } catch (_) {}
// //       }
// //     }
// //   }

// //   void stopScreenShare() async {
// //     try {
// //       print('🛑 Stopping screen share...');

// //       if (localShareScreenTrack != null) {
// //         localShareScreenTrack?.stop();
// //         localShareScreenTrack = null;
// //       }

// //       if (shareScreenStream != null) {
// //         shareScreenStream?.getTracks().forEach((track) {
// //           track.stop();
// //         });
// //         await shareScreenStream?.dispose();
// //         shareScreenStream = null;
// //       }

// //       // Notify server
// //       socket?.emit('close-producer', {'producerId': screenshareId});
// //       socket?.emit('screen-share-stopped', {'role': role});

// //       // Update UI
// //       if (mounted) {
// //         setState(() {
// //           isLocalUserScreenShared = false;
// //           screenshareRender?.srcObject = null;
// //         });
// //       }

// //       print('✅ Screen share stopped successfully');
// //     } catch (e) {
// //       print('❌ Error stopping screen share: ${e.toString()}');
// //     }
// //   }
// // }
// // Future<void> updatingUI(Consumer consumer) async {
// //   if (consumer.appData['role'] == 'host' && consumer.kind == 'video') {
// //     //----------------IF THE MEDIATAGE IS CAMERA OR SOMETHING--------------
// //     if (consumer.appData['mediaTag'] == 'cam') {
// //       if (hostRender?.srcObject != null) {
// //         hostRender!.srcObject?.getTracks().forEach((track) {
// //           track.stop();
// //         });
// //         // hostRender?.setSrcObject(stream: null, trackId: null);
// //         await hostRender?.dispose();
// //       }
// //       isMobile = consumer.appData['device'] == "phone";
// //       hostRender = RTCVideoRenderer();
// //       await hostRender?.initialize();
// //       hostRender?.setSrcObject(
// //           stream: consumer.stream,
// //           trackId: consumer.stream
// //               .getTracks()
// //               .firstWhere((track) => track.kind == 'video')
// //               .id);
// //       if (mounted) {
// //         setState(() {});
// //       }
// //       print(
// //           'This is the consumer in host track details ${consumer.stream.getTracks()}');
// //       print('${hostRender?.srcObject?.getTracks()} is now the host track');
// //       //-------------IF THE MEDIATAG IS SCREEN-SHARE OR SOMETHING--------------
// //     } else if (consumer.appData['mediaTag'] == 'screen-share' &&
// //         !isLocalUserScreenShared) {
// //       if (hostScreenShareRender?.srcObject != null) {
// //         hostScreenShareRender!.srcObject?.getTracks().forEach((track) {
// //           track.stop();
// //         });
// //         await screenshareRender?.dispose();
// //       }
// //       hostScreenShareRender = RTCVideoRenderer();
// //       await hostScreenShareRender?.initialize();
// //       hostScreenShareRender?.setSrcObject(
// //           stream: consumer.stream,
// //           trackId: consumer.stream
// //               .getTracks()
// //               .firstWhere((track) => track.kind == 'video')
// //               .id);
// //       if (mounted) {
// //         setState(() {
// //           isLocalUserScreenShared = false;
// //         });
// //       }
// //     }
// //     //----------------------WHEN THE REMOTE USER IS THE CHALLENGER--------------------
// //   } else if (consumer.appData['role'] == 'challenger' &&
// //       consumer.kind == 'video') {
// //     if (consumer.appData['mediaTag'] == 'cam') {
// //       if (challengerRender?.srcObject != null) {
// //         challengerRender!.srcObject?.getTracks().forEach((track) {
// //           track.stop();
// //         });
// //         // challengerRender?.setSrcObject(stream: null, trackId: null);
// //         await challengerRender?.dispose();
// //       }
// //       isMobile = consumer.appData['device'] == "phone";
// //       challengerRender = RTCVideoRenderer();
// //       await challengerRender?.initialize();
// //       challengerRender?.setSrcObject(
// //           stream: consumer.stream,
// //           trackId: consumer.stream
// //               .getTracks()
// //               .firstWhere((track) => track.kind == 'video')
// //               .id);
// //       if (mounted) {
// //         setState(() {});
// //       }
// //       print(
// //           'This is the consumer track details ${consumer.stream.getTracks()}');
// //       print(
// //           '${challengerRender?.srcObject?.getTracks()} is now the challenger track');
// //     } else if (consumer.appData['mediaTag'] == 'screen-share' &&
// //         !isLocalUserScreenShared) {
// //       if (challengerScreenShareRender?.srcObject != null) {
// //         challengerScreenShareRender!.srcObject?.getTracks().forEach((track) {
// //           track.stop();
// //         });
// //         await challengerScreenShareRender?.dispose();
// //       }
// //       challengerScreenShareRender = RTCVideoRenderer();
// //       await challengerScreenShareRender?.initialize();
// //       challengerScreenShareRender?.setSrcObject(
// //           stream: consumer.stream,
// //           trackId: consumer.stream
// //               .getTracks()
// //               .firstWhere((track) => track.kind == 'video')
// //               .id);
// //       if (mounted) {
// //         setState(() {
// //           isLocalUserScreenShared = false;
// //         });
// //       }
// //     }
// //   }
// // }

// // ignore_for_file: deprecated_member_use, use_build_context_synchronously
// import 'dart:async';
// import 'dart:io';
// import 'package:clapmi/core/api/multi_env.dart';
// import 'package:clapmi/core/app_variables.dart';
// import 'package:clapmi/core/services/notification_handler_classes/notificationWorkers/util_functions.dart';
// import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
// import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
// import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
// import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
// import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
// import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
// import 'package:clapmi/screens/challenge/others/Single_livestream.dart';
// import 'package:clapmi/screens/challenge/others/comment_box.dart';
// import 'package:clapmi/screens/challenge/others/multiple_livestream_screen.dart';
// import 'package:clapmi/screens/challenge/others/screenshare_service.dart';
// import 'package:clapmi/screens/challenge/others/user_join_widget_animation.dart';
// import 'package:clapmi/screens/challenge/widgets/challenge_view.dart';
// import 'package:clapmi/screens/challenge/widgets/livestream%20_header.dart';
// import 'package:clapmi/screens/challenge/widgets/livestream_widget.dart';
// import 'package:clapmi/screens/challenge/widgets/progress_bar.dart';
// import 'package:clapmi/screens/challenge/widgets/single_livestream_video_rendering.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:intl/intl.dart';
// import 'package:mediasfu_mediasoup_client/mediasfu_mediasoup_client.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:wakelock_plus/wakelock_plus.dart';

// class LiveComboThreeImageScreen extends StatefulWidget {
//   const LiveComboThreeImageScreen(
//       {super.key,
//       required this.comboInfo,
//       required this.comboId,
//       required this.bragID});
//   final LiveComboEntity comboInfo;
//   final String comboId;
//   final String bragID;

//   @override
//   State<LiveComboThreeImageScreen> createState() =>
//       _LiveComboThreeImageScreenState();
// }

// class _LiveComboThreeImageScreenState extends State<LiveComboThreeImageScreen>
//     with TickerProviderStateMixin {
//   final List<Map<String, dynamic>> _comments = [];
//   final ScrollController _scrollController = ScrollController();
//   final List<AnimationController> _controllers = [];
//   bool _userScrolling = false;
//   bool _isLoading = true;
//   Timer? _newCommentTimer;
//   static const int visibleCount = 4;
//   static const double commentHeight = 60.0;
//   TextEditingController commentController = TextEditingController();
//   bool showPopup = false;
//   //media status
//   bool isAudioOn = false, isVideoOn = false, isFrontCameraSelected = true;
//   //LIVESTREAMS VARIABLES
//   IO.Socket? socket;
//   Device? device;
//   Transport? _sendTransport;
//   Transport? _recvTransport;
//   RTCVideoRenderer? renderer;
//   RTCVideoRenderer? hostRender;
//   RTCVideoRenderer? challengerRender;
//   RTCVideoRenderer? screenshareRender;
//   RTCVideoRenderer? hostScreenShareRender;
//   RTCVideoRenderer? challengerScreenShareRender;
//   bool isLocalUserScreenShared = false;
//   String roomId = '';
//   String role = '';
//   String micProducerId = '';
//   String videoProducerId = '';
//   MediaStream? audioStream;
//   MediaStream? videoStream;
//   MediaStream? shareScreenStream;
//   MediaStreamTrack? localShareScreenTrack;
//   MediaStreamTrack? localAudioTrack;
//   MediaStreamTrack? localVideoTrack;
//   String screenshareId = '';
//   bool isFullScreen = false;
//   num totalGiftingPot = 0.0;
//   num hostCoin = 0;
//   num challengerCoin = 0;
//   bool userClappEvent = false;
//   DateTime? targetTime;
//   String? timerCountdown;
//   int numberOfStreamers = 0;
//   late AnimationController _controller;
//   late Animation<double> _positionAnimation;
//   late Animation<double> _opacityAnimation;
//   bool? isComboOngoingNow;
//   int numberOfChallenger = 0;
//   LiveGifter? liveChallenger;
//   ComboInLiveStream? liveChallengerData;
//   Timer? _timer;
//   bool isthereInternet = true;
//   StreamSubscription? internetSubscription;
//   bool isMobile = false;
//   String mobilePlatForm = '';

//   //LIVESTREAM SOCKET CONNECTION
//   Future<void> connect() async {
//     print('🔌 CONNECTING TO SERVER...');
//     socket = IO.io(MultiEnv().socketIoUrl, <String, dynamic>{
//       'transports': ['websocket'],
//       'path': '/ss/socket.io',
//     });

//     socket?.onConnect((_) async {
//       print("✅ Connected to SFU Server");
//       socket?.off('new-producer');
//       if (role == 'host' || role == 'challenger') {
//         socket?.emitWithAck(
//           'check-room',
//           {'roomId': roomId},
//           ack: (data) async {
//             print('Does this room exist? : $data');
//             if (!data['exists']) {
//               socket?.emit('create-room', {
//                 'roomId': roomId,
//                 'device': Platform.isIOS ? "IOS" : "android"
//               });
//               await waitForResult('room-created');
//               socket?.emit('join-room', {
//                 'roomId': roomId,
//                 'userId': profileModelG?.pid,
//                 'device': Platform.isIOS ? "IOS" : "android"
//               });
//             }
//           },
//         );
//       }
//       print('DATA DO NOT EXIST THEN JOIN ROOM $roomId');
//       //EMIT JOIN-ROOM FOR ACCESS
//       socket?.emit('join-room', {
//         'roomId': roomId,
//         'userId': profileModelG?.pid,
//         'device': Platform.isIOS ? 'IOS' : 'android'
//       });
//       //RESPONSE AFTER JOINING THE ROOM
//       final transport = await waitForResult('joined-room');
//       print("This is the trannsport care $transport");
//       final routerCapabilities = RtpCapabilities.fromMap(
//         transport['routerRtpCapabilities'],
//       );
//       final producers = transport['producers'];
//       await loadDevice(routerCapabilities);
//       if (role == 'host' || role == 'challenger') {
//         print("creating send transport------------- $role");
//         await createSendTransport(roomId, role);
//       }
//       await createRecvTransport(roomId);
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//       //CONSUME TRACKS FOR ALL ROLES
//       for (var producer in producers) {
//         try {
//           print(
//               "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@loopin through producers $producer");
//           await consumeTrack(producer, roomId);
//         } catch (error) {
//           print('❌ Failed to consume producer ');
//         }
//       }
//       socket?.on('new-producer', (data) async {
//         print('!!!!!!!!!!!!!!!!!!!!!!!!!!!data coming from new-producer $data');
//         try {
//           //await createRecvTransport(roomId);
//           await consumeTrack(data, roomId);
//         } catch (error) {
//           print(
//             '❌ Failed to consume new producer ${data['producerId']}, and the error ${error.toString()}',
//           );
//         }
//       });
//     });
//     socket?.on('screen-share-stopped', (data) async {
//       try {
//         if (data['role'] == 'host') {
//           hostScreenShareRender?.setSrcObject(stream: null, trackId: null);
//         } else if (data['role'] == 'challenger') {
//           challengerScreenShareRender?.setSrcObject(
//               stream: null, trackId: null);
//         }
//         setState(() {});
//       } catch (e) {}
//     });
//     socket?.on('video-stream-stopped', (data) async {
//       try {
//         if (data['role'] == 'host') {
//           hostRender?.setSrcObject(stream: null, trackId: null);
//         } else if (data['role'] == 'challenger') {
//           challengerRender?.setSrcObject(stream: null, trackId: null);
//         }
//         setState(() {});
//       } catch (e) {}
//     });
//     //END OF CONNECTION WITH THE SOCKET... WHEN IT IS CONNECTED THE EVENTS ARE CALLED WITHIN THEM
//     socket?.onConnectError((data) {
//       print('❌ Connection Error: $data');
//     });
//     socket?.onDisconnect((data) {
//       print('🛑 Disconnected: $data');
//     });
//   }

//   assignRole() {
//     //Check if there is an ongoingCombo inside combo
//     if (widget.comboInfo.hasOngoingCombo == true) {
//       isComboOngoingNow = widget.comboInfo.hasOngoingCombo;
//       if (widget.comboInfo.onGoingCombo?.host?.profile == profileModelG?.pid) {
//         role = 'host';
//       } else if (widget.comboInfo.onGoingCombo?.challenger?.profile ==
//           profileModelG?.pid) {
//         role = 'challenger';
//       } else {
//         role = 'spectator';
//         _isLoading = false;
//       }
//     }
//     //**WHEN THERE IS NO ONGOING COMBO */
//     else {
//       isComboOngoingNow = false;
//       if (widget.comboInfo.host?.profile == profileModelG?.pid) {
//         role = 'host';
//         _isLoading = true;
//       } else if (widget.comboInfo.challenger?.profile == profileModelG?.pid) {
//         role = 'challenger';
//         _isLoading = true;
//       } else {
//         role = 'spectator';
//         _isLoading = false;
//       }
//     }
//     numberOfStreamers = widget.comboInfo.presence ?? 1;
//   }

//   initRenderers() async {
//     renderer = RTCVideoRenderer();
//     hostRender = RTCVideoRenderer();
//     challengerRender = RTCVideoRenderer();
//     screenshareRender = RTCVideoRenderer();
//     await renderer?.initialize();
//     await hostRender?.initialize();
//     await challengerRender?.initialize();
//     await screenshareRender?.initialize();
//     assignRole();
//     roomId = widget.comboInfo.combo ?? widget.comboId;
//     //widget.comboInfo.onGoingCombo?.combo;
//   }

//   void countdownTimer(
//       {required String? startTime, required String? durationTime}) {
//     _timer?.cancel();
//     _timer = Timer.periodic((Duration(seconds: 1)), (timer) {
//       final now = DateTime.now();
//       final duration = durationFromOption(durationTime ?? '');
//       final remaining = DateFormat("yyyy-MM-dd HH:mm:ss")
//           .parse(startTime ?? '', true)
//           .toLocal()
//           .add(duration)
//           .difference(now);
//       // targetTime?.difference(now);
//       if (mounted) {
//         if (remaining.isNegative || remaining.inSeconds == 0) {
//           setState(() {
//             timerCountdown = "00:00:00";
//           });
//           timer.cancel();
//         } else {
//           setState(() {
//             timerCountdown = formatHHMMSS(remaining);
//             //  "${remaining.inHours}:${remaining.inMinutes % 60}:${remaining.inSeconds % 60}";
//           });
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     WakelockPlus.enable();
//     internetSubscription =
//         InternetConnection().onStatusChange.listen((InternetStatus status) {
//       if (status == InternetStatus.connected) {
//         setState(() {
//           isthereInternet = true;
//         });
//       } else {
//         isthereInternet = false;
//       }
//     });
//     //TIME TICKING FOR WHEN THE COMBO WILL END.
//     countdownTimer(
//         startTime: widget.comboInfo.onGoingCombo?.startTime ??
//             widget.comboInfo.metaData?.start_time,
//         durationTime: widget.comboInfo.onGoingCombo?.duration ??
//             widget.comboInfo.duration);
//     //ANIMATION CONTROLLERS
//     _controller =
//         AnimationController(vsync: this, duration: Duration(seconds: 10));
//     _positionAnimation = Tween<double>(begin: 0.5, end: 0.7)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//     _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
//         CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));
//     context.read<ChatsAndSocialsBloc>().add(SubscribeTochatEvent(
//         conversationId: widget.comboId, isLiveComboSubscription: true));
//     context
//         .read<ChatsAndSocialsBloc>()
//         .add(GetTotalGiftsEvent(comboId: widget.comboId));
//     if (mounted) {
//       setState(() {
//         hostCoin = widget.comboInfo.gifts?.host ?? 0;
//         if (isComboOngoingNow == true) {
//           challengerCoin =
//               widget.comboInfo.onGoingCombo?.gifts?.challenger ?? 0;
//         } else {
//           challengerCoin = widget.comboInfo.gifts?.challenger ?? 0;
//         }
//       });
//     }
//     initRenderers().then((_) {
//       connect();
//     });
//     //**SWITCH THE ANIMATION STATUS WHEN IT IS COMPLETED */
//     _controller.addStatusListener((status) {
//       if (status.isCompleted) {
//         setState(() {
//           print("----STATUS IS COMPLETED");
//           userClappEvent = false;
//         });
//       }
//     });
//     _scrollController.addListener(_handleScroll);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     WakelockPlus.disable();
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     internetSubscription?.cancel();
//     socket?.disconnect();
//     _timer?.cancel();
//     socket?.dispose();
//     _scrollController.dispose();
//     _newCommentTimer?.cancel();
//     _sendTransport?.close();
//     _recvTransport?.close();
//     renderer?.dispose();
//     hostRender?.dispose();
//     challengerRender?.dispose();
//     shareScreenStream?.dispose();
//     localShareScreenTrack?.dispose();
//     localAudioTrack?.dispose();
//     videoStream?.dispose();
//     audioStream?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom > 0;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
//           listener: (context, state) {
//             if (state is LiveCommentState) {
//               _addComment({
//                 'state': state.commentData,
//                 'stateName': 'commentLive',
//               });
//             }
//             if (state is ClappLiveState) {
//               _controller.reset();
//               _controller.forward();
//             }
//             if (state is ComboEnded) {
//               //Handle the clearing of all resources for livestreaming...
//               //Also show the dialog that streaming has ended...
//               print("Combo has ended ${state.comboDetails.toString()}");
//               if (isComboOngoingNow == true) {
//                 //Revert back to single Livestream screen.
//                 setState(() {
//                   isComboOngoingNow = false;
//                   print(
//                       "This should change the state of the screen or something");
//                   countdownTimer(
//                       startTime: widget.comboInfo.metaData?.start_time,
//                       durationTime: widget.comboInfo.duration);
//                 });
//               } else {
//                 print("An host has left the livestream------------");
//                 setState(() {
//                   timerCountdown = "00:00:00";
//                 });
//                 _timer?.cancel();
//                 // showDialogInforamtion(context, onPressed: () {
//                 // context.pop();
//                 // });
//               }
//               // if (state.comboDetails.wins?.winner == profileModelG?.pid) {
//               //   // showWinnersBadge(context);
//               // } else if (state.comboDetails.wins?.loser == profileModelG?.pid) {
//               //   //  showLoosersBadge(context);
//               // }
//               // showDialogInforamtion(context, onPressed: () {
//               //   context.pop();
//               // });
//             }
//             if (state is PotAmount) {
//               setState(() {
//                 totalGiftingPot = state.totalAmount;
//               });
//             }
//             if (state is UserJoined) {
//               setState(() {
//                 numberOfStreamers = numberOfStreamers + 1;
//               });
//               _controller.reset();
//               _controller.forward();
//               print(
//                   'THE USERNAME OF THE USER IS ${state.userJoined.user?.username}');
//               print("${state.userJoined.user?.pid}");
//               print("${widget.comboInfo.host?.profile}");
//               if (state.userJoined.user?.pid ==
//                       widget.comboInfo.host?.profile ||
//                   state.userJoined.user?.pid ==
//                       widget.comboInfo.challenger?.profile) {
//                 socket?.dispose();
//                 connect();
//               }
//               //Check if a host or challenger is the one that joined.
//               //Then you can reconnect but before then dispose the socket
//               // socket?.dispose();
//             }
//             if (state is UserLeaveCombo) {
//               if (state.user.user?.pid == profileModelG?.pid) {
//                 print("HOST OR CHALLENGER LEAVING---");
//                 // context.goNamed(MyAppRouteConstant.challenge);
//                 context.pop();
//                 context.pop();
//               } else {
//                 _addComment({
//                   'state': state.user,
//                   'stateName': 'userLeaves',
//                 });
//                 setState(() {
//                   numberOfStreamers = numberOfStreamers - 1;
//                 });
//               }
//             }
//             if (state is GiftingState) {
//               setState(() {
//                 totalGiftingPot = totalGiftingPot +
//                     num.parse(state.gifts.giftdata?.amount ?? '0');
//                 if (state.gifts.giftdata?.receiver ==
//                     widget.comboInfo.host?.profile) {
//                   print('HOST GIFTITNG-----------');
//                   hostCoin =
//                       hostCoin + num.parse(state.gifts.giftdata?.amount ?? '0');
//                 } else if (isComboOngoingNow == true &&
//                     (state.gifts.giftdata?.receiver == liveChallenger?.pid ||
//                         state.gifts.giftdata?.receiver ==
//                             widget
//                                 .comboInfo.onGoingCombo?.challenger?.profile)) {
//                   challengerCoin = challengerCoin +
//                       num.parse(state.gifts.giftdata?.amount ?? '0');
//                 } else if (state.gifts.giftdata?.receiver ==
//                     widget.comboInfo.challenger?.profile) {
//                   print('CHALLENGER GIFTING.............');
//                   challengerCoin = challengerCoin +
//                       num.parse(state.gifts.giftdata?.amount ?? '0');
//                 }
//               });
//               _controller.reset();
//               _controller.forward();
//             }
//             if (state is ComboGroundInLive) {
//               print("THE INNER COMBO IS ACTIVATED AND LIVE---****&&&&");
//               setState(() {
//                 isComboOngoingNow = true;
//                 liveChallenger = state.comboData.challenger;
//                 liveChallengerData = state.comboData;
//                 countdownTimer(
//                     startTime: state.comboData.comboGround?.start,
//                     durationTime: state.comboData.comboGround?.duration);
//               });
//             }
//             if (state is LiveBragInCombo) {
//               print("Testing the liveBrag updating");
//               if (state.challenge.action == 'add') {
//                 setState(() {
//                   numberOfChallenger = numberOfChallenger + 1;
//                 });
//               } else if (state.challenge.action == 'remove') {
//                 numberOfChallenger =
//                     numberOfChallenger - 1 < 1 ? 0 : numberOfChallenger - 1;
//               }
//             }
//           },
//           builder: (context, state) {
//             //CONDITION TO SHOW THAT THE COMBO OR SINGLE IS NOT AVAILABLE AGAIN
//             return timerCountdown == "00:00:00" && isComboOngoingNow == false
//                 ? Center(
//                     child: Container(
//                       margin: EdgeInsets.symmetric(horizontal: 65.w),
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
//                       decoration: BoxDecoration(
//                           color: getFigmaColor("121212"),
//                           borderRadius: BorderRadius.circular(20.0)),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 60,
//                             height: 60,
//                             decoration: BoxDecoration(
//                               color: Colors.blue[700],
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.check,
//                               color: Colors.white,
//                               size: 36,
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           // "Challenge Sent" text
//                           const Text(
//                             'Stream has ended',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 32),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 context.pop();
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue[700],
//                                 foregroundColor: Colors.white,
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 16),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 textStyle: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               child: const Text('close'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 : _isLoading
//                     ? Container(
//                         decoration:
//                             BoxDecoration(color: Colors.grey.withAlpha(10)),
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.blueAccent,
//                           ),
//                         ))
//                     //** THIS IS THE STACK WITH THE HEADER **//
//                     : Stack(children: <Widget>[
//                         Container(
//                           margin: EdgeInsets.only(top: 120.h, bottom: 20.h),
//                           child: SizedBox(
//                             //  height: MediaQuery.of(context).size.height / 2,
//                             //**THIS IS THE STACK WITHOUT THE HEADER **//
//                             //CHECK IF COMBO DOES NOT HAVE ONGOINGOCOMBO
//                             child: isComboOngoingNow == false
//                                 ?
//                                 //CHECK IF THE TYPE OF COMBO IS SINGLE
//                                 widget.comboInfo.type == 'single'
//                                     ?
//                                     //THEN CHECK IF THE USER IS THE HOST
//                                     widget.comboInfo.host?.profile ==
//                                             profileModelG?.pid
//                                         //CHECK IF THE HOST(LOCAL USER) IS SHARING SCREEN
//                                         ? screenshareRender?.srcObject != null
//                                             ? ScreenShareView(
//                                                 isHostLocalUser: widget
//                                                         .comboInfo
//                                                         .host
//                                                         ?.profile ==
//                                                     profileModelG?.pid,
//                                                 role: 'host',
//                                                 isMobile: isMobile,
//                                                 mobilePlatForm: mobilePlatForm,
//                                                 imageUrl: widget
//                                                     .comboInfo.host?.avatar,
//                                                 imageAvatar: widget.comboInfo
//                                                     .host?.avatarConvert,
//                                                 cameraRenderer: renderer,
//                                                 isFullScreen: isFullScreen,
//                                                 action: () {
//                                                   stopScreenShare();
//                                                 },
//                                                 screenshareRender:
//                                                     screenshareRender,
//                                               )
//                                             //**IF THE HOST(LOCAL USER) IS NOT SHARING SCREEN */
//                                             : SingleVideoView(
//                                                 aspectRatio: 0.8,
//                                                 isMobile: isMobile,
//                                                 mobilePlatForm: mobilePlatForm,
//                                                 imageUrl: widget.comboInfo.host
//                                                         ?.avatar ??
//                                                     '',
//                                                 imageAvatar: widget
//                                                     .comboInfo.host?.avatarConvert,
//                                                 renderer: renderer!,
//                                                 profilePicMargin:
//                                                     EdgeInsets.only(
//                                                         top: 230.h,
//                                                         left: 120.w),
//                                                 profilePicHeight: 100.w,
//                                                 profilePicWidth: 100.w,
//                                                 shouldShowVideo:
//                                                     renderer?.srcObject != null)
//                                         :
//                                         //IF THE USER IS NOT THE HOST(LOCAL USER) OF THE SINGLE LIVESTREM
//                                         //IF THE HOST(REMOTE USER) IS SHARING SCREEN
//                                         hostScreenShareRender?.srcObject != null
//                                             ? ScreenShareView(
//                                                 isHostLocalUser: widget
//                                                         .comboInfo
//                                                         .host
//                                                         ?.profile ==
//                                                     profileModelG?.pid,
//                                                 isMobile: isMobile,
//                                                 mobilePlatForm: mobilePlatForm,
//                                                 role: 'host',
//                                                 imageUrl: widget
//                                                     .comboInfo.host?.avatar,
//                                                 imageAvatar: widget.comboInfo
//                                                     .host?.avatarConvert,
//                                                 cameraRenderer: hostRender,
//                                                 isFullScreen: isFullScreen,
//                                                 action: () {},
//                                                 screenshareRender:
//                                                     hostScreenShareRender,
//                                               )
//                                             //**IF HOST AS THE (REMOTE USER) IS NOT SHARING SCREEN */
//                                             : SingleVideoView(
//                                                 aspectRatio: 0.8,
//                                                 isMobile: isMobile,
//                                                 mobilePlatForm: mobilePlatForm,
//                                                 remoteRole: 'host',
//                                                 imageUrl: widget.comboInfo.host
//                                                         ?.avatar ??
//                                                     '',
//                                                 imageAvatar: widget.comboInfo
//                                                     .host?.avatarConvert,
//                                                 renderer: hostRender!,
//                                                 profilePicMargin:
//                                                     EdgeInsets.only(
//                                                         top: 210.h,
//                                                         left: 120.w),
//                                                 profilePicHeight: 100.w,
//                                                 profilePicWidth: 100.w,
//                                                 shouldShowVideo:
//                                                     hostRender?.srcObject !=
//                                                         null)
//                                     :
//                                     //**LIVESTREAM IS MULTIPLE AND THERE IS NO ONGOING COMBO */
//                                     MultipleLiveStreamScreen(
//                                         isMobile: isMobile,
//                                         mobilePlatForm: mobilePlatForm,
//                                         hostScreenShareRender:
//                                             hostScreenShareRender,
//                                         challengerScreenShareRender:
//                                             challengerScreenShareRender,
//                                         hostRender: hostRender,
//                                         widget: widget,
//                                         isFullScreen: isFullScreen,
//                                         challengerRender: challengerRender,
//                                         screenshareRender: screenshareRender,
//                                         renderer: renderer,
//                                         hasOngoingCombo:
//                                             isComboOngoingNow == true,
//                                         // ??widget.comboInfo.hasOngoingCombo == true,
//                                         role: role)
//                                 :
//                                 //**WHEN THE COMBOINFO HAS ONGOING COMBO */
//                                 MultipleLiveStreamScreen(
//                                     isMobile: isMobile,
//                                     mobilePlatForm: mobilePlatForm,
//                                     hostScreenShareRender: hostScreenShareRender,
//                                     challengerScreenShareRender: challengerScreenShareRender,
//                                     hostRender: hostRender,
//                                     widget: widget,
//                                     isFullScreen: isFullScreen,
//                                     challengerRender: challengerRender,
//                                     screenshareRender: screenshareRender,
//                                     renderer: renderer,
//                                     hasOngoingCombo: isComboOngoingNow == true,
//                                     //  ??widget.comboInfo.hasOngoingCombo == true,
//                                     role: role),
//                           ),
//                         ),
//                         //THIS IS THE HEADER
//                         LivestreamHeader(
//                           comboInfo: widget.comboInfo,
//                           comboId: widget.comboId,
//                           totalGiftingPot: totalGiftingPot,
//                           timerCountdown: timerCountdown,
//                           bragID: widget.bragID,
//                           streamersCount: numberOfStreamers,
//                           numOfChallengers: numberOfChallenger,
//                           liveChallenger: liveChallengerData,
//                           isLiveGoingNow: isComboOngoingNow == true,
//                           onLeaveComboEvent: (value) {
//                             if (value) {
//                               //**CHECK THAT IT IS A MULTIPLE COMBO AND ALSO THE USER IS */
//                               //**EITHER A HOST OR A CHALLENGER */
//                               // if (
//                               //   //widget.comboInfo.type == "multiple" &&
//                               //     (widget.comboInfo.host?.profile ==
//                               //             profileModelG?.pid ||
//                               //         widget.comboInfo.challenger?.profile ==
//                               //             profileModelG?.pid)) {
//                               showModalBottomSheet(
//                                   context: context,
//                                   builder: (context) {
//                                     return EndliveStream(
//                                       comboId: widget.comboId,
//                                     );
//                                   });
//                               //  }
//                             }
//                           },
//                         ),

//                         //THIS IS THE PROGRESS BAR
//                         //-----------------------------
//                         if (widget.comboInfo.type == "multiple" ||
//                             isComboOngoingNow == true)
//                           Positioned(
//                               top: role == 'spectator' ? 150.h : 150.h,
//                               left: 8,
//                               child: SizedBox(
//                                 // padding: EdgeInsets.only(right: 15.w),
//                                 child: ProgressBars(
//                                   hostCoinAmount: hostCoin,
//                                   challengerCoinAmount: challengerCoin,
//                                   progress: hostCoin / totalGiftingPot,
//                                 ),
//                               )),
//                         // THIS IS TO SHOW THE TEXT WIDGET...
//                         if (state is UserJoined)
//                           LiveNotification(
//                             controller: _controller,
//                             positionAnimation: _positionAnimation,
//                             opacityAnimation: _opacityAnimation,
//                             child: userJoin(
//                                 imageUrl: state.userJoined.user?.image ?? '',
//                                 message: state.userJoined.message,
//                                 userName:
//                                     state.userJoined.user?.username ?? ''),
//                           ),
//                         if (state is GiftingState)
//                           LiveNotification(
//                             controller: _controller,
//                             positionAnimation: _positionAnimation,
//                             opacityAnimation: _opacityAnimation,
//                             child: giftWidget(
//                                 imageUrl:
//                                     state.gifts.giftdata?.sender?.avatar ?? '',
//                                 message: state.gifts.message,
//                                 userName:
//                                     state.gifts.giftdata?.sender?.username ??
//                                         '',
//                                 amount: state.gifts.giftdata?.amount ?? ''),
//                           ),
//                         if (state is ClappLiveState)
//                           LiveNotification(
//                             controller: _controller,
//                             positionAnimation: _positionAnimation,
//                             opacityAnimation: _opacityAnimation,
//                             child: clapLiveWidget(
//                                 imageUrl: state.clapData.user?.avatar,
//                                 message: state.clapData.message,
//                                 userName: state.clapData.user?.username,
//                                 myavatar: state.clapData.user?.avatarConvert),
//                           ),
//                         if (userClappEvent)
//                           LiveNotification(
//                             controller: _controller,
//                             positionAnimation: _positionAnimation,
//                             opacityAnimation: _opacityAnimation,
//                             child: clapLiveWidget(
//                                 imageUrl: profileModelG?.image ?? '',
//                                 message: 'You sent a like \u2764\uFE0F',
//                                 userName: profileModelG?.username ?? '',
//                                 myavatar: profileModelG?.myAvatar),
//                           ),

//                         //THIS IS THE BOTTOM SECTION WITH THE COMMENT SESSION OF THE LIVESTREAM
//                         //------------------------------------------------------------------------
//                         Positioned(
//                           bottom: MediaQuery.of(context).viewInsets.bottom,
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 IgnorePointer(
//                                     ignoring: true,
//                                     child: Container(
//                                       height: visibleCount * commentHeight,
//                                       margin: EdgeInsets.only(bottom: 8.h),
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         controller: _scrollController,
//                                         itemExtent: commentHeight,
//                                         itemCount: _comments.length,
//                                         itemBuilder: (context, index) =>
//                                             _buildAnimatedComment(index),
//                                       ),
//                                     )),
//                                 //** THE IDEA HERE IS TO ALWAYS REBUILD THE WIDGET WHENEVER THE
//                                 //** ISCOMBOGOINGNOW CHANGES....
//                                 if (isComboOngoingNow == true ||
//                                     isComboOngoingNow == false)
//                                   //**BOTTOM BUTTON SESSION OF THE LIVESTREAM SCREEN */
//                                   LiveStreamBottomSession(
//                                     comboId: widget.comboId,
//                                     comboInfo: widget.comboInfo,
//                                     bragID: widget.bragID,
//                                     isLiveOngoing: isComboOngoingNow == true,
//                                     liveChallenger: liveChallenger,
//                                     sendComment: (comment) {
//                                       _addComment({
//                                         'state': comment,
//                                         'stateName': 'commentLive',
//                                       });
//                                     },
//                                     onUserClappEvent: (value) {
//                                       if (value) {
//                                         setState(() {
//                                           _controller.reset();
//                                           _controller.forward();
//                                           userClappEvent = value;
//                                         });
//                                       }
//                                     },
//                                     onLiveMicPressed: (value) {
//                                       value ? enableMic() : disableMic();
//                                     },
//                                     isMicEnabled: isAudioOn,
//                                     onLiveCameraPressed: (value) {
//                                       value
//                                           ? enableCamera(false)
//                                           : disableCamera();
//                                     },
//                                     isCameraEnable: isVideoOn,
//                                     isLiveRecording: isFrontCameraSelected,
//                                     onLiveRecordingPressed: (value) {
//                                       if (value) {
//                                         setState(() {
//                                           isFrontCameraSelected = true;
//                                         });
//                                         enableCamera(true);
//                                       }
//                                     },
//                                     isScreenShared:
//                                         screenshareRender?.srcObject != null,
//                                     onShareScreenPressed: (value) {
//                                       value
//                                           ? showModalBottomSheet(
//                                               context: context,
//                                               builder: (context) {
//                                                 return ScreenSharingIcon(
//                                                   onPress: () {
//                                                     enableShareScreen();
//                                                   },
//                                                 );
//                                               },
//                                             )
//                                           : stopScreenShare();
//                                       //enableShareScreen() : stopScreenShare();
//                                     },
//                                     onEnlargeScreenPressed: (value) {},
//                                     isScreenEnlarged: false,
//                                     onExitPressed: (value) {
//                                       if (value) {
//                                         //  if (
//                                         //widget.comboInfo.type == "multiple" &&
//                                         // (widget.comboInfo.host?.profile ==
//                                         //         profileModelG?.pid ||
//                                         //     widget.comboInfo.challenger?.profile ==
//                                         //         profileModelG?.pid)) {
//                                         showModalBottomSheet(
//                                             context: context,
//                                             builder: (context) {
//                                               return EndliveStream(
//                                                 comboId: widget.comboId,
//                                               );
//                                             });
//                                         //  }
//                                       }
//                                     },
//                                     onTurnedOffPressed: (value) {},
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         //INTERNET CONNECTION OVERLAY.
//                         if (!isthereInternet)
//                           Positioned.fill(
//                             child: AbsorbPointer(
//                               absorbing: true,
//                               child: Container(
//                                 decoration: BoxDecoration(),
//                                 child: Align(
//                                   alignment: Alignment(0, -.7),
//                                   child: Container(
//                                     // height: 40.h,
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 10.w, vertical: 2.h),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                         border: Border.all(
//                                             // color: Colors.white,
//                                             ),
//                                         color:
//                                             // Colors.red
//                                             Colors.black.withAlpha(200)),
//                                     child: Text(
//                                       "Stream quality reduced due to unstable internet connection",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 10.sp,
//                                           fontWeight: FontWeight.w600,
//                                           fontFamily: 'Poppins'),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ]);
//           },
//         ),
//       ),
//     );
//   }

//   //**CALCULATE THE HANDSCROLLING INTERACTION */
//   void _handleScroll() {
//     // If user scrolls away from bottom, pause auto-scroll
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final currentScroll = _scrollController.position.pixels;

//     final isAtBottom = (maxScroll - currentScroll).abs() < 20;
//     if (isAtBottom) {
//       _userScrolling = false;
//     } else {
//       _userScrolling = true;
//     }
//   }

//   //**LOGIC TO ADD LIVE COMMENT TO THE COMMENT LIST FOR REAL-TIME RENDERING */
//   void _addComment(Map<String, dynamic> comment) {
//     // Animation controller for intro
//     final controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _controllers.add(controller);
//     _comments.add(comment);
//     controller.forward();
//     setState(() {});
//     // Scroll to bottom if user is not interacting
//     if (!_userScrolling && _comments.length > visibleCount) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (_scrollController.hasClients) {
//           _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         }
//       });
//     }
//   }

// //**THIS IS THE OPACITY CALCULATION */
//   double _calculateOpacity(int index) {
//     final scrollOffset = _scrollController.offset / commentHeight;
//     final firstVisibleIndex = scrollOffset.floor();
//     if (index < firstVisibleIndex ||
//         index >= firstVisibleIndex + visibleCount) {
//       return 0.0;
//     }
//     if (index == firstVisibleIndex) {
//       return 1 - (scrollOffset - scrollOffset.floor());
//     }
//     if (index == firstVisibleIndex + visibleCount) {
//       return (scrollOffset - scrollOffset.floor());
//     }
//     return 1.0;
//   }

//   //**THIS IS TO BUILD THE ANIMATED CONTENT */
//   Widget _buildAnimatedComment(
//     int index,
//   ) {
//     final comment = _comments[index];
//     // Entry animation for first 4 comments
//     if (_comments.length <= visibleCount && index < _controllers.length) {
//       final animation = CurvedAnimation(
//         parent: _controllers[index],
//         curve: Curves.easeOut,
//       );
//       return FadeTransition(
//         opacity: animation,
//         child: SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(0, 0.5),
//             end: Offset.zero,
//           ).animate(animation),
//           child: BuildCommentBox(commentData: comment),
//         ),
//       );
//     }
//     // Normal comment with fade logic
//     final opacity = _calculateOpacity(index);
//     return Opacity(
//       opacity: opacity.clamp(0.0, 1.0),
//       child: BuildCommentBox(commentData: comment),
//     );
//   }

//   //LIVESTREAMING FUNCTION
//   //CREATE TRANSPORT
//   Future<void> createSendTransport(roomId, role) async {
//     print('Start creating transport and see what happend');
//     socket?.emit('create-transport', {'roomId': roomId, 'direction': 'send'});

//     final transportData = await waitForResult<Map<dynamic, dynamic>>(
//       'transport-created',
//     );

//     _sendTransport = device?.createSendTransportFromMap(
//       transportData,
//       producerCallback: producerCallbackFunction,
//     );

//     _sendTransport!.on("connect", (transportData) async {
//       socket?.emit('connect-transport', {
//         'transportId': _sendTransport?.id,
//         'dtlsParameters': transportData['dtlsParameters'].toMap(),
//       });
//       socket?.once('transport-connected', (data) {
//         print(
//           'This is calling the callback having gotten the transport connect',
//         );
//         transportData['callback']();
//       });

//       // _sendTransportConnected = true;
//     });

//     _sendTransport?.on('produce', (producedData) {
//       socket?.emit('produce', {
//         'transportId': _sendTransport?.id,
//         'kind': producedData['kind'],
//         'rtpParameters': producedData['rtpParameters'].toMap(),
//         'appData': producedData['appData'],
//       });
//       socket?.once('produced', (response) async {
//         // producers.add(response['producerId']);
//         setState(() {
//           if (producedData['appData'] == 'mic') {
//             print(
//                 'THE PRODUCE RESPONSE SHOWING THAT WE HAVE PRODUCERID IMPLEMENTED AND OPEN THE MICROPHONE');
//             isAudioOn = true;
//           }
//           if (producedData['appData'] == 'cam') {
//             isVideoOn = true;
//           }
//         });
//         await producedData['callback'](response['producerId']);
//       });
//     });
//   }

//   //CREATE RECEIVE TRANSPORT ALSO
//   Future<void> createRecvTransport(roomId) async {
//     print('Start creating receiving transport and see what will happen');
//     socket?.emit('create-transport', {'roomId': roomId, 'direction': 'recv'});
//     final transportData = await waitForResult('transport-created');

//     _recvTransport = device?.createRecvTransportFromMap(
//       transportData,
//       consumerCallback: consumerCallback,
//     );

//     _recvTransport?.on("connect", (recvData) {
//       socket?.emit("connect-transport", {
//         'transportId': _recvTransport?.id,
//         'dtlsParameters': recvData['dtlsParameters'].toMap(),
//       });
//       recvData['callback']();

//       print('✅ Recv transport connected successfully');

//       socket?.once('transport-connected', (transportConnectData) async {
//         try {
//           if (recvData != null &&
//               recvData.containsKey('callback') &&
//               recvData['callback'] != null) {
//             final callback = recvData['callback'];
//             recvData.remove('callback');

//             if (callback is Function) {
//               await callback();
//               print('✅ Recv transport connected successfully');
//             }
//           }
//         } catch (e) {
//           print('Already completed the furture ${e.toString()}');
//         }
//       });
//     });
//   }

//   Future<T> waitForResult<T>(String event) {
//     print('TESTING THE WAIT FOR WORKINGE HERE.... $event');
//     final completer = Completer<T>();
//     void handler(dynamic data) {
//       socket?.off(event, handler);
//       completer.complete(data as T);
//     }

//     socket?.once(event, handler);
//     print('before finish for returning...');
//     return completer.future;
//   }

//   //THE CALLBACKS
//   //THE PRODUCER CALL BACK
//   void producerCallbackFunction(Producer producer) async {
//     print('🎬 Producer created: ${producer.id} (${producer.kind})');
//     print('This is the producer appData----- ${producer.appData}');
//     print(
//         'This is the producer Track to get what is happening ${producer.stream.getTracks()}');
//     if (producer.appData['mediaTag'] == 'mic') {
//       micProducerId = producer.id;
//       if (mounted) {
//         setState(() {
//           isAudioOn = true;
//         });
//       }
//     } else if (producer.appData['mediaTag'] == 'cam') {
//       videoProducerId = producer.id;
//       if (mounted) {
//         setState(() {
//           renderer?.setSrcObject(
//               stream: producer.stream,
//               trackId: producer.stream
//                   .getTracks()
//                   .firstWhere((track) => track.kind == 'video')
//                   .id);
//           isVideoOn = true;
//         });
//       }
//     } else if (producer.appData['mediaTag'] == 'screen-share') {
//       screenshareId = producer.id;
//       if (mounted) {
//         setState(() {
//           isLocalUserScreenShared = true;
//           screenshareRender?.setSrcObject(
//               stream: producer.stream,
//               trackId: producer.stream
//                   .getTracks()
//                   .firstWhere((track) => track.kind == 'video')
//                   .id);
//         });
//       }
//     }
//     producer.on('trackended', () {
//       print('This is the dasabling of the microphone or video');
//       producer.close();
//     });
//   }

//   //THE CONSUMER CALLBACKS
//   void consumerCallback(Consumer consumer, [dynamic accept]) async {
//     print('🎬 Consumer callback fired ${consumer.appData}');
//     // print('consumer being consumed is ${consumer.toString()}');
//     // Get tracks by type instead of getTracks()
//     final audioTracks = consumer.stream.getAudioTracks();
//     final videoTracks = consumer.stream.getVideoTracks();

//     print('Audio tracks: ${audioTracks.length}!!!$audioTracks');
//     print('Video tracks: ${videoTracks.length}!!!$videoTracks');
//     print('consumer being consumed is ${consumer.kind}');
//     print('consumer track id is ${consumer.track.id}');
//     print('Consumer is to get consumer ${consumer.stream.getTracks()}');
//     await updatingUI(consumer);
//   }

//   Future<void> updatingUI(Consumer consumer) async {
//     if (consumer.appData['role'] == 'host' && consumer.kind == 'video') {
//       //----------------IF THE MEDIATAG IS CAMERA OR SOMETHING--------------
//       if (consumer.appData['mediaTag'] == 'cam') {
//         if (hostRender?.srcObject != null) {
//           hostRender!.srcObject?.getTracks().forEach((track) {
//             track.stop();
//           });
//           await hostRender?.dispose();
//         }
//         isMobile = (consumer.appData['device'] == "android") ||
//             (consumer.appData['device'] == 'IOS');
//         mobilePlatForm = consumer.appData['device'];
//         hostRender = RTCVideoRenderer();
//         await hostRender?.initialize();

//         // FIX: Don't specify trackId, let it use the entire stream
//         hostRender?.srcObject = consumer.stream;

//         if (mounted) {
//           setState(() {});
//         }
//         print(
//             'This is the consumer in host track details ${consumer.stream.getTracks()}');
//         print('${hostRender?.srcObject?.getTracks()} is now the host track');
//       } else if (consumer.appData['mediaTag'] == 'screen-share' &&
//           !isLocalUserScreenShared) {
//         if (hostScreenShareRender?.srcObject != null) {
//           hostScreenShareRender!.srcObject?.getTracks().forEach((track) {
//             track.stop();
//           });
//           await hostScreenShareRender?.dispose();
//         }
//         hostScreenShareRender = RTCVideoRenderer();
//         await hostScreenShareRender?.initialize();

//         // FIX: Don't specify trackId
//         hostScreenShareRender?.srcObject = consumer.stream;

//         if (mounted) {
//           setState(() {
//             isLocalUserScreenShared = false;
//           });
//         }
//       }
//     } else if (consumer.appData['role'] == 'challenger' &&
//         consumer.kind == 'video') {
//       if (consumer.appData['mediaTag'] == 'cam') {
//         if (challengerRender?.srcObject != null) {
//           challengerRender!.srcObject?.getTracks().forEach((track) {
//             track.stop();
//           });
//           await challengerRender?.dispose();
//         }
//         isMobile = (consumer.appData['device'] == "android") ||
//             (consumer.appData['device'] == 'IOS');
//         mobilePlatForm = consumer.appData['device'];
//         challengerRender = RTCVideoRenderer();
//         await challengerRender?.initialize();

//         // FIX: Don't specify trackId
//         challengerRender?.srcObject = consumer.stream;

//         if (mounted) {
//           setState(() {});
//         }
//         print(
//             'This is the consumer track details ${consumer.stream.getTracks()}');
//         print(
//             '${challengerRender?.srcObject?.getTracks()} is now the challenger track');
//       } else if (consumer.appData['mediaTag'] == 'screen-share' &&
//           !isLocalUserScreenShared) {
//         if (challengerScreenShareRender?.srcObject != null) {
//           challengerScreenShareRender!.srcObject?.getTracks().forEach((track) {
//             track.stop();
//           });
//           await challengerScreenShareRender?.dispose();
//         }
//         challengerScreenShareRender = RTCVideoRenderer();
//         await challengerScreenShareRender?.initialize();

//         // FIX: Don't specify trackId
//         challengerScreenShareRender?.srcObject = consumer.stream;

//         if (mounted) {
//           setState(() {
//             isLocalUserScreenShared = false;
//           });
//         }
//       }
//     }
//   }

//   //CONSUME TRACKS
//   Future<void> consumeTrack(producer, String roomId) async {
//     //Create a unique completer for this specific consume request

//     final completer = Completer<void>();
//     final producerId = producer['producerId'];

//     void handler(dynamic data) {
//       if (data['producerId'] != producerId) {
//         return;
//       }
//       print("----------------This is the data coming from the backend: $data");
//       socket?.off('consumed', handler);
//       try {
//         _recvTransport?.consume(
//           id: data['id'],
//           producerId: data['producerId'],
//           peerId: producer['peerId'] ?? data['producerId'],
//           kind: RTCRtpMediaTypeExtension.fromString(data['kind']),
//           rtpParameters: RtpParameters.fromMap(data['rtpParameters']),
//           appData: {
//             'role': data['role'],
//             'mediaTag': data['tag'],
//             'device': producer['peerDevice']
//           },
//         );
//         if (!completer.isCompleted) {
//           completer.complete();
//         }
//       } catch (e) {
//         print('❌ Failed to create consumer: $e');
//         if (!completer.isCompleted) {
//           completer.completeError(e);
//         }
//       }
//     }

//     socket?.on('consumed', handler);
//     socket?.emit('consume', {
//       'roomId': roomId,
//       'rtpCapabilities': device?.rtpCapabilities.toMap(),
//       'producerId': producer['producerId'],
//     });
//     //wait for this specific consume to complete with a timeout
//     try {
//       await completer.future.timeout(Duration(seconds: 10), onTimeout: () {
//         socket?.off('consumed', handler);
//         throw TimeoutException('Continue timeout for producer: $producerId');
//       });
//     } catch (e) {
//       print("consumeTrack error: $e");
//       rethrow;
//     }
//     // await completer.future;
//   }

//   //LAOD DEVICE FOR COMPARTILIBILITY
//   Future<void> loadDevice(RtpCapabilities rtpCapabilities) async {
//     print('📱 Loading device with RTP capabilities...');

//     try {
//       device = Device();
//       await device?.load(routerRtpCapabilities: rtpCapabilities);
//       print('✅ Device loaded successfully');
//     } catch (e) {
//       print('❌ Failed to load device: $e');
//     }
//   }

//   void disableCamera() async {
//     try {
//       if (localVideoTrack != null) {
//         localVideoTrack?.stop();
//         localVideoTrack = null;
//       }
//       if (videoStream != null) {
//         videoStream?.getTracks().forEach((track) {
//           track.stop();
//         });
//         videoStream = null;
//         socket?.emit('close-producer', {'producerId': videoProducerId});
//         socket?.emit('video-stream-stopped', {'role': role});
//         setState(() {
//           isVideoOn = false;
//           renderer?.setSrcObject(stream: null, trackId: null);
//           videoStream = null;
//         });
//       }
//     } catch (e) {
//       print('This is disabling the camera');
//     }
//   }

//   //ENABLE CAMERA FOR SENDING TRACKS
//   void enableCamera(bool frontCamera) async {
//     print('🎥 enableCamera() called');
//     if (device?.canProduce(RTCRtpMediaType.RTCRtpMediaTypeVideo) == false) {
//       print('❌ Device cannot produce video');
//       return;
//     }
//     if (_sendTransport == null) {
//       print('❌ Send transport not available');
//       return;
//     }
//     try {
//       RtpCodecCapability? codec = device!.rtpCapabilities.codecs.firstWhere(
//         (RtpCodecCapability c) => c.mimeType.toLowerCase() == 'video/vp8',
//         orElse: () => throw 'VP8 codec not supported',
//       );

//       //LOGIC FOR SWITCHING THE CAMERA
//       if (videoStream != null && frontCamera) {
//         socket?.emit('close-producer', {'producerId': videoProducerId});
//         if (isFrontCameraSelected && frontCamera) {
//           videoStream!
//               .getVideoTracks()
//               .forEach((element) => element.switchCamera());
//         } else {
//           videoStream!
//               .getVideoTracks()
//               .forEach((element) => element.switchCamera());
//         }
//       } else if (!frontCamera) {
//         videoStream = await createVideoStream();
//       }
//       localVideoTrack = videoStream?.getVideoTracks().first;
//       setState(() {});
//       print('🎬 Calling transport.produce()...');
//       if (_sendTransport == null) {
//         print('Calling on the one that is a null value __________________');
//       }
//       _sendTransport!.produce(
//         track: localVideoTrack!,
//         stream: videoStream!,
//         codec: codec,
//         codecOptions: ProducerCodecOptions(videoGoogleStartBitrate: 1000),
//         source: 'cam',
//         appData: {
//           'mediaTag': 'cam',
//           'role': role,
//           'device': Platform.isIOS ? 'IOS' : "android"
//         },
//       );
//       print("SendTransport for camera sharing------");
//       socket?.emit('video-stream-started', {'role': role});
//       //  _producerCreated = true;
//     } catch (error) {
//       print('❌ enableCamera error: $error');
//       if (videoStream != null) {
//         await videoStream?.dispose();
//       }
//     }
//   }

//   Future<MediaStream> createVideoStream() async {
//     print('📹 Creating video stream...');
//     Map<String, dynamic> mediaConstraints = <String, dynamic>{
//       'video': true,
//     };
//     try {
//       MediaStream stream =
//           await navigator.mediaDevices.getUserMedia(mediaConstraints);
//       return stream;
//     } catch (e) {
//       print('❌ Failed to create video stream: $e');
//       rethrow;
//     }
//   }

//   Future<MediaStream> createAudioStream() async {
//     Map<String, dynamic> mediaConstraints = {'audio': true};
//     MediaStream stream = await navigator.mediaDevices.getUserMedia(
//       mediaConstraints,
//     );
//     return stream;
//   }

//   //THIS IS TO ENABLE THE MICROPHONE
//   void enableMic() async {
//     if (device?.canProduce(RTCRtpMediaType.RTCRtpMediaTypeAudio) == false) {
//       return;
//     }
//     try {
//       audioStream = await createAudioStream();
//       localAudioTrack = audioStream?.getAudioTracks().first;
//       _sendTransport?.produce(
//         track: localAudioTrack!,
//         // codecOptions: ProducerCodecOptions(opusStereo: 1, opusDtx: 1),
//         stream: audioStream!,
//         source: 'mic',
//         appData: {'mediaTag': 'mic', 'role': role},
//       );
//       socket!.emit('mic-started', {'role': role});
//     } catch (e) {
//       if (audioStream != null) {
//         await audioStream?.dispose();
//       }
//     }
//   }

//   //DISABLE MICROPHONE FOR SENDING TRACKS
//   void disableMic() async {
//     try {
//       if (localAudioTrack != null) {
//         print('This is the producerId $micProducerId');
//         localAudioTrack?.stop();
//         localAudioTrack = null;

//         if (audioStream != null) {
//           audioStream?.getTracks().forEach((track) {
//             track.stop();
//           });
//           audioStream = null;
//         }
//         socket?.emit('close-producer', {'producerId': micProducerId});
//         setState(() {
//           isAudioOn = false;
//           audioStream?.dispose();
//         });
//       }
//     } catch (e) {
//       print('This is the producerId');
//     }
//   }

//   Future<MediaStream?> shareScreen() async {
//     try {
//       Map<String, dynamic> mediaConstraints = {
//         'video': true,
//       };
//       MediaStream stream =
//           await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
//       return stream;
//     } catch (e) {
//       print("Capture failed: $e");
//       return null;
//     }
//   }

//   void enableShareScreen() async {
//     try {
//       if (Platform.isAndroid) {
//         print('📱 Starting Android screen capture service...');
//         // final serviceStarted =
//         await ScreenCaptureService().startScreenShare();

//         // if (!serviceStarted) {
//         //   throw Exception('Failed to start screen capture service');
//         // }

//         // CRITICAL: Wait for service to be fully ready
//         // This is essential for Android 14+
//         print('⏳ Waiting for service to be ready...');
//         await Future.delayed(Duration(milliseconds: 1000));

//         // Verify service is running
//         final isRunning = await ScreenCaptureService().isServiceRunning();

//         if (isRunning) {
//           print(
//               "Permission foregroung is now granted-----------------------------**************");
//         }
//       }
//       shareScreenStream = await shareScreen();
//       localShareScreenTrack = shareScreenStream?.getVideoTracks().first;
//       _sendTransport?.produce(
//         track: localShareScreenTrack!,
//         // codecOptions: ProducerCodecOptions(opusStereo: 1, opusDtx: 1),
//         stream: shareScreenStream!,
//         source: 'screen-share',
//         appData: {'mediaTag': 'screen-share', 'role': role},
//       );
//       context.pop();
//       socket!.emit('screen-share-started', {'role': role});
//     } catch (e) {
//       if (shareScreenStream != null) {
//         await shareScreenStream?.dispose();
//         //  await ScreenCaptureService.stopScreenCapture();
//       }
//     }
//   }

//   void stopScreenShare() async {
//     try {
//       if (localShareScreenTrack != null) {
//         localShareScreenTrack?.stop();
//         localShareScreenTrack = null;

//         if (shareScreenStream != null) {
//           shareScreenStream?.getTracks().forEach((track) {
//             track.stop();
//           });
//           shareScreenStream = null;
//         }
//         socket?.emit('close-producer', {'producerId': screenshareId});
//         socket?.emit('screen-share-stopped', {'role': role});
//       }
//       setState(() {
//         isLocalUserScreenShared = false;
//         //  renderer?.srcObject?.dispose();
//         screenshareRender?.setSrcObject(stream: null, trackId: null);
//         //_stopForegroundService();
//       });
//       //  await ScreenCaptureService.stopScreenCapture();
//     } catch (e) {
//       print('This is the screenshared not disabled ${e.toString()}');
//     }
//   }
// }
