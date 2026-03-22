import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/data/models/edit_post_model.dart';
import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/post/domain/entities/create_video_post_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

final class SelectImageEvent extends PostEvent {
  final ImageSource imageSource;

  const SelectImageEvent({
    required this.imageSource,
  });

  @override
  List<Object> get props => [imageSource];
}

final class SelectVideoEvent extends PostEvent {
  final ImageSource imageSource;

  const SelectVideoEvent({
    required this.imageSource,
  });

  @override
  List<Object> get props => [imageSource];
}

// SelectVideo
final class CreatePostEvent extends PostEvent {
  final CreatePostModel postModel;

  const CreatePostEvent({
    required this.postModel,
  });

  @override
  List<Object> get props => [postModel];
}

final class ChallengePostEvent extends PostEvent {
  final String postID;

  const ChallengePostEvent({
    required this.postID,
  });

  @override
  List<Object> get props => [postID];
}

final class CreateComboEvent extends PostEvent {
  final CreateComboModel comboModel;

  const CreateComboEvent({
    required this.comboModel,
  });

  @override
  List<Object> get props => [comboModel];
}

final class EditPostConntentEvent extends PostEvent {
  final EditPostContentModel editPost;
  final List<PostModel> postModelItems;
  final int? postIndex;

  const EditPostConntentEvent({
    required this.editPost,
    this.postModelItems = const [],
    this.postIndex,
  });

  @override
  List<Object> get props => [editPost];
}

class DelPostUserEvent extends PostEvent {
  final String postId;
  final List<PostModel> postModelItems;
  final int? postIndex;

  const DelPostUserEvent({
    required this.postId,
    this.postModelItems = const [],
    this.postIndex,
  });

  @override
  List<Object> get props => [postId];
}

final class SingleCreateComboEvent extends PostEvent {
  final SingleLiveCreateModel singlecomboModel;

  const SingleCreateComboEvent({
    required this.singlecomboModel,
  });

  @override
  List<Object> get props => [singlecomboModel];
}

final class GetAvatarEvent extends PostEvent {
  const GetAvatarEvent();

  @override
  List<Object> get props => [];
}

final class CommentOnAPostEvent extends PostEvent {
  final String comment;
  final String postID;

  const CommentOnAPostEvent(this.comment, this.postID);

  @override
  List<Object> get props => [];
}

final class GetAllPostsEvent extends PostEvent {
  const GetAllPostsEvent({required this.isRefresh});
  final bool isRefresh;

  @override
  List<Object> get props => [];
}

class GetAllVideoPostsEvent extends PostEvent {
  final bool isRefresh;
  final int index;

  const GetAllVideoPostsEvent({required this.isRefresh, this.index = 0});
  @override
  List<Object> get props => [];
}

// GetAllVideoPosts

final class ClapPostEvent extends PostEvent {
  final String postID;

  const ClapPostEvent({required this.postID});

  @override
  List<Object> get props => [postID];
}

final class NotInterestedPostEvent extends PostEvent {
  final String postID;
  const NotInterestedPostEvent({required this.postID, required postId});

  @override
  List<Object> get props => [postID];
}

final class GetSinglePostEvent extends PostEvent {
  final String postID;
  const GetSinglePostEvent({required this.postID});

  @override
  List<Object> get props => [postID];
}

// UnclapPostEvent
final class UnclapPostEvent extends PostEvent {
  final String postID;

  const UnclapPostEvent({required this.postID});

  @override
  List<Object> get props => [postID];
}

// Event for saving a post
class SavePostEvent extends PostEvent {
  final String postID;

  const SavePostEvent({required this.postID});

  @override
  List<Object> get props => [postID];
}

// Event for sharing a post
class SharePostEvent extends PostEvent {
  final String postID;

  const SharePostEvent({required this.postID});

  @override
  List<Object> get props => [postID];
}

// CommentOnAPost
// GetCategories
final class GetCategoriesEvent extends PostEvent {
  const GetCategoriesEvent();

  @override
  List<Object> get props => [];
}

// CreateVideoPost
final class CreateVideoPostEvent extends PostEvent {
  final CreateVideoPostEntity createVideoPostEntity;
  const CreateVideoPostEvent(this.createVideoPostEntity);

  @override
  List<Object> get props => [createVideoPostEntity];
}

// GetUserPosts
final class GetUserPostsEvent extends PostEvent {
  final String uid;
  const GetUserPostsEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

// GetUserPosts

// GetFollowersPost
final class GetFollowersPostEvent extends PostEvent {
  const GetFollowersPostEvent();

  @override
  List<Object> get props => [];
}

final class GetLinkForVideoEvent extends PostEvent {
  const GetLinkForVideoEvent(this.cred);

  final Map<String, dynamic> cred;
}

class GetCurrentTabIndexEvent extends PostEvent {
  const GetCurrentTabIndexEvent({required this.index});
  final int index;

  @override
  List<Object> get props => [index];
}

class CheckIfNeedMoreDataEvent extends PostEvent {
  // final int index;
  final bool isVideoPost;
  const CheckIfNeedMoreDataEvent({required this.isVideoPost});

  @override
  List<Object> get props => [];
}

class GetClapmiVideosEvent extends PostEvent {
  const GetClapmiVideosEvent();
}
