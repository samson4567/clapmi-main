import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/user/data/models/creator_leaderboard_model.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_event.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_state.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

class LeaderboardUser {
  final int rank;
  final String username;
  final String clapPoints;
  final int winRate;
  final int wins;
  final String avatarInitials;
  final Color avatarColor;
  final int? rankChange;
  final String? avatarUrl; // Add field for creator image URL

  const LeaderboardUser({
    required this.rank,
    required this.username,
    required this.clapPoints,
    required this.winRate,
    required this.wins,
    required this.avatarInitials,
    required this.avatarColor,
    this.rankChange,
    this.avatarUrl,
  });
}

// ─────────────────────────────────────────────
// SAMPLE DATA
// ─────────────────────────────────────────────

const _users = [
  LeaderboardUser(
      rank: 1,
      username: 'john3:16',
      clapPoints: '20.5k',
      winRate: 85,
      wins: 50,
      avatarInitials: 'J',
      avatarColor: Color(0xFF4A7CF7)),
  LeaderboardUser(
      rank: 2,
      username: 'sexyreed',
      clapPoints: '16.9k',
      winRate: 75,
      wins: 45,
      avatarInitials: 'S',
      avatarColor: Color(0xFFE91E8C)),
  LeaderboardUser(
      rank: 3,
      username: 'Saly900',
      clapPoints: '13.6k',
      winRate: 71,
      wins: 40,
      avatarInitials: 'S',
      avatarColor: Color(0xFFFF6B35)),
  LeaderboardUser(
      rank: 4,
      username: 'philly800',
      clapPoints: '7k',
      winRate: 65,
      wins: 33,
      avatarInitials: 'P',
      avatarColor: Color(0xFF9B59B6)),
  LeaderboardUser(
      rank: 5,
      username: 'philly800',
      clapPoints: '7k',
      winRate: 65,
      wins: 33,
      avatarInitials: 'P',
      avatarColor: Color(0xFF9B59B6)),
  LeaderboardUser(
      rank: 6,
      username: 'philly800',
      clapPoints: '7k',
      winRate: 65,
      wins: 33,
      avatarInitials: 'P',
      avatarColor: Color(0xFF9B59B6)),
  LeaderboardUser(
      rank: 7,
      username: 'philly800',
      clapPoints: '7k',
      winRate: 65,
      wins: 33,
      avatarInitials: 'P',
      avatarColor: Color(0xFF9B59B6)),
  LeaderboardUser(
      rank: 8,
      username: 'philly800',
      clapPoints: '7k',
      winRate: 65,
      wins: 33,
      avatarInitials: 'P',
      avatarColor: Color(0xFF9B59B6),
      rankChange: 1),
  LeaderboardUser(
      rank: 9,
      username: 'philly800',
      clapPoints: '7k',
      winRate: 65,
      wins: 33,
      avatarInitials: 'P',
      avatarColor: Color(0xFF9B59B6),
      rankChange: -1),
  LeaderboardUser(
      rank: 10,
      username: 'philly800',
      clapPoints: '7k',
      winRate: 65,
      wins: 33,
      avatarInitials: 'P',
      avatarColor: Color(0xFF9B59B6),
      rankChange: 1),
  LeaderboardUser(
      rank: 0,
      username: 'johndoe',
      clapPoints: '0k',
      winRate: 0,
      wins: 0,
      avatarInitials: 'J',
      avatarColor: Color(0xFF607D8B)),
];

