import 'dart:convert';

import 'package:big_numbers/big_numbers.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/core/di/injector.dart';
import 'package:clapmi/features/chats_and_socials/data/models/user_model.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/chat_user.dart';
import 'package:clapmi/features/chats_and_socials/domain/entities/clap_request_entity.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_bloc.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_event.dart';
import 'package:clapmi/features/chats_and_socials/presentation/blocs/user_bloc/chats_and_socials_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/NetworkAndRewards/clap_request_list_page.dart';
import 'package:clapmi/screens/NetworkAndRewards/suggested_users_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class NetworkViewCache {
  static const Duration _cacheTtl = Duration(seconds: 45);
  static List<UserNearLocationEntity> nearbyUsers = [];
  static List<ClapRequestEntity> clapRequests = [];
  static Set<String> alreadyClappedPids = <String>{};
  static DateTime? nearbyUsersUpdatedAt;
  static DateTime? clapRequestsUpdatedAt;

  static bool isNearbyUsersFresh() {
    final updatedAt = nearbyUsersUpdatedAt;
    if (updatedAt == null || nearbyUsers.isEmpty) {
      return false;
    }
    return DateTime.now().difference(updatedAt) < _cacheTtl;
  }

  static bool isClapRequestsFresh() {
    final updatedAt = clapRequestsUpdatedAt;
    if (updatedAt == null || clapRequests.isEmpty) {
      return false;
    }
    return DateTime.now().difference(updatedAt) < _cacheTtl;
  }
}

class NetworkConnect extends StatefulWidget {
  const NetworkConnect({super.key});

  @override
  State<NetworkConnect> createState() => _NetworkConnectState();
}

