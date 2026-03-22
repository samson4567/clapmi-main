import 'package:clapmi/features/chats_and_socials/data/models/user_model.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/clap_request_entity.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/message_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';

abstract class ChatsAndSocialsRepository {
  Future<Either<Failure, String>> sendClapRequestToUsers(
      {required String userPids});
  Future<Either<Failure, List<ClapRequestEntity>>> getClapRequests();
  Future<Either<Failure, String>> acceptClapRequests(
      {required String requestID});
  Future<Either<Failure, String>> rejectClapRequests(
      {required String requestID});

  Future<Either<Failure, List<UserNearLocationEntity>>> getUsersNearLocation();

  Future<Either<Failure, void>> connectToSocket();

  Stream<dynamic> listeningToSocket();

  Future<Either<Failure, void>> sendOrReplyMessage({
    required String message,
    String? senderId,
    String? conversationId,
    String? parentMessageId,
  });
  Future<Either<Failure, void>> disconnect();
  Future<Either<Failure, void>> postInteractions();

  Future<Either<Failure, List<MessageEntity>>> fetchChatMessages(
      {required String conversationId});

  Future<Either<Failure, void>> authorizeAndSubScribetoChat(
      {required String conversationId, required bool isLiveCombolSubscription});
  Future<Either<Failure, void>> authorizeandSubCribeForNotification();

  Future<Either<Failure, List<ChatUserData>>> getPeopleChattedWith();
  Future<Either<Failure, List<ChatUser>>> getClappers();
  Future<Either<Failure, String>> initiateConversation(
      {required String userPid});

  Future<Either<Failure, void>> commentComboGround(
      {required String comment,
      required String userPid,
      required String username,
      required String comboId,
      required String contextType,
      required String onGoingCombo,
      String avatar});

  Future<Either<Failure, void>> readMessage(
      {required String conversationId, required String messageId});

  Future<Either<Failure, void>> clapInComboGround(
      {required String userPid,
      required String username,
      required String comboId,
      required String contextType,
      required String onGoingCombo,
      String avatar});
  Future<Either<Failure, void>> giftInComboGround(
      {required String userPid,
      required String username,
      required String comboId,
      required int amount,
      required String target,
      required String receiverId,
      required String onGoingCombo,
      required String contextType,
      String avatar});

  Future<Either<Failure, List<LiveGiftingData>>> getComboGifters(
      {required String comboId});
}
