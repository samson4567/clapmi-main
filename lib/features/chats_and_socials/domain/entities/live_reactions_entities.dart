// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, must_be_immutable
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

class PostClappedReaction extends Equatable {
  final String? post;
  final String? claps;

  const PostClappedReaction({
    this.post,
    this.claps,
  });

  @override
  List<Object?> get props => [post, claps];
}

class PostSharedReaction extends Equatable {
  final String? post;
  final String? shares;
  const PostSharedReaction({
    this.post,
    required this.shares,
  });

  @override
  List<Object?> get props => [post, shares];
}

class PostCommentLiveReaction extends Equatable {
  final String? post;
  final String? comments;
  final CommentLiveReactions? comment;

  const PostCommentLiveReaction({
    this.post,
    this.comments,
    this.comment,
  });

  @override
  List<Object?> get props => [post, comments, comment];
}

class CommentLiveReactions extends Equatable {
  final String? uuid;
  final String? comment;
  final CommentLiveReactionData? metadata;
  final String? created_at;
  final String? creator_name;
  final String? creator_avatar;

  const CommentLiveReactions({
    this.uuid,
    this.comment,
    this.metadata,
    this.created_at,
    required this.creator_name,
    this.creator_avatar,
  });

  @override
  List<Object?> get props =>
      [uuid, comment, metadata, created_at, creator_name, creator_avatar];
}

class CommentLiveReactionData extends Equatable {
  final int? claps;
  final int? shares;
  final int? comments;
  const CommentLiveReactionData({
    this.claps,
    this.shares,
    this.comments,
  });

  @override
  List<Object?> get props => [shares, claps, comments];
}

class LiveReactionUser extends Equatable {
  final String? message;
  final String? user;
  final String? username;
  final String? avatar;
  Uint8List? avatarConvert;

  LiveReactionUser({
    this.message,
    this.user,
    this.username,
    this.avatar,
    this.avatarConvert,
  });

  @override
  List<Object?> get props => [message, user, username, avatar, avatarConvert];
}

class LiveGroundComment extends Equatable {
  final String? message;
  final LiveReactionUser? user;
  const LiveGroundComment({
    this.message,
    this.user,
  });

  @override
  List<Object?> get props => [message, user];
}

class LiveUserInteraction extends Equatable {
  final String? message;
  final LiveUserInteractionData? user;
  final WinnerData? wins;
  final String? channel;
  const LiveUserInteraction({
    this.message,
    this.user,
    this.wins,
    this.channel,
  });
  @override
  List<Object?> get props => [message, user, wins, channel];
}

class LiveUserInteractionData extends Equatable {
  final String? pid;
  final String? username;
  final String? image;
  const LiveUserInteractionData({
    this.pid,
    this.username,
    this.image,
  });

  @override
  List<Object?> get props => [pid, username, image];
}

class WinnerData extends Equatable {
  final String? winner;
  final String? loser;
  final num? amount;
  final List<FansData>? fans;
  final num? stake;
  final List<dynamic>? streamers;
  final String? result;
  const WinnerData({
    this.winner,
    this.loser,
    this.amount,
    this.fans,
    this.stake,
    this.streamers,
    this.result,
  });

  @override
  List<Object?> get props =>
      [winner, loser, amount, fans, stake, streamers, result];
}

class FansData extends Equatable {
  final String? user;
  final num? amount_contributed;
  final num? minutes_into_combo;
  final num? reward;
  const FansData({
    this.user,
    this.amount_contributed,
    this.minutes_into_combo,
    this.reward,
  });

  @override
  List<Object?> get props =>
      [user, amount_contributed, minutes_into_combo, reward];
}

class GiftData extends Equatable {
  final String? message;
  final GiftDataUser? giftdata;
  const GiftData({
    this.message,
    this.giftdata,
  });

  @override
  List<Object?> get props => [message, giftdata];
}

class GiftDataUser extends Equatable {
  final GiftSender? sender;
  final String? receiver;
  final String? amount;
  final String? target;

  const GiftDataUser({
    this.sender,
    this.receiver,
    this.amount,
    this.target,
  });

  @override
  List<Object?> get props => [sender, receiver, amount, target];
}

class GiftSender extends Equatable {
  final String? user;
  final String? username;
  final String? avatar;
  Uint8List? avatarConvert;

  GiftSender({
    this.user,
    this.username,
    this.avatar,
    this.avatarConvert,
  });

  @override
  List<Object?> get props => [user, username, avatar, avatarConvert];
}

class LiveGifter extends Equatable {
  final String? pid;
  final String? username;
  final String? image;
  final String? email;
  Uint8List? avatar;

  LiveGifter({
    this.pid,
    this.username,
    this.image,
    this.email,
    this.avatar,
  });

  @override
  List<Object?> get props => [pid, username, image, email, avatar];
}

class LiveGiftingData extends Equatable {
  final LiveGifter? user;
  final num? totalAmount;
  const LiveGiftingData({
    this.user,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [user, totalAmount];
}

class ComboGroundInfo extends Equatable {
  final String? contextType;
  final String? type;
  final String? comboGround;
  final String? title;
  final String? stake;
  final int? boostPoint;
  final String? start;
  final String? duration;

  const ComboGroundInfo({
    this.contextType,
    this.type,
    this.comboGround,
    this.title,
    this.stake,
    this.boostPoint,
    this.start,
    this.duration,
  });

  @override
  List<Object?> get props => [
        contextType,
        type,
        comboGround,
        title,
        stake,
        boostPoint,
        start,
        duration
      ];
}

class ComboInLiveStream extends Equatable {
  final LiveGifter? host;
  final LiveGifter? challenger;
  final String? channel;
  final ComboGroundInfo? comboGround;

  const ComboInLiveStream({
    this.host,
    this.challenger,
    this.channel,
    this.comboGround,
  });

  @override
  List<Object?> get props => [host, challenger];
}

class LiveBragChallenge extends Equatable {
  final String? action;
  final LiveChallenger? challenger;
  final LiveBragInfo? brag;
  final String? channel;

  const LiveBragChallenge(
      {this.action, this.challenger, this.brag, this.channel});

  @override
  List<Object?> get props => [action, challenger, brag, channel];
}

class LiveChallenger extends Equatable {
  final String? username;
  final String? image;
  final String? identifier;
  Uint8List? avatarConvert;

  LiveChallenger(
      {this.username, this.image, this.identifier, this.avatarConvert});

  @override
  List<Object?> get props => [username, image, identifier, avatarConvert];
}

class LiveBragInfo extends Equatable {
  final String? challenge;
  final String? duration;
  final String? stake;
  final String? boostPoints;
  final String? comboGround;

  const LiveBragInfo(
      {this.challenge,
      this.duration,
      this.stake,
      this.boostPoints,
      this.comboGround});

  @override
  List<Object?> get props =>
      [challenge, duration, stake, boostPoints, comboGround];
}
