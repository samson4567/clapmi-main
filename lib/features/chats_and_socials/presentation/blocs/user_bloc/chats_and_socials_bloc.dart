import 'package:clapmi/core/utils.dart';
import 'package:clapmi/core/utils/app_logger.dart';
import 'package:clapmi/features/chats_and_socials/data/models/clap_request_model.dart';
import 'package:clapmi/features/chats_and_socials/data/models/message_model.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/features/chats_and_socials/domain/repositories/chats_and_socials_repository.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsAndSocialsBloc
    extends Bloc<ChatsAndSocialsEvent, ChatsAndSocialsState> {
  final ChatsAndSocialsRepository chatsAndSocialsRepository;

  ChatsAndSocialsBloc({required this.chatsAndSocialsRepository})
      : super(ChatsAndSocialsInitial()) {
    on<SendClapRequestToUsersEvent>(_onSendClapRequestToUsersEvent);
    on<GetClapRequestEvent>(_onGetClapRequestEvent);
    on<AcceptRequestEvent>(_onAcceptRequestEvent);
    on<RejectRequestEvent>(_onRejectRequestEvent);
    on<GetPeopleNearLocationEvent>(_getPeopleNearLocationEventHandler);
    on<ConnectToSocketEvent>(_connectToSocketEventHandler);
    on<ChatSubscriptionRequestEvent>(_onChatSubscriptionRequestEventHandler);
    on<SendChatMessageEvent>(_sendChatMessageEventHandler);
    on<FetchChatMessagesEvent>(_fetchChatMessagesEventHandler);
    on<GetChatFriendsEvent>(_getChatFriendsEventHandler);
    on<GetClappersEvent>(_getClappersEventHandler);
    on<InitiateConversationEvent>(_initiateConversationEventHandler);
    on<SubscribeTochatEvent>(_subscribeTochatEventHandler);
    on<PostLiveInteractionsEvent>(_postLiveInteractionEventHandler);
    on<CommentInComboEvent>(_commentInComboEventHandler);
    on<ClapInComboEvent>(_clapInComboEventHandler);
    on<GiftInComboEvent>(_giftIncomboEventHandler);
    on<GetTotalGiftsEvent>(_getLiveGiftersEventHandler);
    on<SubscribeToNotificationEvent>(_subscribeToNotificationEventHandler);
    on<MarkMessageAsReadEvent>(_markMessageAsReadEventHandler);
    // RejectRequestEvent
  }

  Future<void> _onSendClapRequestToUsersEvent(SendClapRequestToUsersEvent event,
      Emitter<ChatsAndSocialsState> emit) async {
    emit(SendClapRequestToUsersLoadingState());
    final result = await chatsAndSocialsRepository.sendClapRequestToUsers(
        userPids: event.userPids);

    result.fold(
      (error) =>
          emit(SendClapRequestToUsersErrorState(errorMessage: error.message)),
      (data) => emit(
        SendClapRequestToUsersSuccessState(message: data),
      ),
    );
  }

  Future<void> _onGetClapRequestEvent(
      GetClapRequestEvent event, Emitter<ChatsAndSocialsState> emit) async {
    emit(GetClapRequestLoadingState());
    final result = await chatsAndSocialsRepository.getClapRequests();

    result.fold(
      (error) => emit(GetClapRequestErrorState(errorMessage: error.message)),
      (data) => emit(
        GetClapRequestSuccessState(
            listOfClapRequest: data
                .map(
                  (e) => ClapRequestModel.fromEntity(e),
                )
                .toList()),
      ),
    );
  }

  Future<void> _onAcceptRequestEvent(
      AcceptRequestEvent event, Emitter<ChatsAndSocialsState> emit) async {
    emit(AcceptRequestLoadingState(
      event.requestID,
    ));
    final result = await chatsAndSocialsRepository.acceptClapRequests(
        requestID: event.requestID);

    result.fold(
      (error) => emit(AcceptRequestErrorState(
        errorMessage: error.message,
        requestID: event.requestID,
      )),
      (message) => emit(
        AcceptRequestSuccessState(
          message: message,
          requestID: event.requestID,
        ),
      ),
    );
  }

  Future<void> _onRejectRequestEvent(
      RejectRequestEvent event, Emitter<ChatsAndSocialsState> emit) async {
    emit(RejectRequestLoadingState(event.requestID));
    final result = await chatsAndSocialsRepository.rejectClapRequests(
        requestID: event.requestID);

    result.fold(
      (error) => emit(RejectRequestErrorState(
          errorMessage: error.message, requestID: event.requestID)),
      (message) => emit(
        RejectRequestSuccessState(message: message, requestID: event.requestID),
      ),
    );
  }

  Future<void> _getPeopleNearLocationEventHandler(
      GetPeopleNearLocationEvent event,
      Emitter<ChatsAndSocialsState> emit) async {
    emit(PeopleNearLocationLoading());
    final result = await chatsAndSocialsRepository.getUsersNearLocation();

    result.fold(
        (error) => "",
        // emit(RejectRequestErrorState(errorMessage: error.message)),
        (user) => emit(UserNearLocationLoaded(users: user)));
  }

  Future<void> _connectToSocketEventHandler(
      ConnectToSocketEvent event, Emitter<ChatsAndSocialsState> emit) async {
    emit(SocketConnecting());
    final result = await chatsAndSocialsRepository.connectToSocket();
    result.fold(
      (error) => "",
      //  emit(RejectRequestErrorState(errorMessage: error.message)),
      (_) => emit(SocketConnected()),
    );
  }

  Future<void> _onChatSubscriptionRequestEventHandler(
      ChatSubscriptionRequestEvent event,
      Emitter<ChatsAndSocialsState> emit) async {
    await emit.forEach(
      chatsAndSocialsRepository.listeningToSocket(),
      onData: (data) {
        AppLogger.debug("Socket data: ${[data['data'], data]}", tag: 'BLOC');

        if (data['data'] == 'Reconnecting...') {
          return Reconnect();
        } else if (data['data'] == 'connected') {
          return ChatSubscribedSuccessfully();
        } else if (data['event'] == 'PostClappedReaction') {
          PostClappedReaction dataSet = data['data'];
          return PostClappCount(reaction: dataSet);
        } else if (data['event'] == 'PostShared') {
          PostSharedReaction post = data['data'];
          return PostSharedCount(post: post);
        } else if (data['event'] == 'PostCommented') {
          PostCommentLiveReaction postReaction = data['data'];
          return PostCommentCount(postComment: postReaction);
        } else if (data['event'] == 'CommentedInComboGround') {
          LiveGroundComment liveComment = data['data'];
          AppLogger.debug('Live comment: $liveComment', tag: 'BLOC');
          return LiveCommentState(commentData: liveComment);
        } else if (data['event'] == 'ClappedInComboGround') {
          LiveGroundComment clapped = data['data'];
          return ClappLiveState(clapData: clapped);
        } else if (data['event'] == 'ComboGroundJoined') {
          // print("the comboData ${data['data']}");
          LiveUserInteraction userJoined = data['data'];
          // print("**************************** $userJoined");
          return UserJoined(userJoined: userJoined);
        } else if (data['event'] == 'ComboGroundLeft') {
          LiveUserInteraction userLeft = data['data'];
          return UserLeaveCombo(user: userLeft);
        } else if (data['event'] == 'ComboGroundEnded') {
          LiveUserInteraction comboEnded = data['data'];
          return ComboEnded(comboDetails: comboEnded);
        } else if (data['event'] == 'GiftedCoinInComboGround') {
          GiftData userGifted = data['data'];
          return GiftingState(gifts: userGifted);
        } else if (data['event'] == 'ComboGroundInALiveStreamIsLive') {
          ComboInLiveStream comboData = data['data'];
          return ComboGroundInLive(comboData: comboData);
        } else if (data['event'] == 'BragChallengesUpdated') {
          LiveBragChallenge bragData = data['data'];
          return LiveBragInCombo(challenge: bragData);
        } else {
          Map<String, dynamic> dataSet = data['data'];
          final newMessage = MessageEntityModel.fromMap(dataSet);
          // print(
          //     "########################This is the data coming from the pusher server echoing I guess $newMessage");
          return ChatDataLoaded(newMessage);
        }
      },
    );
  }

  Future<void> _sendChatMessageEventHandler(
      SendChatMessageEvent event, Emitter<ChatsAndSocialsState> emit) async {
    final response = await chatsAndSocialsRepository.sendOrReplyMessage(
      message: event.message,
      senderId: event.senderId,
      conversationId: event.conversationId,
      parentMessageId: event.parentMessageId,
    );
    response.fold(
        (error) => "",
        // emit(RejectRequestErrorState(errorMessage: error.message)),
        (_) => emit(MessageSent()));
  }

  Future<void> _fetchChatMessagesEventHandler(
      FetchChatMessagesEvent event, Emitter<ChatsAndSocialsState> emit) async {
    AppLogger.debug(
        'FetchChatMessagesEvent for conversation: ${event.conversationId}',
        tag: 'BLOC');

    if (event.conversationId.isEmpty) {
      AppLogger.warning('Empty conversationId!', tag: 'BLOC');
      emit(GetFriendErrorState(errorMessage: 'Invalid conversation ID'));
      return;
    }

    // FIX: Emit loading state before making API call
    emit(const GetChatMessagesLoadingState());

    final response = await chatsAndSocialsRepository.fetchChatMessages(
        conversationId: event.conversationId);

    response.fold((error) {
      AppLogger.error('Error fetching messages: ${error.message}', tag: 'BLOC');
      emit(GetFriendErrorState(errorMessage: error.message));
    }, (messages) {
      AppLogger.debug(
          'Fetched ${messages.length} messages - emitting MessagesFetched state',
          tag: 'BLOC');
      emit(MessagesFetched(messages: messages));
      AppLogger.debug('MessagesFetched emitted, waiting for subscription...',
          tag: 'BLOC');
    });
  }

  Future<void> _getChatFriendsEventHandler(
      GetChatFriendsEvent event, Emitter<ChatsAndSocialsState> emit) async {
    emit(GetFriendLoadingState());
    final response = await chatsAndSocialsRepository.getPeopleChattedWith();

    response.fold(
        (error) => emit(GetFriendErrorState(errorMessage: error.message)),
        (friends) => emit(ChatFriendsLoaded(chatFriends: friends)));
  }

  Future<void> _getClappersEventHandler(
      GetClappersEvent event, Emitter<ChatsAndSocialsState> emit) async {
    emit(ClappersLoading());
    final response = await chatsAndSocialsRepository.getClappers();
    response.fold(
        (error) => emit(GetFriendErrorState(errorMessage: error.message)),
        (friends) => emit(ClappersLoaded(friends: friends)));
  }

  Future<void> _initiateConversationEventHandler(
      InitiateConversationEvent event,
      Emitter<ChatsAndSocialsState> emit) async {
    AppLogger.debug('Initiating conversation with userPid: ${event.userPid}',
        tag: 'BLOC');
    final response = await chatsAndSocialsRepository.initiateConversation(
        userPid: event.userPid);
    AppLogger.debug('Initiate conversation response: $response', tag: 'BLOC');
    response.fold(
        (error) => emit(ConversationInitiatedFail(message: error.message)),
        (conversationId) =>
            emit(ConversationInitiated(conversationId: conversationId)));
  }

  Future<void> _subscribeTochatEventHandler(
      SubscribeTochatEvent event, Emitter<ChatsAndSocialsState> emit) async {
    AppLogger.debug('Calling live subscription...', tag: 'BLOC');
    final response =
        await chatsAndSocialsRepository.authorizeAndSubScribetoChat(
            conversationId: event.conversationId,
            isLiveCombolSubscription: event.isLiveComboSubscription ?? false);
    response.fold(
        (error) => emit(GetFriendErrorState(errorMessage: error.message)), (_) {
      // Don't emit any state - subscription is background work
      // Messages are already displayed, don't replace them
      AppLogger.debug('Subscription successful (silent - not emitting state)',
          tag: 'BLOC');
    });
  }

  Future<void> _postLiveInteractionEventHandler(PostLiveInteractionsEvent event,
      Emitter<ChatsAndSocialsState> emit) async {
    final response = await chatsAndSocialsRepository.postInteractions();
    response.fold(
        (error) => emit(GetFriendErrorState(errorMessage: error.message)),
        (_) => emit(PostsInteractionsSubscribed()));
  }

  Future<void> _commentInComboEventHandler(
      CommentInComboEvent event, Emitter<ChatsAndSocialsState> emit) async {
    final response = await chatsAndSocialsRepository.commentComboGround(
      avatar: event.avatar,
      comment: event.comment,
      userPid: event.userPid,
      username: event.username,
      comboId: event.comboId,
      contextType: event.contextType,
      onGoingCombo: event.onGoingCombo,
    );
    response.fold(
        (error) => emit(GetFriendErrorState(errorMessage: error.message)),
        (_) => emit(PostsInteractionsSubscribed()));
  }

  Future<void> _clapInComboEventHandler(
      ClapInComboEvent event, Emitter<ChatsAndSocialsState> emit) async {
    final response = await chatsAndSocialsRepository.clapInComboGround(
        userPid: event.userPid,
        username: event.username,
        comboId: event.comboId,
        onGoingCombo: event.onGoingCombo,
        contextType: event.contextType,
        avatar: event.avatar);
    response.fold(
        (error) => emit(GetFriendErrorState(errorMessage: error.message)),
        (_) => emit(PostsInteractionsSubscribed()));
  }

  Future<void> _giftIncomboEventHandler(
      GiftInComboEvent event, Emitter<ChatsAndSocialsState> emit) async {
    AppLogger.debug('Gift event avatar: ${event.avatar}', tag: 'BLOC');
    final response = await chatsAndSocialsRepository.giftInComboGround(
        userPid: event.userPid,
        username: event.username,
        comboId: event.comboId,
        avatar: event.avatar,
        receiverId: event.receiverId,
        target: event.target,
        amount: event.amount,
        contextType: event.contextType,
        onGoingCombo: event.onGoingCombo);
    response.fold(
        (error) => emit(GetFriendErrorState(errorMessage: error.message)),
        (_) => emit(PostsInteractionsSubscribed()));
  }

  Future<void> _getLiveGiftersEventHandler(
      GetTotalGiftsEvent event, Emitter<ChatsAndSocialsState> emit) async {
    num totalAmount = 0;
    final response =
        await chatsAndSocialsRepository.getComboGifters(comboId: event.comboId);
    response
        .fold((error) => emit(LiveGiftersError(errorMessage: error.message)),
            (users) {
      for (var user in users) {
        totalAmount = totalAmount + user.totalAmount!;
      }
      emit(PotAmount(totalAmount: totalAmount));
    });
  }

  Future<void> _subscribeToNotificationEventHandler(
      SubscribeToNotificationEvent event,
      Emitter<ChatsAndSocialsState> emit) async {
    final response =
        await chatsAndSocialsRepository.authorizeandSubCribeForNotification();
    response.fold(
        (error) => emit(GetFriendErrorState(errorMessage: error.message)),
        (_) => emit(PostsInteractionsSubscribed()));
  }

  Future<void> _markMessageAsReadEventHandler(
      MarkMessageAsReadEvent event, Emitter<ChatsAndSocialsState> emit) async {
    AppLogger.debug(
        'Marking message as read - conversationId: ${event.conversationId}, messageId: ${event.messageId}',
        tag: 'BLOC');
    final response = await chatsAndSocialsRepository.readMessage(
        conversationId: event.conversationId, messageId: event.messageId);
    response.fold((error) {
      emit(MessageFailedToBeMarkedAsRead(
          conversationId: event.conversationId,
          errorMessage: error.message,
          messageId: event.messageId));
      AppLogger.error('Error marking message as read: ${error.message}',
          tag: 'BLOC');
    }, (_) {
      AppLogger.debug('Message marked as read successfully', tag: 'BLOC');
      emit(MessageMarkedAsRead(conversationId: event.conversationId));
    });
  }
}
