import 'dart:io';
import 'package:clapmi/Models/chat_model.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/utils/app_logger.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/clap_request_entity.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/message_entity.dart';
import 'package:clapmi/features/chats_and_socials/data/models/message_model.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ChatPage extends StatefulWidget {
  final ChatUserData? user;
  final ChatUser? newUser;
  final ClapRequestEntity? newPartner;
  const ChatPage({
    super.key,
    this.user,
    this.newUser,
    this.newPartner,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Map<int, File?> messageFileToChatModelMap = {};
  List<MessageEntity> chatList = [];
  Map<String, dynamic>? messageEntity;

  bool isEmpty = false;
  Image? newChatFileThumbnail;
  bool isReconnected = false;
  String? connectError;
  String? socketId;
  String? conversationId;

  // FIX: Track loading state to show proper UI
  bool _isLoadingMessages = true;

  // Cache current user ID for performance
  String? _currentUserPid;

  // Track last read message to avoid duplicate calls
  String? _lastReadMessageId;

  ScrollController scrollController = ScrollController();
  ChatModel? newChat;

  // Scoped controllers - properly disposed
  final TextEditingController _textMessageController = TextEditingController();
  final FocusNode _textMessageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Cache current user ID once for performance
    _currentUserPid = profileModelG?.pid ?? userModelG?.pid;

    AppLogger.debug(
        'ChatPage initState - user: ${widget.user}, newUser: ${widget.newUser}, newPartner: ${widget.newPartner}',
        tag: 'CHAT_PAGE');

    if (widget.user != null) {
      AppLogger.debug(
          'Using existing user with conversationId: ${widget.user?.conversationId}',
          tag: 'CHAT_PAGE');
      context.read<ChatsAndSocialsBloc>().add(FetchChatMessagesEvent(
          conversationId: widget.user?.conversationId ?? ''));
      context.read<ChatsAndSocialsBloc>().add(SubscribeTochatEvent(
          conversationId: widget.user?.conversationId ?? ''));
    } else if (widget.newPartner != null) {
      AppLogger.debug(
          'Initiating conversation with newPartner: ${widget.newPartner?.senderProfile}',
          tag: 'CHAT_PAGE');
      context.read<ChatsAndSocialsBloc>().add(InitiateConversationEvent(
          userPid: widget.newPartner?.senderProfile ?? ''));
    } else if (widget.newUser != null) {
      AppLogger.debug(
          'Initiating conversation with newUser pid: ${widget.newUser?.pid}',
          tag: 'CHAT_PAGE');
      context
          .read<ChatsAndSocialsBloc>()
          .add(InitiateConversationEvent(userPid: widget.newUser?.pid ?? ''));
    } else {
      AppLogger.warning('No user data provided to ChatPage!', tag: 'CHAT_PAGE');
    }

    // Add scroll listener to detect when messages become visible
    scrollController.addListener(_onScroll);

    super.initState();
  }

  /// Called when the user scrolls through the chat
  void _onScroll() {
    _markVisibleMessagesAsRead();
  }

  /// Mark messages as read when they become visible in the viewport
  void _markVisibleMessagesAsRead() {
    if (chatList.isEmpty) return;

    // Get the current conversation ID
    final currentConversationId = widget.user?.conversationId;
    if (currentConversationId == null) return;

    // Find the last message from the other user (not from current user)
    // that hasn't been read yet
    for (int i = chatList.length - 1; i >= 0; i--) {
      final message = chatList[i];
      final isFromOtherUser = message.sender != _currentUserPid;
      final isNotRead = message.is_read != 1;
      final hasUuid = message.uuid != null;

      if (isFromOtherUser && isNotRead && hasUuid) {
        // Avoid sending duplicate read events for the same message
        if (_lastReadMessageId != message.uuid) {
          _lastReadMessageId = message.uuid;
          AppLogger.debug('Marking message as read: ${message.uuid}',
              tag: 'CHAT_PAGE');
          context.read<ChatsAndSocialsBloc>().add(MarkMessageAsReadEvent(
                conversationId: currentConversationId,
                messageId: message.uuid!,
              ));
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0D0D), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0D0D),
        elevation: 0,
        title: HeaderTile(
          user: widget.user,
          newUser: widget.newUser,
          newUserMode: widget.newPartner,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white70),
          )
        ],
      ),
      body: BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
        listener: (context, state) {
          // FIX: Handle loading state
          if (state is GetChatMessagesLoadingState) {
            AppLogger.debug('Loading chat messages...', tag: 'CHAT_PAGE');
            setState(() {
              _isLoadingMessages = true;
            });
          }

          // Handle error states
          if (state is GetFriendErrorState) {
            AppLogger.error(
              'Chat Error: ${state.errorMessage}',
              tag: 'CHAT_PAGE',
            );
            setState(() {
              _isLoadingMessages = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load chat: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          // Handle chat subscription - preserve existing messages when subscribed
          if (state is ChatSubscribedSuccessfully) {
            AppLogger.debug(
                'Chat subscribed - keeping existing ${chatList.length} messages',
                tag: 'CHAT_PAGE');
          }

          if (state is MessagesFetched) {
            AppLogger.debug('Received ${state.messages.length} messages',
                tag: 'CHAT_PAGE');
            chatList = state.messages;
            setState(() {
              _isLoadingMessages = false;
            });
            _scrollToBottom();
            // Mark messages as read when loaded
            _markVisibleMessagesAsRead();
          }
          if (state is MessageSent) {
            // WebSocket will deliver the message via ChatDataLoaded, no need for optimistic update or refetch
          }

          if (state is ChatDataLoaded) {
            chatList.add(state.data);
            _scrollToBottom();
            if (state.data.sender != _currentUserPid) {
              _markVisibleMessagesAsRead();
            }
          }
          if (state is ConversationInitiated) {
            conversationId = state.conversationId;
            // Use the new conversationId, not widget.user?.conversationId
            context.read<ChatsAndSocialsBloc>().add(
                FetchChatMessagesEvent(conversationId: state.conversationId));
            context.read<ChatsAndSocialsBloc>().add(
                SubscribeTochatEvent(conversationId: state.conversationId));
          }
        },
        builder: (context, state) {
          AppLogger.debug(
              'ChatPage builder - chatList length: ${chatList.length}, _isLoadingMessages: $_isLoadingMessages, state: $state',
              tag: 'CHAT_PAGE');
          return Column(
            children: [
              // Messages Area
              Expanded(
                child: _buildMessagesArea(),
              ),

              // Chat Input Bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1E),
                  border: Border(
                    top: BorderSide(color: Colors.black26, width: 0.5),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Create new chat model only when needed
                          newChat ??= ChatModel.fromOnlinejson({});
                          // Remove unnecessary setState - state is already handled by newChat
                        },
                        icon: const Icon(Icons.add_circle_outline_sharp,
                            color: Colors.white70),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2E),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: _textMessageController,
                            focusNode: _textMessageFocusNode,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Type your message...",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              newChat ??= ChatModel.fromOnlinejson({});
                              newChat = newChat!.copyWith(
                                  message: (value.isEmpty) ? null : value);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          if (_textMessageController.text.isNotEmpty) {
                            SendChatMessageEvent thisSendChatMessageEvent =
                                SendChatMessageEvent(
                                    parentMessageId: '',
                                    senderId: profileModelG?.pid ??
                                        userModelG?.pid ??
                                        '',
                                    conversationId:
                                        widget.user?.conversationId ??
                                            conversationId ??
                                            '',
                                    message: _textMessageController.text);

                            context
                                .read<ChatsAndSocialsBloc>()
                                .add(thisSendChatMessageEvent);
                            _textMessageController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              generalErrorSnackBar('Message empty'),
                            );
                          }
                        },
                        icon: const Icon(Icons.send, color: Color(0xFF007AFF)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    _textMessageController.dispose();
    _textMessageFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateStr).toLocal();
    } catch (e, stackTrace) {
      AppLogger.warning(
        'Failed to parse date: $dateStr',
        tag: 'CHAT_PAGE',
        error: e,
        stackTrace: stackTrace,
      );
      return DateTime.now();
    }
  }

  /// FIX: Build messages area with loading state handling
  Widget _buildMessagesArea() {
    // Show loading indicator while fetching messages
    if (_isLoadingMessages) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            final isMe = index % 2 == 0;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(12),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          },
        ),
      );
    }

    // Show messages if available
    if (chatList.isNotEmpty) {
      return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 10,
        ),
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          bool isMine = _currentUserPid == chat.sender;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Align(
              alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75),
                child: Container(
                  decoration: BoxDecoration(
                    color: isMine
                        ? const Color(0xFF007AFF)
                        : const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft:
                          isMine ? const Radius.circular(18) : Radius.zero,
                      bottomRight:
                          isMine ? Radius.zero : const Radius.circular(18),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.message ?? '',
                        style: TextStyle(
                          color: isMine
                              ? Colors.white
                              : Colors.white.withOpacity(0.9),
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('hh:mm a').format(
                          _parseDate(chat.created_at),
                        ),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    // Show empty state when no messages and not loading
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: EmptyChatListWidget(),
      ),
    );
  }
}

