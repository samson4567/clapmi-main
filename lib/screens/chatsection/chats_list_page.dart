// ignore_for_file: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/utils/app_logger.dart';
import 'package:clapmi/features/chats_and_socials/data/models/chat_user_model.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // FIXED: Combined loading states to reduce rebuilds
  bool _isLoading = true;
  String selectedTab = "All";
  String? _searchQuery;

  TextEditingController searchController = TextEditingController();
  List<ChatUserData> chatFriends = [];
  // FIXED: Track loading state properly
  bool get isLoading => _isLoading;

  // Cache for sorted friends to avoid recalculating on every rebuild
  List<ChatUserData>? _cachedSortedFriends;

  @override
  void initState() {
    context.read<ChatsAndSocialsBloc>().add(GetChatFriendsEvent());
    super.initState();
  }

  /// Sort chat friends by most recent message date
  /// Uses caching to avoid recalculating on every rebuild
  List<ChatUserData> getSortedChatFriends() {
    _cachedSortedFriends ??= _sortChatFriends(chatFriends);
    return _cachedSortedFriends!;
  }

  /// Internal sorting method
  List<ChatUserData> _sortChatFriends(List<ChatUserData> friends) {
    List<ChatUserData> sorted = List.from(friends);
    sorted.sort((a, b) {
      DateTime? dateA = DateTime.tryParse(a.date ?? "");
      DateTime? dateB = DateTime.tryParse(b.date ?? "");

      // Handle null dates by treating them as very old
      if (dateA == null || dateB == null) return -1;
      // if (dateA == null) return 1;
      // if (dateB == null) return -1;

      // Sort in descending order (most recent first)
      return dateB!.compareTo(dateA);
    });
    return sorted;
  }

  /// Call this when chatFriends is updated to invalidate cache
  void _updateChatFriends(List<ChatUserData> newFriends) {
    chatFriends = newFriends.toList();
    _cachedSortedFriends = null; // Invalidate cache
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
      listener: (context, state) {
        if (state is ChatFriendsLoaded) {
          chatFriends = state.chatFriends.toList();
          // FIXED: Use _isLoading to avoid setter error
          setState(() => _isLoading = false);
        }
        if (state is ChatDataLoaded) {
          if (state.data.sender != userModelG?.pid) {
            chatFriends
                .where(
              (element) => element.conversationId == state.data.conversationId,
            )
                .forEach(
              (element) {
                element = element.copyWith(
                    message_count: (element.message_count ?? 0) + 1);
              },
            );
            setState(() {});
          }
        }
        if (state is GetFriendLoadingState) {
          setState(() => _isLoading = true);
        }
        if (state is GetFriendErrorState) {
          // FIXED: Use _isLoading to avoid setter error
          setState(() => _isLoading = false);
        }

        // Refresh chat friends when messages are marked as read
        if (state is MessageMarkedAsRead) {
          context.read<ChatsAndSocialsBloc>().add(GetChatFriendsEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: getFigmaColor("0C0D0D"),
          appBar: AppBar(
            backgroundColor: getFigmaColor("0C0D0D"),
            elevation: 0,
            centerTitle: false,
            title: Text(
              "Chat",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: FancyContainer(
                      height: 34,
                      width: 34,
                      radius: 12,
                      backgroundColor: getFigmaColor("1E1F20"),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "New Chat",
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(MyAppRouteConstant.myNetworkPage);
                          },
                          child: const Text("New Chat",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                    onChanged: (value) {},
                    dropdownStyleData: DropdownStyleData(
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: getFigmaColor("1A1A1A"),
                      ),
                      offset: const Offset(0, 8),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(MyAppRouteConstant.myAccountPage);
                  },
                  child: profileModelG?.myAvatar != null
                      ? Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: MemoryImage(profileModelG!.myAvatar!),
                            ),
                          ),
                        )
                      : ClipOval(
                          child: CachedNetworkImage(
                            height: 30.w,
                            width: 30.w,
                            imageUrl: profileModelG?.image ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.person),
                            ),
                            errorWidget: (context, error, trace) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
          // FIXED: Use single loading state check
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return FancyContainer(
      height: 45,
      backgroundColor: getFigmaColor("1A1A1A"),
      radius: 25,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.white.withOpacity(0.6), size: 20),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                ),
                // Only update search query, don't trigger full rebuild
                onChanged: (value) => _searchQuery = value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FIXED: Build body based on loading state to reduce rebuilds
  Widget _buildBody() {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: 8,
          separatorBuilder: (_, __) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(
              color: Colors.white.withOpacity(0.08),
              height: 1,
            ),
          ),
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120.w,
                          height: 16.h,
                          color: Colors.white,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 180.w,
                          height: 12.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    if (chatFriends.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(25.0),
        child: EmptyChatListWidget(),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          _buildSearchBar(),
          SizedBox(height: 14.h),
          _buildTabSelection(),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: getSortedChatFriends().length,
              separatorBuilder: (_, __) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Divider(
                  color: Colors.white.withOpacity(0.08),
                  height: 1,
                ),
              ),
              itemBuilder: (context, index) {
                final friend = getSortedChatFriends()[index];
                if (selectedTab == 'Read' && friend.message_count != 0) {
                  return const SizedBox.shrink();
                }
                if (selectedTab == 'Unread' && friend.message_count == 0) {
                  return const SizedBox.shrink();
                }
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (c, a) =>
                      FadeTransition(opacity: a, child: c),
                  child: ChatTile(
                    friend: friend,
                    key: ValueKey(friend.user?.image),
                    updatFriendConversation: (newDetails) {
                      final indexToBeChanged = chatFriends.indexWhere(
                        (element) =>
                            element.conversationId == newDetails.conversationId,
                      );
                      if (indexToBeChanged != -1) {
                        chatFriends[indexToBeChanged] =
                            ChatUserDataModel.fromMap(newDetails.toMap(), true);
                        _cachedSortedFriends = null;
                        setState(() {});
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelection() {
    return Row(
      children: [
        RadioButtonForChat(
          width: 70.w,
          height: 25.h,
          changeSelectedTab: () => setState(() => selectedTab = "All"),
          text: "All",
          isSelected: selectedTab == "All",
        ),
        SizedBox(width: 10.w),
        RadioButtonForChat(
          width: 80.w,
          height: 25.h,
          changeSelectedTab: () => setState(() => selectedTab = "Unread"),
          text: "Unread",
          isSelected: selectedTab == "Unread",
        ),
        SizedBox(width: 10.w),
        RadioButtonForChat(
          width: 70.w,
          height: 25.h,
          changeSelectedTab: () => setState(() => selectedTab = "Read"),
          text: "Read",
          isSelected: selectedTab == "Read",
        ),
      ],
    );
  }
}

class RadioButtonForChat extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function() changeSelectedTab;
  final double? height;
  final double? width;

  const RadioButtonForChat({
    super.key,
    required this.text,
    required this.isSelected,
    required this.changeSelectedTab,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changeSelectedTab,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height ?? 40,
        width: width ?? 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A84FF) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFF3A3A3A),
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: isSelected ? Colors.white : const Color(0xFF9A9A9A),
          ),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  ChatUserData friend;
  final bool isPinned;
  final bool isGroupChat;
  Function(ChatUserData newDetails) updatFriendConversation;

  ChatTile({
    super.key,
    required this.friend,
    this.isGroupChat = false,
    this.isPinned = false,
    required this.updatFriendConversation,
  });

  /// 🔥 NEW: Format the chat timestamp
  /// If conversationId is missing → use current device time as dummy
  String getFormattedDate() {
    try {
      final raw = friend.date ?? "";

      DateTime? dt = DateTime.tryParse(raw)?.toLocal();

      // ⭐ DUMMY TIME: If parsing fails, use current system time
      dt ??= DateTime.now();

      final now = DateTime.now();
      final isToday =
          dt.year == now.year && dt.month == now.month && dt.day == now.day;

      if (isToday) {
        return DateFormat("h:mm a").format(dt); // e.g., 3:20 PM
      } else {
        return DateFormat("dd/MM/yyyy").format(dt); // e.g., Dec 3
      }
    } catch (e, stackTrace) {
      AppLogger.warning(
        'Error formatting date for friend: ${friend.user?.username}',
        tag: 'CHAT_LIST',
        error: e,
        stackTrace: stackTrace,
      );
      return DateFormat("h:mm a").format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (isGroupChat) {
          context.pushNamed(MyAppRouteConstant.chatPageForGroup);
          return;
        }
        ChatUserData;
        // frie0nd.message_count = 0;
        friend = friend.copyWith(message_count: 0);
        updatFriendConversation(friend);

        context.pushNamed(MyAppRouteConstant.chatPage, extra: {"user": friend});
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            GestureDetector(
              onTap: () {
                context.pushNamed(
                  MyAppRouteConstant.othersAccountPage,
                  extra: {'userId': friend.user?.pid},
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.w),
                child: CachedNetworkImage(
                  height: 50.w,
                  width: 50.w,
                  fit: BoxFit.cover,
                  imageUrl: friend.user?.image ?? '',
                  placeholder: (_, __) => Container(
                    color: Colors.grey.shade800,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: getFigmaColor("222222"),
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          friend.user?.username ?? "Unknown",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPinned)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.push_pin,
                              size: 14, color: Colors.white70),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    friend.last_message ?? "No message yet",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 10.w),

            // TIME + unread badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 🔥 NEW: Dummy or parsed date
                Text(
                  getFormattedDate(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: 6.h),
                friend.message_count != 0
                    ? CircleAvatar(
                        backgroundColor: getFigmaColor("2969C3"),
                        radius: 10.w,
                        child: Text(
                          friend.message_count.toString(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Icon(Icons.done_all,
                        size: 16, color: Colors.white.withOpacity(0.4)),
              ],
            ),
          ],
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
        FancyContainer(
          width: 207.w,
          height: 176.h,
          radius: 24,
          backgroundColor: getFigmaColor("222222"),
          child: Image.asset("assets/images/messages.png"),
        ),
        const SizedBox(height: 16),
        const Text(
          "Connect with your network now\nand start chatting",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0XFF8F9090),
            fontFamily: 'Geist',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 40.h),
        FancyContainer(
          action: () {
            context.goNamed(MyAppRouteConstant.myNetworkPage);
          },
          height: 45,
          radius: 36,
          backgroundColor: AppColors.primaryColor,
          isAsync: false,
          child: const Text(
            "My Network",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Geist',
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}
