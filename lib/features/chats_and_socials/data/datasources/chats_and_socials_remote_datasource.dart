import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/api/multi_env.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/core/network_info/network_info.dart';
import 'package:clapmi/core/security/secure_key.dart';
import 'package:clapmi/core/utils.dart';
import 'package:clapmi/core/utils/app_logger.dart';
import 'package:clapmi/features/authentication/data/models/token_model.dart';
import 'package:clapmi/features/chats_and_socials/data/datasources/chats_and_socials_local_datasource.dart';
import 'package:clapmi/features/chats_and_socials/data/models/chat_user_model.dart';
import 'package:clapmi/features/chats_and_socials/data/models/clap_request_model.dart';
import 'package:clapmi/features/chats_and_socials/data/models/live_reactions_model.dart';
import 'package:clapmi/features/chats_and_socials/data/models/message_model.dart';
import 'package:clapmi/features/chats_and_socials/data/models/user_model.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/clap_request_entity.dart';
import 'package:clapmi/screens/NetworkAndRewards/network.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_client/web_socket_client.dart';

typedef EventCallback = void Function(Map<String, dynamic> data);

abstract class ChatsAndSocialsRemoteDatasource {
  Future<List<ClapRequestEntity>> getClapRequests();
  Future<String> sendClapRequestToUsers({required String userPids});
  Future<String> acceptClapRequests({required String requestID});
  Future<String> rejectClapRequests({required String requestID});
  Future<List<UserNearLocationEntity>> getUsersNearLocation();
  Future<void> connectToSocket();
  Stream<dynamic> listeningToSocket();
  Future<void> sendOrReplyMessage({
    required String message,
    String? senderId,
    String? conversationId,
    String? parentMessageId,
  });
  Future<void> disconnect();
  Future<List<MessageEntityModel>> fetchChatMessages(
      {required String conversationId});

  Future<List<ChatUserDataModel>> getPeopleChattedWith();
  Future<void> authorizeAndSubScribetoChat(
      {required String conversationId, required bool isLiveComboSubscription});
  Future<void> postInteractions();
  Future<void> readMessage(
      {required String conversationId, required String messageId});
  Future<List<ChatUserModel>> getClappers();

  Future<String> initiateConversation({required String userPid});

  Future<void> commentComboGround(
      {required String comment,
      required String userPid,
      required String username,
      required String comboId,
      required String contextType,
      required String onGoingCombo,
      String? avatar});

  Future<void> giftInComboGround(
      {required String userPid,
      required String username,
      required String comboId,
      required int amount,
      required String target,
      required String receiverId,
      required String onGoingCombo,
      required String contextType,
      String? avatar});

  Future<void> clapInComboGround(
      {required String userPid,
      required String username,
      required String comboId,
      required String contextType,
      required String onGoingCombo,
      String? avatar});

  Future<void> authorizeandSubCribeForNotification();

  Future<List<LiveGiftingDataModel>> getComboGifters({required String comboId});
}

