import 'dart:collection';
import 'dart:io';

import 'package:clapmi/features/post/domain/entities/create_video_post_entity.dart';
import 'package:clapmi/features/post/domain/repositories/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

part 'video_state.dart';

class VideoBloc extends Cubit<VideoState> {
  VideoBloc({required this.postRepository}) : super(VideoState.inital()) {
    loadInitialVideos(1);
  }

  final PostRepository postRepository;
  final _preloadQueue = Queue<String>();
  final _preloadedFiles = <String, File>{};
  bool _isPreloadingMore = false;
  int pageNumber = 1;

  Future<void> loadInitialVideos(int index) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    final result = await postRepository.getClapmiVideos(index: index);
    result.fold(
        (error) => emit(state.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: error.description,
            )), (videos) {
      final hasMoreVideos = videos.$2.length == 3;
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        videos: videos.$1,
        hasMoreVideos: hasMoreVideos,
        currentIndex: 0,
        errorMessage: '',
      ));
      pageNumber = pageNumber + 1;
      //Start preloading next videos after initial load
      if (videos.$1.isNotEmpty) {
        preloadNextVideos();
      }
    });
  }

  Future<void> loadMoreVideos(int index) async {
    //IF it is paginating or when there is no more videos again,
    // it should not load more videos
    if (state.isPaginating || !state.hasMoreVideos) return;

    final result = await postRepository.getClapmiVideos(index: index);
    result.fold((error) {
      emit(state.copyWith(
        isPaginating: false,
        errorMessage: error.description,
      ));
    }, (moreVideos) {
      final hasMoreVideos = moreVideos.$2.length == 2;
      final updatedVideos = [...state.videos, ...moreVideos.$1];

      emit(state.copyWith(
        videos: updatedVideos,
        isPaginating: false,
        hasMoreVideos: hasMoreVideos,
        errorMessage: '',
      ));
      //preload new videos after loading more
      preloadNextVideos();
    });
  }

  Future<void> onPageChanged(int newIndex) async {
    emit(state.copyWith(currentIndex: newIndex));

    //Start preloading next videos
    await preloadNextVideos();

    //Smart pagination trigger
    if (!_isPreloadingMore &&
        state.hasMoreVideos &&
        newIndex >= state.videos.length - 2) {
      _isPreloadingMore = true;
      await loadMoreVideos(pageNumber);
      _isPreloadingMore = false;
    }
  }
 
 //THIS IS WHEN JUST THREE VIDEOS ARE LOADED TO PLAY IN THE 
 //CONTROLLER
  Future<void> preloadNextVideos() async {
    if (state.videos.isEmpty) return;
    final currentIndex = state.currentIndex;
    final videosToPreload = state.videos
        .skip(currentIndex + 1)
        .take(2)
        .map((v) => v.video)
        .where((url) => !_preloadedFiles.containsKey(url))
        .toList();

    for (final videoUrl in videosToPreload) {
      if (!_preloadQueue.contains(videoUrl)) {
        _preloadQueue.add(videoUrl ?? '');
        await _preloadVideo(videoUrl ?? '');
      }
    }
  }

  Future<void> _preloadVideo(String videoUrl) async {
    try {
      final file = await getCachedVideoFile(videoUrl);
      _preloadedFiles[videoUrl] = file;

      final currentPreloaded = Set<String>.from(state.preloadedVideoUrls)
        ..add(videoUrl);
      emit(state.copyWith(preloadedVideoUrls: currentPreloaded));
    } catch (e) {
      debugPrint('Error preloading video: $e');
    } finally {
      _preloadQueue.remove(videoUrl);
    }
  }

  Future<File> getCachedVideoFile(String videoUrl) async {
    if (_preloadedFiles.containsKey(videoUrl)) {
      return _preloadedFiles[videoUrl]!;
    }
    final cacheManager = DefaultCacheManager();
    final fileInfo = await cacheManager.getFileFromCache(videoUrl);
    final file = fileInfo?.file ?? await cacheManager.getSingleFile(videoUrl);
    _preloadedFiles[videoUrl] = file;
    return file;
  }

  @override
  Future<void> close() {
    _preloadQueue.clear();
    _preloadedFiles.clear();
    return super.close();
  }
}
