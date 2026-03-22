import 'package:clapmi/features/post/domain/entities/create_video_post_entity.dart';
import 'package:clapmi/features/post/presentation/blocs/video_bloc/video_bloc.dart';
import 'package:clapmi/features/post/presentation/views/video_feed_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';

class VideoFeedView extends StatefulWidget {
  const VideoFeedView({super.key});

  @override
  State<VideoFeedView> createState() => _VideoFeedViewState();
}

class _VideoFeedViewState extends State<VideoFeedView>
    with WidgetsBindingObserver {
  ///Maximum number of controllers to keep in cache
  final int _maxCacheSize = 3;

  /// The current videos to display
  List<VideoPostEntity> _videos = [];

  /// Current visible page
  int _currentPage = 0;

  /// PageView controller
  final PreloadPageController _pageController = PreloadPageController();

  ///Whether the app is currently active
  bool _isAppActive = true;

  ///LRU cache of video controllers by video ID
  final Map<String, VideoPlayerController> _controllerCache = {};

  /// Ordered list of videoUrls by most recently accessed
  final List<String> _accessorder = [];

  /// Set of video IDs currently being disposed to prevent race conditions
  final Set<String> _disposingControllers = <String>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeFirstVideo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeAllControllers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final wasActive = _isAppActive;
    _isAppActive = state == AppLifecycleState.resumed;

    if (_isAppActive && !wasActive) {
      //App has come back to foreground
      _cleanupAndReinitializeCurrentVideo();
    } else if (!_isAppActive && !wasActive) {
      // App is going to background - pause all videos
      _pauseAllController();
    }
    super.didChangeAppLifecycleState(state);
  }

  // Initialize the first video when the view loads
  void _initializeFirstVideo() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Recall that the initial loading function has already being called when the bloc class
      //was instantiated
      final state = context.read<VideoBloc>().state;
      if (state.videos.isNotEmpty) {
        setState(() => _videos = state.videos);

        await _initAndPlayVideo(0);
      }
    });
  }

  ///Clean up and reinitialize the current video when coming back from background
  Future<void> _cleanupAndReinitializeCurrentVideo() async {
    if (_videos.isEmpty || _currentPage >= _videos.length) return;

    await _pauseAllController();

    //videoId would be the videoUrl in this case
    final videoPostId = _videos[_currentPage].post;
    final controller = _getController(videoPostId ?? '');

    //If controller exists but has errors, dispose it
    if (controller != null &&
        (controller.value.hasError || !controller.value.isInitialized)) {
      await _removeController(videoPostId ?? '');
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }

    // Reinitialize and play current video
    await _initAndPlayVideo(_currentPage);
  }

  /// Initialize and play a video at the given index
  Future<void> _initAndPlayVideo(int index) async {
    if (_videos.isEmpty || index >= _videos.length) return;

    final video = _videos[index];
    await _getOrCreateController(video);
    await _playController(video.post ?? '');

    if (mounted) setState(() {});
  }

  /// Get a controller for a video ID if it exists in the cache
  VideoPlayerController? _getController(String videoPostId) {
    return _controllerCache[videoPostId];
  }

  /// Touch a controller to mark it as recently used
  void _touchControler(String videoPostId) {
    _accessorder
      ..remove(videoPostId)
      ..add(videoPostId);
  }

  // Get or create a controller for a video
  Future<VideoPlayerController?> _getOrCreateController(
      VideoPostEntity video) async {
    // Return the existing controller if available
    if (_controllerCache.containsKey(video.post)) {
      _touchControler(video.post ?? '');
      return _controllerCache[video.post];
    }
    try {
      //Get cached file from the cubit
      final videoFile =
          await context.read<VideoBloc>().getCachedVideoFile(video.video ?? '');

      //Create a new controller
      final controller = VideoPlayerController.file(videoFile);

      //Initialize the controller
      await controller.initialize();

      // Set looping
      await controller.setLooping(true);

      // Add to cache and update access order
      _controllerCache[video.post ?? ''] = controller;
      _touchControler(video.post ?? '');

      //Enforce cache size limit
      _enforceCacheLimit();
      return controller;
    } catch (e) {
      debugPrint('Error initializing controller: $e');
      return null;
    }
  }

  /// Play a controller if it exists and is initialized
  Future<void> _playController(String videoPostId) async {
    final controller = _controllerCache[videoPostId];
    if (controller != null &&
        controller.value.isInitialized &&
        !controller.value.isPlaying) {
      try {
        await controller.play();
      } catch (e) {
        debugPrint('Error playing video: $e');
      }
    }
  }

  /// Pause all controllers
  Future<void> _pauseAllController() async {
    // Create a copy of the controllers to avoid concurrent modification
    final controllers =
        List<VideoPlayerController>.from(_controllerCache.values);

    for (final controller in controllers) {
      try {
        if (controller.value.isInitialized && controller.value.isPlaying) {
          await controller.pause();
          await controller.seekTo(Duration.zero);
        }
      } catch (e) {
        debugPrint('Error pausing video: $e');
      }
    }
  }

  /// Remove a controller from cache and dispose it
  Future<void> _removeController(String videoPostId) async {
    if (_disposingControllers.contains(videoPostId)) return;

    _disposingControllers.add(videoPostId);

    try {
      final controller = _controllerCache[videoPostId];
      if (controller != null) {
        //Remove from cache immediately
        _controllerCache.remove(videoPostId);
        _accessorder.remove(videoPostId);

        // Pause and dispose
        try {
          if (controller.value.isInitialized) {
            await controller.pause();
          }
          await controller.dispose();
        } catch (e) {
          debugPrint('Error disposing controller: $e');
        }
      }
    } finally {
      _disposingControllers.remove(videoPostId);
    }
  }

  /// Enforce the cache size limit by removing least recently used controllers
  void _enforceCacheLimit() {
    /// Only keep max number of controllers
    while (_controllerCache.length > _maxCacheSize && _accessorder.isNotEmpty) {
      final oldestVideoPostId = _accessorder.first;
      _removeController(oldestVideoPostId);
    }
  }

  /// Dispose all controllers
  Future<void> _disposeAllControllers() async {
    _pageController.dispose();

    final controllerIds = List<String>.from(_controllerCache.keys);
    for (final id in controllerIds) {
      await _removeController(id);
    }
    _controllerCache.clear();
    _accessorder.clear();
  }

  /// Manage the window of controllers around the current page
  Future<void> _manageControllerWindow(int currentPage) async {
    if (_videos.isEmpty) return;

    //Define window of pages to keep
    final windowStart = (currentPage - 1).clamp(0, _videos.length - 1);
    final windowEnd = (currentPage + 1).clamp(0, _videos.length - 1);

    //Get urls in window
    final idsToKeep = <String>{};
    for (int i = windowStart; i <= windowEnd; i++) {
      if (i < _videos.length) {
        idsToKeep.add(_videos[i].video ?? '');
      }
    }

    //Dispose controllers outside window
    final idsToDispose =
        _controllerCache.keys.where((url) => !idsToKeep.contains(url)).toList();
    for (final url in idsToDispose) {
      await _removeController(url);
    }

    // Initialize controllers in window, prioritizing current page
    if (currentPage < _videos.length) {
      // Current page first
      await _getOrCreateController(_videos[currentPage]);

      // Then Previous page if in range
      if (windowStart < currentPage && windowStart >= 0) {
        await _getOrCreateController(_videos[windowStart]);
      }

      // Then next page if in range
      if (windowEnd > currentPage && windowEnd < _videos.length) {
        await _getOrCreateController(_videos[windowEnd]);
      }
    }
  }

  /// Handle page changes in the video feed
  Future<void> _handlePageChange(int newPage) async {
    if (_videos.isEmpty || newPage >= _videos.length) return;

    final previousPage = _currentPage;
    _currentPage = newPage;

    // For fast scrolling, be more aggressive
    final isFastScroll = (newPage - previousPage).abs() > 1;

    //First pause all videos
    await _pauseAllController();

    try {
      if (isFastScroll) {
        // In fast scroll, dispose all except target
        final videoPostId = _videos[newPage].post;
        final idsToDispose = List<String>.from(_controllerCache.keys);

        for (final url in idsToDispose) {
          if (url != videoPostId) {
            await _removeController(url);
          }
        }
      }

      // Manage the window controllers
      await _manageControllerWindow(newPage);

      // Play only the current video
      if (_videos.isNotEmpty && newPage < _videos.length) {
        await _initAndPlayVideo(newPage);
      }

      //Notify the cubit
      if (mounted) {
        await context.read<VideoBloc>().onPageChanged(newPage);
      }
    } catch (e) {
      debugPrint('Error handling page change: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BlocListener<VideoBloc, VideoState>(
        listenWhen: (p, c) =>
            p.videos != c.videos ||
            p.isLoading != c.isLoading ||
            p.preloadedVideoUrls != c.preloadedVideoUrls,
        listener: (context, state) {
          setState(() => _videos = state.videos);
          _manageControllerWindow(_currentPage);
        },
        child: PreloadPageView.builder(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          itemCount: _videos.length,
          physics: const AlwaysScrollableScrollPhysics(),
          onPageChanged: _handlePageChange,
          itemBuilder: (context, index) {
            return RepaintBoundary(
              child: VideoFeedViewItem(
                key: ValueKey(_videos[index].post),
                controller: _getController(_videos[index].post ?? ''),
                videoItem: _videos[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
