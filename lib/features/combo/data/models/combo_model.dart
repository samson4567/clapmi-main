// ComboEntity
// ignore_for_file: non_constant_identifier_names, must_be_immutable
import 'dart:convert';

import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';

class ComboModel extends ComboEntity {
  ComboModel({
    super.combo,
    super.about,
    super.waiting,
    super.brag,
    super.endAt,
    super.duration,
    super.start,
    super.status,
    super.challenger,
    super.host,
    super.stake,
    super.type,
  });

  factory ComboModel.fromJson(Map<String, dynamic> json) {
    num? stake;
    if (json["stake"] != null) {
      if (json["stake"] is num) {
        stake = json['stake'];
      } else if (json["stake"] is String) {
        stake = num.parse(json["stake"]);
      }
    } else if (json['amount-staked'] != null) {
      if (json['amount-staked'] is num) {
        stake = json['amount-staked'];
      } else if (json['amount-staked'] is String) {
        stake = num.parse(json['amount-staked']);
      }
    }

    return ComboModel(
      combo: json["combo"],
      about: json["about"],
      waiting: json["waiting"],
      type: json['type'],
      endAt: json['end'],
      brag: json["brag"],
      duration: json["duration"],
      start: json["start"],
      status: json["status"],
      stake: stake?.toInt(),
      challenger: json["challenger"] != null
          ? LiveUserModel.fromMap(json["challenger"])
          : null,
      host: json["host"] != null ? LiveUserModel.fromMap(json['host']) : null,
    );
  }
  factory ComboModel.fromEntity(ComboEntity comboEntity) {
    return ComboModel(
      about: comboEntity.about,
      brag: comboEntity.brag,
      challenger: comboEntity.challenger,
      type: comboEntity.type,
      combo: comboEntity.combo,
      endAt: comboEntity.endAt,
      duration: comboEntity.duration,
      host: comboEntity.host,
      start: comboEntity.start,
      status: comboEntity.status,
      waiting: comboEntity.waiting,
      stake: comboEntity.stake,
    );
  }
}

class LiveMetaDataModel extends LiveMetaData {
  const LiveMetaDataModel(
      {super.challenger_joined,
      super.host_joined,
      super.start_time,
      super.started_by});

  factory LiveMetaDataModel.fromMap(Map<String, dynamic> map) {
    return LiveMetaDataModel(
      started_by:
          map['started_by'] != null ? map['started_by'] as String : null,
      start_time:
          map['start-time'] != null ? map['start-time'] as String : null,
      host_joined:
          map['host-joined'] != null ? map['host-joined'] as bool : null,
      challenger_joined: map['challenger_joined'] != null
          ? map['challenger_joined'] as bool
          : null,
    );
  }

  factory LiveMetaDataModel.fromJson(String source) =>
      LiveMetaDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LiveUserModel extends LiveUser {
  LiveUserModel({
    super.avatar,
    super.profile,
    super.username,
  });

  factory LiveUserModel.fromMap(Map<String, dynamic> map) {
    return LiveUserModel(
      profile: map['profile'] != null ? map['profile'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
    );
  }
  factory LiveUserModel.fromJson(String source) =>
      LiveUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SingleLiveGiftDataModel extends SingleLiveGiftData {
  const SingleLiveGiftDataModel({super.challenger, super.host});
  factory SingleLiveGiftDataModel.fromMap(Map<String, dynamic> map) {
    num? hostParsedValue;
    num? challengerParsedValue;
    if (map['host'] is num) {
      hostParsedValue = map['host'];
    } else if (map['host'] is String) {
      hostParsedValue = num.parse(map['host']);
    }
    if (map['challenger'] is num) {
      challengerParsedValue = map['challenger'];
    } else if (map['challenger'] is String) {
      challengerParsedValue = num.parse(map['challenger']);
    }
    return SingleLiveGiftDataModel(
        host: hostParsedValue ?? 0, challenger: challengerParsedValue ?? 0);
  }

  factory SingleLiveGiftDataModel.fromJson(String source) =>
      SingleLiveGiftDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class LiveComboModel extends LiveComboEntity {
  const LiveComboModel(
      {super.about,
      super.combo,
      super.duration,
      super.contextType,
      super.type,
      super.challenger,
      super.gifts,
      super.host,
      super.end,
      super.metaData,
      super.presence,
      super.hasOngoingCombo,
      super.onGoingCombo,
      super.startTime,
      super.boostPoint,
      super.brag,
      super.stake,
      super.status});

  factory LiveComboModel.fromMap(Map<String, dynamic> map) {
    num? amountStakeParsed;
    SingleLiveGiftDataModel? gifts;
    LiveUserModel? hostModel;
    //To cater for the stake value which can have different field
    if (map['type'] == 'multiple') {
      if (map['stake'] != null) {
        if (map['stake'] is num) {
          amountStakeParsed = map['stake'];
        } else if (map['stake'] is List) {
          amountStakeParsed = 0.0;
        } else if (map['stake'] is String) {
          amountStakeParsed = num.parse(map['stake']);
        }
      } else if (map['amount-staked'] != null) {
        if (map['amount-staked'] is num) {
          amountStakeParsed = map['amount-staked'];
        } else if (map['amount-staked'] is List) {
          amountStakeParsed = 0.0;
        } else {
          amountStakeParsed = num.parse(map['amount-staked']);
        }
      }
    }
    //To cater for the different data field for gifts
    if (map['gifts'] is num || map['gifts'] == null) {
      gifts = null;
    } else {
      gifts =
          SingleLiveGiftDataModel.fromMap(map['gifts'] as Map<String, dynamic>);
    }

    //To cater for host value which can have different field also
    if (map['host'] is String) {
      hostModel = LiveUserModel(profile: map['host']);
    } else {
      hostModel = LiveUserModel.fromMap(map['host'] as Map<String, dynamic>);
    }

    return LiveComboModel(
      combo: map['combo'] != null ? map['combo'] as String : null,
      about: map['about'] != null ? map['about'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      end: map['end'] != null ? map['end'] as String : null,
      contextType:
          map['context-type'] != null ? map['context-type'] as String : null,
      presence: map['presence'] != null ? map['presence'] as int : null,
      hasOngoingCombo: map['has-ongoing-combos'] != null
          ? map['has-ongoing-combos'] as bool
          : null,
      gifts: gifts,
      host: hostModel,
      challenger: map['challenger'] != null
          ? map['challenger'] is List
              ? null
              : LiveUserModel.fromMap(map['challenger'] as Map<String, dynamic>)
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      stake: amountStakeParsed ?? 0,
      metaData: map['metadata'] != null
          ? LiveMetaDataModel.fromMap(map['metadata'] as Map<String, dynamic>)
          : null,
      startTime: map['start-time'] != null ? map['start-time'] as String : null,
      brag: map['brag'] != null ? map['brag'] as String : null,
      boostPoint: map['boost-point'] != null ? map['boost-point'] as num : null,
      onGoingCombo: map['ongoing-combos'] != null
          ? LiveComboModel.fromMap(
              map['ongoing-combos'] as Map<String, dynamic>)
          : null,
    );
  }

  factory LiveComboModel.fromJson(String source) =>
      LiveComboModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