class _NetworkConnectState extends State<NetworkConnect>
    with AutomaticKeepAliveClientMixin {
  List<UserNearLocationEntity> displayedList = [];
  List<ClapRequestEntity> listOfClapRequest = [];
  Set<String> _alreadyClappedPids = <String>{};
  bool _isLoadingClapRequests = true;
  bool _isLoadingNearbyUsers = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final chatsBloc = context.read<ChatsAndSocialsBloc>();
    displayedList = List<UserNearLocationEntity>.from(chatsBloc.nearbyUsers);
    listOfClapRequest = List<ClapRequestEntity>.from(chatsBloc.clapRequests);
    _alreadyClappedPids = Set<String>.from(NetworkViewCache.alreadyClappedPids);
    _isLoadingClapRequests = listOfClapRequest.isEmpty;
    _isLoadingNearbyUsers = displayedList.isEmpty;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPersistedClappedUsers();
      _refreshNetworkData();
    });
  }

  Future<void> _loadPersistedClappedUsers() async {
    final raw = getItInstance<AppPreferenceService>()
        .getValue<String>("alreadyClapped");
    final decoded = (() {
      try {
        return (json.decode(raw ?? json.encode([])) as List)
            .whereType<Map>()
            .map(
              (e) => UserNearLocationEntity.fromMap(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
      } catch (_) {
        return <UserNearLocationEntity>[];
      }
    })();
    final persistedPids = decoded
        .map((e) => e.pid)
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toSet();
    if (!mounted) {
      return;
    }
    if (_alreadyClappedPids.length == persistedPids.length &&
        _alreadyClappedPids.containsAll(persistedPids)) {
      return;
    }
    setState(() {
      _alreadyClappedPids = persistedPids;
      NetworkViewCache.alreadyClappedPids = Set<String>.from(_alreadyClappedPids);
    });
  }

  Future<void> _markUserAsClapped(UserNearLocationEntity person) async {
    final pid = person.pid;
    if (pid == null || pid.isEmpty) {
      return;
    }

    final updatedPids = {..._alreadyClappedPids, pid};
    final existingUsers = (json.decode(
      getItInstance<AppPreferenceService>().getValue<String>("alreadyClapped") ??
          json.encode([]),
    ) as List)
        .whereType<Map>()
        .map((e) => UserNearLocationEntity.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    final updatedUsers = <UserNearLocationEntity>[
      ...existingUsers.where((e) => e.pid != pid),
      person,
    ];

    await getItInstance<AppPreferenceService>().saveValue<String>(
      "alreadyClapped",
      json.encode(updatedUsers.map((e) => e.toMap()).toList()),
    );

    if (!mounted) {
      return;
    }
    setState(() {
      _alreadyClappedPids = updatedPids;
      NetworkViewCache.alreadyClappedPids = Set<String>.from(updatedPids);
    });
  }

  Future<void> _refreshNetworkData({bool force = false}) async {
    final chatsBloc = context.read<ChatsAndSocialsBloc>();
    if (force || !chatsBloc.isClapRequestsFresh) {
      chatsBloc.add(
        GetClapRequestEvent(
          refreshInBackground: chatsBloc.hasClapRequests && !force,
          forceRefresh: force,
        ),
      );
    }
    if (force || !chatsBloc.isNearbyUsersFresh) {
      chatsBloc.add(
        GetPeopleNearLocationEvent(
          refreshInBackground: chatsBloc.hasNearbyUsers && !force,
          forceRefresh: force,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: buildBackArrow(context),
        title: const Text(
          'Network',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
        listener: (context, state) {
          if (state is GetClapRequestSuccessState) {
            setState(() {
              listOfClapRequest = state.listOfClapRequest;
              _isLoadingClapRequests = false;
            });
          }

          if (state is UserNearLocationLoaded) {
            setState(() {
              displayedList = state.users;
              _isLoadingNearbyUsers = false;
            });
          }

          if (state is GetClapRequestErrorState) {
            setState(() {
              _isLoadingClapRequests = false;
            });
            if (listOfClapRequest.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                generalSnackBar(state.errorMessage),
              );
            }
          }

          if (state is PeopleNearLocationLoading) {
            if (displayedList.isEmpty) {
              setState(() {
                _isLoadingNearbyUsers = true;
              });
            }
          }

          if (state is GetClapRequestLoadingState) {
            if (listOfClapRequest.isEmpty) {
              setState(() {
                _isLoadingClapRequests = true;
              });
            }
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => _refreshNetworkData(force: true),
            color: Colors.white,
            backgroundColor: const Color(0xFF181919),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10),
                child: Column(
                  children: [
                    _buildClapRequestSection(state),
                    _buildLocationSection(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ FIX 4: Extracted Clap Request section to separate method
  Widget _buildClapRequestSection(ChatsAndSocialsState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Clapmi Request',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (listOfClapRequest.length > 3)
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ClapRequestListPage(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'See More ',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
              ),
          ],
        ),

        SizedBox(height: 10.h),

        if (_isLoadingClapRequests && listOfClapRequest.isEmpty)
          _buildRequestSkeleton()
        else if (listOfClapRequest.isEmpty)
          buildEmptyWidget("No Request Yet")
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // ✅ Added this
            itemCount:
                listOfClapRequest.length > 4 ? 4 : listOfClapRequest.length,
            itemBuilder: (context, index) {
              return ProfileCard(
                requestModel: listOfClapRequest[index],
                acceptRequestCallback: (id) {
                  setState(() {
                    final request = listOfClapRequest
                        .where(
                          (element) => element.id == id,
                        )
                        .firstOrNull;
                    try {
                      request!.switchButton = true;
                    } catch (_) {
                      // Ignore missing request; UI already guards the empty state.
                    }
                  });
                },
                declineRequestCallback: (id) {
                  setState(() {
                    listOfClapRequest
                        .removeWhere((element) => element.id == id);
                  });
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'People within location ${simplifyNumber(1000000000.toString())}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Geist',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SuggestedUsersListPage(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'See More ',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontFamily: 'Geist',
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isLoadingNearbyUsers && displayedList.isEmpty)
          _buildNearbyUsersSkeleton()
        else if (displayedList.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedList.length > 4 ? 4 : displayedList.length,
            itemBuilder: (context, index) {
              final person = displayedList[index];
              return ProfileCardForUserVeiw(
                person: person,
                isAlreadyClapped: _alreadyClappedPids.contains(person.pid),
                onActionTaken: () async {
                  await _markUserAsClapped(person);
                },
              );
            },
          )
        else
          buildEmptyWidget("No users nearby yet"),
      ],
    );
  }

  Widget _buildRequestSkeleton() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF181919),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2A2A),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNearbyUsersSkeleton() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF181919),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2A2A),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15,
                      width: 130,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ✅ FIX 6: Improved ProfileCard with better null handling
class ProfileCard extends StatefulWidget {
  final ClapRequestEntity requestModel;
  final Function(String) acceptRequestCallback;
  final Function(String) declineRequestCallback;

  const ProfileCard({
    super.key,
    required this.requestModel,
    required this.acceptRequestCallback,
    required this.declineRequestCallback,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Map<String, dynamic> tempValues = {};
  bool isProcessing = false; // ✅ Added loading state

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsAndSocialsBloc, ChatsAndSocialsState>(
      listener: (context, state) {
        if (state is AcceptRequestSuccessState) {
          setState(() {
            isProcessing = false;
          });
          widget
              .acceptRequestCallback(tempValues[widget.requestModel.id] ?? '');
        }

        if (state is RejectRequestSuccessState) {
          setState(() {
            if (state.requestID == widget.requestModel.id) {
              isProcessing = false;
            }
          });
          widget
              .declineRequestCallback(tempValues[widget.requestModel.id] ?? '');
        }

        // ✅ Handle loading states
        if (state is AcceptRequestLoadingState) {
          setState(() {
            if (state.requestID == widget.requestModel.id) {
              isProcessing = true;
            }
          });
        }
        if (state is RejectRequestLoadingState) {
          setState(() {
            if (state.requestID == widget.requestModel.id) {
              isProcessing = true;
            }
          });
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF181919),
            borderRadius: BorderRadius.circular(16),
          ),
          width: 408.w,
          child: Row(
            children: [
              // Avatar
              FancyContainer(
                radius: 40,
                child: AppAvatar(
                  imageUrl: widget.requestModel.senderImage,
                  name: widget.requestModel.senderName,
                  size: 50,
                  backgroundColor: const Color(0xFF2A2A2A),
                ),
              ),

              SizedBox(width: 12.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.requestModel.senderName ?? "Unknown User",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 4),

                    if (widget.requestModel.occupation != null &&
                        widget.requestModel.occupation!.isNotEmpty)
                      Text(
                        widget.requestModel.occupation!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),

                    const SizedBox(height: 2),

                    const Text(
                      '6 mutual friends',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Action Buttons
                    Row(
                      children: [
                        // Accept/Chat Button
                        Expanded(
                          child: FancyContainer(
                            height: 35,
                            radius: 20,
                            isAsync: true,
                            backgroundColor: getFigmaColor("006FCD"),
                            action: isProcessing
                                ? null
                                : () {
                                    if (widget.requestModel.switchButton) {
                                      context.pushNamed(
                                        MyAppRouteConstant.chatPage,
                                        extra: {
                                          "newUserPid": widget.requestModel
                                        },
                                      );
                                    } else {
                                      setState(() {
                                        tempValues[widget.requestModel.id] =
                                            widget.requestModel.id;
                                      });
                                      context.read<ChatsAndSocialsBloc>().add(
                                            AcceptRequestEvent(
                                                widget.requestModel.id),
                                          );
                                    }
                                  },
                            child: Center(
                              child: isProcessing
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      widget.requestModel.switchButton
                                          ? 'Chat'
                                          : 'Accept',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Decline/Unclap Button
                        Expanded(
                          child: FancyContainer(
                            height: 35,
                            radius: 20,
                            isAsync: true,
                            backgroundColor: getFigmaColor("006FCD", 30),
                            action: isProcessing
                                ? null
                                : () {
                                    if (!widget.requestModel.switchButton) {
                                      context.read<ChatsAndSocialsBloc>().add(
                                            RejectRequestEvent(
                                                widget.requestModel.id),
                                          );
                                    }
                                  },
                            child: Center(
                              child: Text(
                                widget.requestModel.switchButton
                                    ? 'Unclap'
                                    : 'Decline',
                                style:
                                    TextStyle(color: getFigmaColor("006FCD")),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// First, add the UniversalNetworkImage widget
class UniversalNetworkImage extends StatefulWidget {
  final String? imageUrl;
  final String name;
  final double size;

  const UniversalNetworkImage({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 50,
  });

  @override
  State<UniversalNetworkImage> createState() => _UniversalNetworkImageState();
}

class _UniversalNetworkImageState extends State<UniversalNetworkImage> {
  bool _hasError = false;

  // Generate initials from name
  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  // Generate consistent color from name
  Color _getColorFromName(String name) {
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFF45B7D1),
      const Color(0xFFFFA07A),
      const Color(0xFF98D8C8),
      const Color(0xFFF7DC6F),
      const Color(0xFFBB8FCE),
      const Color(0xFF85C1E2),
    ];
    final index = name.codeUnitAt(0) % colors.length;
    return colors[index];
  }

  Widget _buildFallback() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: _getColorFromName(widget.name),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(widget.name),
          style: TextStyle(
            color: Colors.white,
            fontSize: widget.size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = widget.imageUrl;

    if (_hasError || imageUrl == null || imageUrl.isEmpty) {
      return _buildFallback();
    }

    // Check if it's an SVG
    if (imageUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        placeholderBuilder: (context) => Container(
          width: widget.size,
          height: widget.size,
          color: Colors.grey[800],
          child: Center(
            child: SizedBox(
              width: widget.size * 0.4,
              height: widget.size * 0.4,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      );
    }

    // For regular images
    return Image.network(
      imageUrl,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: widget.size,
          height: widget.size,
          color: Colors.grey[800],
          child: Center(
            child: SizedBox(
              width: widget.size * 0.4,
              height: widget.size * 0.4,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey[400],
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _hasError = true);
          }
        });
        return _buildFallback();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[900],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildImage(),
    );
  }
}

class ProfileCardForUserVeiw extends StatefulWidget {
  final UserNearLocationEntity? person;
  final Function onActionTaken;
  final bool isAlreadyClapped; // Add this to check if already clapped

  const ProfileCardForUserVeiw({
    super.key,
    this.person,
    required this.onActionTaken,
    this.isAlreadyClapped = false,
  });

  @override
  State<ProfileCardForUserVeiw> createState() => _ProfileCardForUserVeiwState();
}

class _ProfileCardForUserVeiwState extends State<ProfileCardForUserVeiw> {
  bool _isClapped = false;
  bool _isLoading = false;
  String? _currentRequestPid; // Track which user is being processed

  @override
  void initState() {
    super.initState();
    _isClapped = widget.isAlreadyClapped;
  }

  void _handleClapAction() {
    if (_isClapped || _isLoading) return;

    final userPid = widget.person?.pid;

    if (userPid == null || userPid.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          generalSnackBar("Unable to send clap request"),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _currentRequestPid = userPid;
    });

    context.read<ChatsAndSocialsBloc>().add(
          SendClapRequestToUsersEvent(userPids: userPid),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatsAndSocialsBloc, ChatsAndSocialsState>(
      listener: (context, state) {
        // Only handle state changes for THIS specific user
        if (_currentRequestPid != widget.person?.pid) return;

        if (state is SendClapRequestToUsersSuccessState) {
          setState(() {
            _isClapped = true;
            _isLoading = false;
            _currentRequestPid = null;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              generalSnackBar(state.message),
            );
          }

          widget.onActionTaken();
        } else if (state is SendClapRequestToUsersErrorState) {
          setState(() {
            _isLoading = false;
            _currentRequestPid = null;
          });

          if (mounted) {
            String errorMessages = state.errorMessage;
            if (errorMessages
                .contains('You have an existing pending request to User')) {
              errorMessages = 'You have an existing pending request to User';
              _isClapped = true;
              setState(() {});
            }

            if (errorMessages.contains('is your friend')) {
              errorMessages = 'user already your friend';
              _isClapped = true;
              setState(() {});
            }
            // is your friend
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessages),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          widget.onActionTaken();
        } else if (state is SendClapRequestToUsersLoadingState) {
          // Handle loading state if needed
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF181919),
          borderRadius: BorderRadius.circular(16),
        ),
        width: 408.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UniversalNetworkImage(
                  imageUrl: widget.person?.image,
                  name: widget.person?.name ?? 'User',
                  size: 50,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.person?.name ?? "N/A",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (widget.person?.occupation != null &&
                          widget.person!.occupation!.isNotEmpty)
                        Text(
                          widget.person!.occupation!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _isClapped ? null : _handleClapAction,
                        child: Container(
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                            color: _isClapped
                                ? Colors.grey[700]
                                : getFigmaColor("006FCD"),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_isClapped)
                                        const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      if (_isClapped) const SizedBox(width: 4),
                                      Text(
                                        _isClapped ? 'Clapped' : 'Clap',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCardForUserVeiw2 extends StatefulWidget {
  final ChatUser person;
  final Function()? onActionTaken;
  const ProfileCardForUserVeiw2(
      {super.key, required this.person, required this.onActionTaken});

  @override
  State<ProfileCardForUserVeiw2> createState() =>
      _ProfileCardForUserVeiw2State();
}

class _ProfileCardForUserVeiw2State extends State<ProfileCardForUserVeiw2> {
  // UserModel? person;
  @override
  void initState() {
    // person = widget.person;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      padding: const EdgeInsets.all(16),
      radius: 16,
      backgroundColor: const Color(0xFF181919),
      width: 408.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FancyContainer(
                    radius: 40,
                    height: 50,
                    width: 50,
                    backgroundColor: Colors.black,
                    child: CustomImageView(
                      imagePath: widget.person.image,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(width: 10.w), // Space between avatar and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.person.name ?? "N/A",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (widget.person.occupation != null)
                        Text(
                          widget.person.occupation!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      const SizedBox(height: 2),
                      const Text(
                        "",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Clapped',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  FancyContainer(
                    height: 35,
                    width: 70,
                    radius: 20,
                    backgroundColor: getFigmaColor("006FCD"),
                    isAsync: true,
                    action: widget.onActionTaken,
                    child: const Text(
                      'Chat',
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
