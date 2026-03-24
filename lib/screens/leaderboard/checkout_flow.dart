import 'package:flutter/material.dart';

import 'active_level_update.dart';
import 'tier_card_components.dart';
import 'upgrade_flow_styles.dart';

class LeaderboardPayemtUpgrade extends StatelessWidget {
  const LeaderboardPayemtUpgrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/icons/back_leader.png',
            width: 24,
            height: 24,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoCard(
              title: 'Payment method:',
              value: 'Clapmi Wallet',
            ),
            const SizedBox(height: 12),
            _infoCard(
              title: 'Subscription:',
              value: 'ELITE',
            ),
            const SizedBox(height: 12),
            _orderDetailsCard(),
            const Spacer(),
            _totalRow(),
            const SizedBox(height: 20),
            _checkoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _orderDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order amount:',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Clap coin',
                style: TextStyle(color: Colors.white),
              ),
              CoinDisplay(coins: 4000, iconSize: 40, fontSize: 16),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service charge',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '\$0',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Next payment date is April 30th, 2026',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _totalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        CoinDisplay(coins: 4000, iconSize: 40, fontSize: 16),
      ],
    );
  }

  Widget _checkoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006FCD),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PaymentSuccessScreen(),
            ),
          );
        },
        child: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 1.5,
            color: Colors.white,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

/// Upgrade preview screen - shows current level and target upgrade level side by side
class UpgradePreviewScreen extends StatefulWidget {
  final String currentLevel;
  final String targetLevel;
  final int price;
  final List<String> benefits;
  final String currentImagePath;
  final String targetImagePath;
  final bool isCurrentActive;

  const UpgradePreviewScreen({
    super.key,
    required this.currentLevel,
    required this.targetLevel,
    required this.price,
    required this.benefits,
    this.currentImagePath = 'assets/icons/eli4.png',
    this.targetImagePath = 'assets/icons/ic.png',
    this.isCurrentActive = true,
  });

  @override
  State<UpgradePreviewScreen> createState() => _UpgradePreviewScreenState();
}

