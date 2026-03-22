// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? conversationId;
  final String? uuid;
  final String? message;
  final int? is_read;
  final String? sender;
  final String? reply_to;
  final String? created_at;

  const MessageEntity({
    this.conversationId,
    this.uuid,
    this.message,
    this.is_read,
    this.sender,
    this.reply_to,
    this.created_at,
  });

  @override
  List<Object?> get props =>
      [uuid, conversationId, message, is_read, sender, reply_to, created_at];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': conversationId,
      'uuid': uuid,
      'message': message,
      'is_read': is_read,
      'sender': sender,
      'reply_': reply_to,
      'created_at': created_at,
    };
  }

  String toJson() => json.encode(toMap());
}
