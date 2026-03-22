import 'package:clapmi/features/user/data/models/user_model.dart';

class CreateComboModel {
  final String? title;
  final String? challenge;
  final String? hostAvatar;
  final String? challengerAvatar;
  final String? startTime;
  final String? duration;

  //sbsdsdjb skjdb
  final int? wierdID;
  final String? PID;
  final String? comboPID;
  final int? opponentID;
  final int? comboGroundID;
  final int? creatorID;
  final int? hostOneScore;
  final int? hostTwoScore;
  final List? hosts;
  final List? audiences;
  final List? clapDetails;

  final bool? visible;
  final String? deleteAt;
  final String? createdAt;

  final Map? opponent;
  final Map? creator;
  final String? opponentAvatar;
  final String? creatorAvatar;
  final String? status;
  final String? humanReadableDate;
  final int? bragID;
  final Map? brag;

  final String? rules;

  bool? isLive;

  CreateComboModel({
    this.wierdID,
    this.PID,
    this.opponent,
    this.creator,
    this.opponentAvatar,
    this.creatorAvatar,
    this.status,
    this.humanReadableDate,
    this.bragID,
    this.brag,
    this.startTime,
    this.rules,
    this.title,
    this.audiences,
    this.clapDetails,
    this.comboGroundID,
    this.comboPID,
    this.createdAt,
    this.creatorID,
    this.deleteAt,
    this.hostOneScore,
    this.hostTwoScore,
    this.hosts,
    this.opponentID,
    this.visible,
    this.isLive,
    this.challenge,
    this.challengerAvatar,
    this.duration,
    this.hostAvatar,
  });

  CreateComboModel copyWith({
    int? wierdID,
    String? PID,
    String? comboPID,
    int? opponentID,
    int? comboGroundID,
    int? creatorID,
    int? hostOneScore,
    int? hostTwoScore,
    List? hosts,
    List? audiences,
    List? clapDetails,
    bool? visible,
    String? deleteAt,
    String? createdAt,
    Map? opponent,
    Map? creator,
    String? opponentAvatar,
    String? creatorAvatar,
    String? status,
    String? humanReadableDate,
    int? bragID,
    Map? brag,
    String? startTime,
    String? rules,
    String? title,
    bool? isLive,
    String? challenge,
    String? hostAvatar,
    String? challengerAvatar,
    String? duration,
  }) {
    return CreateComboModel(
      wierdID: wierdID ?? this.wierdID,
      PID: PID ?? this.PID,
      opponent: opponent ?? this.opponent,
      creator: creator ?? this.creator,
      opponentAvatar: opponentAvatar ?? this.opponentAvatar,
      creatorAvatar: creatorAvatar ?? this.creatorAvatar,
      status: status ?? this.status,
      humanReadableDate: humanReadableDate ?? this.humanReadableDate,
      bragID: bragID ?? this.bragID,
      brag: brag ?? this.brag,
      startTime: startTime ?? this.startTime,
      rules: rules ?? this.rules,
      title: title ?? this.title,
      audiences: audiences ?? this.audiences,
      clapDetails: clapDetails ?? this.clapDetails,
      comboGroundID: comboGroundID ?? this.comboGroundID,
      comboPID: comboPID ?? this.comboPID,
      createdAt: createdAt ?? this.createdAt,
      creatorID: creatorID ?? this.creatorID,
      deleteAt: deleteAt ?? this.deleteAt,
      hostOneScore: hostOneScore ?? this.hostOneScore,
      hostTwoScore: hostTwoScore ?? this.hostTwoScore,
      hosts: hosts ?? this.hosts,
      opponentID: opponentID ?? this.opponentID,
      visible: visible ?? this.visible,
      isLive: isLive ?? this.isLive,
      challenge: challenge ?? this.challenge,
      challengerAvatar: challengerAvatar ?? this.challengerAvatar,
      duration: duration ?? this.duration,
      hostAvatar: hostAvatar ?? this.hostAvatar,
    );
  }

  List<UserModel> getUsersFromHost() {
    return hosts?.map(
          (host) {
            return UserModel.fromJson((host as Map?)?["user"] ?? {});
          },
        ).toList() ??
        [];
  }

  factory CreateComboModel.fromOnlinejson(Map json) {
    return CreateComboModel(
      wierdID: json['id'],
      PID: json['PID'],
      opponent: json['opponent'],
      creator: json['creator'],
      opponentAvatar: json['opponent_avatar'],
      creatorAvatar: json['creator_avatar'],
      status: json['status'],
      humanReadableDate: json['human_readable_date'],
      bragID: json['brag_id'],
      brag: json['brag'],
      startTime: json['start-time'],
      rules: json['rules'],
      title: json['title'],
      audiences: json["audiences"],
      clapDetails: json["clapDetails"],
      hosts: json["hosts"],
      comboGroundID: json['comboGroundID'],
      comboPID: json['comboPID'],
      createdAt: json['createdAt'],
      creatorID: json['creatorID'],
      deleteAt: json['deleteAt'],
      hostOneScore: json['hostOneScore'],
      hostTwoScore: json['hostTwoScore'],
      opponentID: json['opponentID'],
      visible: json['visible'],
      isLive: json['isLive'],
      challenge: json['challenge'],
      challengerAvatar: json['avatars[challenger]'],
      duration: json['duration'],
      hostAvatar: json['avatars[host]'],
    );
  }

  Map toCreateMap() {
    return {
      'start-time': startTime,
      "challenge": challenge,
      "avatars[challenger]": challengerAvatar,
      "duration": duration,
      "avatars[host]": hostAvatar,
      'title': title,
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>>}";
  }
}
