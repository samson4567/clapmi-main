import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';

import 'package:uuid/uuid.dart';

class VideoModel {
  final String? uniqueID;
  final String? bragPID;

  final bool? isDownloaded;
  final String? downloadedFilePath;

  final String? url;
  final bool needsDownloading;
  VideoModel({
    required this.uniqueID,
    required this.bragPID,
    required this.isDownloaded,
    required this.downloadedFilePath,
    required this.url,
    required this.needsDownloading,
  });

  VideoModel copyWith({
    String? uniqueID,
    bool? isDownloaded,
    String? downloadedFilePath,
    String? downloadURL,
    String? bragPID,
    bool? needsDownloading,
  }) {
    return VideoModel(
      uniqueID: uniqueID ?? this.uniqueID,
      bragPID: bragPID ?? this.bragPID,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
      url: downloadURL ?? url,
      needsDownloading: needsDownloading ?? this.needsDownloading,
    );
  }

  factory VideoModel.fromSqlitejson(Map json) {
    return VideoModel(
      uniqueID: json["uniqueID"],
      bragPID: json["bragPID"],
      isDownloaded: convertIntToBool(json["isDownloaded"]),
      downloadedFilePath: json["downloadedFilePath"],
      url: json["downloadURL"],
      needsDownloading: convertIntToBool(json["needsDownloading"] ?? 0),
    );
  }

  factory VideoModel.fromBragDetail(BragModel model) {
    return VideoModel(
      uniqueID: const Uuid().v4(),
      isDownloaded: true,
      downloadedFilePath: null,
      url: model.video?["file"],
      bragPID: model.pid,
      needsDownloading: !(model.fromFirebase ?? false),
    );
  }

  factory VideoModel.dummy() {
    return VideoModel(
      uniqueID: "uniqueID",
      isDownloaded: true,
      downloadedFilePath: "downloadedFilePath",
      url: "downloadURL",
      bragPID: "bragPID",
      needsDownloading: false,
    );
  }

  Map toMap() {
    return {
      "uniqueID": uniqueID,
      "isDownloaded": isDownloaded,
      "downloadedFilePath": downloadedFilePath,
      "downloadURL": url,
      "bragPID": bragPID,
      "needsDownloading": needsDownloading ? 1 : 0,
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toMap()}";
  }
}