class _UpgradePreviewScreenState extends State<UpgradePreviewScreen> {
  final PageController _controller = PageController(viewportFraction: 0.85);

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/pnc.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// BACK BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/back_leader.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text("Back", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// CAROUSEL
              SizedBox(
                height: 480,
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) {
                    setState(() => currentPage = i);
                  },
                  children: [
                    /// CURRENT CARD
                    _TierPreviewCard(
                      level: widget.currentLevel,
                      imagePath: widget.currentImagePath,
                      isActive: true,
                      buttonText: "Subscribed",
                      isActiveButton: true,
                      price: "4,000",
                      paymentInfo: "/month",
                      features: widget.benefits,
                    ),

                    /// TARGET CARD
                    _TierPreviewCard(
                      level: widget.targetLevel,
                      imagePath: widget.targetImagePath,
                      isActive: false,
                      buttonText: "Upgrade Subscription",
                      isActiveButton: false,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LeaderboardPayemtUpgrade(),
                          ),
                        );
                      },
                      price: "4,000",
                      paymentInfo: "/month",
                      features: widget.benefits,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// DOT INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage == index ? 10 : 6,
                    height: currentPage == index ? 10 : 6,
                    decoration: BoxDecoration(
                      color: currentPage == index ? Colors.white : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              /// NOTE TEXT
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Note: Upgrade will be in effect after the former subscription expires.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TierPreviewCard extends StatelessWidget {
  final String level;
  final String imagePath;
  final bool isActive;
  final String buttonText;
  final bool isActiveButton;
  final VoidCallback? onPressed;
  final String? price;
  final String? paymentInfo;
  final List<String>? features;

  const _TierPreviewCard({
    required this.level,
    required this.imagePath,
    required this.isActive,
    required this.buttonText,
    required this.isActiveButton,
    this.onPressed,
    this.price,
    this.paymentInfo,
    this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: TierCardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Column(
              children: [
                Image.asset(imagePath, height: 80),
                const SizedBox(height: 10),
                Text(
                  level,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isActive ? "Active" : "",
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// PRICE
            Row(
              children: [
                Image.asset(
                  'assets/icons/commentcoin.png',
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 6),
                Text(
                  "$price",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  " $paymentInfo",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// FEATURES
            ...features!.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                )),

            const Spacer(),

            /// BUTTON
            Center(
              child: isActiveButton
                  ? const Text(
                      "Subscribed",
                      style: TextStyle(color: Colors.white54),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: onPressed,
                      child: Text(buttonText),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/icons/pay.png'),
              const SizedBox(height: 30),
              const Text(
                'Payment Successful',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your clapmi subscription has successfully been activated',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E73BE),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LevelUpAnimatedScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelUpAnimatedScreen extends StatefulWidget {
  const LevelUpAnimatedScreen({super.key});

  @override
  State<LevelUpAnimatedScreen> createState() => _LevelUpAnimatedScreenState();
}

class _LevelUpAnimatedScreenState extends State<LevelUpAnimatedScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LevelAnimated(),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/icons/levelc.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content with animations
          FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Level Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Image.asset(
                    'assets/icons/prime.png',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Prime Unlocked',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/icons/podium.png',
                      fit: BoxFit.contain,
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
}

class LevelAnimated extends StatefulWidget {
  const LevelAnimated({super.key});

  @override
  State<LevelAnimated> createState() => _LevelAnimatedState();
}

class _LevelAnimatedState extends State<LevelAnimated>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const ActiveLevelScreen(),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _floatingIcon(String asset, double delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -50.0, end: 0.0),
      duration: Duration(milliseconds: 500 + delay.toInt()),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: Image.asset(asset, width: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF0B1E3A),
              Colors.black,
            ],
            radius: 1.2,
            center: Alignment(0, -0.3),
          ),
        ),
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
            // Floating icons
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  _floatingIcon('assets/icons/pay1.png', 0),
                  _floatingIcon('assets/icons/pay2.png', 100),
                  _floatingIcon('assets/icons/pay3.png', 200),
                  _floatingIcon('assets/icons/pay6.png', 300),
                  _floatingIcon('assets/icons/pay5.png', 400),
                ],
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Image.asset(
                        'assets/icons/prime.png',
                        width: 250,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: const Text(
                      'Prime Unlocked',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveLevelScreen extends StatelessWidget {
  const ActiveLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/levelc.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _ActiveLevelCard(
                level: 'ELITE',
                isActive: true,
                nextPayment: 'April 30th, 2026',
                price: '4,000',
                paymentMethod: 'Clapmi Wallet',
                imagePath: 'assets/icons/eli4.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveLevelCard extends StatelessWidget {
  final String level;
  final bool isActive;
  final String nextPayment;
  final String price;
  final String paymentMethod;
  final String imagePath;

  const _ActiveLevelCard({
    required this.level,
    required this.isActive,
    required this.nextPayment,
    required this.price,
    required this.paymentMethod,
    this.imagePath = 'assets/icons/eli4.png',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TierCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 20),
          _infoSection(),
          const SizedBox(height: 20),
          _features(),
          const SizedBox(height: 20),
          _buttons(context),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image.asset(imagePath, width: 100, height: 100),
        ),
        const SizedBox(width: 12),
        Text(
          level.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isActive ? "Active" : "Inactive",
          style: TextStyle(
            color: isActive ? Colors.lightBlueAccent : Colors.grey,
            fontSize: 14,
          ),
        )
      ],
    );
  }

  Widget _infoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow("Next payment:", nextPayment),
        _infoRow("Price:", price),
        _infoRow("Payment method:", paymentMethod),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _features() {
    final features = [
      "Profile badge",
      "Themed bounties",
      "Category feature placements",
      "Stream insights",
      "Bonus rewards"
    ];

    return TierBenefitsList(benefits: features);
  }

  Widget _buttons(BuildContext context) {
    return Builder(
      builder: (ctx) => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF006FCD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => const UpgradePreviewScreen(
                      currentLevel: 'ELITE',
                      targetLevel: 'PRIME',
                      price: 4000,
                      benefits: [
                        'Increased ClapCoin rewards',
                        'Themed bounties',
                        'Category feature placements',
                        'Stream performance insights',
                      ],
                    ),
                  ),
                );
              },
              child: const Text(
                "Upgrade",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CancellationEffectiveDateScreen extends StatelessWidget {
  const CancellationEffectiveDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/pnc.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                /// HEADER
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/icons/back_leader.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("Cancel Subscription",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),

                const SizedBox(height: 40),

                /// HERO (ICON + TITLE)
                Column(
                  children: [
                    Image.asset(
                      'assets/icons/eli4.png',
                      height: 90,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "ELITE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// DESCRIPTION
                const Text(
                  "Your subscription will be cancelled at the end of your billing period on March 13, 2026, and you won’t be charged anymore.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5, // line-height: 150%
                    letterSpacing: 0,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "After this date, you’ll no longer have access to these benefits from Clapmi:",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                    letterSpacing: 0,
                    color: Colors.white54,
                  ),
                ),

                const SizedBox(height: 20),

                /// DROPDOWN
                _CancelReasonDropdown(),

                const Spacer(),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Keep Subscription",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006FCD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CancellationConfirmedScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Cancel Subscription",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CancelReasonDropdown extends StatefulWidget {
  @override
  State<_CancelReasonDropdown> createState() => _CancelReasonDropdownState();
}

class _CancelReasonDropdownState extends State<_CancelReasonDropdown> {
  String? selected;

  final List<String> reasons = [
    "Cost-related reasons",
    "I found a better app",
    "I don’t benefit from this service much",
    "Decline to answer",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: selected,
        isExpanded: true,
        dropdownColor: Colors.black,
        hint: const Text(
          "Select a reason for canceling",
          style: TextStyle(color: Colors.white54),
        ),
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        items: reasons.map((r) {
          return DropdownMenuItem(
            value: r,
            child: Text(
              r,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: (val) {
          setState(() => selected = val);
        },
      ),
    );
  }
}

class CancellationConfirmedScreen extends StatelessWidget {
  const CancellationConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              /// ICON
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E73BE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),

              const SizedBox(height: 30),

              const Text(
                "Subscription Cancelled",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Your clapmi subscription has successfully been cancelled",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E73BE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DowngradedScreen(),
                      ),
                    );
                  },
                  child:
                      const Text("Done", style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class DowngradedScreen extends StatelessWidget {
  const DowngradedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/pnc.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Spacer(),

                const Text(
                  "You are now on the",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 8),

                const Text(
                  "BASIC TIER",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 30),

                /// CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Your new benefits:",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      BenefitItem(text: 'Profile badge'),
                      BenefitItem(text: 'Basic bounties'),
                      BenefitItem(text: 'Standard support'),
                    ],
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E73BE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text("Done"),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
