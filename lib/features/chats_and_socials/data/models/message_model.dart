// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:clapmi/features/chats_and_socials/domain/entities/message_entity.dart';

class MessageEntityModel extends MessageEntity {
  const MessageEntityModel(
      {super.created_at,
      super.conversationId,
      super.uuid,
      super.is_read,
      super.message,
      super.reply_to,
      super.sender});

  factory MessageEntityModel.fromMap(Map<String, dynamic> map) {
    // Handle is_read - API may return bool (true/false) or int (0/1)
    int? isReadValue;
    final isReadRaw = map['is_read'];
    if (isReadRaw is bool) {
      isReadValue = isReadRaw ? 1 : 0;
    } else if (isReadRaw is int) {
      isReadValue = isReadRaw;
    }

    return MessageEntityModel(
      conversationId: map['conversation_id'] != null
          ? map['conversation_id'] as String
          : null,
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      is_read: isReadValue,
      sender: map['sender'] != null ? map['sender'] as String : null,
      reply_to: map['reply_to'] != null ? map['reply_to'] as String : null,
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
    );
  }
  factory MessageEntityModel.fromJson(String source) =>
      MessageEntityModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
