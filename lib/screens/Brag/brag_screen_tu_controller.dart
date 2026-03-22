import 'package:clapmi/Models/brag_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFeedProvider extends ChangeNotifier {
  final Map<int, VideoPlayerController> _controllers = {};
  int _currentIndex = 0;
  int _previousIndex = 0;

  bool _isFeedVisible = false;

  int get currentIndex => _currentIndex;
  Map<int, VideoPlayerController> get controllers => _controllers;
  List<BragModel> theListOfBragModel = [];

  @override
  void dispose() {
    // Dispose all video controllers to prevent memory leaks
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  // 1. PRELOAD LOGIC: Call this when your Home Page / App starts
  void preloadInitialVideos(List<String> videoUrls) {
    print("dfgdskfsjhfvsdjhfvjsdhvf");
    for (int i = 0; i < 3; i++) {
      _createController(i, videoUrls[i]);
    }
  }

  int pageNumber = 1;

  void _createController(int index, String url) {
    if (_controllers.containsKey(index)) return;

    final controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        // Only play if this is the current index AND the feed is visible
        if (index == _currentIndex && _isFeedVisible) {
          _controllers[index]?.play();
        }
        notifyListeners();
      });
    _controllers[index] = controller;
  }

  // 2. VISIBILITY LOGIC: Handle Pause/Play when switching tabs
  void setFeedVisibility(bool visible) {
    _isFeedVisible = visible;
    if (visible) {
      _controllers[_currentIndex]?.play();
    } else {
      _controllers[_currentIndex]?.pause();
    }
    notifyListeners();
  }

  void updateIndex(int index, List<String> videoUrls) {
    _controllers[_currentIndex]?.pause();
    _previousIndex = _currentIndex;
    _currentIndex = index;

    if (_isFeedVisible) {
      _controllers[_currentIndex]?.play();
    }
    if (_previousIndex < _currentIndex) {
      // Preload next
      if (index + 1 < videoUrls.length) {
        _createController(index + 1, videoUrls[index + 1]);
      }
      if (index + 2 < videoUrls.length) {
        _createController(index + 2, videoUrls[index + 2]);
      }
    } else {
      // Preload previous
      if (index - 1 > 0) _createController(index - 1, videoUrls[index - 1]);
      if (index - 2 < 0) _createController(index - 2, videoUrls[index - 2]);
    }
    _cleanup(index, _previousIndex < _currentIndex);
    notifyListeners();
  }

  void _cleanup(int index, bool movedDownwards) {
    final keysToRemove = movedDownwards
        ? _controllers.keys
            .where((i) => i < index - 1 || i > index + 2)
            .toList()
        : _controllers.keys
            .where((i) => i < index - 2 || i > index + 1)
            .toList();
    for (var key in keysToRemove) {
      _controllers[key]?.dispose();
      _controllers.remove(key);
    }
  }
}