bool isRecording = false;

Future recordSound() async {}

Future<File?> stopRecording() async {
  return null;
}

class HeaderTile extends StatelessWidget {
  final ChatUserData? user;
  final ChatUser? newUser;
  final ClapRequestEntity? newUserMode;
  const HeaderTile({
    super.key,
    this.user,
    this.newUser,
    this.newUserMode,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: GestureDetector(
        onTap: () {
          AppLogger.debug('Tapped user avatar icon', tag: 'CHAT_PAGE');
          context.pushNamed(
            MyAppRouteConstant.othersAccountPage,
            extra: {'userId': user?.user?.pid ?? newUser?.pid},
          );
        },
        child: FancyContainer(
            backgroundColor: Colors.white,
            radius: 40,
            height: 40,
            width: 40,
            child: CustomImageView(
              imagePath: user?.user?.image ??
                  newUser?.image ??
                  newUserMode?.senderImage,
              height: double.infinity,
              width: double.infinity,
            )),
      ),
      title: Text(
        user?.user?.username ?? newUser?.name ?? newUserMode?.senderName ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: getFigmaColor("47E800"),
        ),
      ),
    );
  }
}

class EmptyChatListWidget extends StatelessWidget {
  const EmptyChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Image.asset('assets/images/me.png')),
        const SizedBox(height: 16),
        SizedBox(height: 60.h),
      ],
    );
  }
}

