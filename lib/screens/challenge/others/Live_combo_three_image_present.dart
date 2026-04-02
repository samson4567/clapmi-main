// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:clapmi/core/api/multi_env.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/di/injector.dart';
import 'package:clapmi/core/services/notification_handler_classes/notificationWorkers/util_functions.dart';
import 'package:clapmi/features/livestream/data/datasources/recording_remote_datasource.dart';
import 'package:clapmi/features/livestream/presentation/blocs/recording/recording_bloc.dart';
import 'package:clapmi/features/livestream/presentation/widgets/record_started_notification.dart';
import 'package:clapmi/features/livestream/presentation/widgets/download_file_container.dart';
import 'package:clapmi/features/livestream/presentation/widgets/confirm_variant.dart';
import 'package:clapmi/screens/challenge/others/widgets/live_buy_point_button.dart'
    show
        ClapLiveStreamButton,
        BuyPointButton,
        GiftLiveButton,
        LiveInteractionButton,
        SpectatorsInteractionButton,
        buttonWidget,
        BoostSuccessWidget,
        PopRecord,
        PopRecordVariant,
        SingleLiveScheduler;
import 'package:clapmi/core/services/device_service.dart';
import 'package:clapmi/core/utils/device_switch_helper.dart';
import 'package:clapmi/core/widgets/device_switch_widgets.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/challenge/others/Single_livestream.dart';
import 'package:clapmi/screens/challenge/others/comment_box.dart';
import 'package:clapmi/screens/challenge/others/multiple_livestream_screen.dart';
import 'package:clapmi/screens/challenge/others/screenshare_service.dart';
import 'package:clapmi/screens/challenge/others/test_widget_for_displaying_screen_track.dart';
import 'package:clapmi/screens/challenge/others/user_join_widget_animation.dart';
import 'package:clapmi/screens/challenge/widgets/challenge_view.dart';
import 'package:clapmi/screens/challenge/widgets/livestream%20_header.dart';
import 'package:clapmi/screens/challenge/widgets/livestream_widget.dart';
import 'package:clapmi/screens/challenge/widgets/progress_bar.dart';
import 'package:clapmi/screens/challenge/widgets/single_livestream_video_rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:mediasfu_mediasoup_client/mediasfu_mediasoup_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:wakelock_plus/wakelock_plus.dart';

class LiveComboThreeImageScreen extends StatefulWidget {
  const LiveComboThreeImageScreen(
      {super.key,
      required this.comboInfo,
      required this.comboId,
      required this.bragID});
  final LiveComboEntity comboInfo;
  final String comboId;
  final String bragID;

  @override
  State<LiveComboThreeImageScreen> createState() =>
      _LiveComboThreeImageScreenState();
}

