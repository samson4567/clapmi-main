import 'package:clapmi/features/chats_and_socials/data/models/clap_request_model.dart';
import 'package:clapmi/features/chats_and_socials/data/models/user_model.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ChatsAndSocialsState extends Equatable {
  const ChatsAndSocialsState();

  @override
  List<Object> get props => [];
}

class ChatsAndSocialsInitial extends ChatsAndSocialsState {
  const ChatsAndSocialsInitial();
}

class ChatsAndSocialPlaceHolder extends ChatsAndSocialsState {
  const ChatsAndSocialPlaceHolder();
}

// Friend States
class GetFriendLoadingState extends ChatsAndSocialsState {
  const GetFriendLoadingState();
}

class GetFriendSuccessState extends ChatsAndSocialsState {
  final String message;

  const GetFriendSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class GetFriendErrorState extends ChatsAndSocialsState {
  final String errorMessage;

  const GetFriendErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
// Friend States ended .....

// Send clap request events
class SendClapRequestToUsersLoadingState extends ChatsAndSocialsState {
  const SendClapRequestToUsersLoadingState();

  @override
  List<Object> get props => [];
}

class SendClapRequestToUsersSuccessState extends ChatsAndSocialsState {
  const SendClapRequestToUsersSuccessState({required this.message});

  final String message;
  @override
  List<Object> get props => [message];
}

class SendClapRequestToUsersErrorState extends ChatsAndSocialsState {
  const SendClapRequestToUsersErrorState({
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
// Send clap request events ended .....

// Get clap request events
class GetClapRequestLoadingState extends ChatsAndSocialsState {
  const GetClapRequestLoadingState();

  @override
  List<Object> get props => [];
}

class GetClapRequestSuccessState extends ChatsAndSocialsState {
  const GetClapRequestSuccessState({
    required this.listOfClapRequest,
  });
  final List<ClapRequestModel> listOfClapRequest;

  @override
  List<Object> get props => [listOfClapRequest];
}

class GetClapRequestErrorState extends ChatsAndSocialsState {
  const GetClapRequestErrorState({
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
// Get clap request events ended .....

// AcceptRequest
class AcceptRequestLoadingState extends ChatsAndSocialsState {
  const AcceptRequestLoadingState(this.requestID);
  final String requestID;

  @override
  List<Object> get props => [];
}

class AcceptRequestSuccessState extends ChatsAndSocialsState {
  const AcceptRequestSuccessState({
    required this.message,
    required this.requestID,
  });
  final String message;
  final String requestID;

  @override
  List<Object> get props => [message];
}

class AcceptRequestErrorState extends ChatsAndSocialsState {
  const AcceptRequestErrorState({
    required this.errorMessage,
    required this.requestID,
  });
  final String errorMessage;
  final String requestID;

  @override
  List<Object> get props => [errorMessage];
}
// AcceptRequest ended .....

// RejectRequest
class RejectRequestLoadingState extends ChatsAndSocialsState {
  const RejectRequestLoadingState(this.requestID);
  final String requestID;

  @override
  List<Object> get props => [];
}

class RejectRequestSuccessState extends ChatsAndSocialsState {
  const RejectRequestSuccessState({
    required this.message,
    required this.requestID,
  });
  final String message;
  final String requestID;

  @override
  List<Object> get props => [message];
}

class RejectRequestErrorState extends ChatsAndSocialsState {
  const RejectRequestErrorState({
    required this.errorMessage,
    required this.requestID,
  });
  final String errorMessage;
  final String requestID;

  @override
  List<Object> get props => [errorMessage];
}
// RejectRequest ended .....

// RejectRequest

class UserNearLocationLoaded extends ChatsAndSocialsState {
  final List<UserNearLocationEntity> users;
  const UserNearLocationLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class PeopleNearLocationLoading extends ChatsAndSocialsState {
  const PeopleNearLocationLoading();
}

class SocketConnected extends ChatsAndSocialsState {
  const SocketConnected();
}

class SocketConnecting extends ChatsAndSocialsState {
  const SocketConnecting();
}

class ChatDataLoaded extends ChatsAndSocialsState {
  final MessageEntity data;
  const ChatDataLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class MessageSent extends ChatsAndSocialsState {
  const MessageSent();
}

// FIX: Added loading state for chat messages
class GetChatMessagesLoadingState extends ChatsAndSocialsState {
  const GetChatMessagesLoadingState();
}

class MessagesFetched extends ChatsAndSocialsState {
  const MessagesFetched({required this.messages, this.isSubscribed = false});
  final List<MessageEntity> messages;
  final bool isSubscribed;

  @override
  List<Object> get props => [messages, isSubscribed];
}

class ChatFriendsLoaded extends ChatsAndSocialsState {
  const ChatFriendsLoaded({required this.chatFriends});
  final List<ChatUserData> chatFriends;
  @override
  List<Object> get props => [chatFriends];
}

class MessageMarkedAsRead extends ChatsAndSocialsState {
  final String conversationId;
  const MessageMarkedAsRead({required this.conversationId});
  @override
  List<Object> get props => [conversationId];
}

class MessageFailedToBeMarkedAsRead extends ChatsAndSocialsState {
  final String conversationId;
  final String messageId;
  final String errorMessage;

  const MessageFailedToBeMarkedAsRead({
    required this.conversationId,
    required this.messageId,
    required this.errorMessage,
  });
  @override
  List<Object> get props => [conversationId];
}

class ClappersLoaded extends ChatsAndSocialsState {
  const ClappersLoaded({required this.friends});
  final List<ChatUser> friends;
  @override
  List<Object> get props => [friends];
}

class ConversationInitiated extends ChatsAndSocialsState {
  const ConversationInitiated({required this.conversationId});
  final String conversationId;
  @override
  List<Object> get props => [conversationId];
}

class ConversationInitiatedFail extends ChatsAndSocialsState {
  const ConversationInitiatedFail({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

class ChatSubscribedSuccessfully extends ChatsAndSocialsState {
  const ChatSubscribedSuccessfully();
}

class ClappersLoading extends ChatsAndSocialsState {
  const ClappersLoading();
}

class Reconnect extends ChatsAndSocialsState {
  const Reconnect();
}

class PostsInteractionsSubscribed extends ChatsAndSocialsState {
  const PostsInteractionsSubscribed();
}

//**THESE ARE LIVE INTERACTION STATE WHICH DOES NOT REQUIRE CALL AND RESPONSE */
//**HENCE MORE OFTEN THAN NOT THERE ARE NOT EVENTS TO BE CALLED FROM THE FRONTEND TO EMIT THIS STATE */
//**SINCE IT IS COMING FROM THE BACKEND REALTIME INTERACTION OR BETTER STILL COMING FROM WEBSOCKET */
class PostClappCount extends ChatsAndSocialsState {
  final PostClappedReaction reaction;
  const PostClappCount({required this.reaction});
  @override
  List<Object> get props => [reaction];
}

class PostCommentCount extends ChatsAndSocialsState {
  const PostCommentCount({required this.postComment});
  final PostCommentLiveReaction postComment;
  @override
  List<Object> get props => [postComment];
}

class PostSharedCount extends ChatsAndSocialsState {
  const PostSharedCount({required this.post});
  final PostSharedReaction post;
  @override
  List<Object> get props => [post];
}

class LiveCommentState extends ChatsAndSocialsState {
  final LiveGroundComment commentData;
  const LiveCommentState({required this.commentData});

  @override
  List<Object> get props => [commentData];
}

class ClappLiveState extends ChatsAndSocialsState {
  final LiveGroundComment clapData;
  const ClappLiveState({required this.clapData});

  @override
  List<Object> get props => [clapData];
}

class UserJoined extends ChatsAndSocialsState {
  final LiveUserInteraction userJoined;
  const UserJoined({required this.userJoined});

  @override
  List<Object> get props => [userJoined];
}

class UserLeaveCombo extends ChatsAndSocialsState {
  final LiveUserInteraction user;
  const UserLeaveCombo({required this.user});

  @override
  List<Object> get props => [user];
}

class ComboEnded extends ChatsAndSocialsState {
  final LiveUserInteraction comboDetails;
  const ComboEnded({required this.comboDetails});

  @override
  List<Object> get props => [comboDetails];
}

class GiftingState extends ChatsAndSocialsState {
  final GiftData gifts;
  const GiftingState({required this.gifts});

  @override
  List<Object> get props => [gifts];
}

class PotAmount extends ChatsAndSocialsState {
  final num totalAmount;
  const PotAmount({required this.totalAmount});

  @override
  List<Object> get props => [totalAmount];
}

class LiveGiftersError extends ChatsAndSocialsState {
  final String errorMessage;
  const LiveGiftersError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ComboGroundInLive extends ChatsAndSocialsState {
  final ComboInLiveStream comboData;
  const ComboGroundInLive({required this.comboData});

  @override
  List<Object> get props => [comboData];
}

class LiveBragInCombo extends ChatsAndSocialsState {
  final LiveBragChallenge challenge;
  const LiveBragInCombo({required this.challenge});

  @override
  List<Object> get props => [challenge];
}
