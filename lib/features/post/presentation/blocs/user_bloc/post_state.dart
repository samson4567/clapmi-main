import 'dart:io';
import 'package:clapmi/features/post/data/models/avatar_model.dart';
import 'package:clapmi/features/post/data/models/create_video_post_model.dart';
import 'package:clapmi/features/post/data/models/post_model.dart'; // Import PostModel
import 'package:clapmi/features/post/domain/entities/category_entity.dart';
import 'package:clapmi/features/post/domain/entities/video_url.dart';
import 'package:equatable/equatable.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => []; // Allow nullable objects in props
}

class PostInitial extends PostState {
  const PostInitial();
}

// user update States
class CreatePostLoadingState extends PostState {
  const CreatePostLoadingState();

  @override
  List<Object> get props => [];
}

class CreatePostSuccessState extends PostState {
  final String message;

  const CreatePostSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

// States for Saving a Post
class SavePostLoadingState extends PostState {
  const SavePostLoadingState();

  @override
  List<Object> get props => [];
}

class SavePostSuccessState extends PostState {
  final String message;

  const SavePostSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class SavePostErrorState extends PostState {
  final String errorMessage;

  const SavePostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// States for Sharing a Post
class SharePostLoadingState extends PostState {
  const SharePostLoadingState();

  @override
  List<Object> get props => [];
}

class SharePostSuccessState extends PostState {
  final String message;

  const SharePostSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class SharePostErrorState extends PostState {
  final String errorMessage;

  const SharePostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class CreatePostErrorState extends PostState {
  final String errorMessage;

  const CreatePostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// select Post image
class SelectPostImageLoadingState extends PostState {
  const SelectPostImageLoadingState();
}

class SelectPostImageSuccessState extends PostState {
  final List<File> imageFiles;

  const SelectPostImageSuccessState({required this.imageFiles});

  @override
  List<Object?> get props => [imageFiles]; // Updated props
}

class SelectPostImageErrorState extends PostState {
  final String errorMessage;

  const SelectPostImageErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// selectPostVideo
class SelectPostVideoLoadingState extends PostState {
  const SelectPostVideoLoadingState();
}

class SelectPostVideoSuccessState extends PostState {
  final File? imageFiles;

  const SelectPostVideoSuccessState({required this.imageFiles});

  @override
  List<Object?> get props => [imageFiles]; // Updated props
}

class SelectPostVideoErrorState extends PostState {
  final String errorMessage;

  const SelectPostVideoErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// ChallengePost
class ChallengePostLoadingState extends PostState {
  const ChallengePostLoadingState();
}

class ChallengePostSuccessState extends PostState {
  final String? message;

  const ChallengePostSuccessState({required this.message});

  @override
  List<Object?> get props => [message]; // Updated props
}

class ChallengePostErrorState extends PostState {
  final String errorMessage;

  const ChallengePostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// CreateCombo
class CreateComboLoadingState extends PostState {
  const CreateComboLoadingState();
}

class CreateComboSuccessState extends PostState {
  final String? message;

  const CreateComboSuccessState({required this.message});

  @override
  List<Object?> get props => [message]; // Updated props
}

class CreateComboErrorState extends PostState {
  final String errorMessage;

  const CreateComboErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// CreateCombo
class EditPostContentLoadingState extends PostState {
  const EditPostContentLoadingState();
}

class EditPostContentSuccessState extends PostState {
  final String? message;
  final List<PostModel> postmodelItems;

  const EditPostContentSuccessState(
      {required this.message, required this.postmodelItems});

  @override
  List<Object?> get props => [message, postmodelItems]; // Updated props
}

class EditPostContentErrorState extends PostState {
  final String errorMessage;

  const EditPostContentErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
//deletePost

final class DelPostUserLoadingState extends PostState {
  const DelPostUserLoadingState();
}

final class DelPostUserSuccessState extends PostState {
  final String message;
  final List<PostModel> postmodelItems;

  const DelPostUserSuccessState({
    required this.message,
    required this.postmodelItems,
  });

  @override
  List<Object> get props => [message, postmodelItems];
}

final class DelPostUserErrorState extends PostState {
  final String errorMessage;

  const DelPostUserErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//singleCreateCombo

class SingleCreateComboLoadingState extends PostState {
  const SingleCreateComboLoadingState();
}

class SingleCreateComboSuccessState extends PostState {
  final String? message;

  const SingleCreateComboSuccessState({required this.message});

  @override
  List<Object?> get props => [message]; // Updated props
}

class SingleCreateComboErrorState extends PostState {
  final String errorMessage;

  const SingleCreateComboErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetAvatar
class GetAvatarLoadingState extends PostState {
  const GetAvatarLoadingState();
}

class GetAvatarSuccessState extends PostState {
  final List<AvatarModel> listOfAvatarModel;

  const GetAvatarSuccessState({required this.listOfAvatarModel});

  @override
  List<Object> get props => [listOfAvatarModel];
}

class GetAvatarErrorState extends PostState {
  final String errorMessage;

  const GetAvatarErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// CommentOnAPost
class CommentOnAPostLoadingState extends PostState {
  const CommentOnAPostLoadingState();
}

class CommentOnAPostSuccessState extends PostState {
  final String message;

  const CommentOnAPostSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class CommentOnAPostErrorState extends PostState {
  final String errorMessage;

  const CommentOnAPostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetAllPosts
class GetAllPostsLoadingState extends PostState {
  const GetAllPostsLoadingState();
}

class GetAllPostsSuccessState extends PostState {
  final List<PostModel> posts;
  final bool isRefresh;

  const GetAllPostsSuccessState({required this.posts, required this.isRefresh});

  @override
  List<Object> get props => [posts];
}

class GetAllPostsErrorState extends PostState {
  final String errorMessage;

  const GetAllPostsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetAllVideoPosts
class GetAllVideoPostsLoadingState extends PostState {
  const GetAllVideoPostsLoadingState();
}

class GetAllVideoPostsSuccessState extends PostState {
  final List<PostModel> posts;
  final bool isRefresh;

  const GetAllVideoPostsSuccessState(
      {required this.posts, required this.isRefresh});

  @override
  List<Object> get props => [posts];
}

class GetAllVideoPostsErrorState extends PostState {
  final String errorMessage;

  const GetAllVideoPostsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ClapPostErrorState extends PostState {
  final String errorMessage;

  const ClapPostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ClapPostLoadingState extends PostState {
  const ClapPostLoadingState();
}

class ClapPostSuccessState extends PostState {
  final String message;
  const ClapPostSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class NotInterestedPostSuccessState extends PostState {
  final String message;
  const NotInterestedPostSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class NotInterestedPostErrorState extends PostState {
  final String errorMessage;

  const NotInterestedPostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetAllPosts
class NotInterestedPostLoadingState extends PostState {
  const NotInterestedPostLoadingState();
}

class GetSinglePostErrorState extends PostState {
  final String errorMessage;

  const GetSinglePostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetAllPosts
class GetSinglePostLoadingState extends PostState {
  const GetSinglePostLoadingState();
}

class GetSinglePostSuccessState extends PostState {
  final PostModel post;
  const GetSinglePostSuccessState({required this.post});

  @override
  List<Object> get props => [post];
}

// UnclapPost States
class UnclapPostLoadingState extends PostState {
  const UnclapPostLoadingState();
}

class UnclapPostSuccessState extends PostState {
  final String message;
  const UnclapPostSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class UnclapPostErrorState extends PostState {
  final String errorMessage;

  const UnclapPostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetCategories States
class GetCategoriesLoadingState extends PostState {
  const GetCategoriesLoadingState();
}

class GetCategoriesSuccessState extends PostState {
  final List<CategoryEntity> listOfCategoryEntity;
  const GetCategoriesSuccessState({required this.listOfCategoryEntity});

  @override
  List<Object> get props => [listOfCategoryEntity];
}

class GetCategoriesErrorState extends PostState {
  final String errorMessage;

  const GetCategoriesErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// CreateVideoPost States
class CreateVideoPostLoadingState extends PostState {
  const CreateVideoPostLoadingState();
}

class CreateVideoPostSuccessState extends PostState {
  final String message;
  const CreateVideoPostSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class CreateVideoPostErrorState extends PostState {
  final String errorMessage;

  const CreateVideoPostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// select Post image
class SelectVideoImageLoadingState extends PostState {
  const SelectVideoImageLoadingState();
}

class SelectVideoImageSuccessState extends PostState {
  final File? imageFile;

  const SelectVideoImageSuccessState({required this.imageFile});

  @override
  List<Object?> get props => [imageFile]; // Updated props
}

class SelectVideoImageErrorState extends PostState {
  final String errorMessage;

  const SelectVideoImageErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// AcceptChallenge States
class AcceptChallengeLoadingState extends PostState {
  const AcceptChallengeLoadingState();
}

class AcceptChallengeSuccessState extends PostState {
  final String message;
  const AcceptChallengeSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class AcceptChallengeErrorState extends PostState {
  final String errorMessage;

  const AcceptChallengeErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetFollowersPost States
class GetFollowersPostLoadingState extends PostState {
  const GetFollowersPostLoadingState();
}

class GetFollowersPostSuccessState extends PostState {
  // final String message;
  final List<PostModel> posts;
  const GetFollowersPostSuccessState({required this.posts});

  @override
  List<Object> get props => [posts];
}

class GetFollowersPostErrorState extends PostState {
  final String errorMessage;

  const GetFollowersPostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GetUserPostsLoadingState extends PostState {
  const GetUserPostsLoadingState();
}

class GetUserPostsSuccessState extends PostState {
  final List<PostModel> posts;
  const GetUserPostsSuccessState({required this.posts});

  @override
  List<Object> get props => [posts];
}

class GetUserPostsErrorState extends PostState {
  final String errorMessage;

  const GetUserPostsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class VideoUrlLink extends PostState {
  final VideoUrlEntity videoData;
  const VideoUrlLink({required this.videoData});

  @override
  List<Object?> get props => [videoData];
}

class CurrentTabIndexState extends PostState {
  final int index;
  const CurrentTabIndexState({required this.index});

  @override
  List<Object?> get props => [index];
}

class VideosLoaded extends PostState {
  final (List<VideoPostModel>, List<String>) videoData;
  const VideosLoaded({required this.videoData});
}
