// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:clapmi/core/utils/app_logger.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';

class ChatUserModel extends ChatUser {
  const ChatUserModel({
    required super.pid,
    required super.username,
    required super.image,
    required super.name,
    required super.occupation,
    required super.email,
  });

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    try {
      return ChatUserModel(
        pid: map['pid'] as String?,
        username: map['username'] as String?,
        image: map['image'] as String?,
        email: map['email'] as String?,
        name: map['name'] as String?,
        occupation: map['occupation'] as String?,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create ChatUserModel from map',
        tag: 'MODEL',
        error: e,
        stackTrace: stackTrace,
      );
      // Return a default model instead of throwing
      return const ChatUserModel(
        pid: null,
        username: null,
        image: null,
        name: null,
        occupation: null,
        email: null,
      );
    }
  }

  factory ChatUserModel.fromJson(String source) {
    try {
      return ChatUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create ChatUserModel from JSON: $source',
        tag: 'MODEL',
        error: e,
        stackTrace: stackTrace,
      );
      return const ChatUserModel(
        pid: null,
        username: null,
        image: null,
        name: null,
        occupation: null,
        email: null,
      );
    }
  }
}

class ChatUserDataModel extends ChatUserData {
  const ChatUserDataModel({
    required super.user,
    required super.conversationId,
    required super.last_message,
    required super.message_count,
    required super.date,
  });

  factory ChatUserDataModel.fromMap(Map<String, dynamic> map, bool isLocal) {
    try {
      // FIX: Map both 'created_at' and 'updated_at' to date field
      // API returns 'created_at' but local DB might have 'updated_at'
      final dateValue = map['date'] ?? map['created_at'] ?? map['updated_at'];

      return ChatUserDataModel(
        conversationId: map['conversation_id'] as String?,
        user: map['user'] != null
            ? isLocal
                ? ChatUserModel.fromJson(map['user'] as String)
                : ChatUserModel.fromMap(map['user'] as Map<String, dynamic>)
            : null,
        message_count: map['unread_message_count'] as int?,
        last_message: map['last_message'] as String?,
        date: dateValue as String?,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create ChatUserDataModel from map',
        tag: 'MODEL',
        error: e,
        stackTrace: stackTrace,
      );
      // Return a default model instead of throwing
      return const ChatUserDataModel(
        user: null,
        conversationId: null,
        last_message: null,
        message_count: null,
        date: null,
      );
    }
  }

  factory ChatUserDataModel.fromJson(String source, bool isLocal) {
    try {
      return ChatUserDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>, isLocal);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create ChatUserDataModel from JSON: $source',
        tag: 'MODEL',
        error: e,
        stackTrace: stackTrace,
      );
      return const ChatUserDataModel(
        user: null,
        conversationId: null,
        last_message: null,
        message_count: null,
        date: null,
      );
    }
  }
}
