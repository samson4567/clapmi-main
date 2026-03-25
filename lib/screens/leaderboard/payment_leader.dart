import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/core/di/injector.dart';
import 'package:clapmi/features/user/data/datasources/user_remote_datasource.dart';
import 'package:clapmi/features/user/data/models/payment_grade_model.dart';
import 'package:shimmer/shimmer.dart';

class TierData {
  final String name;
  final int coins;

  final bool isActive;

  final String imagePath;
  final String buttonText;
  final String headerText;
  final List<String> benefits;

  const TierData({
    required this.name,
    required this.coins,
    this.isActive = false,
    required this.imagePath,
    required this.buttonText,
    required this.headerText,
    required this.benefits,
  });
}

const tiers = [
  TierData(
    imagePath: 'assets/icons/prii.png',
    name: 'PRIME',
    coins: 4000,
    isActive: false,
    buttonText: 'Subscribe',
    headerText: 'Access & Benefits',
    benefits: [
      'Increased ClapCoin rewards',
      'Themed bounties',
      'Category feature placements',
      'Stream performance insights',
    ],
  ),
  TierData(
    imagePath: 'assets/icons/prii.png',
    name: 'PRIME',
    coins: 4000,
    isActive: false,
    buttonText: 'Upgrade',
    headerText: 'Access & Benefits',
    benefits: [
      'Increased ClapCoin rewards',
      'Themed bounties',
      'Category feature placements',
      'Stream performance insights',
    ],
  ),
  TierData(
    imagePath: 'assets/icons/eli4.png',
    name: 'ELITE',
    coins: 4000,
    // primaryColor: Color(0xFFAA55FF),
    // glowColor: Color(0xFF7722FF),
    // crystalColors: [Color(0xFFCC88FF), Color(0xFF8833FF), Color(0xFFDD99FF)],
    isActive: true,
    buttonText: 'Subscribe',
    headerText: 'Eligibility Metrics',
    benefits: [
      'Total livestreams: 20–50',
      'Avg. live viewers: 100–250',
      'Engagement rate: 8–12%',
      'Revenue generated: \$351 – \$1500 (35,100 - 150,000CP)',
      'Returning viewers: ≥ 35%',
      '85% cashback from livestream',
    ],
  ),
  TierData(
    imagePath: 'assets/icons/eli4.png',
    name: 'ELITE',
    coins: 12000,
    // primaryColor: Color(0xFFAA55FF),
    // glowColor: Color(0xFF7722FF),
    // crystalColors: [Color(0xFFCC88FF), Color(0xFF8833FF), Color(0xFFDD99FF)],
    isActive: false,
    buttonText: 'Upgrade',
    headerText: 'Eligibility Metrics',
    benefits: [
      'Total livestreams: 20–50',
      'Avg. live viewers: 100–250',
      'Engagement rate: 8–12%',
      'Revenue generated: \$351 – \$1500 (35,100 - 150,000CP)',
      'Returning viewers: ≥ 35%',
      '85% cashback from livestream',
    ],
  ),
  TierData(
    imagePath: 'assets/icons/ic.png',
    name: 'ICON',
    coins: 8000,
    // primaryColor: Color(0xFFFFAA22),
    // glowColor: Color(0xFFFF7700),
    // crystalColors: [Color(0xFFFFCC66), Color(0xFFFF8800), Color(0xFFFFDD88)],
    isActive: false,
    buttonText: 'Subscribe',
    headerText: 'Eligibility Metrics',
    benefits: [
      'Total livestreams: 40–100+',
      'Avg. live viewers: 250–750',
      'Engagement rate: 12–18%',
      'Revenue generated: \$1501- \$4999 (150,100 - 499,900CP)',
      'Returning viewers: ≥ 50%',
      '90% cashback from livestream',
    ],
  ),
  TierData(
    imagePath: 'assets/icons/ic.png',
    name: 'ICON',
    coins: 12000,
    // primaryColor: Color(0xFFFFAA22),
    // glowColor: Color(0xFFFF7700),
    // crystalColors: [Color(0xFFFFCC66), Color(0xFFFF8800), Color(0xFFFFDD88)],
    isActive: false,
    buttonText: 'Upgrade',
    headerText: 'Eligibility Metrics',
    benefits: [
      'Total livestreams: 40–100+',
      'Avg. live viewers: 250–750',
      'Engagement rate: 12–18%',
      'Revenue generated: \$1501- \$4999 (150,100 - 499,900CP)',
      'Returning viewers: ≥ 50%',
      '90% cashback from livestream',
    ],
  ),
  TierData(
    imagePath: 'assets/icons/led.png',
    name: 'LEGEND',
    coins: 16000,
    // primaryColor: Color(0xFFFFAA22),
    // glowColor: Color(0xFFFF7700),
    // crystalColors: [Color(0xFFFFCC66), Color(0xFFFF8800), Color(0xFFFFDD88)],
    isActive: false,
    buttonText: 'Subscribe',
    headerText: 'Eligibility Metrics',
    benefits: [
      'Invitation-only OR exceptional performance',
      'Avg. live viewers: 750+',
      'Engagement rate: 18%+',
      'Revenue generated: \$5000+ (500,000+)',
      'Proven brand alignment & consistency',
      '100% cash back',
    ],
  ),
  TierData(
    imagePath: 'assets/icons/led.png',
    name: 'LEGEND',
    coins: 20000,
    // primaryColor: Color(0xFFFFAA22),
    // glowColor: Color(0xFFFF7700),
    // crystalColors: [Color(0xFFFFCC66), Color(0xFFFF8800), Color(0xFFFFDD88)],
    isActive: false,
    buttonText: 'Upgrade',
    headerText: 'Eligibility Metrics',
    benefits: [
      'Invitation-only OR exceptional performance',
      'Avg. live viewers: 750+',
      'Engagement rate: 18%+',
      'Revenue generated: \$5000+ (500,000+)',
      'Proven brand alignment & consistency',
      '100% cash back',
    ],
  ),
];

