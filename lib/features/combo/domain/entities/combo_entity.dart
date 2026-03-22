// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, must_be_immutable
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ComboEntity {
  final String? combo;
  final String? about;
  final String? type;
  final int? waiting;
  final String? endAt;
  final String? brag;
  final String? duration;
  final String? start;
  final String? status;
  final int? stake;
  LiveUser? host;
  LiveUser? challenger;

  ComboEntity({
    required this.combo,
    required this.about,
    required this.type,
    this.endAt,
    this.waiting,
    required this.brag,
    required this.duration,
    required this.start,
    required this.stake,
    this.status,
    this.challenger,
    this.host,
  });
}

class LiveComboEntity extends Equatable {
  final String? about;
  final String? combo;
  final int? presence;
  final String? duration;
  final String? type;
  final SingleLiveGiftData? gifts;
  final String? end;
  final String? contextType;
  final LiveUser? host;
  final LiveUser? challenger;
  final String? status;
  final LiveMetaData? metaData;
  final bool? hasOngoingCombo;
  final LiveComboEntity? onGoingCombo;
  final String? startTime;
  final num? stake;
  final num? boostPoint;
  final String? brag;
  const LiveComboEntity({
    this.about,
    this.combo,
    this.presence,
    this.duration,
    this.contextType,
    this.type,
    this.gifts,
    this.end,
    this.host,
    this.challenger,
    this.status,
    this.startTime,
    this.stake,
    this.boostPoint,
    this.metaData,
    this.brag,
    this.hasOngoingCombo = false,
    this.onGoingCombo,
  });

  @override
  List<Object?> get props => [
        about,
        combo,
        presence,
        contextType,
        duration,
        type,
        gifts,
        end,
        host,
        challenger,
        startTime,
        boostPoint,
        stake,
        brag,
        status,
        metaData,
        hasOngoingCombo,
        onGoingCombo,
      ];

  LiveComboEntity copyWith({
    String? about,
    String? combo,
    int? presence,
    String? duration,
    String? contextType,
    String? type,
    SingleLiveGiftData? gifts,
    String? end,
    LiveUser? host,
    LiveUser? challenger,
    String? status,
    bool? hasOngoingCombo,
    String? startTime,
    num? boostPoint,
    num? stake,
    num? amountStaked,
    String? brag,
    LiveMetaData? metaData,
    LiveComboEntity? onGoingCombo,
  }) {
    return LiveComboEntity(
      about: about ?? this.about,
      combo: combo ?? this.combo,
      presence: presence ?? this.presence,
      contextType: contextType ?? this.contextType,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      gifts: gifts ?? this.gifts,
      end: end ?? this.end,
      hasOngoingCombo: hasOngoingCombo ?? this.hasOngoingCombo,
      host: host ?? this.host,
      challenger: challenger ?? this.challenger,
      status: status ?? this.status,
      stake: stake ?? this.stake,
      boostPoint: boostPoint ?? this.boostPoint,
      brag: brag ?? this.brag,
      startTime: startTime ?? this.startTime,
      metaData: metaData ?? this.metaData,
      onGoingCombo: onGoingCombo ?? this.onGoingCombo,
    );
  }
}

class SingleLiveGiftData extends Equatable {
  final num? host;
  final num? challenger;

  const SingleLiveGiftData({
    this.host,
    this.challenger,
  });

  @override
  List<Object?> get props => [host, challenger];
}

class LiveUser extends Equatable {
  final String? profile;
  final String? avatar;
  final String? username;
  Uint8List? avatarConvert;
  LiveUser({
    this.profile,
    this.avatar,
    this.username,
    this.avatarConvert,
  });

  @override
  List<Object?> get props => [profile, avatar, username, avatarConvert];
}

class LiveMetaData extends Equatable {
  final String? started_by;
  final String? start_time;
  final bool? host_joined;
  final bool? challenger_joined;
  const LiveMetaData({
    this.started_by,
    this.start_time,
    this.host_joined,
    this.challenger_joined,
  });

  @override
  List<Object?> get props =>
      [started_by, start_time, host_joined, challenger_joined];
}
