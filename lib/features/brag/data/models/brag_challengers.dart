// ignore_for_file: must_be_immutable

import 'package:clapmi/features/brag/domain/entities/brag_challengers.dart';

class BragChallengersModel extends BragChallengersEntity {
  const BragChallengersModel({
    required super.stake,
    required super.title,
    required super.combo,
    required super.start,
    required super.duration,
    required super.lifecycleStatus,
    required super.challenge,
    required super.status,
    required super.createdAt,
    required super.challenger,
  });

  factory BragChallengersModel.fromMap(Map<String, dynamic> map) {
    num? stake;
    if (map['stake'] is int?) {
      stake = map['stake'];
    } else if (map['stake'] is String?) {
      stake = num.parse(map['stake']);
    }
    return BragChallengersModel(
      stake: stake ?? 0,
      title: map['title'] as String,
      start: map['start'] as String,
      duration: map['duration'] as String,
      combo: map['combo'] as String,
      lifecycleStatus: map['lifecycle']['status'] as String,
      challenge: map['challenge'] as String,
      status: map['status'] as String,
      challenger:
          BragChallengerM.fromMap(map['challenger'] as Map<String, dynamic>),
      createdAt: map['created_at'] as String,
    );
  }
}

class BragChallengerM extends BragChallenger {
  BragChallengerM({
    required super.username,
    required super.image,
    required super.pid,
    required super.email,
    super.imageConvert,
  });

  factory BragChallengerM.fromMap(Map<String, dynamic> map) {
    return BragChallengerM(
      pid: map['pid'] as String,
      username: map['username'] as String,
      image: map['image'] as String,
      email: map['email'] as String,
    );
  }
}

/// Singlive CHallenger Stream
class SingleLiveStreamBragChallengerModel
    extends SingleLiveStreamBragChallengerEntity {
  SingleLiveStreamBragChallengerModel({
    required super.challenge,
    required super.stake,
    required super.duration,
    required super.status,
    required super.createdAt,
    required super.boostPoints,
    required super.challengerPid,
    required super.challengerUsername,
    required super.challengerImage,
    required super.challengerEmail,
    required super.lifecycleStatus,
    super.imageConvert,
  });

  factory SingleLiveStreamBragChallengerModel.fromJson(
      Map<String, dynamic> json) {
    return SingleLiveStreamBragChallengerModel(
        challenge: json['challenge'] ?? "",
        stake: json['stake'] ?? "",
        duration: json['duration'] ?? "",
        status: json['status'] ?? "",
        createdAt: json['created_at'] ?? "",
        boostPoints: json['boost_points'] ?? "",
        challengerPid: json['challenger']?['pid'] ?? "",
        challengerUsername: json['challenger']?['username'] ?? "",
        challengerImage: json['challenger']?['image'] ?? "",
        challengerEmail: json['challenger']?['email'] ?? "",
        lifecycleStatus: json['lifecycle']?['status'] ?? "",
        imageConvert: json['image']);
  }

  Map<String, dynamic> toJson() {
    return {
      "challenge": challenge,
      "stake": stake,
      "duration": duration,
      "status": status,
      "created_at": createdAt,
      "boost_points": boostPoints,
      "image": imageConvert,
      "challenger": {
        "pid": challengerPid,
        "username": challengerUsername,
        "image": challengerImage,
        "email": challengerEmail,
      },
      "lifecycle": {
        "status": lifecycleStatus,
      },
    };
  }
}
