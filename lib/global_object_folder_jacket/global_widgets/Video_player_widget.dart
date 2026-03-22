import 'dart:developer';
import 'dart:io';

import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/fancy_text.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController? externalVideoPlayerController;
  final double? height;
  final double? width;
  final DataSourceType dataSourceType;
  final String resourcePath;
  final Function()? onInitialize;

  const VideoPlayerWidget({
    super.key,
    this.externalVideoPlayerController,
    this.height,
    this.width,
    required this.dataSourceType,
    required this.resourcePath,
    this.onInitialize,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

// _controller
class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;

  @override
  void initState() {
    iconAnimationController = AnimationController(vsync: this);
    if (widget.externalVideoPlayerController == null) {
      if (widget.dataSourceType == DataSourceType.asset) {
        _controller = VideoPlayerController.asset(widget.resourcePath);
      }

      if (widget.dataSourceType == DataSourceType.file) {
        _controller = VideoPlayerController.file(File(widget.resourcePath));
      }
      if (widget.dataSourceType == DataSourceType.network) {
        _controller =
            VideoPlayerController.networkUrl(Uri.parse(widget.resourcePath));
      }
    } else {
      _controller = widget.externalVideoPlayerController!;
    }
    // try {
    // if (!_controller.value.isInitialized) {

    //   .then(
    //     (value) {
    //       try {
    //         if (mounted) setState(() {});
    //       } catch (e) {}
    //     },
    //   );
    // } else {}
    // } catch (e) {}

    super.initState();
  }

  late AnimationController iconAnimationController;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: () async {
          if (!_controller.value.isInitialized) {
            await _controller.initialize();
          }
          widget.onInitialize?.call();
          return "";
        }.call(),
        builder: (context, snapshot) {
          return (snapshot.hasData)
              ? FancyContainer(
                  backgroundColor: AppColors.backgroundColor,
                  height: widget.height ?? 200,
                  width: widget.width ?? 200,
                  child: _controller.value.isInitialized
                      ? Stack(
                          children: [
                            VideoPlayer(
                              _controller,
                            ),
                            FancyContainer(
                              action: () {
                                log("debug_print-_VideoPlayerWidgetState-build-pause_triggered");
                                log("debug_print-_VideoPlayerWidgetState-build-_coltroller_playing_state-${_controller.value.isPlaying}");

                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                                try {
                                  iconAnimationController.forward(from: 0);
                                } catch (e) {}
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: FittedBox(
                                  child: Icon(_controller.value.isPlaying
                                          ? Icons.play_arrow_rounded
                                          : Icons.pause_rounded)
                                      .animate()
                                      .fadeOut(),
                                ),
                              ),
                            )
                          ],
                        )
                      : SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator.adaptive(),
                        ),
                )
              : ((snapshot.hasError)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dangerous,
                            color: Colors.red,
                          ),
                          FancyText("${snapshot.error}")
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator.adaptive()));
        });
  }

  // ============ MEMORY LEAK FIX ============
  @override
  void dispose() {
    // Dispose AnimationController to prevent memory leak
    iconAnimationController.dispose();
    // Dispose VideoPlayerController if we created it internally
    if (widget.externalVideoPlayerController == null) {
      _controller.dispose();
    }
    super.dispose();
  }
  // ============ END MEMORY LEAK FIX ============
}
