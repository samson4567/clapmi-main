// import 'dart:convert';

// import 'package:clapmi/Models/brag_model.dart';
// import 'package:clapmi/Models/user_model.dart';
// import 'package:clapmi/features/user/data/models/user_model.dart';
// import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';

// class ComboModel {
//   final int? wierdID;
//   final String? PID;
//   final String? comboPID;
//   final int? opponentID;
//   final int? comboGroundID;
//   final int? creatorID;
//   final int? hostOneScore;
//   final int? hostTwoScore;
//   final List? hosts;
//   final List? audiences;
//   final List? clapDetails;

//   final bool? visible;
//   final String? deleteAt;
//   final String? createdAt;

//   final Map? opponent;
//   final Map? creator;
//   final String? opponentAvatar;
//   final String? creatorAvatar;
//   final String? status;
//   final String? humanReadableDate;
//   final int? bragID;
//   final Map? brag;
//   final String? startTime;
//   final String? rules;
//   final String? title;
//   bool? isLive;

//   ComboModel({
//     required this.wierdID,
//     required this.PID,
//     required this.opponent,
//     required this.creator,
//     required this.opponentAvatar,
//     required this.creatorAvatar,
//     required this.status,
//     required this.humanReadableDate,
//     required this.bragID,
//     required this.brag,
//     required this.startTime,
//     required this.rules,
//     required this.title,
//     required this.audiences,
//     required this.clapDetails,
//     required this.comboGroundID,
//     required this.comboPID,
//     required this.createdAt,
//     required this.creatorID,
//     required this.deleteAt,
//     required this.hostOneScore,
//     required this.hostTwoScore,
//     required this.hosts,
//     required this.opponentID,
//     required this.visible,
//     required this.isLive,
//   });

//   ComboModel copyWith({
//     int? wierdID,
//     String? PID,
//     String? comboPID,
//     int? opponentID,
//     int? comboGroundID,
//     int? creatorID,
//     int? hostOneScore,
//     int? hostTwoScore,
//     List? hosts,
//     List? audiences,
//     List? clapDetails,
//     bool? visible,
//     String? deleteAt,
//     String? createdAt,
//     Map? opponent,
//     Map? creator,
//     String? opponentAvatar,
//     String? creatorAvatar,
//     String? status,
//     String? humanReadableDate,
//     int? bragID,
//     Map? brag,
//     String? startTime,
//     String? rules,
//     String? title,
//     bool? isLive,
//   }) {
//     return ComboModel(
//       wierdID: wierdID ?? this.wierdID,
//       PID: PID ?? this.PID,
//       opponent: opponent ?? this.opponent,
//       creator: creator ?? this.creator,
//       opponentAvatar: opponentAvatar ?? this.opponentAvatar,
//       creatorAvatar: creatorAvatar ?? this.creatorAvatar,
//       status: status ?? this.status,
//       humanReadableDate: humanReadableDate ?? this.humanReadableDate,
//       bragID: bragID ?? this.bragID,
//       brag: brag ?? this.brag,
//       startTime: startTime ?? this.startTime,
//       rules: rules ?? this.rules,
//       title: title ?? this.title,
//       audiences: audiences ?? this.audiences,
//       clapDetails: clapDetails ?? this.clapDetails,
//       comboGroundID: comboGroundID ?? this.comboGroundID,
//       comboPID: comboPID ?? this.comboPID,
//       createdAt: createdAt ?? this.createdAt,
//       creatorID: creatorID ?? this.creatorID,
//       deleteAt: deleteAt ?? this.deleteAt,
//       hostOneScore: hostOneScore ?? this.hostOneScore,
//       hostTwoScore: hostTwoScore ?? this.hostTwoScore,
//       hosts: hosts ?? this.hosts,
//       opponentID: opponentID ?? this.opponentID,
//       visible: visible ?? this.visible,
//       isLive: isLive ?? this.isLive,
//     );
//   }

//   List<UserModel> getUsersFromHost() {
//     return hosts?.map(
//           (host) {
//             return UserModel.fromJson((host as Map?)?["user"] ?? {});
//           },
//         ).toList() ??
//         [];
//   }

//   factory ComboModel.fromSqlitejson(Map json) {
//     return ComboModel(
//       wierdID: json['id'],
//       PID: json['PID'],
//       opponent: functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
//           json['opponent']) as Map?,
//       creator: functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
//           json['creator']) as Map?,
//       opponentAvatar: json['opponent_avatar'],
//       creatorAvatar: json['creator_avatar'],
//       status: json['status'],
//       humanReadableDate: json['human_readable_date'],
//       bragID: json['brag_id'],
//       brag:
//           functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(json['brag'])
//               as Map?,
//       startTime: json['start_time'],
//       rules: json['rules'],
//       title: json['title'],
//       audiences: functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
//           json['audiences']) as List?,
//       clapDetails: functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
//           json['clapDetails']) as List?,
//       hosts:
//           functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(json['hosts'])
//               as List?,
//       comboGroundID: json['comboGroundID'],
//       comboPID: json['comboPID'],
//       createdAt: json['createdAt'],
//       creatorID: json['creatorID'],
//       deleteAt: json['deleteAt'],
//       hostOneScore: json['hostOneScore'],
//       hostTwoScore: json['hostTwoScore'],
//       opponentID: json['opponentID'],
//       visible: convertIntToBool(json['visible'] ?? 0),
//       isLive: convertIntToBool(json['isLive'] ?? 0),
//     );
//   }

