import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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

  const LeaderboardUser({
    required this.rank,
    required this.username,
    required this.clapPoints,
    required this.winRate,
    required this.wins,
    required this.avatarInitials,
    required this.avatarColor,
    this.rankChange,
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
  String _selectedLevel = 'Legend';
  int _currentPage = 1;

  final _levels = ['Legend', 'Icon', 'Elite', 'Prime'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Image.asset('assets/images/person2.png'),
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
                  textAlign: TextAlign.center,
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
                  "See where you stand amongst\nclapmi's top contributors.",
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
                onTap: () => setState(() => _selectedLevel = level),
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
                  Text(
                    'Search',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400, // Regular
                      fontSize: 13, // fixed from 14 → 13
                      height: 1.5, // 150% line-height
                      letterSpacing: 0,
                      color: Colors.white.withOpacity(0.3),
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
            child: const Row(
              children: [
                Text(
                  'All time',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400, // Regular
                    fontSize: 13,
                    height: 1.5, // 150% line-height
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
              ],
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
    return Column(children: _users.map(_buildUserRow).toList());
  }

  Widget _buildUserRow(LeaderboardUser user) {
    final isCurrentUser = user.username == 'johndoe';

    // Get rank icon for top 3 users
    String? rankIcon;
    if (user.rank == 1) rankIcon = 'assets/icons/rank1.svg';
    if (user.rank == 2) rankIcon = 'assets/icons/rank2.svg';
    if (user.rank == 3) rankIcon = 'assets/icons/rank3.svg';

    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
      child: Container(
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
                    child: Image.asset(
                      'assets/images/person2.png',
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
            onTap: () =>
                setState(() => _currentPage = (_currentPage - 1).clamp(1, 10)),
            child: Row(children: [
              Icon(Icons.arrow_back,
                  size: 16, color: Colors.white.withOpacity(0.5)),
              const SizedBox(width: 4),
              Text('Previous',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 13)),
            ]),
          ),
          const SizedBox(width: 20),
          ...[1, 2, 3].map((page) => GestureDetector(
                onTap: () => setState(() => _currentPage = page),
                child: Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentPage == page
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text('$page',
                        style: TextStyle(
                          color: _currentPage == page
                              ? Colors.black
                              : Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        )),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('...',
                style: TextStyle(color: Colors.white.withOpacity(0.4))),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () =>
                setState(() => _currentPage = (_currentPage + 1).clamp(1, 10)),
            child: Row(children: [
              Text('Next',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 13)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward,
                  size: 16, color: Colors.white.withOpacity(0.5)),
            ]),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    _buildLevelBenefitsCard(),
                    const SizedBox(height: 12),
                    _buildUnlockEliteCard(),
                    const SizedBox(height: 12),
                    _buildEarningsCard(),
                    const SizedBox(height: 12),
                    _buildStatsGrid(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
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
            child: const Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                SizedBox(width: 4),
                Text('Back',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        Image.asset('assets/images/person2.png'),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John doe',
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
                '@johndoe',
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
            const Text('Rookie',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelBenefitsCard() {
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
                    context.go(MyAppRouteConstant.subscriptionScreen);
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
                    'Pay to unlock elite',
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

  Widget _buildUnlockEliteCard() {
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
              SvgPicture.asset('assets/icons/rank.svg')
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
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
                '67%',
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
            child: const LinearProgressIndicator(
              value: 0.67,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8ABDE8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
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

  Widget _buildStatsGrid() {
    final stats = [
      ('Ranking', '#1', null),
      ('Earned points', '20.5k', 'coin'),
      ('Win rate', '85%', null),
      ('Total wins', '50', null),
      ('Total livestream', '75', null),
      ('Avg. live viewers', '6k', null),
      ('Returning viewers', '25', null),
      ('Engagement rate', '60%', null),
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