class ChatsAndSocialsRemoteDatasourceImpl
    implements ChatsAndSocialsRemoteDatasource {
  ChatsAndSocialsRemoteDatasourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
    required this.localSource,
    required this.dio,
  }) : socketStream = StreamController.broadcast();
  final AppPreferenceService appPreferenceService;
  final ChatsAndSocialsLocalDatasource localSource;

  final ClapMiNetworkClient networkClient;
  Map<String, dynamic> chatIds = {};
  WebSocket? socket;
  final Dio dio;

  String? accessTokenSaved;
  String? receiverIdSaved;

  final StreamController<dynamic> socketStream;
  Map<String, dynamic> liveComboId = {};

  @override
  Future<String> sendClapRequestToUsers({required String userPids}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.sendClapRequests,
      isAuthHeaderRequired: true,
      data: {
        "users": [userPids]
      },
      options: Options(),
    );
    return response.message;
  }

  @override
  Future<List<ClapRequestEntity>> getClapRequests() async {
    try {
      final response = await networkClient.get(
        endpoint: EndpointConstant.clapRequest,
        isAuthHeaderRequired: true,
      );

      print('🔍 Raw response.data: ${response.data}');
      try {
        (response.data as List);
        return [];
      } catch (e) {}

      // ✅ FIX: Remove the ['data'] - clap_requests is at the root level
      final clapRequestsList =
          response.data['clap_requests'] as List<dynamic>? ?? [];

      print('🔍 Clap Requests Count: ${clapRequestsList.length}');

      final result = clapRequestsList
          .map((e) {
            try {
              final map = Map<String, dynamic>.from(e as Map);
              return ClapRequestModel.fromJson(map);
            } catch (error) {
              print('❌ Error parsing item: $error');
              return null;
            }
          })
          .whereType<ClapRequestModel>()
          .toList();

      print('🔍 Parsed Entities Count: ${result.length}');

      return result;
    } catch (e, stackTrace) {
      print('❌ Error in getClapRequests: $e');
      print('❌ StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<String> acceptClapRequests({required String requestID}) async {
    print("This is the accept clap request in $requestID");
    final response = await networkClient.post(
      endpoint: EndpointConstant.acceptClapRequest,
      isAuthHeaderRequired: true,
      data: {
        "request": requestID,
      },
    );
    // print("This is the response coming from accept clap request");
    return response.message;
  }

  @override
  Future<String> rejectClapRequests({required String requestID}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.rejectClapRequest,
      isAuthHeaderRequired: true,
      data: {
        "request": requestID,
      },
    );
    return response.message;
  }

  @override
  Future<List<UserNearLocationEntity>> getUsersNearLocation() async {
    try {
      final response = await networkClient.get(
        endpoint: EndpointConstant.getPeopleNearMe,
        isAuthHeaderRequired: true,
      );

      print('🔍 Raw response.data: ${response.data}');

      // ✅ FIX: users is directly in response.data, not nested in data
      final usersList = response.data['users'] as List<dynamic>?;

      if (usersList == null || usersList.isEmpty) {
        print('❌ users list is null or empty');
        return [];
      }

      print('🔍 Users count: ${usersList.length}');

      // ✅ Safe parsing with proper type conversion
      final result = usersList
          .map((user) {
            try {
              // Convert to proper Map type
              final userMap = Map<String, dynamic>.from(user as Map);
              print(
                  '🔍 Parsing: ${userMap['name']} - Image: ${userMap['image']}');
              return UserNearLocationEntity.fromMap(userMap);
            } catch (e) {
              print('❌ Error parsing user: $e');
              print('❌ User data: $user');
              return null;
            }
          })
          .whereType<UserNearLocationEntity>()
          .toList();

      print('✅ Successfully parsed ${result.length} users');

      if (result.isNotEmpty) {
        print('🔍 First user: ${result.first.name}');
        print('🔍 First user image: ${result.first.image}');
      }

      return result;
    } catch (e, stackTrace) {
      print('❌ Error in getUsersNearLocation: $e');
      print('❌ StackTrace: $stackTrace');
      throw Exception('An error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> connectToSocket() async {
    try {
      print('This is trying to connect the websocket again......');
      final loginToken =
          appPreferenceService.getValue<String>(SecureKey.loginAuthTokenKey);
      final authToken = TokenModel.deserialize(loginToken ?? '');
      globalAccessToken = authToken.accessToken;
      socket = WebSocket(
          Uri.parse(
            MultiEnv().webSocketApiUrl,
          ),
          headers: {
            'Authorization': authToken.accessToken,
          });
      // await socket?.connection
      //     .firstWhere((state) => state is Connected || state is Reconnected);
      // postInteractions();
    } catch (e) {
      print('❌ Connection failed:${e.toString()}');
    }
  }

  @override
  Future<void> authorizeandSubCribeForNotification() async {
    try {
      final response = await dio.post(MultiEnv().webSocketAuthUrl,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': globalAccessToken,
            },
          ),
          data: {
            'socket_id': socketId,
            'channel_name': 'notification.${profileModelG?.pid}'
          });
      if (response.statusCode == 200) {
        final result = response.data['auth'];
        subscribeToNotification(authToken: result);
      }
    } catch (e) {
      print('notification subscription error is this ${e.toString()}');
    }
  }

  //So I need to get the conversation_id from the screen...
  //That is the chatPage
  @override
  Future<void> authorizeAndSubScribetoChat({
    required String conversationId,
    required bool isLiveComboSubscription,
  }) async {
    try {
      if (await ConnectivityHelper.hasInternetConnection()) {
        final response = await dio.post(MultiEnv().webSocketAuthUrl,
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Authorization': globalAccessToken,
              },
            ),
            data: {
              'socket_id': socketId,
              'channel_name': isLiveComboSubscription
                  ? 'private-combo-ground.$conversationId'
                  : 'private-chat.$conversationId',
            });

        if (response.statusCode == 200) {
          final result = response.data['auth'];
          if (isLiveComboSubscription) {
            print('LIVECOMBO SUBSCRIPTION HERE OOOOOOOOOOOOOOO------');
            subscribeToLiveCombo(authToken: result, uuid: conversationId);
          } else {
            subscribeToChannel(
                authToken: result, conversationId: conversationId);
          }
        }
      } else {
        throw const NetworkConnect();
      }
    } catch (e) {
      print(
          'Printing error of the subscription $e -----------------!!!!!!!!!!!!!!');
    }
  }

  void subscribeToPostClappChannel() {
    if (socket == null) return;
    final subscribeMessage = {
      'event': 'pusher:subscribe',
      'data': {
        'channel': 'post-clapped-reaction',
      },
    };
    socket?.send(jsonEncode(subscribeMessage));
    print('Subscribed to post reaction channel');
  }

  void subscribeToCommentChannel() {
    if (socket == null) return;
    final subscribeMessage = {
      'event': 'pusher:subscribe',
      'data': {'channel': 'post-commented'}
    };
    socket?.send(jsonEncode(subscribeMessage));
  }

  void subscribeToPostShared() {
    if (socket == null) return;
    final subscribeMesage = {
      'event': 'pusher:subscribe',
      'data': {'channel': 'post-shared'}
    };
    socket?.send(jsonEncode(subscribeMesage));
  }

  void subscribeToNotification({required String authToken}) {
    final subscribeMessage = {
      "event": 'pusher:subscribe',
      'data': {
        'channel': 'notification.${profileModelG?.pid}',
        'auth': authToken,
      }
    };
    socket?.send(jsonEncode(subscribeMessage));
    ("Subscribing to the notification Channel");
  }

  void subscribeToLiveCombo({required String authToken, required String uuid}) {
    final subscribeMessage = {
      'event': 'pusher:subscribe',
      'data': {
        'channel': 'combo-ground.$uuid',
        // 'auth': authToken,
      },
    };
    socket?.send(jsonEncode(subscribeMessage));
    //  liveComboId.clear();
    if (liveComboId[uuid] == null) {
      liveComboId[uuid] = uuid;
    }
    print('📨 Subscribed to channel:');
  }

  //**THIS IS TO SUBSCRIBE TO THE CHAT CHANNELS */
  void subscribeToChannel(
      {required String? authToken, required String conversationId}) {
    //**Check if the socket is connected */
    // if (socket?.connection.state  Connected) return;
    //**Check if the conversation is already existing */
    final subscribeMessage = {
      'event': 'pusher:subscribe',
      'data': {
        'channel': 'private-chat.$conversationId',
        'auth': authToken,
      },
    };
    socket?.send(jsonEncode(subscribeMessage));
    if (chatIds[conversationId] == null) {
      chatIds[conversationId] = conversationId;
    }
    print('📨 Subscribed to channel:');
  }

  @override
  Future<void> postInteractions() async {
    try {
      subscribeToPostClappChannel();
      subscribeToCommentChannel();
      subscribeToPostShared();
    } catch (e) {
      print('Failed to subscribe to all of them .....');
    }
  }