//   factory ComboModel.fromOnlinejson(Map json) {
//     return ComboModel(
//       wierdID: json['id'],
//       PID: json['PID'],
//       opponent: json['opponent'],
//       creator: json['creator'],
//       opponentAvatar: json['opponent_avatar'],
//       creatorAvatar: json['creator_avatar'],
//       status: json['status'],
//       humanReadableDate: json['human_readable_date'],
//       bragID: json['brag_id'],
//       brag: json['brag'],
//       startTime: json['start_time'],
//       rules: json['rules'],
//       title: json['title'],
//       audiences: json["audiences"],
//       clapDetails: json["clapDetails"],
//       hosts: json["hosts"],
//       comboGroundID: json['comboGroundID'],
//       comboPID: json['comboPID'],
//       createdAt: json['createdAt'],
//       creatorID: json['creatorID'],
//       deleteAt: json['deleteAt'],
//       hostOneScore: json['hostOneScore'],
//       hostTwoScore: json['hostTwoScore'],
//       opponentID: json['opponentID'],
//       visible: json['visible'],
//       isLive: json['isLive'],
//     );
//   }

//   factory ComboModel.dummy() {
//     return ComboModel(
//       wierdID: 100,
//       PID: "dummy-PID",
//       opponent: UserModel.empty().toJson(),
//       creator: UserModel.empty().toJson(),
//       opponentAvatar:
//           "https://res.cloudinary.com/clapmi-alt/image/upload/v1696356393/a_b4ahjd.png",
//       creatorAvatar:
//           "https://res.cloudinary.com/clapmi-alt/image/upload/v1696356393/a_b4ahjd.png",
//       status: "UPCOMING",
//       humanReadableDate: "00hr : 40mins : 57secs",
//       bragID: 1243,
//       brag: BragModel.dummy().toMapforInternet(),
//       startTime: "30 Dec 2024 17:00",
//       rules: "no rule, go wild",
//       title: "Dummy race to heaven",
//       audiences: [],
//       clapDetails: [],
//       hosts: [],
//       //
//       comboGroundID: 120,
//       comboPID: "kdasdaja",
//       createdAt: DateTime.now().toString(),
//       creatorID: 12321,
//       deleteAt: DateTime.now().toString(),
//       hostOneScore: 0,
//       hostTwoScore: 12,
//       opponentID: 12321,
//       visible: true,
//       isLive: true,
//     );
//   }

//   Map toOnlineMap() {
//     return {
//       'id': wierdID,
//       'PID': PID,
//       'opponent': opponent,
//       'creator': creator,
//       'opponent_avatar': opponentAvatar,
//       'creator_avatar': creatorAvatar,
//       'status': status,
//       'human_readable_date': humanReadableDate,
//       'brag_id': bragID,
//       'brag': brag,
//       'start_time': startTime,
//       'rules': rules,
//       'title': title,
//       //
//       "audiences": audiences,
//       "clapDetails": clapDetails,
//       "hosts": hosts,
//       //
//       'comboGroundID': comboGroundID,
//       'comboPID': comboPID,
//       'createdAt': createdAt,
//       'creatorID': creatorID,
//       'deleteAt': deleteAt,
//       'hostOneScore': hostOneScore,
//       'hostTwoScore': hostTwoScore,
//       'opponentID': opponentID,
//       'visible': visible,
//       'isLive': isLive,
//     };
//   }

//   Map toSqliteMap() {
//     return {
//       'id': wierdID,
//       'PID': PID,
//       'opponent': jsonEncode(opponent),
//       'creator': jsonEncode(creator),
//       'opponent_avatar': opponentAvatar,
//       'creator_avatar': creatorAvatar,
//       'status': status,
//       'human_readable_date': humanReadableDate,
//       'brag_id': bragID,
//       'brag': jsonEncode(brag),
//       'start_time': startTime,
//       'rules': rules,
//       'title': title,
//       //
//       "audiences": jsonEncode(audiences),
//       "clapDetails": jsonEncode(clapDetails),
//       "hosts": jsonEncode(hosts),
//       //
//       'comboGroundID': comboGroundID,
//       'comboPID': comboPID,
//       'createdAt': createdAt,
//       'creatorID': creatorID,
//       'deleteAt': deleteAt,
//       'hostOneScore': hostOneScore,
//       'hostTwoScore': hostTwoScore,
//       'opponentID': opponentID,
//       'visible': (visible ?? false) ? 1 : 0,
//       'isLive': (isLive ?? false) ? 1 : 0,
//     };
//   }

//   @override
//   String toString() {
//     return "${super.toString()}>>> ${toOnlineMap()}";
//   }
// }
