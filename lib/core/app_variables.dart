import 'dart:async';

import 'package:clapmi/features/app/data/models/user_model.dart';
import 'package:clapmi/features/notification/domain/entities/notification_entity.dart';
import 'package:clapmi/features/onboarding/domain/entities/interest_category_entity.dart';
import 'package:clapmi/features/post/data/models/avatar_model.dart';
import 'package:clapmi/features/post/domain/entities/category_entity.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

List<AvatarModel> listOfAvatarModelG = [];
// I/flutter ( 7398): FCM Token: dXe6KXWfRc-xNKr3krw7kR:APA91bFoOxlxSFWtMndsf5xswQP7ZHg7FTzZKWS59eBRGS84JgovvPUapSBDU2YjjmwYkYr4ItJsPnYXqC9UTDNajqtiZo4tLAwkfpOTSmF3fhRaq0C77vk

List<CategoryEntity> listOfCategoryModelG = [];

List<InterestCategoryEntity> listOFInterestCategoryModelG = [];

UserModel? userModelG;

late AnimationController theclapAnimationController;
bool isthereInternetG = false;

List<NotificationEntity>? listOfNotificationEntityG = [];
NotificationEntity? lastNotificationEntity;
int notificationCountG = 0;

ProfileModel? profileModelG;

String? socketId;
String? globalAccessToken;

VideoPlayerController? videoPlayerControllerG;

List<String> globalVideoUrls = [];

StreamController<double> progressUpdate = StreamController<double>();
VideoPlayerController? currentlyDisplayedVideoPlayerController;
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

// ============ MEMORY LEAK FIXES ============
// Helper method to close the global StreamController
// Call this when the app is terminating or when clearing resources
void disposeGlobalStreamController() {
  if (!progressUpdate.isClosed) {
    progressUpdate.close();
    // Create a new one for future use
    progressUpdate = StreamController<double>();
  }
}

// Helper method to dispose the global VideoPlayerController
// Call this before reassigning videoPlayerControllerG
void disposeGlobalVideoPlayerController() {
  videoPlayerControllerG?.dispose();
  videoPlayerControllerG = null;
}

// Helper method to dispose currently displayed video controller
void disposeCurrentlyDisplayedVideoController() {
  currentlyDisplayedVideoPlayerController?.dispose();
  currentlyDisplayedVideoPlayerController = null;
}

// Helper method to clear all global lists to free memory
void clearGlobalLists() {
  listOfAvatarModelG.clear();
  listOfCategoryModelG.clear();
  listOFInterestCategoryModelG.clear();
  globalVideoUrls.clear();
  if (listOfNotificationEntityG != null) {
    listOfNotificationEntityG!.clear();
  }
}

// Combined cleanup method for all global resources
void disposeAllGlobalResources() {
  disposeGlobalStreamController();
  disposeGlobalVideoPlayerController();
  disposeCurrentlyDisplayedVideoController();
  clearGlobalLists();
}
// ============ END MEMORY LEAK FIXES ============

// List<Notification>