// End of tiers

// ── Screen ────────────────────────────────────────────────────────────────────

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  late final AnimationController _pulseController;

  final UserRemoteDatasource _datasource =
      getItInstance<UserRemoteDatasource>();

  List<PaymentGradeModel>? _paymentGrades;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _fetchPaymentGrades();
  }

  Future<void> _fetchPaymentGrades() async {
    try {
      final response = await _datasource.getPaymentGrades();

      // Debug logging
      print('Screen received response: $response');
      print('Screen response.data: ${response.data}');
      print('Screen response.data.data: ${response.data.data}');

      if (mounted) {
        setState(() {
          _paymentGrades = response.data.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching payment grades: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Handle loading state
    if (_isLoading) {
      return Scaffold(
        body: Stack(
          children: [
            const Image(
              image: AssetImage('assets/icons/pnc.png'),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Handle error state
    if (_error != null || _paymentGrades == null || _paymentGrades!.isEmpty) {
      return Scaffold(
        body: Stack(
          children: [
            const Image(
              image: AssetImage('assets/icons/pnc.png'),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.white, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    _error ?? 'Failed to load payment grades',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _error = null;
                      });
                      _fetchPaymentGrades();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          const Image(
            image: AssetImage('assets/icons/pnc.png'),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 22),
                      label: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // PageView of tier cards
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _paymentGrades!.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, index) {
                      final tier = _paymentGrades![index];
                      final isCenter = index == _currentPage;
                      return AnimatedScale(
                        scale: isCenter ? 1.0 : 0.92,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: _TierCard(
                          tier: tier,
                          pulseController: _pulseController,
                          isCenter: isCenter,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Page indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_paymentGrades!.length, (i) {
                    final active = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        // color: active
                        //     ? tiers[_currentPage].primaryColor
                        //     : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tier Card ─────────────────────────────────────────────────────────────────

class _TierCard extends StatelessWidget {
  final PaymentGradeModel tier;
  final AnimationController pulseController;
  final bool isCenter;

  const _TierCard({
    required this.tier,
    required this.pulseController,
    required this.isCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Crystal gem + tier name
        SizedBox(
          height: 100.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow behind crystal

              // Tier Image Icon
              tier.badgeUrl != null
                  ? Image.network(
                      tier.badgeUrl!,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/icons/prii.png',
                        width: 100,
                        height: 100,
                      ),
                    )
                  : Image.asset(
                      'assets/icons/prii.png',
                      width: 100,
                      height: 100,
                    ),
            ],
          ),
        ),

        // Tier name
        Text(
          tier.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 31,
            fontWeight: FontWeight.w700,
            height: 1.5, // line-height: 150%
            letterSpacing: 0,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 8),

        // Page dots inside header area (per-tier)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == 0 ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == 0 ? Colors.white : Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // Benefits card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment(-0.7, -1.0), // approximates 145deg
                  end: Alignment(1, 1.0),
                  colors: [
                    Color(0xFF7A7F7F),
                    Color(0xFF1E1E1E),
                  ],
                  stops: [-0.2, 0.3], // mimics -74% → 31%
                ),
                border: Border.all(color: Color(0XFFFFF7E8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/icons/commentcoin.png',
                          height: 28,
                          width: 28,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tier.subscriptionAmount == 0
                              ? 'Free'
                              : tier.subscriptionAmount
                                  .toString()
                                  .replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (m) => '${m[1]},',
                                  ),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            height: 1.5, // 150% line height
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                        if (tier.subscriptionAmount > 0) ...[
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              '/month',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Eligibility Metrics',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Benefits list
                    ...tier.benefits.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '●',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  b.label,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),

                    const Spacer(),

                    // Subscribe button
                    Center(
                      child: tier.isCurrentLevel
                          ? SizedBox(
                              width: 102,
                              height: 38,
                              child: ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white24,
                                  foregroundColor: Colors.white54,
                                  disabledBackgroundColor: Colors.white24,
                                  disabledForegroundColor: Colors.white54,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  tier.isSubscribed
                                      ? 'Current'
                                      : (tier.isNextLevel
                                          ? 'Upgrade'
                                          : 'Subscribe'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 102,
                              height: 38,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.push(
                                    MyAppRouteConstant.paymentCheckout,
                                    extra: {
                                      'tierUuid': tier.uuid,
                                      'tierName': tier.name,
                                      'tierPrice': tier.subscriptionAmount,
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  tier.isSubscribed
                                      ? 'Current'
                                      : (tier.isNextLevel
                                          ? 'Upgrade'
                                          : 'Subscribe'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Crystal Gem Widget ────────────────────────────────────────────────────────

class _CrystalGem extends StatelessWidget {
  final List<Color> colors;
  final Color primaryColor;

  const _CrystalGem({required this.colors, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 130,
      child: CustomPaint(
        painter: _CrystalPainter(colors: colors, primaryColor: primaryColor),
      ),
    );
  }
}

class _CrystalPainter extends CustomPainter {
  final List<Color> colors;
  final Color primaryColor;

  _CrystalPainter({required this.colors, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Main gem body
    final bodyPath = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w * 0.85, h * 0.3)
      ..lineTo(w * 0.75, h * 0.85)
      ..lineTo(w * 0.5, h)
      ..lineTo(w * 0.25, h * 0.85)
      ..lineTo(w * 0.15, h * 0.3)
      ..close();

    final bodyGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colors[0],
        colors[1],
        colors[2].withOpacity(0.8),
      ],
    );

    canvas.drawPath(
      bodyPath,
      Paint()
        ..shader = bodyGradient.createShader(Offset.zero & size)
        ..style = PaintingStyle.fill,
    );

    // Highlight facet top-left
    final facet1 = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w * 0.15, h * 0.3)
      ..lineTo(w * 0.38, h * 0.45)
      ..lineTo(w * 0.5, h * 0.15)
      ..close();

    canvas.drawPath(
      facet1,
      Paint()
        ..color = Colors.white.withOpacity(0.35)
        ..style = PaintingStyle.fill,
    );

    // Highlight facet center
    final facet2 = Path()
      ..moveTo(w * 0.5, h * 0.15)
      ..lineTo(w * 0.62, h * 0.45)
      ..lineTo(w * 0.5, h * 0.55)
      ..lineTo(w * 0.38, h * 0.45)
      ..close();

    canvas.drawPath(
      facet2,
      Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.fill,
    );

    // Wing-like side glow (left)
    final wingLeft = Path()
      ..moveTo(w * 0.15, h * 0.3)
      ..lineTo(-w * 0.2, h * 0.25)
      ..lineTo(-w * 0.05, h * 0.45)
      ..lineTo(w * 0.2, h * 0.5)
      ..close();

    canvas.drawPath(
      wingLeft,
      Paint()
        ..color = primaryColor.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Wing-like side glow (right)
    final wingRight = Path()
      ..moveTo(w * 0.85, h * 0.3)
      ..lineTo(w * 1.2, h * 0.25)
      ..lineTo(w * 1.05, h * 0.45)
      ..lineTo(w * 0.8, h * 0.5)
      ..close();

    canvas.drawPath(
      wingRight,
      Paint()
        ..color = primaryColor.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Outline
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = colors[0].withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_CrystalPainter old) => false;
}

// ── Starfield Background ──────────────────────────────────────────────────────

class _StarfieldBackground extends StatelessWidget {
  const _StarfieldBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _StarfieldPainter(),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Dark gradient background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF070707), Color(0xFF050D1A)],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, bgPaint);

    // Subtle top glow
    final glowPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.topCenter,
        radius: 1.0,
        colors: [Color(0x220055AA), Color(0x00000000)],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, glowPaint);

    // Stars
    final rng = math.Random(42);
    final starPaint = Paint()..color = Colors.white;

    for (int i = 0; i < 120; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 1.5;
      final opacity = 0.2 + rng.nextDouble() * 0.6;
      starPaint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), r, starPaint);
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => false;
}
