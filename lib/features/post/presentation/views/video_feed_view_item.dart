import 'package:clapmi/features/post/domain/entities/create_video_post_entity.dart';
import 'package:clapmi/features/post/presentation/views/video_feed_view_optimized_videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFeedViewItem extends StatelessWidget {
  const VideoFeedViewItem(
      {required this.videoItem, required this.controller, super.key});

  final VideoPostEntity videoItem;
  final VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoFeedViewOptimizedVideoPlayer(
            controller: controller, videoId: videoItem.video ?? ''),
        // VideoFeedViewOverlaySection(
        //   profileImageUrl: videoItem.profileImageUrl,
        //   username: videoItem.username,
        //   description: videoItem.description,
        //   isBookmarked: false,
        //   isLiked: false,
        //   likeCount: videoItem.likeCount,
        //   commentCount: videoItem.commentCount,
        //   shareCount: videoItem.shareCount,
        // ),
      ],
    );
  }
}
