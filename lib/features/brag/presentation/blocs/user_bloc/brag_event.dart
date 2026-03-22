import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class BragEvent extends Equatable {
  const BragEvent();

  @override
  List<Object> get props => [];
}

class SelectVideoEvent extends BragEvent {
  final ImageSource imageSource;

  const SelectVideoEvent({
    required this.imageSource,
  });

  @override
  List<Object> get props => [imageSource];
}

class CreateBragEvent extends BragEvent {
  final CreatePostModel postModel;

  const CreateBragEvent({
    required this.postModel,
  });

  @override
  List<Object> get props => [postModel];
}

class ChallengePostEvent extends BragEvent {
  final String postID;

  const ChallengePostEvent({
    required this.postID,
  });

  @override
  List<Object> get props => [postID];
}

class SingleLiveStreamChallengeEvent extends BragEvent {
  final String bragID;

  const SingleLiveStreamChallengeEvent({
    required this.bragID,
  });

  @override
  List<Object> get props => [bragID];
}

class CreateComboEvent extends BragEvent {
  final CreateComboModel comboModel;
  final bool isSingleLiveStream;

  const CreateComboEvent({
    required this.comboModel,
    required this.isSingleLiveStream,
  });

  @override
  List<Object> get props => [comboModel];
}

class GetAvatarEvent extends BragEvent {
  const GetAvatarEvent();

  @override
  List<Object> get props => [];
}

class CommentOnAPostEvent extends BragEvent {
  final String comment;
  final String postID;

  const CommentOnAPostEvent(this.comment, this.postID);

  @override
  List<Object> get props => [];
}

// bargchallengersevent

class BragChallengersEvent extends BragEvent {
  final String postId;
  final String contextType;
  final String list;
  final String status;
  const BragChallengersEvent(
      {required this.postId,
      required this.contextType,
      required this.list,
      required this.status});
  @override
  List<Object> get props => [];
}

//SingleChallengerLive
class SingleBragChallengersEvent extends BragEvent {
  final String contextType;
  final String list;
  final String status;
  final String brags;

  const SingleBragChallengersEvent(
      {required this.contextType,
      required this.list,
      required this.status,
      required this.brags});
  @override
  List<Object> get props => [];
}

class GetSingleBragEvent extends BragEvent {
  final String postId;
  const GetSingleBragEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

class AcceptChallengeEvent extends BragEvent {
  final String challengeId;
  const AcceptChallengeEvent(this.challengeId);

  @override
  List<Object> get props => [challengeId];
}

class DeclineChallengeEvent extends BragEvent {
  final String challengeId;
  const DeclineChallengeEvent(this.challengeId);
  @override
  List<Object> get props => [challengeId];
}

class SingleLiveAcceptChallengeEvent extends BragEvent {
  final String challenge;
  const SingleLiveAcceptChallengeEvent(this.challenge);

  @override
  List<Object> get props => [challenge];
}

class SingleLiveDeclineChallengeEvent extends BragEvent {
  final String challenge;
  const SingleLiveDeclineChallengeEvent(this.challenge);
  @override
  List<Object> get props => [challenge];
}

class BoostChallengePoint extends BragEvent {
  final String challengeId;
  final int boostPoint;
  const BoostChallengePoint(
      {required this.challengeId, required this.boostPoint});

  @override
  List<Object> get props => [challengeId, boostPoint];
}

