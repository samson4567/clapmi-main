import 'dart:io';

import 'package:clapmi/features/brag/data/models/brag_challengers.dart';
import 'package:clapmi/features/brag/data/models/post_model.dart';
import 'package:clapmi/features/post/data/models/avatar_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:equatable/equatable.dart';

sealed class BragState extends Equatable {
  const BragState();

  @override
  List<Object> get props => [];
}

class BragInitial extends BragState {
  const BragInitial();
}

// user update States
class CreatePostLoadingState extends BragState {
  const CreatePostLoadingState();
}

class CreatePostSuccessState extends BragState {
  final CreatePostModel postModel;

  const CreatePostSuccessState({required this.postModel});

  @override
  List<Object> get props => [postModel];
}

class CreatePostErrorState extends BragState {
  final String errorMessage;

  const CreatePostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// select Post image
class SelectPostImageLoadingState extends BragState {
  const SelectPostImageLoadingState();
}

class SelectPostImageSuccessState extends BragState {
  final File? imageFile;

  const SelectPostImageSuccessState({required this.imageFile});

  @override
  List<Object> get props => [];
}

class SelectPostImageErrorState extends BragState {
  final String errorMessage;

  const SelectPostImageErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// ChallengePost
class ChallengePostLoadingState extends BragState {
  const ChallengePostLoadingState();
}

class ChallengePostSuccessState extends BragState {
  final String? challengeId;

  const ChallengePostSuccessState({required this.challengeId});

  @override
  List<Object> get props => [];
}

class ChallengePostErrorState extends BragState {
  final String errorMessage;

  const ChallengePostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// SingleChallengeStream
class SingleLiveStreamChallengeLoadingState extends BragState {
  const SingleLiveStreamChallengeLoadingState();
}

class SingleLiveStreamChallengeSuccessState extends BragState {
  final String? challengeId;

  const SingleLiveStreamChallengeSuccessState({required this.challengeId});

  @override
  List<Object> get props => [];
}

class SingleLiveStreamChallengeErrorState extends BragState {
  final String errorMessage;

  const SingleLiveStreamChallengeErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// CreateCombo
class CreateComboLoadingState extends BragState {
  const CreateComboLoadingState();
}

class CreateComboSuccessState extends BragState {
  final String? message;

  const CreateComboSuccessState({required this.message});

  @override
  List<Object> get props => [];
}

class CreateComboErrorState extends BragState {
  final Map<String, dynamic> errorMessage;

  const CreateComboErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetAvatar
class GetAvatarLoadingState extends BragState {
  const GetAvatarLoadingState();
}

class GetAvatarSuccessState extends BragState {
  final List<AvatarModel> listOfAvatarModel;

  const GetAvatarSuccessState({required this.listOfAvatarModel});

  @override
  List<Object> get props => [];
}

class GetAvatarErrorState extends BragState {
  final String errorMessage;

  const GetAvatarErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// CommentOnAPost
class CommentOnAPostLoadingState extends BragState {
  const CommentOnAPostLoadingState();
}

class CommentOnAPostSuccessState extends BragState {
  final String message;

  const CommentOnAPostSuccessState({required this.message});

  @override
  List<Object> get props => [];
}

class CommentOnAPostErrorState extends BragState {
  final String errorMessage;

  const CommentOnAPostErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// BragChallengers
class BragChallengersLoadingState extends BragState {
  const BragChallengersLoadingState();
}

class BragChallengersSuccessState extends BragState {
  final List<BragChallengersModel> challengers;
  const BragChallengersSuccessState(this.challengers);
  @override
  List<Object> get props => [challengers];
}

class BragChallengersErrorState extends BragState {
  final String errorMessage;

  const BragChallengersErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//SingleLiveStreamChallenger
class SingleBragChallengersLoadingState extends BragState {
  const SingleBragChallengersLoadingState();
}

class SingleBragChallengersSuccessState extends BragState {
  final List<SingleLiveStreamBragChallengerModel> challengers;

  const SingleBragChallengersSuccessState(this.challengers);

  @override
  List<Object> get props => [challengers];
}

class SingleBragChallengersErrorState extends BragState {
  final String errorMessage;

  const SingleBragChallengersErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//SinglebragState
class SingleBragState extends BragState {
  final SingleVideoPostModel post;
  const SingleBragState({required this.post});

  @override
  List<Object> get props => [post];
}

//AcceptChallenge States
class AcceptChallengeLoadingState extends BragState {
  const AcceptChallengeLoadingState();
}

class AcceptChallengeSuccessState extends BragState {
  final String message;
  const AcceptChallengeSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class AcceptChallengeErrorState extends BragState {
  final String errorMessage;

  const AcceptChallengeErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ChallengeDeclinedLoading extends BragState {
  const ChallengeDeclinedLoading();
}

class ChallengeDeclined extends BragState {
  final String message;
  const ChallengeDeclined({required this.message});

  @override
  List<Object> get props => [message];
}

//SingleLiveAcceptChallenge States and decline
class SingleLiveAcceptChallengeLoadingState extends BragState {
  const SingleLiveAcceptChallengeLoadingState();
}

class SingleLiveAcceptChallengeSuccessState extends BragState {
  final String message;
  const SingleLiveAcceptChallengeSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class SingleLiveAcceptChallengeErrorState extends BragState {
  final String errorMessage;

  const SingleLiveAcceptChallengeErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//decline
class SingleLiveChallengeDeclinedLoading extends BragState {
  const SingleLiveChallengeDeclinedLoading();
}

class SingeLiveChallengeDeclined extends BragState {
  final String message;
  const SingeLiveChallengeDeclined({required this.message});

  @override
  List<Object> get props => [message];
}

class BoostPointLoading extends BragState {
  const BoostPointLoading();
}

class BoostPointLoaded extends BragState {
  final String responseMessage;
  const BoostPointLoaded({required this.responseMessage});
}
