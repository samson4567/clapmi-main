import 'dart:convert';

import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';

class ChatModel {
  final int? wierdID;
  final int? senderID;
  final int? recipientID;

  final String? message;
  final int? isRead;
  final String? createdAt;
  final String? updatedAt;
  final String? time;
  final List? files;

  ChatModel({
    required this.wierdID,
    required this.files,
    required this.createdAt,
    required this.updatedAt,
    required this.isRead,
    required this.message,
    required this.recipientID,
    required this.senderID,
    required this.time,
  });

  ChatModel copyWith({
    int? wierdID,
    int? senderID,
    int? recipientID,
    String? avatarImage,
    String? message,
    int? isRead,
    String? createdAt,
    String? updatedAt,
    String? time,
    List? files,
  }) {
    return ChatModel(
      wierdID: wierdID ?? this.wierdID,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      message: message ?? this.message,
      recipientID: recipientID ?? this.recipientID,
      senderID: senderID ?? this.senderID,
      time: time ?? this.time,
      updatedAt: updatedAt ?? this.updatedAt,
      files: files ?? this.files,
    );
  }

  factory ChatModel.fromjson(Map json) {
    return ChatModel(
      wierdID: json['wierdID'],
      senderID: json['sender_id'],
      recipientID: json['recipient_id'],
      message: json['message'],
      isRead: json['isRead'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      time: json['time'],
      files: (functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
          json['files']) as List?),
    );
  }

  factory ChatModel.fromOnlinejson(Map json) {
    return ChatModel(
      wierdID: json['id'],
      senderID: json['sender_id'],
      recipientID: json['recipient_id'],
      message: json['message'],
      isRead: json['isRead'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      time: json['time'],
      files: json['files'],
    );
  }

  factory ChatModel.dummy() {
    return ChatModel(
        wierdID: 123,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        isRead: 1,
        message: "this is a dummy message",
        recipientID: 122,
        senderID: 100,
        time: DateTime.now().toString(),
        files: []);
  }

  Map toMap() {
    return {
      'wierdID': wierdID,
      'senderID': senderID,
      'recipientID': recipientID,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'time': time,
      'files': files,
    };
  }

  Map toOnlineMap() {
    return {
      'id': wierdID,
      'sender_id': senderID,
      'recipient_id': recipientID,
      'message': message,
      'isRead': isRead,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'time': time,
      'files': jsonEncode(files),
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toMap()}";
  }
}