//When the stuff is connected, I think I need to return the socket_Id
//Or save the socket_Id as a global variable and then access it from that point.
  @override
  Stream<dynamic> listeningToSocket()
  //=>  socket!.asBroadcastStream();
  {
    socket?.messages.listen((data) {
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ $data');
      Map<String, dynamic> dataDecoded =
          jsonDecode(data) as Map<String, dynamic>;
      if (dataDecoded['event'] == 'pusher:connection_established') {
        postInteractions();
        //  authorizeandSubCribeForNotification();
        final connectionData =
            jsonDecode(dataDecoded['data']) as Map<String, dynamic>;
        socketId = connectionData['socket_id'];
        socketStream.add({'data': 'connected'});
        //for resubscription to the chats when the pusher is reconnected;
        //RESUBSCRIPTION FOR CHATS
        if (chatIds.values.isNotEmpty) {
          for (final channelId in chatIds.values) {
            authorizeAndSubScribetoChat(
                conversationId: channelId, isLiveComboSubscription: false);
          }
        }
        //RESUBSCRIPTION TO THE LIVE COMBOS
        //AND IT SHOULD BE ONE CHANNEL AT A TIME IN THIS CASE
        if (liveComboId.values.isNotEmpty) {
          for (final liveIds in liveComboId.values) {
            authorizeAndSubScribetoChat(
                conversationId: liveIds, isLiveComboSubscription: true);
          }
        }
        return;
      }
      //       //Event to listen to when Message is sent
      if (dataDecoded['event'] == 'MessageStatus') {
        final connectionData =
            jsonDecode(dataDecoded['data']) as Map<String, dynamic>;
        print('This is the connectionData $connectionData');
        final String message = connectionData['data'];
        //['message'];
        //ADD THIS MESSAGE TO THE STREAMCONTROLLER WHICH IS GOING TO THE SCREEN.
        socketStream.add({
          "data": message,
        });
        return;
      }
      //Event to listen to when message is sent by the User and echo it back.
      if (dataDecoded['event'] == 'message.saved') {
        final connectionData =
            jsonDecode(dataDecoded['data']) as Map<String, dynamic>;
        final message = connectionData['data'];
        socketStream.add({"data": message});
        return;
      }
      //       if (dataDecoded['event'] ==
      //           '"pusher_internal:subscription_succeeded') {
      //         socketStream.add({"data": 'subscribed'});
      //       }
      //       // if(dataDecoded['event'] == 'MessageRead') {
      //       //   final connectionData = jsonDecode(dataDecoded['data']) as Map<String, dynamic>;
      //       //   final message = connectionData['data'];
      //       //   return;
      //       // }
      //**WHEN EVENT IS POSTCLAPPREACTION */
      if (dataDecoded['event'] == 'PostClappedReaction') {
        final connectionData =
            PostClappReactionModel.fromJson(dataDecoded['data']);
        socketStream
            .add({"event": dataDecoded['event'], "data": connectionData});
      }
      //**WHEN THE EVENT IS POST SHARED */
      if (dataDecoded['event'] == 'PostShared') {
        final connectionData =
            PostSharedReactionModel.fromJson(dataDecoded['data']);
        socketStream
            .add({'event': dataDecoded['event'], "data": connectionData});
      }
      //**WHEN THE EVENT IS POST COMMENTED */
      if (dataDecoded['event'] == 'PostCommented') {
        final connectionData =
            PostCommentLiveReactionModel.fromJson(dataDecoded['data']);
        socketStream
            .add({"event": dataDecoded['event'], "data": connectionData});
      }
      //**WHEN THE LIVE INTERACTION IS COMMENTEDINCOMBOGROUND */
      if (dataDecoded['event'] == 'CommentedInComboGround') {
        var connectionData =
            LiveGroundCommentModel.fromJson(dataDecoded['data']);
        //**IN CASE THE DEFAULT AVATAR WAS USED, IT WOULD FIRST BE CONVERTED BEFORE USE */
        if (connectionData.user != null &&
            connectionData.user!.avatar!.contains(".svg")) {
          convertAvatar(avatar: connectionData.user!.avatar ?? '');
          connectionData.user?.avatarConvert = tempAvatarData;
        }
        socketStream
            .add({"event": dataDecoded['event'], 'data': connectionData});
      }
      if (dataDecoded['event'] == 'ClappedInComboGround') {
        final connectionData =
            LiveGroundCommentModel.fromJson(dataDecoded['data']);
        socketStream
            .add({'event': dataDecoded['event'], 'data': connectionData});
      }
      if (dataDecoded['event'] == 'ComboGroundJoined') {
        final connectionData =
            LiveUserInteractionModel.fromJson(dataDecoded['data']);
        print("This is the comboJoin $connectionData");
        socketStream
            .add({'event': dataDecoded['event'], 'data': connectionData});
      }
      if (dataDecoded['event'] == 'ComboGroundLeft') {
        final connectionData =
            LiveUserInteractionModel.fromJson(dataDecoded['data']);
        socketStream
            .add({'event': dataDecoded['event'], 'data': connectionData});
      }
      if (dataDecoded['event'] == 'ComboGroundEnded') {
        final connectionData =
            LiveUserInteractionModel.fromJson(dataDecoded['data']);
        socketStream
            .add({'event': dataDecoded['event'], 'data': connectionData});
      }
      if (dataDecoded['event'] == 'GiftedCoinInComboGround') {
        var connectionData = GiftDataModel.fromJson(dataDecoded['data']);
        //**CONVERT THE AVATAR TO THE KNOWN DATA IN SVG FOR PROPER RENDERING */
        if (connectionData.giftdata?.sender != null &&
            connectionData.giftdata!.sender!.avatar!.contains(".svg")) {
          convertAvatar(avatar: connectionData.giftdata?.sender?.avatar ?? '');
          connectionData.giftdata?.sender?.avatarConvert = tempAvatarData;
        }
        print('This is the giftingCoin messages $connectionData');
        socketStream
            .add({'event': dataDecoded['event'], 'data': connectionData});
      }
      if (dataDecoded['event'] == "ComboGroundInALiveStreamIsLive") {
        print("This is calling this event already");
        var connectionData =
            ComboInLiveStreamModel.fromJson(dataDecoded['data']);
        if (connectionData.challenger != null &&
            connectionData.challenger!.image!.contains(".svg")) {
          convertAvatar(avatar: connectionData.challenger?.image ?? '');
          connectionData.challenger?.avatar = tempAvatarData;
        }
        socketStream
            .add({'event': dataDecoded['event'], 'data': connectionData});
      }
      if (dataDecoded['event'] == "BragChallengesUpdated") {
        print("Testing the bragChallenges here updating here-----");
        var connectionData =
            LiveBragChallengeModel.fromJson(dataDecoded['data']);
        socketStream
            .add({'event': dataDecoded['event'], 'data': connectionData});
      }
    }, onError: (e) {
      print("***************************This is the error of the listnerer $e");
    });
    return socketStream.stream;
  }

  @override
  Future<void> sendOrReplyMessage({
    required String message,
    String? senderId,
    String? conversationId,
    String? parentMessageId,
  }) async {
    if (socket == null) {
      print('❌ Not connected to WebSocket server');
      return;
    }
    final messageData = {
      'event': 'MessageSent',
      'channel': 'private-chat.$conversationId',
      'data': {
        'conversation_id': conversationId,
        'sender': senderId,
        'message': message,
        'reply_to': parentMessageId == null ? parentMessageId : '',
      },
    };
    socket?.send(jsonEncode(messageData));
    print('📤 Sent message: $messageData');
  }

  @override
  Future<void> commentComboGround(
      {required String comment,
      required String userPid,
      required String username,
      required String comboId,
      required String contextType,
      required String onGoingCombo,
      String? avatar}) async {
    if (socket == null) {
      print('❌ Not connected to WebSocket server');
      return;
    }
    final commentPayload = {
      'event': 'CommentInComboGround',
      'channel': 'combo-ground.$comboId',
      'data': {
        'message': comment,
        'user': userPid,
        'username': username,
        'avatar': avatar,
        'contextType': contextType,
        'onGoingCombo': onGoingCombo,
      }
    };
    socket?.send(jsonEncode(commentPayload));
    print('📤 Sent Live Comment: $commentPayload');
  }

  @override
  Future<void> clapInComboGround(
      {required String userPid,
      required String username,
      required String comboId,
      required String contextType,
      required String onGoingCombo,
      String? avatar}) async {
    if (socket == null) {
      print('❌ Not connected to WebSocket server');
      return;
    }
    final clapPayload = {
      'event': 'ClapInComboGround',
      'channel': 'combo-ground.$comboId',
      'data': {
        'user': userPid,
        'username': username,
        'avatar': avatar,
        'contextType': contextType,
        'onGoingCombo': onGoingCombo,
      }
    };
    socket?.send(jsonEncode(clapPayload));
    print('📤 clap Live: $clapPayload');
  }

  @override
  Future<void> giftInComboGround(
      {required String userPid,
      required String username,
      required String comboId,
      required int amount,
      required String target,
      required String receiverId,
      required String onGoingCombo,
      required String contextType,
      String? avatar}) async {
    if (socket == null) {
      print('❌ Not connected to WebSocket server');
      return;
    }
    final giftPayload = {
      'event': 'GiftingInComboGround',
      'channel': 'combo-ground.$comboId',
      'data': {
        'sender': {
          'user': userPid,
          'username': username,
          'avatar': avatar,
        },
        'receiver': receiverId,
        'amount': amount,
        'target': target,
        'contextType': contextType,
        'comboGround': onGoingCombo,
      }
    };
    socket?.send(jsonEncode(giftPayload));
    print('📤 giftCombo: $giftPayload');
  }

  @override
  Future<void> disconnect() async {
    //  socket?.close();
    socketStream.close();
    print('🔌 Disconnected from WebSocket server');
  }

  @override
  Future<List<MessageEntityModel>> fetchChatMessages(
      {required String conversationId}) async {
    print('fgghdd$conversationId');

    try {
      final response = await networkClient.get(
          endpoint: EndpointConstant.fetchChatMessages,
          isAuthHeaderRequired: true,
          params: {
            "conversation": conversationId,
          });

      // API returns: { success, message, data: { messages: [...] } }
      // BaseResponse.data = the 'data' field from API = { messages: [...] }
      // So response.data['messages'] = the actual messages array
      final messagesData = response.data['messages'];
      if (messagesData == null) {
        return [];
      }
      print('dhdhdhdh$messagesData');
      final result = (messagesData as List)
          .map((e) => MessageEntityModel.fromMap(e))
          .toList();
      return result;
    } catch (e) {
      print('fhfhfhfhfh$e');
      return [];
    }
  }

  @override
  Future<List<ChatUserDataModel>> getPeopleChattedWith() async {
    try {
      final response = await networkClient.get(
          endpoint: EndpointConstant.chatFriends, isAuthHeaderRequired: true);

      AppLogger.debug('API response for getPeopleChattedWith: ${response.data}',
          tag: 'REMOTE_DS');

      final result = (response.data as List)
          .map((e) => ChatUserDataModel.fromMap(e, false))
          .toList();

      AppLogger.debug('Parsed ${result.length} chat friends', tag: 'REMOTE_DS');

      //Updating the local storage with the new data coming
      await localSource.deleteChatHistory();
      await localSource.insertChatList(chatHistory: result);

      AppLogger.debug('Saved ${result.length} chat friends to local storage',
          tag: 'REMOTE_DS');

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get people chatted with',
        tag: 'REMOTE_DS',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> readMessage(
      {required String conversationId, required String messageId}) async {
    if (socket == null) {
      print('❌ Not connected to WebSocket server');
      return;
    }
    final messageReadPayload = {
      'event': 'MessageRead',
      'channel': 'private-chat.$conversationId',
      'data': {
        'conversation_id': conversationId,
        "uuid": messageId,
      },
    };
    socket?.send(jsonEncode(messageReadPayload));
    print('📤 Message Read: $conversationId');
  }

  @override
  Future<List<ChatUserModel>> getClappers() async {
    final response = await networkClient.get(
        endpoint: EndpointConstant.clappers, isAuthHeaderRequired: true);
    final result = (response.data['clappers'] as List)
        .map((e) => ChatUserModel.fromMap(e))
        .toList();
    return result;
  }

  @override
  Future<String> initiateConversation({required String userPid}) async {
    print("sdsjdvsjdhvshdsjhvd-000");
    final response = await networkClient.post(
        endpoint: EndpointConstant.createConversation,
        isAuthHeaderRequired: true,
        params: {
          'partner': userPid,
        });
    print("sdsjdvsjdhvshdsjhvd-111");
    final result = response.data['conversation_id'] as String;
    print("sdsjdvsjdhvshdsjhvd-222");
    return result;
  }

  @override
  Future<List<LiveGiftingDataModel>> getComboGifters(
      {required String comboId}) async {
    final response = await networkClient.get(
        endpoint: '${EndpointConstant.getLiveCombo}$comboId/top-gifters',
        isAuthHeaderRequired: true);

    return (response.data as List)
        .map((element) => LiveGiftingDataModel.fromMap(element))
        .toList();
  }
}

//CONVERTING AVATAR BEFORE SENDING TO THE UI
Uint8List? tempAvatarData;
void convertAvatar({required String avatar}) async {
  tempAvatarData = await fetchSvg(avatar);
}