// ─────────────────────────────────────────────
// LEADERBOARD SCREEN
// ─────────────────────────────────────────────

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _selectedLevel = 'Rookie';
  int _currentPage = 1;
  List<CreatorRankingModel> _creatorRankings = [];
  bool _isLoading = false;
  String? _error;
  int _totalPages = 1;
  String _selectedTimeFilter = 'all'; // 'week', 'month', 'year', 'all'
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // Add field for total pages
  CreatorRankingModel? _currentUserRanking; // Store current user's ranking

  // Map UI level names to API level names
  final _levels = ['Rookie', 'Prime', 'Elite', 'Icon', 'Legend'];

  String _getApiLevelName(String uiLevel) {
    // Convert UI level name to API expected format (Title Case)
    switch (uiLevel.toLowerCase()) {
      case 'legend':
        return 'Legend';
      case 'icon':
        return 'Icon';
      case 'elite':
        return 'Elite';
      case 'prime':
        return 'Prime';
      case 'rookie':
      default:
        return 'Rookie';
    }
  }

  @override
  void initState() {
    super.initState();
    final hydratedFromBloc = _hydrateFromCurrentBlocState();
    if (!hydratedFromBloc) {
      _loadCreatorLeaderboard();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _hydrateFromCurrentBlocState() {
    final currentState = context.read<UserBloc>().state;

    if (currentState is GetCreatorLeaderboardLoadingState &&
        _matchesLeaderboardRequest(
          levelName: currentState.levelName,
          page: currentState.page,
          timeFilter: currentState.timeFilter,
          creator: currentState.creator,
        )) {
      _isLoading = true;
      _error = null;
      return true;
    }

    if (currentState is GetCreatorLeaderboardSuccessState &&
        _matchesLeaderboardRequest(
          levelName: currentState.levelName,
          page: currentState.page,
          timeFilter: currentState.timeFilter,
          creator: currentState.creator,
        )) {
      _applyLeaderboardResponse(currentState.response);
      return true;
    }

    if (currentState is GetCreatorLeaderboardErrorState &&
        _matchesLeaderboardRequest(
          levelName: currentState.levelName,
          page: currentState.page,
          timeFilter: currentState.timeFilter,
          creator: currentState.creator,
        )) {
      _error = currentState.errorMessage;
      _isLoading = false;
      return true;
    }

    return false;
  }

  bool _matchesLeaderboardRequest({
    required String? levelName,
    required int page,
    required String timeFilter,
    required String? creator,
  }) {
    return creator == null &&
        levelName == _getApiLevelName(_selectedLevel) &&
        page == _currentPage &&
        timeFilter == _selectedTimeFilter;
  }

  void _applyLeaderboardResponse(CreatorLeaderboardResponse response) {
    final rankings = response.data.rankings;
    final currentUserPid = profileModelG?.pid;
    final currentUserIndex = currentUserPid == null
        ? -1
        : rankings.indexWhere((ranking) => ranking.creatorPid == currentUserPid);

    _creatorRankings = rankings;
    _totalPages = response.data.pagination.lastPage;
    _currentUserRanking =
        currentUserIndex >= 0 ? rankings[currentUserIndex] : null;
    _error = null;
    _isLoading = false;
  }

  void _loadCreatorLeaderboard() {
    final levelName = _getApiLevelName(_selectedLevel);
    print(
        'Loading creator leaderboard for level: $levelName, page: $_currentPage, timeFilter: $_selectedTimeFilter');
    context.read<UserBloc>().add(GetCreatorLeaderboardEvent(
          levelName: levelName,
          page: _currentPage,
          timeFilter: _selectedTimeFilter,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        print('LeaderboardScreen received state: $state');
        if (state is GetCreatorLeaderboardLoadingState) {
          print('Loading state received');
          setState(() {
            _isLoading = true;
            _error = null;
          });
        } else if (state is GetCreatorLeaderboardSuccessState) {
          print(
              'Success state received with ${state.response.data.rankings.length} rankings');
          setState(() {
            _applyLeaderboardResponse(state.response);
          });
        } else if (state is GetCreatorLeaderboardErrorState) {
          print('Error state received: ${state.errorMessage}');
          setState(() {
            _error = state.errorMessage;
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroHeader(),
                      _buildLevelTabs(),
                      _buildSearchAndFilter(),
                      _buildTableHeader(),
                      _buildUserList(),
                      _buildPagination(),
                      const SizedBox(height: 16),
                      _buildCurrentUserRanking(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            child: profileModelG?.myAvatar != null
                ? Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: MemoryImage(profileModelG!.myAvatar!))),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: ClipOval(
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
            onTap: () {
              // Open drawer - try Scaffold first, then use global key
              if (context.canPop()) {
                Navigator.of(context).pop();
              } else {
                // Use GoRouter to navigate to feed where drawer is available
                context.go('/feed');
              }
            },
          ),
          const SizedBox(width: 12),
          const Text(
            'Leaderboard',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.5, // line-height: 150%
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF181919),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clapmi Leaderboard',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.5,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "See where you stand amongst clapmi's top contributors.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    height: 1.5,
                    letterSpacing: 0,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          _buildPodiumGraphic(),
        ],
      ),
    );
  }

  Widget _buildPodiumGraphic() {
    return SizedBox(
        width: 80, height: 80, child: Image.asset('assets/icons/illu.png'));
  }

  Widget _buildLevelTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'Overall Ranking',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400, // Regular
              fontSize: 13,
              height: 1.5, // 150% line-height
              letterSpacing: 0,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'lvl:',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400, // Regular
              fontSize: 13,
              height: 1.5, // 150% line-height
              letterSpacing: 0,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          const SizedBox(width: 6),
          ..._levels.map((level) => GestureDetector(
                onTap: () => setState(() {
                  _selectedLevel = level;
                  _loadCreatorLeaderboard();
                }),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    level,
                    style: TextStyle(
                      color: _selectedLevel == level
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      fontSize: 13,
                      fontWeight: _selectedLevel == level
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: const Color(0xFF181919),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search,
                      color: Colors.white.withOpacity(0.4), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
              value: _selectedTimeFilter,
              dropdownColor: const Color(0xFF1E1E1E),
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: Colors.white, size: 18),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Colors.white,
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All time')),
                DropdownMenuItem(value: 'week', child: Text('This week')),
                DropdownMenuItem(value: 'month', child: Text('This month')),
                DropdownMenuItem(value: 'year', child: Text('This year')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTimeFilter = value;
                    _currentPage = 1; // Reset to first page when filter changes
                    _loadCreatorLeaderboard();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 36),
          Expanded(
            flex: 3,
            child: Text(
              'Username',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500, // Medium
                fontSize: 13,
                height: 1.5, // 150%
                letterSpacing: 0,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Clap points',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                height: 1.5,
                letterSpacing: 0,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Win rate',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                height: 1.5,
                letterSpacing: 0,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Wins',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                height: 1.5,
                letterSpacing: 0,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: const Color(0xFF1E1E1E),
        highlightColor: const Color(0xFF2C2C2C),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
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
                          width: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 10,
                          width: 60,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 14,
                    width: 40,
                    color: Colors.white,
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Text(
                'Error loading leaderboard',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _loadCreatorLeaderboard,
                child: const Text('Retry',
                    style: TextStyle(color: Color(0xFF4A7CF7))),
              ),
            ],
          ),
        ),
      );
    }

    if (_creatorRankings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No creators found for $_selectedLevel level',
            style: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
        ),
      );
    }

    // Map API data to local model for display
    final users = _creatorRankings.asMap().entries.map((entry) {
      final index = entry.key;
      final creator = entry.value;
      return LeaderboardUser(
        rank: index + 1,
        username: creator.creatorUsername,
        clapPoints: creator.score,
        winRate: ((creator.progress.winRate ?? 0) * 100).toInt(),
        wins: creator.progress.totalWins ?? 0,
        avatarInitials: creator.creatorUsername.isNotEmpty
            ? creator.creatorUsername[0].toUpperCase()
            : '?',
        avatarColor: _getAvatarColor(index),
        rankChange: null,
        avatarUrl: creator.creatorImage, // Pass the creator image URL
      );
    }).toList();

    // Filter by search query if not empty
    final filteredUsers = _searchQuery.isEmpty
        ? users
        : users
            .where((user) => user.username
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

    return Column(children: filteredUsers.map(_buildUserRow).toList());
  }

  Color _getAvatarColor(int index) {
    final colors = [
      const Color(0xFF4A7CF7),
      const Color(0xFFE91E8C),
      const Color(0xFFFF6B35),
      const Color(0xFF9B59B6),
      const Color(0xFF2ECC71),
      const Color(0xFFE74C3C),
      const Color(0xFF1ABC9C),
      const Color(0xFFF39C12),
      const Color(0xFF3498DB),
      const Color(0xFFE91E63),
    ];
    return colors[index % colors.length];
  }

  Widget _buildUserRow(LeaderboardUser user) {
    final isCurrentUser = user.username == 'johndoe';

    // Get rank icon for top 3 users
    String? rankIcon;
    if (user.rank == 1) rankIcon = 'assets/icons/rank1.svg';
    if (user.rank == 2) rankIcon = 'assets/icons/rank2.svg';
    if (user.rank == 3) rankIcon = 'assets/icons/rank3.svg';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color:
            isCurrentUser ? const Color(0xFF1A2535) : const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: const Color(0xFF4A7CF7).withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: rankIcon != null
                ? SvgPicture.asset(
                    rankIcon,
                    width: 28,
                    height: 28,
                  )
                : Text(
                    user.rank == 0 ? '-' : '#${user.rank}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 12),
                  ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                      ? Image.network(
                          user.avatarUrl!,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/images/profile1.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          'assets/images/profile1.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(user.username,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/coin.svg',
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFFFD700),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                Text('${user.clapPoints}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text('${user.winRate}%',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text('${user.wins}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 13)),
                if (user.rankChange != null) ...[
                  const SizedBox(width: 4),
                  Icon(
                    user.rankChange! > 0
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: user.rankChange! > 0
                        ? Colors.blueAccent
                        : Colors.redAccent,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _currentPage > 1
                ? () => setState(() {
                      _currentPage = _currentPage - 1;
                      _loadCreatorLeaderboard();
                    })
                : null,
            child: Row(children: [
              Icon(Icons.arrow_back,
                  size: 16,
                  color:
                      Colors.white.withOpacity(_currentPage > 1 ? 0.5 : 0.2)),
              const SizedBox(width: 4),
              Text('Previous',
                  style: TextStyle(
                      color: Colors.white
                          .withOpacity(_currentPage > 1 ? 0.5 : 0.2),
                      fontSize: 13)),
            ]),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () => setState(() {
              _currentPage = 1;
              _loadCreatorLeaderboard();
            }),
            child: Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _currentPage == 1 ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('1',
                    style: TextStyle(
                      color: _currentPage == 1
                          ? Colors.black
                          : Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    )),
              ),
            ),
          ),
          if (_currentPage > 2) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('...',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 13)),
            ),
            GestureDetector(
              onTap: () {
                _loadCreatorLeaderboard();
              },
              child: Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('$_currentPage',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      )),
                ),
              ),
            ),
          ],
          const SizedBox(width: 20),
          GestureDetector(
            onTap: _currentPage < _totalPages
                ? () => setState(() {
                      _currentPage = _currentPage + 1;
                      _loadCreatorLeaderboard();
                    })
                : null,
            child: Row(children: [
              Text('Next',
                  style: TextStyle(
                      color: Colors.white
                          .withOpacity(_currentPage < _totalPages ? 0.5 : 0.2),
                      fontSize: 13)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward,
                  size: 16,
                  color: Colors.white
                      .withOpacity(_currentPage < _totalPages ? 0.5 : 0.2)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserRanking() {
    // Get current user's ranking - prefer _currentUserRanking (set from filtered query)
    final currentUserPid = profileModelG?.pid;
    if (currentUserPid == null) {
      return const SizedBox.shrink();
    }

    // First try to use _currentUserRanking which is populated from filtered user query
    if (_currentUserRanking != null) {
      final rank = _currentUserRanking!.leaderboardRank ?? 1;
      return GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4A7CF7).withOpacity(0.2),
                const Color(0xFF4A7CF7).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF4A7CF7).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7CF7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileModelG?.username ?? 'Your Profile',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Current Ranking',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7CF7).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Color(0xFF4A7CF7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Fallback: Check if user is in _creatorRankings (general leaderboard)
    if (_creatorRankings.isEmpty) {
      return const SizedBox.shrink();
    }

    final userIndex = _creatorRankings.indexWhere(
      (ranking) => ranking.creatorPid == currentUserPid,
    );

    if (userIndex == -1) {
      // User not in rankings - show message
      return GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileModelG?.myAvatar != null
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(profileModelG!.myAvatar!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : CachedNetworkImage(
                        width: 40,
                        height: 40,
                        imageUrl: profileModelG?.image ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, size: 20),
                        ),
                        errorWidget: (context, error, trace) => Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, size: 20),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileModelG?.username ?? 'Your Profile',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'You\'re not in the rankings yet',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7CF7).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '-',
                  style: TextStyle(
                    color: Color(0xFF4A7CF7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final userRanking = _creatorRankings[userIndex];
    // Use leaderboardRank from API response, fallback to index + 1 if not available
    final rank = userRanking.leaderboardRank ?? (userIndex + 1);

    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF4A7CF7).withOpacity(0.2),
              const Color(0xFF4A7CF7).withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF4A7CF7).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4A7CF7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userRanking.creatorUsername,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${userRanking.score} points',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (userRanking.creatorImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  width: 40,
                  height: 40,
                  imageUrl: userRanking.creatorImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 20),
                  ),
                  errorWidget: (context, error, trace) => Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 20),
                  ),
                ),
              )
            else
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7CF7).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    userRanking.creatorUsername.isNotEmpty
                        ? userRanking.creatorUsername[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROFILE SCREEN
// ─────────────────────────────────────────────

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isBenefitsExpanded = false;
  List<CreatorLevelModel> _creatorLevels = [];
  bool _isLevelsLoading = true;
  // Store current user's ranking data for stats
  CreatorRankingModel? _currentUserRanking;
  bool _isRankingLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch creator levels when screen loads
    context.read<UserBloc>().add(const GetCreatorLevelsEvent());
    // Fetch creator leaderboard to get current user's stats
    _loadUserRanking();
  }

  void _loadUserRanking() {
    // Get current user's PID to filter for their ranking only
    final currentUserPid = profileModelG?.pid;

    if (currentUserPid == null) {
      print('LeaderboardScreen: No current user PID found');
      return;
    }

    print(
        'LeaderboardScreen: Loading ranking for current user: $currentUserPid');

    // Load all levels to find the current user - pass creator parameter to filter
    for (final level in ['Rookie', 'Prime', 'Elite', 'Icon', 'Legend']) {
      context.read<UserBloc>().add(GetCreatorLeaderboardEvent(
            levelName: level,
            page: 1,
            timeFilter: 'all',
            creator:
                currentUserPid, // Pass creator to filter for current user only
          ));
    }
    // Set a fallback timeout to stop loading if user not found
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _isRankingLoading) {
        setState(() {
          _isRankingLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is GetCreatorLevelsSuccessState) {
          setState(() {
            _creatorLevels = state.response.data.creatorLevels;
            _isLevelsLoading = false;
          });
        } else if (state is GetCreatorLevelsErrorState) {
          print('ProfileScreen: Error loading levels - ${state.errorMessage}');
          setState(() {
            _isLevelsLoading = false;
          });
        } else if (state is GetCreatorLeaderboardSuccessState) {
          // Find current user's ranking from the leaderboard data
          final currentUserPid = profileModelG?.pid;
          if (currentUserPid != null) {
            final rankings = state.response.data.rankings;
            final userIndex = rankings.indexWhere(
              (ranking) => ranking.creatorPid == currentUserPid,
            );
            if (userIndex != -1) {
              setState(() {
                _currentUserRanking = rankings[userIndex];
                _isRankingLoading = false;
              });
            }
          }
        } else if (state is GetCreatorLeaderboardErrorState) {
          print(
              'ProfileScreen: Error loading rankings - ${state.errorMessage}');
          setState(() {
            _isRankingLoading = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          child: Column(
            children: [
              _buildBackBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildProfileHeader(),
                      const SizedBox(height: 16),
                      _buildLevelBenefitsCard(_creatorLevels, _isLevelsLoading),
                      const SizedBox(height: 12),
                      _buildUnlockEliteCard(_creatorLevels, _isLevelsLoading,
                          _currentUserRanking),
                      const SizedBox(height: 12),
                      _buildEarningsCard(_creatorLevels, _isLevelsLoading),
                      const SizedBox(height: 12),
                      _buildStatsGrid(_currentUserRanking, _isRankingLoading),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/back_leader.png',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                const Text('Back',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final userName =
        profileModelG?.name ?? profileModelG?.username ?? 'Unknown User';
    final userHandle = '@${profileModelG?.username ?? 'user'}';

    return Row(
      children: [
        // Profile image
        profileModelG?.myAvatar != null
            ? Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: MemoryImage(profileModelG!.myAvatar!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : CachedNetworkImage(
                width: 50,
                height: 50,
                imageUrl: profileModelG?.image ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.person),
                ),
                errorWidget: (context, error, trace) => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.person),
                ),
              ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500, // Medium (not bold)
                  fontSize: 16, // fixed from 18 → 16
                  height: 1.5, // 150% line-height
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
              Text(
                userHandle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400, // Regular
                  fontSize: 13,
                  height: 1.5, // 150% line-height
                  letterSpacing: 0,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Current level',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_currentUserRanking?.level.badge != null &&
                    _currentUserRanking!.level.badge.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Image.network(
                      _currentUserRanking!.level.badge,
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                Text(_currentUserRanking?.level.name ?? 'Rookie',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelBenefitsCard(
      List<CreatorLevelModel> creatorLevels, bool isLoading) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: const Color(0xFF1E1E1E),
        highlightColor: const Color(0xFF2C2C2C),
        child: Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }

    // Use creatorLevels data to display level-specific information
    final currentLevel = creatorLevels.isNotEmpty ? creatorLevels.first : null;

    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: _buildBenefitsDropdown(),
        trailing: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
        initiallyExpanded: true,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFF1A2E5A),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Want to skip the wait?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  'Pay for the upgrade now and enjoy all better livestream and combo ground payout, revenue share and much more.',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      height: 1.5),
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () {
                    context.go(MyAppRouteConstant.paymentLeader);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Color(0XFFB0D2F0),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Pay to unlock next prime',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600, // SemiBold
                      fontSize: 13,
                      height: 1.5, // 150% line-height
                      letterSpacing: 0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockEliteCard(List<CreatorLevelModel> creatorLevels,
      bool isLoading, CreatorRankingModel? userRanking) {
    if (isLoading) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Unlock Elite',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500, // Medium
                  fontSize: 16,
                  height: 1.5, // 150% line-height
                  letterSpacing: 0,
                  color: Colors.white, // adjust if needed
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/icons/elite.png',
                height: 100.h,
                width: 100.w,
              )
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              context.go(MyAppRouteConstant.unlockElite);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A7CF7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'How to unlock elite',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600, // SemiBold
                fontSize: 13,
                height: 1.5, // 150% line-height
                letterSpacing: 0,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text("You are almost there, don't give up!",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 13)),
              ),
              Text(
                '${userRanking?.progressPercentage ?? 0}%',
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600, // SemiBold
                    fontSize: 16, // fixed from 13 → 16
                    height: 1.5, // 150% line-height
                    letterSpacing: 0,
                    color: Color(0XFF8ABDE8)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (userRanking?.progressPercentage ?? 0) / 100,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8ABDE8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard(
      List<CreatorLevelModel> creatorLevels, bool isLoading) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: const Color(0xFF1E1E1E),
        highlightColor: const Color(0xFF2C2C2C),
        child: Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2E5A), Color(0xFF1E3A6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child:
                      _buildEarningItem('80%', 'Earning from live\nstreams')),
              const SizedBox(width: 12),
              Expanded(
                  child:
                      _buildEarningItem('55%', 'Earning from combo\nstreams')),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Unlock higher levels to get better earning percentage.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600, // SemiBold
              fontSize: 13,
              height: 1.5, // 150% line-height
              letterSpacing: 0,
              color: Colors.white, // adjust opacity if needed
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Color(0XFF002F56), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/coin.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFFD700),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600, // SemiBold
                  fontSize: 20, // fixed from 22 → 20
                  height: 1.5, // 150% line-height
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                  height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(CreatorRankingModel? userRanking, bool isLoading) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: const Color(0xFF1E1E1E),
        highlightColor: const Color(0xFF2C2C2C),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.4,
          children: List.generate(8, (index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      );
    }

    // Extract stats from API data or use defaults
    final progress = userRanking?.progress;
    final ranking = userRanking?.leaderboardRank ?? 0;
    final earnedPoints = userRanking?.score ?? '0';
    final winRate = progress?.winRate != null
        ? '${((progress?.winRate ?? 0) * 100).toInt()}%'
        : '0%';
    final totalWins = progress?.totalWins?.toString() ?? '0';
    final totalLivestreams = progress?.totalStreams30d?.toString() ?? '0';
    final avgViewers = progress?.avgViewers30d != null
        ? '${progress?.avgViewers30d!.toStringAsFixed(1)}k'
        : '0';
    final returningViewers = progress?.returningViewers30d?.toString() ?? '0';
    final engagementRate = progress?.engagementRate30d != null
        ? '${((progress?.engagementRate30d ?? 0) * 100).toInt()}%'
        : '0%';

    final stats = [
      ('Ranking', '#$ranking', null),
      ('Earned points', earnedPoints, 'coin'),
      ('Win rate', winRate, null),
      ('Total wins', totalWins, null),
      ('Total livestream', totalLivestreams, null),
      ('Avg. live viewers', avgViewers, null),
      ('Returning viewers', returningViewers, null),
      ('Engagement rate', engagementRate, null),
    ];

    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.4,
          children: stats.map((s) => _buildStatCard(s.$1, s.$2, s.$3)).toList(),
        ),
        const SizedBox(height: 16),
        _buildBenefitsDropdown(),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String? iconType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 1.5,
                    letterSpacing: 0,
                    color: Colors.white.withOpacity(0.45),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (iconType == 'coin') ...[
                      SvgPicture.asset(
                        'assets/icons/coin.svg',
                        width: 14,
                        height: 14,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFFD700),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 1.5,
                        letterSpacing: 0,
                        color: Colors.white,
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
  }

  Widget _buildBenefitsDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                setState(() => _isBenefitsExpanded = !_isBenefitsExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Levels Benefits',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    _isBenefitsExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
          if (_isBenefitsExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBenefitItem('Access to exclusive badges'),
                  _buildBenefitItem('Priority in leaderboard ranking'),
                  _buildBenefitItem('Earn 10% more clap points'),
                  _buildBenefitItem('Unlock premium profile themes'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF4A7CF7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