class MessageWidget extends StatefulWidget {
  final MessageModel model;
  final File? localFile;
  final MessageModel? repliedMessage;

  const MessageWidget({
    super.key,
    required this.model,
    this.repliedMessage,
    required this.localFile,
  });

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  File? displayedFile;
  double downloadLevel = 0;
  Image? thumbnailImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: widget.model.isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: widget.model.isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              FancyContainer(
                nulledAlign: true,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                radius: 12.w,
                backgroundColor: (!widget.model.isMine)
                    ? getFigmaColor("222222")
                    : AppColors.primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.model.files?.isNotEmpty ?? false)
                      FutureBuilder<Object>(
                          future: () async {
                            displayedFile = (widget.localFile == null)
                                ? File(await downloadURL(
                                    widget.model.files?.firstOrNull,
                                    (level) {
                                      downloadLevel = level;
                                    },
                                  ))
                                : widget.localFile;

                            return "done";
                          }.call(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GestureDetector(child: const SizedBox());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red.withAlpha(50),
                                  size: 50,
                                ),
                              );
                            }
                            return CircularProgressIndicator.adaptive(
                              value: downloadLevel / 100,
                              strokeCap: StrokeCap.round,
                            );
                          }),
                    Text(
                      widget.model.message ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                DateFormat('hh:mm a')
                    .format(widget.model.date ?? DateTime.now()),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MessageModel {
  final String? message;
  final DateTime? date;
  final List? files;
  final bool isMine;

  MessageModel({
    required this.message,
    this.files,
    required this.date,
    required this.isMine,
  });
}
