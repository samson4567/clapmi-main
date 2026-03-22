part of 'video_bloc.dart';

class VideoState extends Equatable {
  const VideoState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isPaginating = false,
    this.currentIndex = 0,
    this.errorMessage = '',
    this.hasMoreVideos = true,
    this.videos = const [],
    this.preloadedVideoUrls = const {},
  });
  final bool isLoading;
  final bool isSuccess;
  final bool isPaginating;
  final String errorMessage;
  final bool hasMoreVideos;
  final int currentIndex;
  final Set<String> preloadedVideoUrls;
  final List<VideoPostEntity> videos;

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        isPaginating,
        hasMoreVideos,
        errorMessage,
        videos,
        currentIndex,
        preloadedVideoUrls,
      ];

  VideoState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isPaginating,
    bool? hasMoreVideos,
    String? errorMessage,
    List<VideoPostEntity>? videos,
    int? currentIndex,
    Set<String>? preloadedVideoUrls,
  }) {
    return VideoState(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isPaginating: isPaginating ?? this.isPaginating,
        hasMoreVideos: hasMoreVideos ?? this.hasMoreVideos,
        errorMessage: errorMessage ?? this.errorMessage,
        videos: videos ?? this.videos,
        currentIndex: currentIndex ?? this.currentIndex,
        preloadedVideoUrls: preloadedVideoUrls ?? this.preloadedVideoUrls);
  }

  factory VideoState.inital() => VideoState();
}