class _LiveComboThreeImageScreenState extends State<LiveComboThreeImageScreen>
    with TickerProviderStateMixin, RouteAware {
  final List<Map<String, dynamic>> _comments = [];
  final ScrollController _scrollController = ScrollController();
  final List<AnimationController> _controllers = [];
  bool _userScrolling = false;
  bool _isLoading = true;
  Timer? _newCommentTimer;
  static const int visibleCount = 4;
  static const double commentHeight = 60.0;
  TextEditingController commentController = TextEditingController();

  // Media status
  bool isAudioOn = false, isVideoOn = false, isFrontCameraSelected = true;

  // Livestream variables
  io.Socket? socket;
  Device? device;
  Transport? _sendTransport;
  Transport? _recvTransport;
  RTCVideoRenderer? renderer;
  RTCVideoRenderer? hostRender;
  RTCVideoRenderer? challengerRender;
  RTCVideoRenderer? screenshareRender;
  RTCVideoRenderer? hostScreenShareRender;
  RTCVideoRenderer? challengerScreenShareRender;
  bool isLocalUserScreenShared = false;
  String roomId = '';
  String role = '';
  String micProducerId = '';
  String videoProducerId = '';
  MediaStream? audioStream;
  MediaStream? videoStream;
  MediaStream? shareScreenStream;
  MediaStreamTrack? localShareScreenTrack;
  MediaStreamTrack? localScreenShareAudioTrack;
  MediaStreamTrack? localAudioTrack;
  MediaStreamTrack? localVideoTrack;
  String screenshareId = '';
  String screenshareAudioId = '';
  bool isFullScreen = false;
  num totalGiftingPot = 0.0;
  num hostCoin = 0;
  num challengerCoin = 0;
  bool userClappEvent = false;
  DateTime? targetTime;
  String? timerCountdown;
  int numberOfStreamers = 0;
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _opacityAnimation;

  bool? isComboOngoingNow;
  int numberOfChallenger = 0;
  LiveGifter? liveChallenger;
  ComboInLiveStream? liveChallengerData;
  Timer? _timer;
  bool isthereInternet = true;
  StreamSubscription? internetSubscription;
  bool isMobile = false;
  String mobilePlatForm = '';
  final ScreenCaptureService _screenCaptureService = ScreenCaptureService();
  final DeviceSwitchHelper _deviceSwitchHelper = DeviceSwitchHelper();
  final DeviceService _deviceService = DeviceService();
  DeviceRole _deviceRole = DeviceRole.primary;
  String? _currentDeviceId;
  String? _pendingSwitchMessage;
  String? _pendingSwitchDevice;
  bool _isDeviceActionInProgress = false;
  Timer? _noGiftReminderTimer;
  bool _isNoGiftReminderVisible = false;
  OverlayEntry? _floatingLiveOverlayEntry;
  bool _isRouteObserverRegistered = false;
  bool _isMinimizedToOverlay = false;

  bool get _isCreatorDevice => role == 'host' || role == 'challenger';
  bool get _canBroadcastFromThisDevice =>
      _isCreatorDevice &&
      _deviceRole != DeviceRole.companion &&
      _deviceRole != DeviceRole.spectator;
  num get _currentCreatorGiftTotal {
    if (role == 'challenger') {
      return challengerCoin;
    }
    if (role == 'host') {
      return hostCoin;
    }
    return 0;
  }
  RTCVideoRenderer? get _floatingPreviewRenderer {
    if (screenshareRender?.srcObject != null) {
      return screenshareRender;
    }
    if (renderer?.srcObject != null) {
      return renderer;
    }
    if (hostScreenShareRender?.srcObject != null) {
      return hostScreenShareRender;
    }
    if (challengerScreenShareRender?.srcObject != null) {
      return challengerScreenShareRender;
    }
    if (hostRender?.srcObject != null) {
      return hostRender;
    }
    if (challengerRender?.srcObject != null) {
      return challengerRender;
    }
    return null;
  }
  ({int width, int height}) get _pictureInPictureAspectRatio {
    final renderer = _floatingPreviewRenderer;
    final width = renderer?.videoWidth ?? 0;
    final height = renderer?.videoHeight ?? 0;
    if (width > 0 && height > 0) {
      return (width: width, height: height);
    }
    return isMobile ? (width: 9, height: 16) : (width: 16, height: 9);
  }

  // ─────────────────────────────────────────────
  // SOCKET CONNECTION
  // ─────────────────────────────────────────────
  Future<void> connect() async {
    debugPrint('🔌 CONNECTING TO SERVER...');
    socket = io.io(MultiEnv().socketIoUrl, <String, dynamic>{
      'transports': ['websocket'],
      'path': '/ss/socket.io',
    });

    // Connect socket to RecordingRemoteDataSource
    final recordingDataSource = getItInstance<RecordingRemoteDataSource>();
    recordingDataSource.setSocket(socket!);

    socket?.onConnect((_) async {
      debugPrint("✅ Connected to SFU Server");
      socket?.off('new-producer');

      if (_canBroadcastFromThisDevice) {
        socket?.emitWithAck(
          'check-room',
          {'roomId': roomId},
          ack: (data) async {
            debugPrint('Does this room exist? : $data');
            if (!data['exists']) {
              socket?.emit('create-room', {
                'roomId': roomId,
                'device': Platform.isIOS ? "IOS" : "android"
              });
              await waitForResult('room-created');
              socket?.emit('join-room', {
                'roomId': roomId,
                'userId': profileModelG?.pid,
                'device': Platform.isIOS ? "IOS" : "android"
              });
            }
          },
        );
      }

      debugPrint('DATA DO NOT EXIST THEN JOIN ROOM $roomId');
      socket?.emit('join-room', {
        'roomId': roomId,
        'userId': profileModelG?.pid,
        'device': Platform.isIOS ? 'IOS' : 'android'
      });

      final transport = await waitForResult('joined-room');
      debugPrint("This is the transport care $transport");
      final routerCapabilities = RtpCapabilities.fromMap(
        transport['routerRtpCapabilities'],
      );
      final producers = transport['producers'];
      await loadDevice(routerCapabilities);

      if (_canBroadcastFromThisDevice) {
        debugPrint("creating send transport------------- $role");
        await createSendTransport(roomId, role);
      }
      await createRecvTransport(roomId);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show PopRecord dialog for host/challenger to prompt recording
        if (_canBroadcastFromThisDevice) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierColor: Colors.black54,
              builder: (_) => PopRecord(
                variant: PopRecordVariant.initial,
                onNo: () => Navigator.pop(context),
                onLater: () => Navigator.pop(context),
                onYes: () {
                  Navigator.pop(context);
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    barrierColor: Colors.black54,
                    builder: (_) => PopRecord(
                      variant: PopRecordVariant.confirm,
                      onNo: () => Navigator.pop(context),
                      onYes: () {
                        Navigator.pop(context);
                        // Start recording
                        context.read<RecordingBloc>().add(
                              StartRecording(roomId: roomId),
                            );
                      },
                    ),
                  );
                },
              ),
            );
          });
        }
      }

      for (var producer in producers) {
        try {
          debugPrint("@@@ looping through producers $producer");
          await consumeTrack(producer, roomId);
        } catch (error) {
          debugPrint('❌ Failed to consume producer');
        }
      }

      socket?.on('new-producer', (data) async {
        debugPrint('!!! data coming from new-producer $data');
        try {
          await consumeTrack(data, roomId);
        } catch (error) {
          debugPrint(
            '❌ Failed to consume new producer ${data['producerId']}, error: ${error.toString()}',
          );
        }
      });
    });

    socket?.on('screen-share-stopped', (data) async {
      try {
        if (data['role'] == 'host') {
          hostScreenShareRender?.setSrcObject(stream: null, trackId: null);
        } else if (data['role'] == 'challenger') {
          challengerScreenShareRender?.setSrcObject(
              stream: null, trackId: null);
        }
        if (mounted) setState(() {});
      } catch (e) {
        debugPrint('Error handling screen-share-stopped: $e');
      }
    });

    socket?.on('video-stream-stopped', (data) async {
      try {
        if (data['role'] == 'host') {
          hostRender?.setSrcObject(stream: null, trackId: null);
        } else if (data['role'] == 'challenger') {
          challengerRender?.setSrcObject(stream: null, trackId: null);
        }
        if (mounted) setState(() {});
      } catch (e) {
        debugPrint('Error handling video-stream-stopped: $e');
      }
    });

    socket?.onConnectError((data) {
      debugPrint('❌ Connection Error: $data');
    });

    socket?.onDisconnect((data) {
      debugPrint('🛑 Disconnected: $data');
    });
  }

  // ─────────────────────────────────────────────
  // ROLE ASSIGNMENT
  // ─────────────────────────────────────────────
  assignRole() {
    if (widget.comboInfo.hasOngoingCombo == true) {
      isComboOngoingNow = widget.comboInfo.hasOngoingCombo;
      if (widget.comboInfo.onGoingCombo?.host?.profile == profileModelG?.pid) {
        role = 'host';
      } else if (widget.comboInfo.onGoingCombo?.challenger?.profile ==
          profileModelG?.pid) {
        role = 'challenger';
      } else {
        role = 'spectator';
        _isLoading = false;
      }
    } else {
      isComboOngoingNow = false;
      if (widget.comboInfo.host?.profile == profileModelG?.pid) {
        role = 'host';
        _isLoading = true;
      } else if (widget.comboInfo.challenger?.profile == profileModelG?.pid) {
        role = 'challenger';
        _isLoading = true;
      } else {
        role = 'spectator';
        _isLoading = false;
      }
    }
    numberOfStreamers = widget.comboInfo.presence ?? 1;
  }

  // ─────────────────────────────────────────────
  // FIX #1: Initialize ALL six renderers here
  // ─────────────────────────────────────────────
  initRenderers() async {
    renderer = RTCVideoRenderer();
    hostRender = RTCVideoRenderer();
    challengerRender = RTCVideoRenderer();
    screenshareRender = RTCVideoRenderer();
    hostScreenShareRender = RTCVideoRenderer(); // ✅ was missing
    challengerScreenShareRender = RTCVideoRenderer(); // ✅ was missing

    await renderer?.initialize();
    await hostRender?.initialize();
    await challengerRender?.initialize();
    await screenshareRender?.initialize();
    await hostScreenShareRender?.initialize(); // ✅ was missing
    await challengerScreenShareRender?.initialize(); // ✅ was missing

    assignRole();
    roomId = widget.comboInfo.combo ?? widget.comboId;
  }

  Future<void> _initializeDeviceSwitch() async {
    _deviceSwitchHelper.initialize(
      onDeviceSwitchRequested: (data) {
        if (data.oldDeviceId.isNotEmpty &&
            _currentDeviceId != null &&
            data.oldDeviceId != _currentDeviceId) {
          return;
        }
        if (!mounted) return;
        setState(() {
          _pendingSwitchMessage = data.message;
          _pendingSwitchDevice = data.newDevice;
        });
      },
      onDeviceSwitchReady: (data) async {
        await _enterPrimaryMode(showFeedback: false);
        if (mounted) {
          showDeviceSwitchSuccess(
            context,
            'This device is ready to continue the livestream.',
          );
        }
      },
      onCompanionJoined: (data) {
        if (!mounted) return;
        showDeviceSwitchSuccess(
          context,
          'Companion device connected successfully.',
        );
      },
      onConnectionChanged: (connected) {
        if (!mounted || connected) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Device sync disconnected. Reopen the menu to retry.'),
          ),
        );
      },
    );

    _currentDeviceId = await _deviceService.getDeviceId();
    final savedRole = await _deviceService.getDeviceRole();
    if (mounted) {
      setState(() {
        _deviceRole = savedRole;
      });
    }

    final currentUserId = profileModelG?.pid;
    if (currentUserId != null && roomId.isNotEmpty) {
      await _deviceSwitchHelper.connect(roomId, currentUserId);
    }
  }

  Future<void> _ensureDeviceSwitchConnection() async {
    final currentUserId = profileModelG?.pid;
    if (currentUserId == null || roomId.isEmpty) {
      throw Exception('Missing livestream room or user information.');
    }
    await _deviceSwitchHelper.connect(roomId, currentUserId);
  }

  Future<void> _enterPrimaryMode({bool showFeedback = true}) async {
    await _deviceService.setDeviceRole(DeviceRole.primary);
    if (_sendTransport == null &&
        socket?.connected == true &&
        device != null &&
        _isCreatorDevice) {
      await createSendTransport(roomId, role);
    }

    if (!mounted) return;
    setState(() {
      _deviceRole = DeviceRole.primary;
    });

    if (showFeedback) {
      showDeviceSwitchSuccess(
          context, 'This device is now your streaming device.');
    }
  }

  Future<void> _enterCompanionMode() async {
    await _deviceService.setDeviceRole(DeviceRole.companion);
    _stopBroadcastingOnCurrentDevice();

    if (!mounted) return;
    setState(() {
      _deviceRole = DeviceRole.companion;
    });

    showDeviceSwitchSuccess(
      context,
      'Companion mode enabled. This device is now receive-only.',
    );
  }

  Future<void> _enterSpectatorModeAfterSwitch() async {
    await _deviceService.setDeviceRole(DeviceRole.spectator);
    _stopBroadcastingOnCurrentDevice();

    if (!mounted) return;
    setState(() {
      _deviceRole = DeviceRole.spectator;
      _pendingSwitchMessage = null;
      _pendingSwitchDevice = null;
    });

    showDeviceSwitchSuccess(
      context,
      'Livestream controls moved to your other device.',
    );
  }

  void _stopBroadcastingOnCurrentDevice() {
    if (isLocalUserScreenShared || screenshareRender?.srcObject != null) {
      stopScreenShare();
    }
    if (isVideoOn) {
      disableCamera();
    }
    if (isAudioOn) {
      disableMic();
    }
    _sendTransport?.close();
    _sendTransport = null;
  }

  Future<void> _requestDeviceSwitch() async {
    if (_isDeviceActionInProgress) return;
    try {
      setState(() {
        _isDeviceActionInProgress = true;
      });
      context.read<ComboBloc>().add(
            SwitchDeviceEvent(
              comboID: widget.comboId,
              deviceId: _currentDeviceId ?? await _deviceService.getDeviceId(),
            ),
          );
    } catch (e) {
      if (!mounted) return;
      showDeviceSwitchError(context, 'Unable to request device switch: $e');
      setState(() {
        _isDeviceActionInProgress = false;
      });
    }
  }

  Future<void> _requestCompanionMode() async {
    if (_isDeviceActionInProgress) return;
    try {
      setState(() {
        _isDeviceActionInProgress = true;
      });
      context.read<ComboBloc>().add(
            JoinCompanionEvent(
              comboID: widget.comboId,
              deviceId: _currentDeviceId ?? await _deviceService.getDeviceId(),
            ),
          );
    } catch (e) {
      if (!mounted) return;
      showDeviceSwitchError(context, 'Unable to start companion mode: $e');
      setState(() {
        _isDeviceActionInProgress = false;
      });
    }
  }

  Future<void> _handleSwitchDeviceSuccess(
      SwitchDeviceSuccessState state) async {
    try {
      await _ensureDeviceSwitchConnection();
      await _deviceSwitchHelper.initiateDeviceSwitch();
      await _enterPrimaryMode(showFeedback: false);

      if (!mounted) return;
      setState(() {
        _isDeviceActionInProgress = false;
      });

      showDeviceSwitchSuccess(
        context,
        state.result.message ?? 'Device switch request sent.',
      );
    } catch (e) {
      _handleDeviceActionError('Unable to complete device switch: $e');
    }
  }

  Future<void> _handleCompanionSuccess(JoinCompanionSuccessState state) async {
    try {
      await _ensureDeviceSwitchConnection();
      await _deviceSwitchHelper.joinAsCompanion();
      await _enterCompanionMode();

      if (!mounted) return;
      setState(() {
        _isDeviceActionInProgress = false;
      });

      showDeviceSwitchSuccess(
        context,
        state.result.message ?? 'Companion mode request sent.',
      );
    } catch (e) {
      _handleDeviceActionError('Unable to enable companion mode: $e');
    }
  }

  void _handleDeviceActionError(String message) {
    if (!mounted) return;
    setState(() {
      _isDeviceActionInProgress = false;
    });

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: scaffoldMessenger.hideCurrentSnackBar,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // COUNTDOWN TIMER
  // ─────────────────────────────────────────────
  void countdownTimer(
      {required String? startTime, required String? durationTime}) {
    _timer?.cancel();
    _timer = Timer.periodic((Duration(seconds: 1)), (timer) {
      final now = DateTime.now();
      final duration = durationFromOption(durationTime ?? '');
      final remaining = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(startTime ?? '', true)
          .toLocal()
          .add(duration)
          .difference(now);
      if (mounted) {
        if (remaining.isNegative || remaining.inSeconds == 0) {
          setState(() {
            timerCountdown = "00:00:00";
          });
          timer.cancel();
        } else {
          setState(() {
            timerCountdown = formatHHMMSS(remaining);
          });
        }
      }
    });
  }

  // ─────────────────────────────────────────────
  // INIT STATE
  // ─────────────────────────────────────────────
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (!_isRouteObserverRegistered && route is PageRoute) {
      routeObserver.subscribe(this, route);
      _isRouteObserverRegistered = true;
    }
  }

  @override
  void initState() {
    WakelockPlus.enable();
    internetSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
        setState(() => isthereInternet = true);
      } else {
        setState(() => isthereInternet = false);
      }
    });

    countdownTimer(
        startTime: widget.comboInfo.onGoingCombo?.startTime ??
            widget.comboInfo.metaData?.start_time,
        durationTime: widget.comboInfo.onGoingCombo?.duration ??
            widget.comboInfo.duration);

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _positionAnimation = Tween<double>(begin: 0.5, end: 0.7)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));

    context.read<ChatsAndSocialsBloc>().add(SubscribeTochatEvent(
        conversationId: widget.comboId, isLiveComboSubscription: true));
    context
        .read<ChatsAndSocialsBloc>()
        .add(GetTotalGiftsEvent(comboId: widget.comboId));

    if (mounted) {
      setState(() {
        hostCoin = widget.comboInfo.gifts?.host ?? 0;
        if (isComboOngoingNow == true) {
          challengerCoin =
              widget.comboInfo.onGoingCombo?.gifts?.challenger ?? 0;
        } else {
          challengerCoin = widget.comboInfo.gifts?.challenger ?? 0;
        }
      });
    }

    initRenderers().then((_) async {
      _syncNoGiftReminder();
      await _initializeDeviceSwitch();
      connect();
    });

    _controller.addStatusListener((status) {
      if (status.isCompleted) {
        setState(() {
          debugPrint("----STATUS IS COMPLETED");
          userClappEvent = false;
        });
      }
    });

    _scrollController.addListener(_handleScroll);
    super.initState();
  }

  // ─────────────────────────────────────────────
  // FIX #2: Dispose ALL renderers
  // ─────────────────────────────────────────────
  @override
  void dispose() {
    if (_isRouteObserverRegistered) {
      routeObserver.unsubscribe(this);
      _isRouteObserverRegistered = false;
    }
    WakelockPlus.disable();
    for (var controller in _controllers) {
      controller.dispose();
    }
    commentController.dispose();
    internetSubscription?.cancel();
    _timer?.cancel();
    _scrollController.dispose();
    _newCommentTimer?.cancel();
    _noGiftReminderTimer?.cancel();
    if (!_isMinimizedToOverlay) {
      _removeFloatingLiveOverlay();
      socket?.disconnect();
      socket?.dispose();
      _deviceSwitchHelper.dispose();
      _sendTransport?.close();
      _recvTransport?.close();
      renderer?.dispose();
      hostRender?.dispose();
      challengerRender?.dispose();
      screenshareRender?.dispose();
      hostScreenShareRender?.dispose();
      challengerScreenShareRender?.dispose();
      shareScreenStream?.dispose();
      localShareScreenTrack?.dispose();
      localAudioTrack?.dispose();
      videoStream?.dispose();
      audioStream?.dispose();
    }
    super.dispose();
  }

  @override
  void didPopNext() {
    _removeFloatingLiveOverlay();
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return DeviceSwitchBlocListener(
        onSwitchDeviceSuccess: (state) {
          _handleSwitchDeviceSuccess(state as SwitchDeviceSuccessState);
        },
        onSwitchDeviceError: (state) {
          _handleDeviceActionError(
            (state as SwitchDeviceErrorState).errorMessage,
          );
        },
        onCompanionSuccess: (state) {
          _handleCompanionSuccess(state as JoinCompanionSuccessState);
        },
        onCompanionError: (state) {
          _handleDeviceActionError(
            (state as JoinCompanionErrorState).errorMessage,
          );
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
                BlocListener<RecordingBloc, RecordingState>(
                  listener: (context, recordingState) {
                    if (recordingState is RecordingStarted) {
                      // Show recording started notification
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => RecordStartedNotification(
                          onDismiss: () => Navigator.pop(context),
                        ),
                      );
                    } else if (recordingState is RecordingStopped) {
                      // Show download dialog
                      showDialog(
                        context: context,
                        builder: (context) => DownloadFileContainer(
                          recordingId: recordingState.recording.recordingId,
                          downloadUrl:
                              recordingState.recording.downloadUrl ?? '',
                          duration: recordingState.recording.duration,
                          onClose: () => Navigator.pop(context),
                          onDownloadComplete: (filePath) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Recording saved to: \$filePath')),
                            );
                          },
                        ),
                      );
                    } else if (recordingState is RecordingError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Recording error: ${recordingState.message}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child:
                      BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
                    listener: (context, state) {
                      if (state is LiveCommentState) {
                        _addComment({
                          'state': state.commentData,
                          'stateName': 'commentLive',
                        });
                      }
                      if (state is ClappLiveState) {
                        _controller.reset();
                        _controller.forward();
                      }
                      if (state is ComboEnded) {
                        debugPrint(
                            "Combo has ended ${state.comboDetails.toString()}");
                        if (isComboOngoingNow == true) {
                          setState(() {
                            isComboOngoingNow = false;
                            countdownTimer(
                                startTime:
                                    widget.comboInfo.metaData?.start_time,
                                durationTime: widget.comboInfo.duration);
                          });
                        } else {
                          debugPrint(
                              "An host has left the livestream------------");
                          setState(() {
                            timerCountdown = "00:00:00";
                          });
                          _timer?.cancel();
                        }
                      }
                      if (state is PotAmount) {
                        setState(() {
                          totalGiftingPot = state.totalAmount;
                        });
                        _syncNoGiftReminder();
                      }
                      if (state is UserJoined) {
                        setState(() {
                          numberOfStreamers = numberOfStreamers + 1;
                        });
                        _controller.reset();
                        _controller.forward();
                        debugPrint(
                            'THE USERNAME OF THE USER IS ${state.userJoined.user?.username}');
                        // FIX #3: Only reconnect if socket is actually disconnected
                        if ((state.userJoined.user?.pid ==
                                    widget.comboInfo.host?.profile ||
                                state.userJoined.user?.pid ==
                                    widget.comboInfo.challenger?.profile) &&
                            socket?.disconnected == true) {
                          socket?.dispose();
                          connect();
                        }
                      }
                      if (state is UserLeaveCombo) {
                        if (state.user.user?.pid == profileModelG?.pid) {
                          debugPrint("HOST OR CHALLENGER LEAVING---");
                          context.pop();
                          context.pop();
                        } else {
                          _addComment({
                            'state': state.user,
                            'stateName': 'userLeaves',
                          });
                          setState(() {
                            numberOfStreamers = numberOfStreamers - 1;
                          });
                        }
                      }
                      if (state is GiftingState) {
                        setState(() {
                          totalGiftingPot = totalGiftingPot +
                              num.parse(state.gifts.giftdata?.amount ?? '0');
                          if (state.gifts.giftdata?.receiver ==
                              widget.comboInfo.host?.profile) {
                            hostCoin = hostCoin +
                                num.parse(state.gifts.giftdata?.amount ?? '0');
                          } else if (isComboOngoingNow == true &&
                              (state.gifts.giftdata?.receiver ==
                                      liveChallenger?.pid ||
                                  state.gifts.giftdata?.receiver ==
                                      widget.comboInfo.onGoingCombo?.challenger
                                          ?.profile)) {
                            challengerCoin = challengerCoin +
                                num.parse(state.gifts.giftdata?.amount ?? '0');
                          } else if (state.gifts.giftdata?.receiver ==
                              widget.comboInfo.challenger?.profile) {
                            challengerCoin = challengerCoin +
                                num.parse(state.gifts.giftdata?.amount ?? '0');
                          }
                        });
                        _syncNoGiftReminder();
                        _controller.reset();
                        _controller.forward();
                      }
                      if (state is ComboGroundInLive) {
                        debugPrint(
                            "THE INNER COMBO IS ACTIVATED AND LIVE---****&&&&");
                        setState(() {
                          isComboOngoingNow = true;
                          liveChallenger = state.comboData.challenger;
                          liveChallengerData = state.comboData;
                          countdownTimer(
                              startTime: state.comboData.comboGround?.start ??
                                  widget.comboInfo.metaData?.start_time,
                              durationTime:
                                  state.comboData.comboGround?.duration);
                        });
                      }
                      if (state is LiveBragInCombo) {
                        debugPrint("Testing the liveBrag updating");
                        if (state.challenge.action == 'add') {
                          setState(() {
                            numberOfChallenger = numberOfChallenger + 1;
                          });
                        } else if (state.challenge.action == 'remove') {
                          numberOfChallenger = numberOfChallenger - 1 < 1
                              ? 0
                              : numberOfChallenger - 1;
                        }
                      }
                    },
                    builder: (context, state) {
                      return timerCountdown == "00:00:00" &&
                              isComboOngoingNow == false
                          ? Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 65.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                    color: getFigmaColor("121212"),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[700],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'Stream has ended',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () => context.pop(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue[700],
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        child: const Text('close'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : _isLoading
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withAlpha(10)),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blueAccent,
                                    ),
                                  ))
                              : Stack(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 120.h, bottom: 20.h),
                                    child: SizedBox(
                                      child: isComboOngoingNow == false
                                          ? widget.comboInfo.type == 'single'
                                              ? widget.comboInfo.host?.profile ==
                                                      profileModelG?.pid
                                                  ? screenshareRender?.srcObject !=
                                                          null
                                                      ? ScreenShareView(
                                                          isHostLocalUser: widget
                                                                  .comboInfo
                                                                  .host
                                                                  ?.profile ==
                                                              profileModelG
                                                                  ?.pid,
                                                          role: 'host',
                                                          isMobile: isMobile,
                                                          mobilePlatForm:
                                                              mobilePlatForm,
                                                          imageUrl: widget
                                                              .comboInfo
                                                              .host
                                                              ?.avatar,
                                                          imageAvatar: widget
                                                              .comboInfo
                                                              .host
                                                              ?.avatarConvert,
                                                          cameraRenderer:
                                                              renderer,
                                                          isFullScreen:
                                                              isFullScreen,
                                                          action: () {
                                                            stopScreenShare();
                                                          },
                                                          screenshareRender:
                                                              screenshareRender,
                                                        )
                                                      : SingleVideoView(
                                                          isMobile: isMobile,
                                                          mobilePlatForm:
                                                              mobilePlatForm,
                                                          imageUrl: widget
                                                                  .comboInfo
                                                                  .host
                                                                  ?.avatar ??
                                                              '',
                                                          imageAvatar: widget
                                                              .comboInfo
                                                              .host
                                                              ?.avatarConvert,
                                                          renderer: renderer,
                                                          profilePicMargin:
                                                              EdgeInsets.only(
                                                                  top: 230.h,
                                                                  left: 120.w),
                                                          profilePicHeight:
                                                              100.w,
                                                          profilePicWidth:
                                                              100.w,
                                                          shouldShowVideo: renderer != null &&
                                                              renderer?.srcObject !=
                                                                  null)
                                                  : hostScreenShareRender?.srcObject !=
                                                          null
                                                      ? ScreenShareView(
                                                          isHostLocalUser: widget
                                                                  .comboInfo
                                                                  .host
                                                                  ?.profile ==
                                                              profileModelG
                                                                  ?.pid,
                                                          isMobile: isMobile,
                                                          mobilePlatForm:
                                                              mobilePlatForm,
                                                          role: 'host',
                                                          imageUrl: widget
                                                              .comboInfo
                                                              .host
                                                              ?.avatar,
                                                          imageAvatar: widget
                                                              .comboInfo
                                                              .host
                                                              ?.avatarConvert,
                                                          cameraRenderer:
                                                              hostRender,
                                                          isFullScreen:
                                                              isFullScreen,
                                                          action: () {},
                                                          screenshareRender:
                                                              hostScreenShareRender,
                                                        )
                                                      : SingleVideoView(
                                                          isMobile: isMobile,
                                                          mobilePlatForm: mobilePlatForm,
                                                          remoteRole: 'host',
                                                          imageUrl: widget.comboInfo.host?.avatar ?? '',
                                                          imageAvatar: widget.comboInfo.host?.avatarConvert,
                                                          renderer: hostRender,
                                                          profilePicMargin: EdgeInsets.only(top: 210.h, left: 120.w),
                                                          profilePicHeight: 100.w,
                                                          profilePicWidth: 100.w,
                                                          shouldShowVideo: hostRender != null && hostRender?.srcObject != null)
                                              : MultipleLiveStreamScreen(isMobile: isMobile, mobilePlatForm: mobilePlatForm, hostScreenShareRender: hostScreenShareRender, challengerScreenShareRender: challengerScreenShareRender, hostRender: hostRender, widget: widget, isFullScreen: isFullScreen, challengerRender: challengerRender, screenshareRender: screenshareRender, renderer: renderer, hasOngoingCombo: isComboOngoingNow == true, role: role)
                                          : MultipleLiveStreamScreen(isMobile: isMobile, mobilePlatForm: mobilePlatForm, hostScreenShareRender: hostScreenShareRender, challengerScreenShareRender: challengerScreenShareRender, hostRender: hostRender, widget: widget, isFullScreen: isFullScreen, challengerRender: challengerRender, screenshareRender: screenshareRender, renderer: renderer, hasOngoingCombo: isComboOngoingNow == true, role: role),
                                    ),
                                  ),
                                  LivestreamHeader(
                                    comboInfo: widget.comboInfo,
                                    comboId: widget.comboId,
                                    totalGiftingPot: totalGiftingPot,
                                    creatorEarnedClapPoints: _isCreatorDevice
                                        ? _currentCreatorGiftTotal
                                        : null,
                                    timerCountdown: timerCountdown,
                                    bragID: widget.bragID,
                                    streamersCount: numberOfStreamers,
                                    numOfChallengers: numberOfChallenger,
                                    liveChallenger: liveChallengerData,
                                    isLiveGoingNow: isComboOngoingNow == true,
                                    onLeaveComboEvent: (value) {
                                      if (value) {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return EndliveStream(
                                                comboId: widget.comboId,
                                                earnedClapPoints:
                                                    _currentCreatorGiftTotal,
                                                totalGiftPoints:
                                                    totalGiftingPot,
                                                showGiftSummary:
                                                    _isCreatorDevice,
                                              );
                                            });
                                      }
                                    },
                                  ),
                                  // Timer positioned outside LivestreamHeader
                                  Positioned(
                                    top: 150.h,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: buildTimerCapsule(
                                          timerCountdown ?? ''),
                                    ),
                                  ),
                                  if (_isCreatorDevice)
                                    Positioned(
                                      top: 100.h,
                                      right: 16.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          if (_deviceRole == DeviceRole.primary)
                                            PrimaryDeviceIndicator(
                                              deviceType: 'mobile',
                                            ),
                                          if (_deviceRole ==
                                              DeviceRole.companion)
                                            const CompanionModeIndicator(),
                                          const SizedBox(height: 8),
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withOpacity(0.55),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: IgnorePointer(
                                              ignoring:
                                                  _isDeviceActionInProgress,
                                              child: DeviceSwitchMenu(
                                                comboId: widget.comboId,
                                                userId:
                                                    profileModelG?.pid ?? '',
                                                isStreaming:
                                                    _canBroadcastFromThisDevice,
                                                onSwitchDevice: () {
                                                  _requestDeviceSwitch();
                                                },
                                                onJoinAsCompanion: () {
                                                  _requestCompanionMode();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (widget.comboInfo.type == "multiple" ||
                                      isComboOngoingNow == true)
                                    Positioned(
                                        top: 180.h,
                                        left: 8,
                                        child: SizedBox(
                                          child: ProgressBars(
                                            hostCoinAmount: hostCoin,
                                            challengerCoinAmount:
                                                challengerCoin,
                                            progress: totalGiftingPot > 0
                                                ? hostCoin / totalGiftingPot
                                                : 0.0,
                                          ),
                                        )),
                                  if (state is UserJoined)
                                    LiveNotification(
                                      controller: _controller,
                                      positionAnimation: _positionAnimation,
                                      opacityAnimation: _opacityAnimation,
                                      child: userJoin(
                                          imageUrl:
                                              state.userJoined.user?.image ??
                                                  '',
                                          message: state.userJoined.message,
                                          userName:
                                              state.userJoined.user?.username ??
                                                  ''),
                                    ),
                                  if (state is GiftingState)
                                    LiveNotification(
                                      controller: _controller,
                                      positionAnimation: _positionAnimation,
                                      opacityAnimation: _opacityAnimation,
                                      child: giftWidget(
                                          imageUrl: state.gifts.giftdata?.sender
                                                  ?.avatar ??
                                              '',
                                          message: state.gifts.message,
                                          userName: state.gifts.giftdata?.sender
                                                  ?.username ??
                                              '',
                                          amount:
                                              state.gifts.giftdata?.amount ??
                                                  ''),
                                    ),
                                  if (state is ClappLiveState)
                                    LiveNotification(
                                      controller: _controller,
                                      positionAnimation: _positionAnimation,
                                      opacityAnimation: _opacityAnimation,
                                      child: clapLiveWidget(
                                          imageUrl: state.clapData.user?.avatar,
                                          message: state.clapData.message,
                                          userName:
                                              state.clapData.user?.username,
                                          myavatar: state
                                              .clapData.user?.avatarConvert),
                                    ),
                                  if (userClappEvent)
                                    LiveNotification(
                                      controller: _controller,
                                      positionAnimation: _positionAnimation,
                                      opacityAnimation: _opacityAnimation,
                                      child: clapLiveWidget(
                                          imageUrl: profileModelG?.image ?? '',
                                          message:
                                              'You sent a like \u2764\uFE0F',
                                          userName:
                                              profileModelG?.username ?? '',
                                          myavatar: profileModelG?.myAvatar),
                                    ),

                                  if (!isthereInternet)
                                    Positioned.fill(
                                      child: AbsorbPointer(
                                        absorbing: true,
                                        child: Container(
                                          decoration: const BoxDecoration(),
                                          child: Align(
                                            alignment: const Alignment(0, -.7),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 2.h),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(),
                                                  color: Colors.black
                                                      .withAlpha(200)),
                                              child: Text(
                                                "Stream quality reduced due to unstable internet connection",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_pendingSwitchMessage != null)
                                    Positioned(
                                      top: 210.h,
                                      left: 16.w,
                                      right: 16.w,
                                      child: DeviceSwitchNotification(
                                        newDevice: _pendingSwitchDevice ?? '',
                                        message: _pendingSwitchMessage!,
                                        onAccept: () {
                                          _enterSpectatorModeAfterSwitch();
                                        },
                                        onReject: () {
                                          setState(() {
                                            _pendingSwitchMessage = null;
                                            _pendingSwitchDevice = null;
                                          });
                                        },
                                      ),
                                    ),
                                  // BOTTOM SECTION WITH COMMENTS AND BUTTONS
                                  Positioned(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IgnorePointer(
                                              ignoring: true,
                                              child: Container(
                                                height: visibleCount *
                                                    commentHeight,
                                                margin: EdgeInsets.only(
                                                    bottom: 8.h),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  controller: _scrollController,
                                                  itemExtent: commentHeight,
                                                  itemCount: _comments.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          _buildAnimatedComment(
                                                              index),
                                                ),
                                              )),
                                          // BOTTOM BUTTON SESSION OF THE LIVESTREAM SCREEN
                                          LiveStreamBottomSession(
                                            comboId: widget.comboId,
                                            comboInfo: widget.comboInfo,
                                            bragID: widget.bragID,
                                            isLiveOngoing:
                                                isComboOngoingNow == true,
                                            liveChallenger: liveChallenger,
                                            sendComment: (comment) {
                                              _addComment({
                                                'state': comment,
                                                'stateName': 'commentLive',
                                              });
                                            },
                                            onUserClappEvent: (value) {
                                              if (value) {
                                                setState(() {
                                                  _controller.reset();
                                                  _controller.forward();
                                                  userClappEvent = value;
                                                });
                                              }
                                            },
                                            onLiveMicPressed: (value) {
                                              value
                                                  ? enableMic()
                                                  : disableMic();
                                            },
                                            isMicEnabled: isAudioOn,
                                            onLiveCameraPressed: (value) {
                                              value
                                                  ? enableCamera(false)
                                                  : disableCamera();
                                            },
                                            isCameraEnable: isVideoOn,
                                            isLiveRecording:
                                                isFrontCameraSelected,
                                            onLiveRecordingPressed: (value) {
                                              if (value) {
                                                setState(() {
                                                  isFrontCameraSelected = true;
                                                });
                                                enableCamera(true);
                                              }
                                            },
                                            isScreenShared:
                                                screenshareRender?.srcObject !=
                                                    null,
                                            onShareScreenPressed: (value) {
                                              value
                                                  ? showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return ScreenSharingIcon(
                                                          onPress: () {
                                                            enableShareScreen();
                                                          },
                                                        );
                                                      },
                                                    )
                                                  : stopScreenShare();
                                            },
                                        onEnlargeScreenPressed: (value) {},
                                        isScreenEnlarged: false,
                                        onMiniPressed: (value) {
                                          if (value) {
                                            _minimizeToFloatingLive();
                                          }
                                        },
                                        onExitPressed: (value) {
                                          if (value) {
                                            showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return EndliveStream(
                                                        comboId: widget.comboId,
                                                        earnedClapPoints:
                                                            _currentCreatorGiftTotal,
                                                        totalGiftPoints:
                                                            totalGiftingPot,
                                                        showGiftSummary:
                                                            _isCreatorDevice,
                                                      );
                                                    });
                                              }
                                            },
                                            onTurnedOffPressed: (value) {
                                              if (value) {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return EndliveStream(
                                                        comboId: widget.comboId,
                                                        earnedClapPoints:
                                                            _currentCreatorGiftTotal,
                                                        totalGiftPoints:
                                                            totalGiftingPot,
                                                        showGiftSummary:
                                                            _isCreatorDevice,
                                                      );
                                                    });
                                              }
                                            },
                                            forceSpectatorControls:
                                                !_canBroadcastFromThisDevice,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]);
                    },
                  ),
                ),
                // if (localShareScreenTrack != null)
                // SizedBox.square(
                //     dimension: 400,
                //     child: MediasfuVideoPlayer(track: localShareScreenTrack))
              ],
            ),
          ),
        ));
  }

  // ─────────────────────────────────────────────
  // SCROLL HANDLER
  // ─────────────────────────────────────────────
  void _handleScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final isAtBottom = (maxScroll - currentScroll).abs() < 20;
    _userScrolling = !isAtBottom;
  }

  // ─────────────────────────────────────────────
  // COMMENT LOGIC
  // ─────────────────────────────────────────────
  void _addComment(Map<String, dynamic> comment) {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controllers.add(controller);
    _comments.add(comment);
    controller.forward();
    setState(() {});
    if (!_userScrolling && _comments.length > visibleCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  double _calculateOpacity(int index) {
    final scrollOffset = _scrollController.offset / commentHeight;
    final firstVisibleIndex = scrollOffset.floor();
    if (index < firstVisibleIndex ||
        index >= firstVisibleIndex + visibleCount) {
      return 0.0;
    }
    if (index == firstVisibleIndex) {
      return 1 - (scrollOffset - scrollOffset.floor());
    }
    if (index == firstVisibleIndex + visibleCount) {
      return (scrollOffset - scrollOffset.floor());
    }
    return 1.0;
  }

  Widget _buildAnimatedComment(int index) {
    final comment = _comments[index];
    if (_comments.length <= visibleCount && index < _controllers.length) {
      final animation = CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.easeOut,
      );
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(animation),
          child: BuildCommentBox(commentData: comment),
        ),
      );
    }
    final opacity = _calculateOpacity(index);
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: BuildCommentBox(commentData: comment),
    );
  }

  void _syncNoGiftReminder() {
    if (!_isCreatorDevice || _currentCreatorGiftTotal > 0) {
      _noGiftReminderTimer?.cancel();
      _noGiftReminderTimer = null;
      return;
    }

    _noGiftReminderTimer ??=
        Timer.periodic(const Duration(minutes: 5), (_) => _showNoGiftPrompt());
  }

  Future<void> _showNoGiftPrompt() async {
    if (!mounted ||
        !_isCreatorDevice ||
        _currentCreatorGiftTotal > 0 ||
        _isNoGiftReminderVisible) {
      return;
    }

    _isNoGiftReminderVisible = true;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const NoLivestreamGiftPrompt(),
    );
    _isNoGiftReminderVisible = false;
  }

  Future<void> _minimizeToFloatingLive() async {
    if (Platform.isAndroid) {
      final ratio = _pictureInPictureAspectRatio;
      final enteredPiP = await _screenCaptureService.enterPictureInPicture(
        width: ratio.width,
        height: ratio.height,
      );
      if (enteredPiP) {
        return;
      }
    }

    if (!mounted || _floatingLiveOverlayEntry != null) {
      return;
    }

    final overlay = rootNavigatorKey.currentState?.overlay;
    if (overlay == null) {
      return;
    }

    final positionNotifier = ValueNotifier<Offset>(const Offset(16, 120));
    final comboInfo = widget.comboInfo;
    final comboId = widget.comboId;
    final bragId = widget.bragID;
    final previewRenderer = _floatingPreviewRenderer;

    late final OverlayEntry entry;
    void removeEntry() {
      if (_floatingLiveOverlayEntry == entry) {
        _floatingLiveOverlayEntry = null;
      }
      entry.remove();
    }

    void reopenLive() {
      removeEntry();
      _isMinimizedToOverlay = false;
      _disposePreservedMiniSession();
      rootNavigatorKey.currentContext?.pushNamed(
        MyAppRouteConstant.liveComboThreeImageScreen,
        extra: {
          'liveCombo': comboInfo,
          'comboId': comboId,
          'brag': bragId,
        },
      );
    }

    entry = OverlayEntry(
      builder: (overlayContext) {
        return ValueListenableBuilder<Offset>(
          valueListenable: positionNotifier,
          builder: (context, offset, child) {
            return Positioned(
              left: offset.dx,
              top: offset.dy,
              child: SafeArea(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final size = MediaQuery.of(context).size;
                    positionNotifier.value = Offset(
                      (offset.dx + details.delta.dx).clamp(8.0, size.width - 92.w),
                      (offset.dy + details.delta.dy)
                          .clamp(8.0, size.height - 120.h),
                    );
                  },
                  onTap: reopenLive,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 84.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1F2024),
                            Color(0xFF101115),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.24),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              width: 62.w,
                              height: 62.w,
                              color: Colors.black,
                              child: previewRenderer?.srcObject != null
                                  ? RTCVideoView(
                                      previewRenderer!,
                                      mirror: false,
                                      objectFit: RTCVideoViewObjectFit
                                          .RTCVideoViewObjectFitCover,
                                    )
                                  : Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/mini.svg',
                                        width: 22.w,
                                        height: 22.w,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: const Color(0xFFFF4D67),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Tap to return',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              height: 1.35,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    _floatingLiveOverlayEntry = entry;
    _isMinimizedToOverlay = true;
    overlay.insert(entry);
    context.go(MyAppRouteConstant.feedScreen);
  }

  void _disposePreservedMiniSession() {
    socket?.disconnect();
    socket?.dispose();
    _deviceSwitchHelper.dispose();
    _sendTransport?.close();
    _recvTransport?.close();
    renderer?.dispose();
    hostRender?.dispose();
    challengerRender?.dispose();
    screenshareRender?.dispose();
    hostScreenShareRender?.dispose();
    challengerScreenShareRender?.dispose();
    shareScreenStream?.dispose();
    localShareScreenTrack?.dispose();
    localAudioTrack?.dispose();
    videoStream?.dispose();
    audioStream?.dispose();
  }

  void _removeFloatingLiveOverlay() {
    _floatingLiveOverlayEntry?.remove();
    _floatingLiveOverlayEntry = null;
  }

  // ─────────────────────────────────────────────
  // CREATE SEND TRANSPORT
  // ─────────────────────────────────────────────
  Future<void> createSendTransport(roomId, role) async {
    debugPrint('Start creating transport and see what happened');
    socket?.emit('create-transport', {'roomId': roomId, 'direction': 'send'});

    final transportData = await waitForResult<Map<dynamic, dynamic>>(
      'transport-created',
    );

    _sendTransport = device?.createSendTransportFromMap(
      transportData,
      producerCallback: producerCallbackFunction,
    );

    _sendTransport!.on("connect", (transportData) async {
      socket?.emit('connect-transport', {
        'transportId': _sendTransport?.id,
        'dtlsParameters': transportData['dtlsParameters'].toMap(),
      });
      socket?.once('transport-connected', (data) {
        debugPrint('Transport connected callback fired');
        transportData['callback']();
      });
    });

    _sendTransport?.on('produce', (producedData) {
      socket?.emit('produce', {
        'transportId': _sendTransport?.id,
        'kind': producedData['kind'],
        'rtpParameters': producedData['rtpParameters'].toMap(),
        'appData': producedData['appData'],
      });
      socket?.once('produced', (response) async {
        setState(() {
          if (producedData['appData'] == 'mic') {
            isAudioOn = true;
          }
          if (producedData['appData'] == 'cam') {
            isVideoOn = true;
          }
          if (producedData['appData'] is Map &&
              producedData['appData']['mediaTag'] == 'screen-share') {
            debugPrint(
                '✅ Screen share producer created, producerId: ${response['producerId']}');
            isLocalUserScreenShared = true;
          }
        });
        await producedData['callback'](response['producerId']);
      });
    });
  }

  // ─────────────────────────────────────────────
  // FIX #4: Create Recv Transport — callback called only ONCE
  // ─────────────────────────────────────────────
  Future<void> createRecvTransport(roomId) async {
    debugPrint('Start creating receiving transport');
    socket?.emit('create-transport', {'roomId': roomId, 'direction': 'recv'});
    final transportData = await waitForResult('transport-created');

    _recvTransport = device?.createRecvTransportFromMap(
      transportData,
      consumerCallback: consumerCallback,
    );

    _recvTransport?.on("connect", (recvData) {
      socket?.emit("connect-transport", {
        'transportId': _recvTransport?.id,
        'dtlsParameters': recvData['dtlsParameters'].toMap(),
      });
      // ✅ Call callback only once, inside transport-connected
      socket?.once('transport-connected', (_) {
        try {
          recvData['callback']();
          debugPrint('✅ Recv transport connected successfully');
        } catch (e) {
          debugPrint('Recv transport callback error: ${e.toString()}');
        }
      });
    });
  }

  Future<T> waitForResult<T>(String event) {
    debugPrint('TESTING THE WAIT FOR WORKING HERE.... $event');
    final completer = Completer<T>();
    void handler(dynamic data) {
      socket?.off(event, handler);
      completer.complete(data as T);
    }

    socket?.once(event, handler);
    debugPrint('before finish for returning...');
    return completer.future;
  }

  // ─────────────────────────────────────────────
  // FIX #5: Producer callback — removed ALL duplicate setSrcObject blocks
  // ─────────────────────────────────────────────
  void producerCallbackFunction(Producer producer) async {
    debugPrint(
        '🔍 producerCallbackFunction: Producer created: ${producer.id} (${producer.kind})');
    debugPrint('🔍 producerCallbackFunction: appData = ${producer.appData}');

    if (producer.appData['mediaTag'] == 'mic') {
      micProducerId = producer.id;
      if (mounted) {
        setState(() => isAudioOn = true);
      }
    } else if (producer.appData['mediaTag'] == 'cam') {
      videoProducerId = producer.id;
      if (mounted) {
        setState(() {
          renderer?.setSrcObject(
              stream: producer.stream,
              trackId: producer.stream
                  .getTracks()
                  .firstWhere((track) => track.kind == 'video')
                  .id);
          isVideoOn = true;
        });
      }
    } else if (producer.appData['mediaTag'] == 'screen-share') {
      // ✅ Single, authoritative setSrcObject call — duplicates removed
      screenshareId = producer.id;
      debugPrint('✅ Screen share video producer ID: ${producer.id}');
      if (mounted) {
        setState(() {
          isLocalUserScreenShared = true;
          screenshareRender?.setSrcObject(
              stream: producer.stream,
              trackId: producer.stream
                  .getTracks()
                  .firstWhere((track) => track.kind == 'video')
                  .id);
        });
      }
    } else if (producer.appData['mediaTag'] == 'screen-share-audio') {
      screenshareAudioId = producer.id;
      debugPrint('✅ Screen share audio producer ID: ${producer.id}');
    }

    producer.on('producerclose', () {
      debugPrint('🔚 Producer closed: ${producer.id}');
      producer.close();
    });

    producer.on('producererror', (error) {
      debugPrint('❌ Producer error: $error');
    });

    _sendTransport?.on('transportclose', () {
      debugPrint('❌ Send transport closed');
    });

    producer.on('trackended', () {
      debugPrint('Track ended — closing producer');
      producer.close();
    });
  }

  // ─────────────────────────────────────────────
  // CONSUMER CALLBACK
  // ─────────────────────────────────────────────
  void consumerCallback(Consumer consumer, [dynamic accept]) async {
    debugPrint('🎬 Consumer callback fired ${consumer.appData}');
    await updatingUI(consumer);
  }

  Future<void> updatingUI(Consumer consumer) async {
    debugPrint(
        '🎬 updatingUI() called with role: ${consumer.appData['role']}, mediaTag: ${consumer.appData['mediaTag']}');

    if (consumer.appData['role'] == 'host' && consumer.kind == 'video') {
      if (consumer.appData['mediaTag'] == 'cam') {
        if (hostRender?.srcObject != null) {
          hostRender!.srcObject?.getTracks().forEach((track) => track.stop());
          await hostRender?.dispose();
        }
        isMobile = (consumer.appData['device'] == "android") ||
            (consumer.appData['device'] == 'IOS');
        mobilePlatForm = consumer.appData['device'];
        hostRender = RTCVideoRenderer();
        await hostRender?.initialize();
        hostRender?.srcObject = consumer.stream;
        if (mounted) setState(() {});
      } else if (consumer.appData['mediaTag'] == 'screen-share') {
        if (hostScreenShareRender?.srcObject != null) {
          hostScreenShareRender!.srcObject
              ?.getTracks()
              .forEach((track) => track.stop());
          await hostScreenShareRender?.dispose();
        }
        hostScreenShareRender = RTCVideoRenderer();
        await hostScreenShareRender?.initialize();
        hostScreenShareRender?.srcObject = consumer.stream;
        // Note: isLocalUserScreenShared should NOT be modified here
        // as this is a REMOTE user's screen share, not the local user
      }
    } else if (consumer.appData['role'] == 'challenger' &&
        consumer.kind == 'video') {
      if (consumer.appData['mediaTag'] == 'cam') {
        if (challengerRender?.srcObject != null) {
          challengerRender!.srcObject
              ?.getTracks()
              .forEach((track) => track.stop());
          await challengerRender?.dispose();
        }
        isMobile = (consumer.appData['device'] == "android") ||
            (consumer.appData['device'] == 'IOS');
        mobilePlatForm = consumer.appData['device'];
        challengerRender = RTCVideoRenderer();
        await challengerRender?.initialize();
        challengerRender?.srcObject = consumer.stream;
        if (mounted) setState(() {});
      } else if (consumer.appData['mediaTag'] == 'screen-share') {
        if (challengerScreenShareRender?.srcObject != null) {
          challengerScreenShareRender!.srcObject
              ?.getTracks()
              .forEach((track) => track.stop());
          await challengerScreenShareRender?.dispose();
        }
        challengerScreenShareRender = RTCVideoRenderer();
        await challengerScreenShareRender?.initialize();
        challengerScreenShareRender?.srcObject = consumer.stream;
        // Note: isLocalUserScreenShared should NOT be modified here
        // as this is a REMOTE user's screen share, not the local user
      }
    }
  }

  // ─────────────────────────────────────────────
  // CONSUME TRACKS
  // ─────────────────────────────────────────────
  Future<void> consumeTrack(producer, String roomId) async {
    final completer = Completer<void>();
    final producerId = producer['producerId'];

    void handler(dynamic data) {
      if (data['producerId'] != producerId) return;
      debugPrint(
          "----------------This is the data coming from the backend: $data");
      socket?.off('consumed', handler);
      try {
        _recvTransport?.consume(
          id: data['id'],
          producerId: data['producerId'],
          peerId: producer['peerId'] ?? data['producerId'],
          kind: RTCRtpMediaTypeExtension.fromString(data['kind']),
          rtpParameters: RtpParameters.fromMap(data['rtpParameters']),
          appData: {
            'role': data['role'],
            'mediaTag': data['tag'],
            'device': producer['peerDevice']
          },
        );
        if (!completer.isCompleted) completer.complete();
      } catch (e) {
        debugPrint('❌ Failed to create consumer: $e');
        if (!completer.isCompleted) completer.completeError(e);
      }
    }

    socket?.on('consumed', handler);
    socket?.emit('consume', {
      'roomId': roomId,
      'rtpCapabilities': device?.rtpCapabilities.toMap(),
      'producerId': producer['producerId'],
    });

    try {
      await completer.future.timeout(Duration(seconds: 10), onTimeout: () {
        socket?.off('consumed', handler);
        throw TimeoutException('Consume timeout for producer: $producerId');
      });
    } catch (e) {
      debugPrint("consumeTrack error: $e");
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  // LOAD DEVICE
  // ─────────────────────────────────────────────
  Future<void> loadDevice(RtpCapabilities rtpCapabilities) async {
    debugPrint('📱 Loading device with RTP capabilities...');
    try {
      device = Device();
      await device?.load(routerRtpCapabilities: rtpCapabilities);
      debugPrint('✅ Device loaded successfully');
    } catch (e) {
      debugPrint('❌ Failed to load device: $e');
    }
  }

  // ─────────────────────────────────────────────
  // CAMERA
  // ─────────────────────────────────────────────
  void disableCamera() async {
    try {
      localVideoTrack?.stop();
      localVideoTrack = null;
      if (videoStream != null) {
        videoStream?.getTracks().forEach((track) => track.stop());
        videoStream = null;
        socket?.emit('close-producer', {'producerId': videoProducerId});
        socket?.emit('video-stream-stopped', {'role': role});
        setState(() {
          isVideoOn = false;
          renderer?.setSrcObject(stream: null, trackId: null);
          videoStream = null;
        });
      }
    } catch (e) {
      debugPrint('Error disabling the camera: $e');
    }
  }

  void enableCamera(bool frontCamera) async {
    debugPrint('🎥 enableCamera() called');
    if (device?.canProduce(RTCRtpMediaType.RTCRtpMediaTypeVideo) == false) {
      debugPrint('❌ Device cannot produce video');
      return;
    }
    if (_sendTransport == null) {
      debugPrint('❌ Send transport not available');
      return;
    }
    try {
      RtpCodecCapability? codec = device!.rtpCapabilities.codecs.firstWhere(
        (RtpCodecCapability c) => c.mimeType.toLowerCase() == 'video/vp8',
        orElse: () => throw 'VP8 codec not supported',
      );

      if (videoStream != null && frontCamera) {
        socket?.emit('close-producer', {'producerId': videoProducerId});
        videoStream!
            .getVideoTracks()
            .forEach((element) => element.switchCamera());
      } else if (!frontCamera) {
        videoStream = await createVideoStream();
      }
      localVideoTrack = videoStream?.getVideoTracks().first;
      setState(() {});
      _sendTransport!.produce(
        track: localVideoTrack!,
        stream: videoStream!,
        codec: codec,
        codecOptions: ProducerCodecOptions(videoGoogleStartBitrate: 1000),
        source: 'cam',
        appData: {
          'mediaTag': 'cam',
          'role': role,
          'device': Platform.isIOS ? 'IOS' : "android"
        },
      );
      socket?.emit('video-stream-started', {'role': role});
    } catch (error) {
      debugPrint('❌ enableCamera error: $error');
      if (videoStream != null) await videoStream?.dispose();
    }
  }

  Future<MediaStream> createVideoStream() async {
    debugPrint('📹 Creating video stream...');
    try {
      return await navigator.mediaDevices
          .getUserMedia(<String, dynamic>{'video': true});
    } catch (e) {
      debugPrint('❌ Failed to create video stream: $e');
      rethrow;
    }
  }

  Future<MediaStream> createAudioStream() async {
    return await navigator.mediaDevices.getUserMedia({'audio': true});
  }

  // ─────────────────────────────────────────────
  // MICROPHONE
  // ─────────────────────────────────────────────
  void enableMic() async {
    if (device?.canProduce(RTCRtpMediaType.RTCRtpMediaTypeAudio) == false) {
      return;
    }
    try {
      audioStream = await createAudioStream();
      localAudioTrack = audioStream?.getAudioTracks().first;
      _sendTransport?.produce(
        track: localAudioTrack!,
        stream: audioStream!,
        source: 'mic',
        appData: {'mediaTag': 'mic', 'role': role},
      );
      socket!.emit('mic-started', {'role': role});
    } catch (e) {
      debugPrint('Error enabling mic: $e');
      if (audioStream != null) await audioStream?.dispose();
    }
  }

  void disableMic() async {
    try {
      if (localAudioTrack != null) {
        localAudioTrack?.stop();
        localAudioTrack = null;
        if (audioStream != null) {
          audioStream?.getTracks().forEach((track) => track.stop());
          await audioStream?.dispose();
          audioStream = null;
        }
        socket?.emit('close-producer', {'producerId': micProducerId});
        setState(() => isAudioOn = false);
      }
    } catch (e) {
      debugPrint('Error disabling mic: $e');
    }
  }

  // ─────────────────────────────────────────────
  // FIX #6: Screen share — platform-specific constraints + lower Android fps
  // ─────────────────────────────────────────────
  // ─────────────────────────────────────────────
  // FIX #6: Screen share — platform-specific constraints + lower Android fps
  // ─────────────────────────────────────────────
  Future<MediaStream?> shareScreen({bool includeAudio = true}) async {
    try {
      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj 🔍 shareScreen: Starting screen capture');
      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj 🔍 shareScreen: Platform = ${Platform.operatingSystem}');

      final Map<String, dynamic> mediaConstraints = Platform.isIOS
          ? {
              // iOS: uses broadcast extension (extension is configured in Info.plist)
              // Note: audio is always false for iOS broadcast - iOS doesn't provide audio in broadcast streams
              // OPTIMIZED: Lower frame rate and add resolution constraints for better performance
              'video': {
                'deviceId': 'broadcast',
                'mandatory': {
                  'minWidth': 640,
                  'minHeight': 480,
                  'maxWidth': 1280,
                  'maxHeight': 720,
                  'maxFrameRate':
                      15, // ✅ Reduced from 30 to 15 for smoother streaming
                },
              },
              'audio': false, // iOS broadcast extension doesn't provide audio
            }
          : {
              // Android: simpler constraints — 15fps avoids Samsung Exynos black frame bug
              'video': {
                'mandatory': {
                  'minWidth': 720,
                  'minHeight': 1280,
                  'maxFrameRate': 15, // ✅ lowered from 30
                },
              },
              'audio': includeAudio,
            };

      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj 🔍 shareScreen: Calling getDisplayMedia with constraints: $mediaConstraints');
      final MediaStream stream =
          await navigator.mediaDevices.getDisplayMedia(mediaConstraints);

      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj ✅ shareScreen: getDisplayMedia returned successfully');

      final tracks = stream.getTracks();

      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj ✅ shareScreen: got stream with ${tracks.length} tracks');
      for (var track in tracks) {
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj 🔍 Track: ${track.kind}, id: ${track.id}, enabled: ${track.enabled}');
      }

      final audioTracks = stream.getAudioTracks();
      if (audioTracks.isNotEmpty) {
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj ✅ Audio track found: ${audioTracks.first.id}');
      } else {
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj ⚠️ No audio tracks in screen share stream');
      }

      return stream;
    } catch (e, stackTrace) {
      debugPrint("dbjfkdbfskdfbkdbfkjbdsfkj ❌ shareScreen Capture failed: $e");
      debugPrint(
          "dbjfkdbfskdfbkdbfkjbdsfkj ❌ shareScreen Stack trace: $stackTrace");
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // FIX #7: enableShareScreen
  //   - finally block only stops service on ERROR (not on success)
  //   - VP8 forced for Android
  //   - Service NOT killed prematurely
  //   - iOS and Android now have completely separate flows
  // ─────────────────────────────────────────────
  void enableShareScreen() async {
    debugPrint(
        'dbjfkdbfskdfbkdbfkjbdsfkj ========== enableShareScreen START ==========');
    debugPrint('dbjfkdbfskdfbkdbfkjbdsfkj enableShareScreen: role = $role');
    debugPrint(
        'dbjfkdbfskdfbkdbfkjbdsfkj enableShareScreen: Platform = ${Platform.operatingSystem}');

    bool serviceStarted = false;

    try {
      if (Platform.isIOS) {
        // ═════════════════════════════════════════════════════════════
        // iOS: Use broadcast extension - show picker then getDisplayMedia
        // ═════════════════════════════════════════════════════════════
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj 📱 iOS detected - showing broadcast picker');

        final bool picked = await ScreenCaptureService().showBroadcastPicker();
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj 📱 iOS broadcast picker result: $picked');

        if (!picked) {
          _showScreenShareError('Broadcast picker was cancelled');
          return;
        }

        // Mark as started - iOS doesn't use foreground service
        serviceStarted = true;
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj 📱 iOS: Calling shareScreen() function...');
        shareScreenStream = await shareScreen();
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj 📱 iOS shareScreen() returned: ${shareScreenStream != null}');
      } else if (Platform.isAndroid) {
        // ═════════════════════════════════════════════════════════════
        // Android: Use foreground service + getDisplayMedia
        // ═════════════════════════════════════════════════════════════
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj 📱 Starting Android screen capture service...');

        final bool started = await ScreenCaptureService().startScreenShare();
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj Android screen capture started: $started');

        if (!started) {
          debugPrint(
              'dbjfkdbfskdfbkdbfkjbdsfkj ❌ Failed to start Android screen capture service');
          _showScreenShareError('Failed to start screen capture service');
          return;
        }

        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj ⏳ Waiting for service to be ready...');
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj ⏳ Service check: maxAttempts=50, intervalMs=500');
        final bool serviceReady =
            await _waitForService(maxAttempts: 50, intervalMs: 500);
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj ⏳ Service ready result: $serviceReady');

        if (!serviceReady) {
          debugPrint(
              'dbjfkdbfskdfbkdbfkjbdsfkj ❌ Service did not start in time');
          try {
            await ScreenCaptureService().stopScreenShare();
          } catch (e) {
            debugPrint(
                'dbjfkdbfskdfbkdbfkjbdsfkj ⚠️ Error stopping service: $e');
          }
          _showScreenShareError('Screen capture service did not start');
          return;
        }

        // ✅ Mark as started only after confirmed running
        serviceStarted = true;
        debugPrint(
            "dbjfkdbfskdfbkdbfkjbdsfkj ✅ Screen capture service is running");

        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj Calling shareScreen() function...');
        shareScreenStream = await shareScreen();
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj shareScreen() returned: ${shareScreenStream != null}');
      } else {
        _showScreenShareError(
            'Screen sharing is only supported on iOS and Android');
        return;
      }

      if (shareScreenStream == null) {
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj ❌ enableShareScreen: Stream is null — user may have cancelled or getDisplayMedia failed');
        // Don't stop service here — user might retry
        return;
      }

      localShareScreenTrack = shareScreenStream?.getVideoTracks().first;
      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj ✅ enableShareScreen: Got video track: ${localShareScreenTrack?.id}');
      setState(() {});

      if (localShareScreenTrack == null) {
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj ❌ enableShareScreen: No video track in stream');
        _showScreenShareError('No video track available');
        return;
      }

      if (_sendTransport == null) {
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj ❌ enableShareScreen: Send transport is null');
        _showScreenShareError('Connection error - transport not available');
        return;
      }

      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj ✅ enableShareScreen: All checks passed, proceeding to produce track');

      // ✅ Force VP8 on Android to prevent Samsung Exynos black screen
      RtpCodecCapability? screenCodec;
      print(
          "hdhasvdhvsadhvasdjhvs-rtpCapabilities>>>${device?.rtpCapabilities.codecs.map(
        (e) => e.mimeType,
      )}");
      if (device?.rtpCapabilities.codecs != null) {
        // if (Platform.isAndroid && device?.rtpCapabilities.codecs != null) {

        try {
          screenCodec = device!.rtpCapabilities.codecs.firstWhere(
            (c) => c.mimeType.toLowerCase() == 'video/h264',
            // c.mimeType.toLowerCase() == 'video/vp8',
            // c.mimeType.toLowerCase() == 'video/rtx',

            // (audio/opus, video/VP8, video/rtx, video/H264, video/rtx)
          );
          debugPrint('✅ VP8 codec selected for Android screen share');
        } catch (e) {
          debugPrint('⚠️ VP8 not available, using server default: $e');
          screenCodec = null;
        }
      }

      _sendTransport?.produce(
        track: localShareScreenTrack!,
        stream: shareScreenStream!,
        codec: screenCodec, // VP8 for Android, default for iOS
        codecOptions: ProducerCodecOptions(
            videoGoogleStartBitrate:
                1000), // ✅ Reduced from 2500 to 1000 for better performance
        source: 'screen-share',
        appData: {
          'mediaTag': 'screen-share',
          'role': role,
          'device': Platform.isIOS ? 'IOS' : 'android',
        },
      );
      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj ✅ enableShareScreen: produce() called for video');

      // Produce audio track if available
      final audioTracks = shareScreenStream?.getAudioTracks();
      if (audioTracks != null && audioTracks.isNotEmpty) {
        localScreenShareAudioTrack = audioTracks.first;
        debugPrint(
            '🎬 Producing screen share audio: ${localScreenShareAudioTrack?.id}');
        _sendTransport?.produce(
          track: localScreenShareAudioTrack!,
          stream: shareScreenStream!,
          source: 'screen-share-audio',
          appData: {
            'mediaTag': 'screen-share-audio',
            'role': role,
            'device': Platform.isIOS ? 'IOS' : 'android',
          },
        );
      } else {
        debugPrint('⚠️ No audio track available for screen share');
      }

      setState(() => isLocalUserScreenShared = true);

      if (context.mounted) context.pop();
      socket?.emit('screen-share-started', {'role': role});
      debugPrint('✅ Screen share started successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error enabling screen share: $e');
      debugPrint('Stack trace: $stackTrace');
      _showScreenShareError('Failed to start screen share: $e');
    } finally {
      // ✅ Only stop the Android service if we failed before producing
      // iOS doesn't use foreground service, so no cleanup needed
      if (serviceStarted && Platform.isAndroid && !isLocalUserScreenShared) {
        try {
          await ScreenCaptureService().stopScreenShare();
          debugPrint('🧹 Android service stopped (error cleanup)');
        } catch (e) {
          debugPrint('⚠️ Error stopping service in finally: $e');
        }
      }
      // If isLocalUserScreenShared == true, service stays alive
      // and will be stopped in stopScreenShare()
    }
  }

  Future<bool> _waitForService(
      {required int maxAttempts, required int intervalMs}) async {
    debugPrint(
        'dbjfkdbfskdfbkdbfkjbdsfkj 🔍 _waitForService: Starting check (max $maxAttempts attempts)');
    for (int i = 0; i < maxAttempts; i++) {
      final running = await ScreenCaptureService().isServiceRunning();
      debugPrint(
          'dbjfkdbfskdfbkdbfkjbdsfkj 🔍 _waitForService: Attempt ${i + 1}/$maxAttempts - isRunning: $running');
      if (running) {
        debugPrint(
            'dbjfkdbfskdfbkdbfkjbdsfkj ✅ Service ready after ${i + 1} attempts');
        return true;
      }
      await Future.delayed(Duration(milliseconds: intervalMs));
    }
    debugPrint(
        'dbjfkdbfskdfbkdbfkjbdsfkj ❌ _waitForService: Service did not start after $maxAttempts attempts');
    return false;
  }

  void _showScreenShareError(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // ─────────────────────────────────────────────
  // STOP SCREEN SHARE
  // Added proper state management to prevent race conditions
  // ─────────────────────────────────────────────
  void stopScreenShare() async {
    // Prevent multiple simultaneous stop calls
    if (!isLocalUserScreenShared) {
      debugPrint('🛑 stopScreenShare called but no active share, ignoring');
      return;
    }

    try {
      debugPrint('🛑 Stopping screen share...');

      // Stop and clear track first
      localShareScreenTrack?.stop();
      localShareScreenTrack = null;
      debugPrint('✅ Local screen track stopped');

      if (shareScreenStream != null) {
        shareScreenStream?.getTracks().forEach((track) => track.stop());
        await shareScreenStream?.dispose();
        shareScreenStream = null;
        debugPrint('✅ Screen stream disposed');
      }

      // Emit socket events sequentially (await each)
      if (screenshareId.isNotEmpty) {
        socket?.emit('close-producer', {'producerId': screenshareId});
        screenshareId = '';
        debugPrint('✅ Server notified: video producer closed');
      }

      if (screenshareAudioId.isNotEmpty) {
        socket?.emit('close-producer', {'producerId': screenshareAudioId});
        screenshareAudioId = '';
        debugPrint('✅ Server notified: audio producer closed');
      }

      localScreenShareAudioTrack = null;
      socket?.emit('screen-share-stopped', {'role': role});
      debugPrint('✅ Screen share stopped event emitted');

      // ✅ Stop Android foreground service here (correct place — not in finally)
      // Only stop if it's Android - iOS doesn't use foreground service
      if (Platform.isAndroid) {
        await ScreenCaptureService().stopScreenShare();
        debugPrint('✅ Android screen capture service stopped');
      }

      // Clear render sources last
      screenshareRender?.setSrcObject(stream: null, trackId: null);

      setState(() {
        isLocalUserScreenShared = false;
      });

      debugPrint('✅ Screen share stopped successfully');
    } catch (e) {
      debugPrint('Error stopping screen share: ${e.toString()}');
      // Force reset state even on error
      setState(() => isLocalUserScreenShared = false);
    }
  }
}
