import 'dart:async';
import 'package:clapmi/core/error/exception.dart';
import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/features/chats_and_socials/data/datasources/chats_and_socials_local_datasource.dart';
import 'package:clapmi/features/chats_and_socials/data/datasources/chats_and_socials_remote_datasource.dart';
import 'package:clapmi/features/chats_and_socials/data/models/user_model.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/clap_request_entity.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/message_entity.dart';
import 'package:clapmi/features/chats_and_socials/domain/repositories/chats_and_socials_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';

class ChatsAndSocialsRepositoryImpl implements ChatsAndSocialsRepository {
  ChatsAndSocialsRepositoryImpl({
    required this.chatsAndSocialsLocalDatasource,
    required this.chatsAndSocialsRemoteDatasource,
  });

  final ChatsAndSocialsRemoteDatasource chatsAndSocialsRemoteDatasource;
  final ChatsAndSocialsLocalDatasource chatsAndSocialsLocalDatasource;

  @override
  Future<Either<Failure, String>> sendClapRequestToUsers(
      {required String userPids}) async {
    try {
      final result = await chatsAndSocialsRemoteDatasource
          .sendClapRequestToUsers(userPids: userPids);

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ClapRequestEntity>>> getClapRequests() async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.getClapRequests();

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> acceptClapRequests(
      {required String requestID}) async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.acceptClapRequests(
        requestID: requestID,
      );

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> rejectClapRequests(
      {required String requestID}) async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.rejectClapRequests(
        requestID: requestID,
      );

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<UserNearLocationEntity>>>
      getUsersNearLocation() async {
    try {
      final result =
          await chatsAndSocialsRemoteDatasource.getUsersNearLocation();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> connectToSocket() async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.connectToSocket();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Stream<dynamic> listeningToSocket() {
    try {
      final result = chatsAndSocialsRemoteDatasource.listeningToSocket();
      return result;
    } catch (e) {
      throw Exception('Error occured : ${e.toString()}');
      // return mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, void>> sendOrReplyMessage(
      {required String message,
      String? senderId,
      String? conversationId,
      String? parentMessageId}) async {
    try {
      await chatsAndSocialsRemoteDatasource.sendOrReplyMessage(
          message: message,
          conversationId: conversationId,
          senderId: senderId,
          parentMessageId: parentMessageId);
      return right(null);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await chatsAndSocialsRemoteDatasource.disconnect();
      return right(null);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> fetchChatMessages(
      {required String conversationId}) async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.fetchChatMessages(
          conversationId: conversationId);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ChatUserData>>> getPeopleChattedWith() async {
    try {
      final result = await chatsAndSocialsLocalDatasource.getChatHistory();
      unawaited(chatsAndSocialsRemoteDatasource.getPeopleChattedWith());
      return right(result);
    } on UnknownException catch (_) {
      //When an error is thrown by the localdatasource,
      //remote sever should handle it.
      //This will call and also handle the getPeople you have chattedWith
      try {
        final result =
            await chatsAndSocialsRemoteDatasource.getPeopleChattedWith();
        return Right(result);
      } catch (e) {
        return left(mapExceptionToFailure(e));
      }
    } catch (e) {
      //Catch other errors coming from the localDataSource
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ChatUser>>> getClappers() async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.getClappers();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> initiateConversation(
      {required String userPid}) async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.initiateConversation(
          userPid: userPid);
      print("sdsjdvsjdhvshdsjhvd--errorr$result");
      return right(result);
    } catch (e) {
      print("sdsjdvsjdhvshdsjhvd--errorr$e");
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> authorizeAndSubScribetoChat(
      {required String conversationId,
      required bool isLiveCombolSubscription}) async {
    try {
      final result =
          await chatsAndSocialsRemoteDatasource.authorizeAndSubScribetoChat(
              conversationId: conversationId,
              isLiveComboSubscription: isLiveCombolSubscription);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> postInteractions() async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.postInteractions();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> clapInComboGround(
      {required String userPid,
      required String username,
      required String comboId,
      required String contextType,
      required String onGoingCombo,
      String? avatar}) async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.clapInComboGround(
          userPid: userPid,
          username: username,
          comboId: comboId,
          contextType: contextType,
          onGoingCombo: onGoingCombo);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> commentComboGround(
      {required String comment,
      required String userPid,
      required String username,
      required String comboId,
      required String contextType,
      required String onGoingCombo,
      String? avatar}) async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.commentComboGround(
          userPid: userPid,
          username: username,
          comboId: comboId,
          avatar: avatar,
          onGoingCombo: onGoingCombo,
          contextType: contextType,
          comment: comment);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> giftInComboGround(
      {required String userPid,
      required String username,
      required String comboId,
      required int amount,
      required String target,
      required String receiverId,
      required String onGoingCombo,
      required String contextType,
      String? avatar}) async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.giftInComboGround(
          amount: amount,
          target: target,
          avatar: avatar,
          receiverId: receiverId,
          userPid: userPid,
          username: username,
          onGoingCombo: onGoingCombo,
          contextType: contextType,
          comboId: comboId);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<LiveGiftingData>>> getComboGifters(
      {required String comboId}) async {
    try {
      final result = await chatsAndSocialsRemoteDatasource.getComboGifters(
          comboId: comboId);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> authorizeandSubCribeForNotification() async {
    try {
      final result = await chatsAndSocialsRemoteDatasource
          .authorizeandSubCribeForNotification();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> readMessage(
      {required String conversationId, required String messageId}) async {
    try {
      await chatsAndSocialsRemoteDatasource.readMessage(
          conversationId: conversationId, messageId: messageId);
      return right(null);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
