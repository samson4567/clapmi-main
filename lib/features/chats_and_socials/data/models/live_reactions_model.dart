// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:convert';

import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';

class PostClappReactionModel extends PostClappedReaction {
  const PostClappReactionModel({super.claps, super.post});

  factory PostClappReactionModel.fromMap(Map<String, dynamic> map) {
    return PostClappReactionModel(
      post: map['post'] != null ? map['post'] as String : null,
      claps: map['claps'] != null ? map['claps'] as String : null,
    );
  }
  factory PostClappReactionModel.fromJson(String source) =>
      PostClappReactionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class PostSharedReactionModel extends PostSharedReaction {
  const PostSharedReactionModel({super.post, super.shares});

  factory PostSharedReactionModel.fromMap(Map<String, dynamic> map) {
    return PostSharedReactionModel(
      post: map['post'] != null ? map['post'] as String : null,
      shares: map['shares'] != null ? map['shares'] as String : null,
    );
  }

  factory PostSharedReactionModel.fromJson(String source) =>
      PostSharedReactionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class CommentLiveReactionDataModel extends CommentLiveReactionData {
  const CommentLiveReactionDataModel(
      {super.claps, super.comments, super.shares});
  factory CommentLiveReactionDataModel.fromMap(Map<String, dynamic> map) {
    return CommentLiveReactionDataModel(
      claps: map['claps'] != null ? map['claps'] as int : null,
      shares: map['shares'] != null ? map['shares'] as int : null,
      comments: map['comments'] != null ? map['comments'] as int : null,
    );
  }

  factory CommentLiveReactionDataModel.fromJson(String source) =>
      CommentLiveReactionDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class CommentLiveReactionsModel extends CommentLiveReactions {
  const CommentLiveReactionsModel(
      {super.comment,
      super.created_at,
      super.creator_avatar,
      super.creator_name,
      super.metadata,
      super.uuid});

  factory CommentLiveReactionsModel.fromMap(Map<String, dynamic> map) {
    return CommentLiveReactionsModel(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      metadata: map['metadata'] != null
          ? CommentLiveReactionDataModel.fromMap(
              map['metadata'] as Map<String, dynamic>)
          : null,
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
      creator_name:
          map['creator_name'] != null ? map['creator_name'] as String : null,
      creator_avatar: map['creator_avatar'] != null
          ? map['creator_avatar'] as String
          : null,
    );
  }

  factory CommentLiveReactionsModel.fromJson(String source) =>
      CommentLiveReactionsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class PostCommentLiveReactionModel extends PostCommentLiveReaction {
  const PostCommentLiveReactionModel(
      {super.comment, super.comments, super.post});
  factory PostCommentLiveReactionModel.fromMap(Map<String, dynamic> map) {
    return PostCommentLiveReactionModel(
      post: map['post'] != null ? map['post'] as String : null,
      comments: map['comments'] != null ? map['comments'] as String : null,
      comment: map['comment'] != null
          ? CommentLiveReactionsModel.fromMap(
              map['comment'] as Map<String, dynamic>)
          : null,
    );
  }

  factory PostCommentLiveReactionModel.fromJson(String source) =>
      PostCommentLiveReactionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class LiveReactionUserModel extends LiveReactionUser {
  LiveReactionUserModel(
      {super.avatar, super.message, super.user, super.username});

  factory LiveReactionUserModel.fromMap(Map<String, dynamic> map) {
    return LiveReactionUserModel(
      message: map['message'] != null ? map['message'] as String : null,
      user: map['user'] != null ? map['user'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
    );
  }

  factory LiveReactionUserModel.fromJson(String source) =>
      LiveReactionUserModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class LiveGroundCommentModel extends LiveGroundComment {
  const LiveGroundCommentModel({super.message, super.user});

  factory LiveGroundCommentModel.fromMap(Map<String, dynamic> map) {
    return LiveGroundCommentModel(
      message: map['message'] != null ? map['message'] as String : null,
      user: map['user'] != null
          ? LiveReactionUserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  factory LiveGroundCommentModel.fromJson(String source) =>
      LiveGroundCommentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class FansDataModel extends FansData {
  const FansDataModel(
      {super.user,
      super.amount_contributed,
      super.minutes_into_combo,
      super.reward});

  factory FansDataModel.fromMap(Map<String, dynamic> map) {
    return FansDataModel(
      user: map['user'] != null ? map['user'] as String : null,
      amount_contributed: map['amount_contributed'] != null
          ? map['amount_contributed'] as num
          : null,
      minutes_into_combo: map['minutes_into_combo'] != null
          ? map['minutes_into_combo'] as num
          : null,
      reward: map['reward'] != null ? map['reward'] as num : null,
    );
  }

  factory FansDataModel.fromJson(String source) =>
      FansDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class WinnerDataModel extends WinnerData {
  const WinnerDataModel(
      {super.amount,
      super.fans,
      super.loser,
      super.result,
      super.stake,
      super.streamers,
      super.winner});

  factory WinnerDataModel.fromMap(Map<String, dynamic> map) {
    return WinnerDataModel(
      winner: map['winner'] != null ? map['winner'] as String : null,
      loser: map['loser'] != null ? map['loser'] as String : null,
      amount: map['amount'] != null ? map['amount'] as num : null,
      fans: map['fans'] != null
          ? List<FansDataModel>.from(
              (map['fans'] as List<dynamic>).map<FansData?>(
                (x) => FansDataModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      stake: map['stake'] != null ? map['stake'] as num : null,
      streamers: map['streamers'] != null
          ? List<dynamic>.from((map['streamers'] as List<dynamic>))
          : null,
      result: map['result'] != null ? map['result'] as String : null,
    );
  }

  factory WinnerDataModel.fromJson(String source) =>
      WinnerDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LiveUserInteractionDataModel extends LiveUserInteractionData {
  const LiveUserInteractionDataModel({super.image, super.pid, super.username});

  factory LiveUserInteractionDataModel.fromMap(Map<String, dynamic> map) {
    return LiveUserInteractionDataModel(
      pid: map['pid'] != null ? map['pid'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  factory LiveUserInteractionDataModel.fromJson(String source) =>
      LiveUserInteractionDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class LiveUserInteractionModel extends LiveUserInteraction {
  const LiveUserInteractionModel(
      {super.channel, super.message, super.user, super.wins});

  factory LiveUserInteractionModel.fromMap(Map<String, dynamic> map) {
    return LiveUserInteractionModel(
      message: map['message'] != null ? map['message'] as String : null,
      user: map['user'] != null
          ? LiveUserInteractionDataModel.fromMap(
              map['user'] as Map<String, dynamic>)
          : null,
      wins: map['wins'] != null
          ? WinnerDataModel.fromMap(map['wins'] as Map<String, dynamic>)
          : null,
      channel: map['channel'] != null ? map['channel'] as String : null,
    );
  }

  factory LiveUserInteractionModel.fromJson(String source) =>
      LiveUserInteractionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class GiftSenderModel extends GiftSender {
  GiftSenderModel({super.avatar, super.user, super.username});

  factory GiftSenderModel.fromMap(Map<String, dynamic> map) {
    return GiftSenderModel(
      user: map['user'] != null ? map['user'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
    );
  }

  factory GiftSenderModel.fromJson(String source) =>
      GiftSenderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class GiftDataUserModel extends GiftDataUser {
  const GiftDataUserModel(
      {super.sender, super.receiver, super.amount, super.target});

  factory GiftDataUserModel.fromMap(Map<String, dynamic> map) {
    String? amountTemp;
    if (map['amount'] is String) {
      amountTemp = map['amount'];
    } else {
      amountTemp = map['amount'].toString();
    }
    return GiftDataUserModel(
      sender: map['sender'] != null
          ? GiftSenderModel.fromMap(map['sender'] as Map<String, dynamic>)
          : null,
      receiver: map['receiver'] != null ? map['receiver'] as String : null,
      amount: amountTemp,
      //map['amount'] != null ? map['amount'] as String : null,
      target: map['target'] != null ? map['target'] as String : null,
    );
  }

  factory GiftDataUserModel.fromJson(String source) =>
      GiftDataUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class GiftDataModel extends GiftData {
  const GiftDataModel({super.giftdata, super.message});

  factory GiftDataModel.fromMap(Map<String, dynamic> map) {
    return GiftDataModel(
      message: map['message'] != null ? map['message'] as String : null,
      giftdata: map['gift-data'] != null
          ? GiftDataUserModel.fromMap(map['gift-data'] as Map<String, dynamic>)
          : null,
    );
  }

  factory GiftDataModel.fromJson(String source) =>
      GiftDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LiveGifterModel extends LiveGifter {
  LiveGifterModel({super.email, super.image, super.username, super.pid});

  factory LiveGifterModel.fromMap(Map<String, dynamic> map) {
    return LiveGifterModel(
      pid: map['pid'] != null ? map['pid'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  factory LiveGifterModel.fromJson(String source) =>
      LiveGifterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LiveGiftingDataModel extends LiveGiftingData {
  const LiveGiftingDataModel({super.totalAmount, super.user});

  factory LiveGiftingDataModel.fromMap(Map<String, dynamic> map) {
    return LiveGiftingDataModel(
      user: map['user'] != null
          ? LiveGifterModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      totalAmount:
          map['total_amount'] != null ? map['total_amount'] as num : null,
    );
  }

  factory LiveGiftingDataModel.fromJson(String source) =>
      LiveGiftingDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ComboGroundInfoModel extends ComboGroundInfo {
  const ComboGroundInfoModel(
      {super.boostPoint,
      super.comboGround,
      super.contextType,
      super.duration,
      super.stake,
      super.start,
      super.title,
      super.type});

  factory ComboGroundInfoModel.fromMap(Map<String, dynamic> map) {
    return ComboGroundInfoModel(
      contextType:
          map['context-type'] != null ? map['context-type'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      comboGround:
          map['combo-ground'] != null ? map['combo-ground'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      stake: map['stake'] != null ? map['stake'] as String : null,
      boostPoint:
          map['boost-points'] != null ? map['boost-points'] as int : null,
      start: map['start'] != null ? map['start'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
    );
  }

  factory ComboGroundInfoModel.fromJson(String source) =>
      ComboGroundInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ComboInLiveStreamModel extends ComboInLiveStream {
  const ComboInLiveStreamModel(
      {super.challenger, super.channel, super.comboGround, super.host});

  factory ComboInLiveStreamModel.fromMap(Map<String, dynamic> map) {
    return ComboInLiveStreamModel(
      host: map['host'] != null
          ? LiveGifterModel.fromMap(map['host'] as Map<String, dynamic>)
          : null,
      challenger: map['challenger'] != null
          ? LiveGifterModel.fromMap(map['challenger'] as Map<String, dynamic>)
          : null,
      channel: map['channel'] != null ? map['channel'] as String : null,
      comboGround: map['combo-ground'] != null
          ? ComboGroundInfoModel.fromMap(
              map['combo-ground'] as Map<String, dynamic>)
          : null,
    );
  }

  factory ComboInLiveStreamModel.fromJson(String source) =>
      ComboInLiveStreamModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class LiveBragInfoModel extends LiveBragInfo {
  const LiveBragInfoModel(
      {super.challenge,
      super.duration,
      super.stake,
      super.boostPoints,
      super.comboGround});

  factory LiveBragInfoModel.fromMap(Map<String, dynamic> map) {
    return LiveBragInfoModel(
      challenge: map['challenge'] != null ? map['challenge'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      stake: map['stake'] != null ? map['stake'] as String : null,
      boostPoints:
          map['boost-points'] != null ? map['boost-points'] as String : null,
      comboGround:
          map['combo-ground'] != null ? map['combo-ground'] as String : null,
    );
  }

  factory LiveBragInfoModel.fromJson(String source) =>
      LiveBragInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LiveChallengerModel extends LiveChallenger {
  LiveChallengerModel(
      {super.avatarConvert, super.identifier, super.image, super.username});

  factory LiveChallengerModel.fromMap(Map<String, dynamic> map) {
    return LiveChallengerModel(
      username: map['username'] != null ? map['username'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      identifier:
          map['identifier'] != null ? map['identifier'] as String : null,
    );
  }

  factory LiveChallengerModel.fromJson(String source) =>
      LiveChallengerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LiveBragChallengeModel extends LiveBragChallenge {
  const LiveBragChallengeModel(
      {super.action, super.brag, super.challenger, super.channel});

  factory LiveBragChallengeModel.fromMap(Map<String, dynamic> map) {
    return LiveBragChallengeModel(
      action: map['action'] != null ? map['action'] as String : null,
      challenger: map['challenger'] != null
          ? LiveChallengerModel.fromMap(
              map['challenger'] as Map<String, dynamic>)
          : null,
      brag: map['brag'] != null
          ? LiveBragInfoModel.fromMap(map['brag'] as Map<String, dynamic>)
          : null,
      channel: map['channel'] != null ? map['channel'] as String : null,
    );
  }

  factory LiveBragChallengeModel.fromJson(String source) =>
      LiveBragChallengeModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
