import 'dart:math' as math;
import 'package:flutter/material.dart';

class TierData {
  final String name;
  final int coins;
  final Color primaryColor;
  final Color glowColor;
  final List<Color> crystalColors;
  final bool isActive;

  const TierData({
    required this.name,
    required this.coins,
    required this.primaryColor,
    required this.glowColor,
    required this.crystalColors,
    this.isActive = false,
  });
}

const tiers = [
  TierData(
    name: 'PRIME',
    coins: 4000,
    primaryColor: Color(0xFF00B4FF),
    glowColor: Color(0xFF0077FF),
    crystalColors: [Color(0xFF00CFFF), Color(0xFF0066FF), Color(0xFF00E5FF)],
    isActive: false,
  ),
  TierData(
    name: 'ELITE',
    coins: 4000,
    primaryColor: Color(0xFFAA55FF),
    glowColor: Color(0xFF7722FF),
    crystalColors: [Color(0xFFCC88FF), Color(0xFF8833FF), Color(0xFFDD99FF)],
    isActive: true,
  ),
  TierData(
    name: 'ICON',
    coins: 8000,
    primaryColor: Color(0xFFFFAA22),
    glowColor: Color(0xFFFF7700),
    crystalColors: [Color(0xFFFFCC66), Color(0xFFFF8800), Color(0xFFFFDD88)],
    isActive: false,
  ),
];

const benefits = [
  _Benefit(icon: Icons.account_circle_outlined, label: 'Profile badge'),
  _Benefit(icon: Icons.card_giftcard_outlined, label: 'Themed bounties'),
  _Benefit(
      icon: Icons.view_carousel_outlined, label: 'Category feature placements'),
  _Benefit(
      icon: Icons.bar_chart_outlined, label: 'Stream performance insights'),
  _Benefit(
      icon: Icons.monetization_on_outlined,
      label: 'Increased Clap coin rewards'),
];

class _Benefit {
  final IconData icon;
  final String label;
  const _Benefit({required this.icon, required this.label});
}

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

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Starfield background
          const _StarfieldBackground(),

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
                      onPressed: () {},
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
                    itemCount: tiers.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, index) {
                      final tier = tiers[index];
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
                  children: List.generate(tiers.length, (i) {
                    final active = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active
                            ? tiers[_currentPage].primaryColor
                            : Colors.white24,
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
  final TierData tier;
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
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow behind crystal
              AnimatedBuilder(
                animation: pulseController,
                builder: (_, __) {
                  final pulse = 0.6 + 0.4 * pulseController.value;
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: tier.glowColor.withOpacity(0.35 * pulse),
                          blurRadius: 60,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Crystal
              _CrystalGem(
                  colors: tier.crystalColors, primaryColor: tier.primaryColor),
            ],
          ),
        ),

        // Tier name
        Text(
          tier.name,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 6,
            color: Colors.white,
            shadows: [
              Shadow(color: tier.primaryColor.withOpacity(0.7), blurRadius: 20),
            ],
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
                color: const Color(0xFF1A1F2E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isCenter
                      ? tier.primaryColor.withOpacity(0.3)
                      : Colors.white10,
                  width: 1,
                ),
                boxShadow: isCenter
                    ? [
                        BoxShadow(
                          color: tier.glowColor.withOpacity(0.15),
                          blurRadius: 30,
                          spreadRadius: 4,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text(
                          '${tier.coins.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            '/month',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Access & Benefits',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Benefits list
                    ...benefits.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(b.icon,
                                    color: Colors.white70, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                b.label,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )),

                    const Spacer(),

                    // Subscribe button
                    SizedBox(
                      width: double.infinity,
                      child: tier.isActive
                          ? ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white24,
                                foregroundColor: Colors.white54,
                                disabledBackgroundColor: Colors.white24,
                                disabledForegroundColor: Colors.white54,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Subscribe',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Subscribe',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
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
        colors: [Color(0xFF081525), Color(0xFF050D1A)],
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
