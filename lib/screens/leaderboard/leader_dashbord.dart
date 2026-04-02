import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/core/di/injector.dart';
import 'package:clapmi/features/user/data/models/creator_leaderboard_model.dart';
import 'package:clapmi/features/user/data/models/payment_grade_model.dart';
import 'package:clapmi/features/user/data/datasources/user_remote_datasource.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_event.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
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
  final String creatorPid;
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
    required this.creatorPid,
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
// LEADERBOARD SCREEN
// ─────────────────────────────────────────────

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static const String _leaderboardIntroSeenKey = 'leaderboard_intro_seen_v2';
  static CreatorLeaderboardResponse? _cachedLeaderboardResponse;
  static CreatorRankingModel? _cachedCurrentUserRanking;
  static String? _cachedCurrentUserLevelName;
  static String? _cachedCurrentUserTimeFilter;
  static String? _cachedLevelName;
  static int? _cachedPage;
  static String? _cachedTimeFilter;
  String _selectedLevel = 'Rookie';
  int _currentPage = 1;
  List<CreatorRankingModel> _creatorRankings = [];
  bool _isLoading = false;
  String? _error;
  int _totalPages = 1;
  int _perPage = 30;
  String _selectedTimeFilter = 'all'; // 'week', 'month', 'year', 'all'
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // Add field for total pages
  CreatorRankingModel? _currentUserRanking; // Store current user's ranking
  bool _isCurrentUserRankingLoading = true;
  bool _hasResolvedCurrentUserRanking = false;

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
    _hydrateFromCache();
    _hydrateFromCurrentBlocState();
    if (_creatorRankings.isEmpty && !_isLoading && _error == null) {
      _loadCreatorLeaderboard();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowLeaderboardIntro();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _hydrateFromCurrentBlocState() {
    final currentState = context.read<UserBloc>().state;
    var hydrated = false;

    if (currentState is GetCreatorLeaderboardLoadingState &&
        _matchesMainLeaderboardRequest(
          levelName: currentState.levelName,
          page: currentState.page,
          timeFilter: currentState.timeFilter,
          creator: currentState.creator,
        )) {
      _isLoading = true;
      _error = null;
      hydrated = true;
    }

    if (currentState is GetCreatorLeaderboardSuccessState &&
        _matchesMainLeaderboardRequest(
          levelName: currentState.levelName,
          page: currentState.page,
          timeFilter: currentState.timeFilter,
          creator: currentState.creator,
        )) {
      _applyLeaderboardResponse(currentState.response);
      hydrated = true;
    }

    if (currentState is GetCreatorLeaderboardErrorState &&
        _matchesMainLeaderboardRequest(
          levelName: currentState.levelName,
          page: currentState.page,
          timeFilter: currentState.timeFilter,
          creator: currentState.creator,
        )) {
      _error = currentState.errorMessage;
      _isLoading = false;
      hydrated = true;
    }

    if (currentState is GetCreatorLeaderboardSuccessState &&
        _matchesCurrentUserLeaderboardRequest(
          levelName: currentState.levelName,
          timeFilter: currentState.timeFilter,
          creator: currentState.creator,
        )) {
      _currentUserRanking = _extractCurrentUserRanking(currentState.response);
      _isCurrentUserRankingLoading = false;
      _hasResolvedCurrentUserRanking = true;
      hydrated = true;
    }

    if (currentState is GetCreatorLeaderboardErrorState &&
        _matchesCurrentUserLeaderboardRequest(
          levelName: currentState.levelName,
          timeFilter: currentState.timeFilter,
          creator: currentState.creator,
        )) {
      _isCurrentUserRankingLoading = false;
      _hasResolvedCurrentUserRanking = true;
      hydrated = true;
    }

    return hydrated;
  }

  bool _matchesMainLeaderboardRequest({
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

  bool _matchesCachedRequest() {
    return _cachedLeaderboardResponse != null &&
        _cachedLevelName == _getApiLevelName(_selectedLevel) &&
        _cachedPage == _currentPage &&
        _cachedTimeFilter == _selectedTimeFilter;
  }

  bool _matchesCachedCurrentUserRequest() {
    return _cachedCurrentUserRanking != null &&
        _cachedCurrentUserLevelName == _getApiLevelName(_selectedLevel) &&
        _cachedCurrentUserTimeFilter == _selectedTimeFilter;
  }

  bool _matchesCurrentUserLeaderboardRequest({
    required String? levelName,
    required String timeFilter,
    required String? creator,
  }) {
    final currentUserPid = profileModelG?.pid;
    return currentUserPid != null &&
        creator == currentUserPid &&
        levelName == _getApiLevelName(_selectedLevel) &&
        timeFilter == _selectedTimeFilter;
  }

  void _applyLeaderboardResponse(CreatorLeaderboardResponse response) {
    final rankings = response.data.rankings;
    _creatorRankings = rankings;
    _totalPages = response.data.pagination.lastPage;
    _perPage = response.data.pagination.perPage;
    _error = null;
    _isLoading = false;
    _cachedLeaderboardResponse = response;
    _cachedLevelName = _getApiLevelName(_selectedLevel);
    _cachedPage = _currentPage;
    _cachedTimeFilter = _selectedTimeFilter;
  }

  CreatorRankingModel? _extractCurrentUserRanking(
      CreatorLeaderboardResponse response) {
    final currentUserPid = profileModelG?.pid;
    if (currentUserPid == null) {
      return null;
    }

    for (final ranking in response.data.rankings) {
      if (ranking.creatorPid == currentUserPid) {
        return ranking;
      }
    }

    return null;
  }

  CreatorRankingModel? _currentUserRankingFromVisibleList() {
    final currentUserPid = profileModelG?.pid;
    if (currentUserPid == null) {
      return null;
    }

    for (final ranking in _creatorRankings) {
      if (ranking.creatorPid == currentUserPid) {
        return ranking;
      }
    }

    return null;
  }

  void _loadCreatorLeaderboard() {
    final levelName = _getApiLevelName(_selectedLevel);
    context.read<UserBloc>().add(GetCreatorLeaderboardEvent(
          levelName: levelName,
          page: _currentPage,
          timeFilter: _selectedTimeFilter,
        ));
  }

  void _loadCurrentUserRanking() {
    final currentUserPid = profileModelG?.pid;
    if (currentUserPid == null) {
      _isCurrentUserRankingLoading = false;
      _hasResolvedCurrentUserRanking = true;
      return;
    }

    final visibleRanking = _currentUserRankingFromVisibleList();
    if (visibleRanking != null) {
      _currentUserRanking = visibleRanking;
      _cachedCurrentUserRanking = visibleRanking;
      _cachedCurrentUserLevelName = _getApiLevelName(_selectedLevel);
      _cachedCurrentUserTimeFilter = _selectedTimeFilter;
      _isCurrentUserRankingLoading = false;
      _hasResolvedCurrentUserRanking = true;
      return;
    }

    if (_matchesCachedCurrentUserRequest()) {
      _currentUserRanking = _cachedCurrentUserRanking;
      _isCurrentUserRankingLoading = false;
      _hasResolvedCurrentUserRanking = true;
      return;
    }

    if (_isCurrentUserRankingLoading) {
      return;
    }

    _isCurrentUserRankingLoading = true;
    _hasResolvedCurrentUserRanking = false;
    context.read<UserBloc>().add(GetCreatorLeaderboardEvent(
          levelName: _getApiLevelName(_selectedLevel),
          page: 1,
          timeFilter: _selectedTimeFilter,
          creator: currentUserPid,
        ));
  }

  void _refreshLeaderboard({bool resetPage = false}) {
    if (resetPage) {
      _currentPage = 1;
    }
    _currentUserRanking = null;
    _isCurrentUserRankingLoading = false;
    _hasResolvedCurrentUserRanking = false;
    _loadCreatorLeaderboard();
  }

  void _hydrateFromCache() {
    if (!_matchesCachedRequest()) {
      return;
    }

    final cachedResponse = _cachedLeaderboardResponse;
    if (cachedResponse == null) {
      return;
    }

    _applyLeaderboardResponse(cachedResponse);
    _currentUserRanking = _currentUserRankingFromVisibleList();
    if (_currentUserRanking == null && _matchesCachedCurrentUserRequest()) {
      _currentUserRanking = _cachedCurrentUserRanking;
    }
    _hasResolvedCurrentUserRanking =
        _currentUserRanking != null || _matchesCachedCurrentUserRequest();
    _isCurrentUserRankingLoading = false;
  }

  Future<void> _maybeShowLeaderboardIntro() async {
    final preferenceService = getItInstance<AppPreferenceService>();
    final hasSeenIntro =
        preferenceService.getValue<bool>(_leaderboardIntroSeenKey) ?? false;

    if (hasSeenIntro || !mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => const _LeaderboardIntroDialog(),
    );

    await preferenceService.saveValue<bool>(_leaderboardIntroSeenKey, true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is GetCreatorLeaderboardLoadingState &&
            _matchesMainLeaderboardRequest(
              levelName: state.levelName,
              page: state.page,
              timeFilter: state.timeFilter,
              creator: state.creator,
            )) {
          setState(() {
            _isLoading = true;
            _error = null;
          });
        } else if (state is GetCreatorLeaderboardSuccessState &&
            _matchesMainLeaderboardRequest(
              levelName: state.levelName,
              page: state.page,
              timeFilter: state.timeFilter,
              creator: state.creator,
            )) {
          final visibleCurrentUserRanking =
              _extractCurrentUserRanking(state.response);
          final shouldLoadCurrentUserRanking = visibleCurrentUserRanking ==
              null &&
              profileModelG?.pid != null &&
              !_matchesCachedCurrentUserRequest();

          setState(() {
            _applyLeaderboardResponse(state.response);
            if (visibleCurrentUserRanking != null) {
              _currentUserRanking = visibleCurrentUserRanking;
              _cachedCurrentUserRanking = visibleCurrentUserRanking;
              _cachedCurrentUserLevelName = _getApiLevelName(_selectedLevel);
              _cachedCurrentUserTimeFilter = _selectedTimeFilter;
              _isCurrentUserRankingLoading = false;
              _hasResolvedCurrentUserRanking = true;
            } else if (_matchesCachedCurrentUserRequest()) {
              _currentUserRanking = _cachedCurrentUserRanking;
              _isCurrentUserRankingLoading = false;
              _hasResolvedCurrentUserRanking = true;
            } else {
              _currentUserRanking = null;
              _isCurrentUserRankingLoading = false;
              _hasResolvedCurrentUserRanking = false;
            }
          });

          if (shouldLoadCurrentUserRanking) {
            _loadCurrentUserRanking();
          }
        } else if (state is GetCreatorLeaderboardErrorState &&
            _matchesMainLeaderboardRequest(
              levelName: state.levelName,
              page: state.page,
              timeFilter: state.timeFilter,
              creator: state.creator,
            )) {
          setState(() {
            _error = state.errorMessage;
            _isLoading = false;
          });
        } else if (state is GetCreatorLeaderboardSuccessState &&
            _matchesCurrentUserLeaderboardRequest(
              levelName: state.levelName,
              timeFilter: state.timeFilter,
              creator: state.creator,
            )) {
          setState(() {
            _currentUserRanking = _extractCurrentUserRanking(state.response);
            _cachedCurrentUserRanking = _currentUserRanking;
            _cachedCurrentUserLevelName = _getApiLevelName(_selectedLevel);
            _cachedCurrentUserTimeFilter = _selectedTimeFilter;
            _isCurrentUserRankingLoading = false;
            _hasResolvedCurrentUserRanking = true;
          });
        } else if (state is GetCreatorLeaderboardErrorState &&
            _matchesCurrentUserLeaderboardRequest(
              levelName: state.levelName,
              timeFilter: state.timeFilter,
              creator: state.creator,
            )) {
          setState(() {
            _isCurrentUserRankingLoading = false;
            _hasResolvedCurrentUserRanking = true;
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
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: AppAvatar(
                imageUrl: profileModelG?.image,
                memoryBytes: profileModelG?.myAvatar,
                name: profileModelG?.username ?? profileModelG?.name,
                size: 30.w,
                backgroundColor: Colors.grey[300]!,
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
                  _refreshLeaderboard(resetPage: true);
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
                    _refreshLeaderboard(resetPage: true);
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
    if (_isLoading && _creatorRankings.isEmpty) {
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
                onPressed: _refreshLeaderboard,
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
      final fallbackRank = ((_currentPage - 1) * _perPage) + index + 1;
      return LeaderboardUser(
        creatorPid: creator.creatorPid,
        rank: creator.leaderboardRank ?? fallbackRank,
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

    return Column(
      children: [
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: const LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Color(0xFF1E1E1E),
                valueColor: AlwaysStoppedAnimation(Color(0xFF4A7CF7)),
              ),
            ),
          ),
        ...filteredUsers.map(_buildUserRow),
      ],
    );
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

  Widget _buildInitialsAvatar({
    required String initials,
    required Color backgroundColor,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Text(
        initials.isNotEmpty ? initials : '?',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.4,
        ),
      ),
    );
  }

  String _firstInitial(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '?';
    }
    return trimmed[0].toUpperCase();
  }

  Widget _buildLeaderboardAvatar({
    required String? imageUrl,
    required String initials,
    required Color fallbackColor,
    required double size,
  }) {
    return AppAvatar(
      imageUrl: imageUrl,
      fallbackText: initials,
      size: size,
      backgroundColor: fallbackColor,
      foregroundColor: Colors.white,
    );
  }

  Widget _buildUserRow(LeaderboardUser user) {
    final isCurrentUser = user.creatorPid == profileModelG?.pid;

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
                  child: _buildLeaderboardAvatar(
                    imageUrl: user.avatarUrl,
                    initials: user.avatarInitials,
                    fallbackColor: user.avatarColor,
                    size: 32,
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
    final currentUserPid = profileModelG?.pid;
    if (currentUserPid == null) {
      return const SizedBox.shrink();
    }

    final currentUserRanking =
        _currentUserRanking ?? _currentUserRankingFromVisibleList();

    if (!_hasResolvedCurrentUserRanking ||
        (currentUserRanking == null &&
            (_isLoading || _isCurrentUserRankingLoading))) {
      return const SizedBox.shrink();
    }

    if (currentUserRanking == null) {
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
                child: _buildLeaderboardAvatar(
                  imageUrl: profileModelG?.image,
                  initials: _firstInitial(profileModelG?.username),
                  fallbackColor: const Color(0xFF4A7CF7),
                  size: 40,
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
    final rank = currentUserRanking.leaderboardRank;
    final rankLabel = rank == null || rank <= 0 ? '-' : '#$rank';

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
                  rankLabel,
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
                    currentUserRanking.creatorUsername,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${currentUserRanking.score} points',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _buildLeaderboardAvatar(
                imageUrl: currentUserRanking.creatorImage,
                initials: currentUserRanking.creatorUsername.isNotEmpty
                    ? currentUserRanking.creatorUsername[0].toUpperCase()
                    : '?',
                fallbackColor: const Color(0xFF4A7CF7).withOpacity(0.5),
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionStatusCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF181919),
            const Color(0xFF181919).withOpacity(0.92),
            const Color(0xFFF9D0B3).withOpacity(0.18),
          ],
          stops: const [0.0, 0.78, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.24),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '26 Days Remaining',
                      style: TextStyle(
                        color: Color(0xFFF9D0B3),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Stay subscribed to remain on Prime',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(MyAppRouteConstant.paymentLeader);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Subscribe',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.94,
              minHeight: 5,
              backgroundColor: Colors.black.withOpacity(0.35),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFF9D0B3)),
            ),
          ),
        ],
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
  List<PaymentGradeModel> _paymentGrades = [];
  bool _isPaymentGradesLoading = true;
  // Store current user's ranking data for stats
  CreatorRankingModel? _currentUserRanking;
  bool _isRankingLoading = true;
  int _pendingRankingRequests = 0;
  static const List<String> _levelOrder = [
    'Rookie',
    'Prime',
    'Elite',
    'Icon',
    'Legend',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch creator levels when screen loads
    context.read<UserBloc>().add(const GetCreatorLevelsEvent());
    // Fetch creator leaderboard to get current user's stats
    _loadUserRanking();
    // Fetch payment grades to get subscription_ends_at
    _loadPaymentGrades();
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

    _pendingRankingRequests = _levelOrder.length;
    _currentUserRanking = null;
    _isRankingLoading = true;

    // Load all levels to find the current user - pass creator parameter to filter
    for (final level in _levelOrder) {
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

  Future<void> _loadPaymentGrades({int retryCount = 0}) async {
    const maxRetries = 3;
    const baseDelay = Duration(seconds: 2);

    try {
      final datasource = getItInstance<UserRemoteDatasource>();
      final response = await datasource.getPaymentGrades();

      if (mounted) {
        setState(() {
          _paymentGrades = response.data.data;
          _isPaymentGradesLoading = false;
        });
        print('ProfileScreen: Loaded ${_paymentGrades.length} payment grades');
        for (final grade in _paymentGrades) {
          print(
              'ProfileScreen: Grade ${grade.name} - subscriptionEndsAt: ${grade.subscriptionEndsAt}');
        }
      }
    } catch (e) {
      print(
          'ProfileScreen: Error loading payment grades (attempt ${retryCount + 1}/$maxRetries) - $e');

      // Retry with exponential backoff
      if (retryCount < maxRetries && mounted) {
        final delay = baseDelay * (retryCount + 1);
        print('ProfileScreen: Retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
        if (mounted) {
          return _loadPaymentGrades(retryCount: retryCount + 1);
        }
      }

      if (mounted) {
        setState(() {
          _isPaymentGradesLoading = false;
        });
      }
    }
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
          final currentUserPid = profileModelG?.pid;
          if (currentUserPid != null &&
              state.creator == currentUserPid &&
              state.levelName != null) {
            final rankings = state.response.data.rankings;
            final userIndex = rankings.indexWhere(
              (ranking) => ranking.creatorPid == currentUserPid,
            );
            final matchedRanking = userIndex != -1 ? rankings[userIndex] : null;
            if (userIndex != -1) {
              setState(() {
                _currentUserRanking = _pickHigherLevelRanking(
                  _currentUserRanking,
                  matchedRanking,
                );
              });
            }
            _markRankingLookupComplete();
          }
        } else if (state is GetCreatorLeaderboardErrorState) {
          final currentUserPid = profileModelG?.pid;
          if (currentUserPid != null &&
              state.creator == currentUserPid &&
              state.levelName != null) {
            print(
                'ProfileScreen: Error loading rankings - ${state.errorMessage}');
            _markRankingLookupComplete();
          }
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
                      _buildSubscriptionStatusCard(
                          _creatorLevels, _currentUserRanking),
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
        AppAvatar(
          imageUrl: profileModelG?.image,
          memoryBytes: profileModelG?.myAvatar,
          name: profileModelG?.username ?? profileModelG?.name,
          size: 50,
          backgroundColor: Colors.grey[300]!,
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
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.network(
                      _currentUserRanking!.level.badge,
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 28,
                      ),
                    ),
                  ),
                Text(_currentUserRanking?.level.name ?? 'Rookie',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
            margin: const EdgeInsets.fromLTRB(8, 0, 12, 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF181919),
                    Color(0xFFF9D0B3),
                  ],
                  stops: [0.03, 0.97],
                ),
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
                    backgroundColor: Color(0xFFF9D0B3),
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

  Widget _buildSubscriptionStatusCard(
      List<CreatorLevelModel> creatorLevels, CreatorRankingModel? userRanking) {
    final currentLevelName = _currentUserRanking?.level.name ?? 'Prime';
    final currentLevel = _getCurrentLevelModel(creatorLevels, userRanking);

    // Find current level from payment grades to get subscription_ends_at
    PaymentGradeModel? currentPaymentGrade;
    if (_paymentGrades.isNotEmpty) {
      try {
        currentPaymentGrade = _paymentGrades.firstWhere(
          (grade) => grade.name.toLowerCase() == currentLevelName.toLowerCase(),
        );
      } catch (e) {
        // If not found, use the first payment grade
        currentPaymentGrade = _paymentGrades.first;
      }
    }

    // Calculate days remaining from subscription_ends_at
    final subscriptionEndsAt = currentPaymentGrade?.subscriptionEndsAt;
    int daysRemaining = 0;
    double progressValue = 0.0;

    // Debug logging
    print('Subscription Debug: currentLevelName = $currentLevelName');
    print('Subscription Debug: currentLevel = ${currentLevel?.name}');
    print(
        'Subscription Debug: currentPaymentGrade = ${currentPaymentGrade?.name}');
    print('Subscription Debug: subscriptionEndsAt = $subscriptionEndsAt');

    if (subscriptionEndsAt != null) {
      final now = DateTime.now();
      final difference = subscriptionEndsAt.difference(now);
      daysRemaining = difference.inDays;

      // Calculate progress (assuming 30-day subscription period)
      // Progress shows how much of the subscription period has elapsed
      final totalDays = 30;
      final daysElapsed = totalDays - daysRemaining;
      progressValue = (daysElapsed / totalDays).clamp(0.0, 1.0);
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF181919),
            const Color(0xFF181919).withOpacity(0.92),
            const Color(0xFFF9D0B3).withOpacity(0.18),
          ],
          stops: const [0.0, 0.78, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.24),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$daysRemaining Days Remaining',
                      style: TextStyle(
                        color: Color(0xFFF9D0B3),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Stay subscribed to remain on $currentLevelName',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(
                      MyAppRouteConstant.paymentCheckout,
                      extra: {
                        'tierUuid': currentLevel?.uuid,
                        'tierName': currentLevel?.name ?? currentLevelName,
                        'tierPrice': currentLevel?.subscriptionAmount ?? 0,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Subscribe',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 5,
              backgroundColor: Colors.black.withOpacity(0.35),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFF9D0B3)),
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

    final nextLevelName = _getNextLevelName(userRanking);
    final nextLevel = nextLevelName == null
        ? null
        : _findLevelByName(creatorLevels, nextLevelName);
    final unlockTitle = nextLevelName == null
        ? 'You are on the top level'
        : 'Unlock $nextLevelName';
    final unlockButtonLabel = nextLevel == null
        ? (nextLevelName == null
            ? 'You are already at the highest tier'
            : 'How to unlock $nextLevelName')
        : 'How to unlock $nextLevelName';

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
              Text(
                unlockTitle,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500, // Medium
                  fontSize: 16,
                  height: 1.5, // 150% line-height
                  letterSpacing: 0,
                  color: Colors.white, // adjust if needed
                ),
              ),
              const Spacer(),
              _buildNextLevelIcon(nextLevel, nextLevelName),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: nextLevelName == null
                ? null
                : () {
                    context.go(MyAppRouteConstant.unlockElite);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A7CF7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              unlockButtonLabel,
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

  String? _getNextLevelName(CreatorRankingModel? userRanking) {
    final currentLevelName = userRanking?.level.name;
    if (currentLevelName == null || currentLevelName.isEmpty) {
      return _levelOrder.isNotEmpty ? _levelOrder.first : null;
    }

    final fallbackIndex = _levelOrder.indexWhere(
      (level) => level.toLowerCase() == currentLevelName.toLowerCase(),
    );

    if (fallbackIndex == -1 || fallbackIndex + 1 >= _levelOrder.length) {
      return null;
    }

    return _levelOrder[fallbackIndex + 1];
  }

  CreatorLevelModel? _findLevelByName(
      List<CreatorLevelModel> creatorLevels, String levelName) {
    for (final level in creatorLevels) {
      if (level.name.toLowerCase() == levelName.toLowerCase()) {
        return level;
      }
    }

    return null;
  }

  CreatorLevelModel? _getCurrentLevelModel(
      List<CreatorLevelModel> creatorLevels, CreatorRankingModel? userRanking) {
    final currentLevelName = userRanking?.level.name;
    if (currentLevelName == null || currentLevelName.isEmpty) {
      return null;
    }

    return _findLevelByName(creatorLevels, currentLevelName);
  }

  Widget _buildNextLevelIcon(
      CreatorLevelModel? nextLevel, String? nextLevelName) {
    const height = 100.0;
    const width = 100.0;
    final normalized = nextLevelName?.toLowerCase() ?? '';

    if (normalized == 'legend') {
      return _buildFallbackLevelIcon(nextLevelName);
    }

    if (nextLevel?.badge != null && nextLevel!.badge!.isNotEmpty) {
      return Image.network(
        nextLevel.badge!,
        height: height.h,
        width: width.w,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallbackLevelIcon(nextLevelName),
      );
    }

    return _buildFallbackLevelIcon(nextLevelName);
  }

  Widget _buildFallbackLevelIcon(String? levelName) {
    final normalized = levelName?.toLowerCase() ?? '';

    if (normalized == 'legend') {
      return Image.asset(
        'assets/icons/legend1.png',
        height: 100.h,
        width: 100.w,
      );
    }

    if (normalized == 'prime') {
      return Image.asset(
        'assets/icons/prime.png',
        height: 100.h,
        width: 100.w,
      );
    }

    if (normalized == 'icon') {
      return Image.asset(
        'assets/icons/ic.png',
        height: 100.h,
        width: 100.w,
      );
    }

    return Image.asset(
      'assets/icons/elite.png',
      height: 100.h,
      width: 100.w,
    );
  }

  void _markRankingLookupComplete() {
    if (!mounted) {
      return;
    }

    setState(() {
      if (_pendingRankingRequests > 0) {
        _pendingRankingRequests -= 1;
      }
      if (_pendingRankingRequests == 0) {
        _isRankingLoading = false;
      }
    });
  }

  CreatorRankingModel? _pickHigherLevelRanking(
    CreatorRankingModel? current,
    CreatorRankingModel? candidate,
  ) {
    if (candidate == null) {
      return current;
    }
    if (current == null) {
      return candidate;
    }

    final currentIndex = _levelIndex(current.level.name);
    final candidateIndex = _levelIndex(candidate.level.name);

    if (candidateIndex > currentIndex) {
      return candidate;
    }

    return current;
  }

  int _levelIndex(String? levelName) {
    if (levelName == null) {
      return -1;
    }

    return _levelOrder.indexWhere(
      (level) => level.toLowerCase() == levelName.toLowerCase(),
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

class _LeaderboardIntroDialog extends StatefulWidget {
  const _LeaderboardIntroDialog();

  @override
  State<_LeaderboardIntroDialog> createState() =>
      _LeaderboardIntroDialogState();
}

class _LeaderboardIntroDialogState extends State<_LeaderboardIntroDialog> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const List<String> _pages = [
    'There are 5 creator levels on Clapmi: Rookie, Prime, Elite, Icon and Legend. Only Prime level and above appear on the leaderboard.\n\nRookie creators are excluded to maintain quality, competitiveness, and signal strength.\n\nRankings are based on:\nConsistency (number of livestreams)\nAudience size (average live viewers)\nEngagement (claps, comments, gifts)\nRevenue generated.\n\nPerformance is calculated over a rolling 30-day window.\n\nLeaderboard updates daily (with near real-time adjustments).',
    'Must stream within last 7 days to remain visible.\n\n14+ days inactivity = removed from leaderboard.\n\nUpgrade means immediate move to next level.\n\nCreators can upgrade to the next level by paying with Clap points from their wallet or by meeting the performance criteria of the next level.\n\nLegend cannot be upgraded into, it is strictly merit-based/invite only.',
    'Creators can subscribe to remain in their current level for 30 days.\n\nSubscription auto-renews after first purchase.\n\nCreators can cancel anytime.\n\nSubscription applies to all levels, including Legend.',
    'If a creator:\nFails to meet current level criteria.\nFails to meet next level progression threshold.\nThey are demoted to the previous level.\n\nLeaderboard rewards: consistent performance, real engagement, and revenue impact, not one-time spikes or virality.',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modalWidth = MediaQuery.sizeOf(context).width - 36;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: SizedBox(
        width: modalWidth,
        child: AspectRatio(
          aspectRatio: 373 / 683,
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/icons/leader.svg',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.22),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white.withOpacity(0.82),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(26, 220, 26, 24),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                _pages[index],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14.sp,
                                  height: 1.62,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: List.generate(
                                _pages.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  margin: const EdgeInsets.only(right: 6),
                                  width: _currentPage == index ? 22 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? const Color(0xFFF9D0B3)
                                        : Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_currentPage == _pages.length - 1) {
                                Navigator.of(context).pop();
                                return;
                              }
                              await _pageController.nextPage(
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Text(
                              _currentPage == _pages.length - 1
                                  ? 'Done'
                                  : 'Next',
                              style: const TextStyle(
                                color: Color(0xFFF9D0B3),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
