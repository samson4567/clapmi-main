// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ChatUser extends Equatable {
  final String? pid;
  final String? username;
  final String? image;
  final String? email;
  final String? name;
  final String? occupation;

  const ChatUser({
    required this.pid,
    required this.username,
    required this.image,
    required this.email,
    required this.name,
    required this.occupation,
  });

  @override
  List<Object?> get props => [
        pid,
        username,
        image,
        email,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pid': pid,
      'username': username,
      'image': image,
      'email': email,
      'name': name,
      'occupation': occupation,
    };
  }

  String toJson() => json.encode(toMap());
}

class ChatUserData extends Equatable {
  final ChatUser? user;
  final int? message_count;
  final String? last_message;
  final String? conversationId;
  final String? date;

  const ChatUserData(
      {this.user,
      this.message_count,
      this.last_message,
      this.conversationId,
      this.date});

  @override
  List<Object?> get props =>
      [user, message_count, last_message, conversationId];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user?.toJson(),
      'unread_message_count': message_count,
      'last_message': last_message,
      'conversation_id': conversationId,
      'created_at': date
    };
  }

  ChatUserData copyWith({
    ChatUser? user,
    int? message_count,
    String? last_message,
    String? conversationId,
    String? date,
  }) {
    return ChatUserData(
        user: user ?? this.user,
        message_count: message_count ?? this.message_count,
        last_message: last_message ?? this.last_message,
        conversationId: conversationId ?? this.conversationId,
        date: date ?? this.date);
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    // 1. Check if the objects are the same instance
    if (identical(this, other)) return true;

    // 2. Check if the other object is the same type and compare fields
    return other is ChatUserData &&
        other.user?.pid == user?.pid &&
        user?.pid != null;
  }
}
