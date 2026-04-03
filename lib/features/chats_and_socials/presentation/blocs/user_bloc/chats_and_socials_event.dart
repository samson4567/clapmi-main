// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class ChatsAndSocialsEvent extends Equatable {
  const ChatsAndSocialsEvent();

  @override
  List<Object> get props => [];
}

class SendClapRequestToUsersEvent extends ChatsAndSocialsEvent {
  final String userPids;
  const SendClapRequestToUsersEvent({required this.userPids});

  @override
  List<Object> get props => [userPids];
}

class GetClapRequestEvent extends ChatsAndSocialsEvent {
  final bool refreshInBackground;
  final bool forceRefresh;

  const GetClapRequestEvent({
    this.refreshInBackground = false,
    this.forceRefresh = false,
  });

  @override
  List<Object> get props => [refreshInBackground, forceRefresh];
}

class AcceptRequestEvent extends ChatsAndSocialsEvent {
  final String requestID;
  const AcceptRequestEvent(this.requestID);

  @override
  List<Object> get props => [];
}

class RejectRequestEvent extends ChatsAndSocialsEvent {
  final String requestID;
  const RejectRequestEvent(this.requestID);

  @override
  List<Object> get props => [];
}

class GetPeopleNearLocationEvent extends ChatsAndSocialsEvent {
  final bool refreshInBackground;
  final bool forceRefresh;

  const GetPeopleNearLocationEvent({
    this.refreshInBackground = false,
    this.forceRefresh = false,
  });

  @override
  List<Object> get props => [refreshInBackground, forceRefresh];
}
// RejectRequest

class ConnectToSocketEvent extends ChatsAndSocialsEvent {
  const ConnectToSocketEvent();
}

class ChatSubscriptionRequestEvent extends ChatsAndSocialsEvent {
  const ChatSubscriptionRequestEvent();
}

class SendChatMessageEvent extends ChatsAndSocialsEvent {
  final String message;
  final String senderId;
  final String conversationId;
  final String parentMessageId;
  const SendChatMessageEvent({
    required this.message,
    required this.senderId,
    required this.conversationId,
    required this.parentMessageId,
  });
  @override
  List<Object> get props => [message, senderId];
}

class FetchChatMessagesEvent extends ChatsAndSocialsEvent {
  final String conversationId;
  const FetchChatMessagesEvent({required this.conversationId});
}

class GetChatFriendsEvent extends ChatsAndSocialsEvent {
  final bool refreshInBackground;
  final bool forceRefresh;

  const GetChatFriendsEvent({
    this.refreshInBackground = false,
    this.forceRefresh = false,
  });

  @override
  List<Object> get props => [refreshInBackground, forceRefresh];
}

class GetClappersEvent extends ChatsAndSocialsEvent {
  final bool refreshInBackground;
  final bool forceRefresh;

  const GetClappersEvent({
    this.refreshInBackground = false,
    this.forceRefresh = false,
  });

  @override
  List<Object> get props => [refreshInBackground, forceRefresh];
}

class InitiateConversationEvent extends ChatsAndSocialsEvent {
  final String userPid;
  const InitiateConversationEvent({required this.userPid});
}

class SubscribeTochatEvent extends ChatsAndSocialsEvent {
  final String conversationId;
  final bool? isLiveComboSubscription;
  const SubscribeTochatEvent(
      {required this.conversationId, this.isLiveComboSubscription});
}

class PostLiveInteractionsEvent extends ChatsAndSocialsEvent {
  const PostLiveInteractionsEvent();
}

class CommentInComboEvent extends ChatsAndSocialsEvent {
  const CommentInComboEvent(
      {required this.userPid,
      required this.comboId,
      required this.avatar,
      required this.comment,
      required this.contextType,
      required this.onGoingCombo,
      required this.username});
  final String username;
  final String comboId;
  final String userPid;
  final String avatar;
  final String comment;
  final String onGoingCombo;
  final String contextType;

  @override
  List<Object> get props =>
      [userPid, comment, comboId, userPid, avatar, onGoingCombo, contextType];
}

class GiftInComboEvent extends ChatsAndSocialsEvent {
  final String username;
  final String comboId;
  final String avatar;
  final String userPid;
  final int amount;
  final String target;
  final String receiverId;
  final String onGoingCombo;
  final String contextType;
  const GiftInComboEvent({
    required this.username,
    required this.comboId,
    required this.avatar,
    required this.userPid,
    required this.amount,
    required this.receiverId,
    required this.target,
    required this.onGoingCombo,
    required this.contextType,
  });

  @override
  List<Object> get props =>
      [username, comboId, avatar, userPid, onGoingCombo, contextType, target];
}

class ClapInComboEvent extends ChatsAndSocialsEvent {
  final String userPid;
  final String username;
  final String comboId;
  final String avatar;
  final String onGoingCombo;
  final String contextType;
  const ClapInComboEvent({
    required this.userPid,
    required this.username,
    required this.avatar,
    required this.comboId,
    required this.contextType,
    required this.onGoingCombo,
  });

  @override
  List<Object> get props => [avatar, username, userPid, comboId];
}

class GetTotalGiftsEvent extends ChatsAndSocialsEvent {
  final String comboId;
  const GetTotalGiftsEvent({required this.comboId});

  @override
  List<Object> get props => [comboId];
}

class SubscribeToNotificationEvent extends ChatsAndSocialsEvent {
  const SubscribeToNotificationEvent();
}

class MarkMessageAsReadEvent extends ChatsAndSocialsEvent {
  final String conversationId;
  final String messageId;

  const MarkMessageAsReadEvent({
    required this.conversationId,
    required this.messageId,
  });

  @override
  List<Object> get props => [conversationId, messageId];
}
