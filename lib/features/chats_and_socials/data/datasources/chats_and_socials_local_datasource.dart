import 'package:clapmi/core/db/database_service.dart';
import 'package:clapmi/core/error/exception.dart';
import 'package:clapmi/core/utils/app_logger.dart';
import 'package:clapmi/features/chats_and_socials/data/models/chat_user_model.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
import 'package:sqflite/sqflite.dart';

abstract class ChatsAndSocialsLocalDatasource {
  Future<List<ChatUserDataModel>> getChatHistory();
  Future<void> insertChatList({required List<ChatUserDataModel> chatHistory});
  Future<void> deleteChatHistory();
}

class ChatsAndSocialsLocalDatasourceImpl
    implements ChatsAndSocialsLocalDatasource {
  ChatsAndSocialsLocalDatasourceImpl({required this.databaseService});
  final DatabaseService databaseService;

  @override
  Future<List<ChatUserDataModel>> getChatHistory() async {
    try {
      // FIX: Query both 'created_at' and 'updated_at' for compatibility
      final chatHistory =
          await databaseService.database.query('Chat', columns: [
        '''
              conversation_id, 
              unread_message_count,
              last_message,
              created_at,
              updated_at,
              user
              '''
      ]);
      //
      final chats = chatHistory
          .map((chatItem) => ChatUserDataModel.fromMap(chatItem, true))
          .toList();
      AppLogger.debug('Chat list from sqflite: ${chats.length} items',
          tag: 'LOCAL_DS');
      if (chats.isEmpty) {
        throw UnknownException(message: 'The chat History is Empty');
      }
      return chats;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load chat history',
        tag: 'LOCAL_DS',
        error: e,
        stackTrace: stackTrace,
      );
      throw UnknownException(message: 'Failed to query the database');
    }
  }

  @override
  Future<void> insertChatList({required List<ChatUserData> chatHistory}) async {
    try {
      for (var chatItem in chatHistory) {
        final lastRow = await databaseService.database.insert(
            'Chat', chatItem.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        AppLogger.debug('Inserted chat row: $lastRow', tag: 'LOCAL_DS');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to insert chat list',
        tag: 'LOCAL_DS',
        error: e,
        stackTrace: stackTrace,
      );
      throw UnknownException(message: 'Failed to insert the chatList');
    }
  }

  @override
  Future<void> deleteChatHistory() async {
    try {
      await databaseService.database.delete('Chat');
      AppLogger.debug('Chat history deleted', tag: 'LOCAL_DS');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete chat history',
        tag: 'LOCAL_DS',
        error: e,
        stackTrace: stackTrace,
      );
      throw UnknownException(message: 'Failed to delete the data');
    }
  }
}
