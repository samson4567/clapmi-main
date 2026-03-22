import 'dart:convert';

import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';

class LiveStreamModel {
  final int? wierdID;
  final String? channelName;
  final List<int>? listOfPaticipants;
  final List<Map>? listOfPaticipantsFullDetails;

  final bool? hasStarted;
  final bool? hasEnded;

  LiveStreamModel({
    required this.wierdID,
    required this.channelName,
    required this.hasEnded,
    required this.hasStarted,
    required this.listOfPaticipants,
    required this.listOfPaticipantsFullDetails,
  });

  LiveStreamModel copyWith({
    int? wierdID,
    String? channelName,
    List<int>? listOfPaticipants,
    List<Map>? listOfPaticipantsFullDetails,
    bool? hasStarted,
    bool? hasEnded,
  }) {
    return LiveStreamModel(
      wierdID: wierdID ?? this.wierdID,
      channelName: channelName ?? this.channelName,
      hasEnded: hasEnded ?? this.hasEnded,
      hasStarted: hasStarted ?? this.hasStarted,
      listOfPaticipants: listOfPaticipants ?? this.listOfPaticipants,
      listOfPaticipantsFullDetails:
          listOfPaticipantsFullDetails ?? this.listOfPaticipantsFullDetails,
    );
  }

  factory LiveStreamModel.fromjson(Map json) {
    return LiveStreamModel(
        wierdID: json["wierdID"],
        channelName: json["channelName"],
        hasEnded: convertIntToBool(json['hasEnded'] ?? 0),
        hasStarted: convertIntToBool(json['hasStarted'] ?? 0),
        listOfPaticipants: [
          ...(functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
                  json['listOfPaticipants']) as List?) ??
              []
        ],
        listOfPaticipantsFullDetails: [
          ...(functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
                  json['listOfPaticipantsFullDetails']) as List?) ??
              []
        ]);
  }

  factory LiveStreamModel.fromOnlinejson(Map json) {
    return LiveStreamModel(
      wierdID: json["wierdID"],
      channelName: json["channelName"],
      hasEnded: json["hasEnded"],
      hasStarted: json["hasStarted"],
      listOfPaticipants: json["listOfPaticipants"],
      listOfPaticipantsFullDetails: json["listOfPaticipantsFullDetails"],
    );
  }

  factory LiveStreamModel.dummy() {
    return LiveStreamModel(
      wierdID: 100023287,
      channelName: "dummyChannelName",
      hasEnded: false,
      hasStarted: true,
      listOfPaticipants: [],
      listOfPaticipantsFullDetails: [],
    );
  }

  Map toMap() {
    return {
      "wierdID": wierdID,
      "channelName": channelName,
      "hasEnded": hasEnded,
      "hasStarted": hasStarted,
      "listOfPaticipants": listOfPaticipants,
      "listOfPaticipantsFullDetails": listOfPaticipantsFullDetails,
    };
  }

  Map toMapforsqlite() {
    return {
      "wierdID": wierdID,
      "channelName": channelName,
      "hasEnded": (hasEnded ?? false) ? 1 : 0,
      "hasStarted": (hasStarted ?? false) ? 1 : 0,
      "listOfPaticipants": jsonEncode(listOfPaticipants),
      "listOfPaticipantsFullDetails": jsonEncode(listOfPaticipantsFullDetails),
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toMap()}";
  }
}
