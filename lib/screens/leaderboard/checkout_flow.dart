import 'package:flutter/material.dart';

import 'tier_card_components.dart';

class LeaderboardPayemtUpgrade extends StatelessWidget {
  const LeaderboardPayemtUpgrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
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
class UpgradePreviewScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Upgrade',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Horizontal scrollable cards
            SizedBox(
              height: 450,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Current Level Card (ELITE)
                  _TierPreviewCard(
                    level: currentLevel,
                    imagePath: currentImagePath,
                    isActive: isCurrentActive,
                    buttonText: 'Subscribed',
                    isActiveButton: true,
                    onPressed: null,
                    price: '\$price',
                    paymentInfo: 'Monthly',
                    features: [
                      'Profile badge',
                      'Themed bounties',
                      'Category feature placements',
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Target Level Card (ICON)
                  _TierPreviewCard(
                    level: targetLevel,
                    imagePath: targetImagePath,
                    isActive: false,
                    buttonText: 'Upgrade',
                    isActiveButton: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardPayemtUpgrade(),
                        ),
                      );
                    },
                    price: '\${(price * 2).toString()}',
                    paymentInfo: 'Monthly',
                    features: benefits,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Benefits section
          ],
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
  final bool isUpgradeButton;
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
    this.isUpgradeButton = false,
    this.onPressed,
    this.price,
    this.paymentInfo,
    this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/icons/levelc.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon and level
            _header(),
            const SizedBox(height: 20),
            // Info section
            if (price != null || paymentInfo != null) ...[
              _infoSection(),
              const SizedBox(height: 20),
            ],
            // Features
            if (features != null && features!.isNotEmpty) ...[
              _features(),
              const SizedBox(height: 20),
            ],
            // Button
            if (buttonText.isNotEmpty) _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        // Level icon
        SizedBox(
          width: 100,
          height: 100,
          child: Image.asset(
            imagePath,
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                level.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isActive ? 'Active' : 'Next',
                style: TextStyle(
                  color: isActive ? Colors.lightBlueAccent : Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (price != null) _infoRow("Price:", price!),
        if (paymentInfo != null) _infoRow("Payment:", paymentInfo!),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _features() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Benefits:',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...features!.take(4).map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildButton() {
    // Style for upgrade button (white, smaller)
    if (isUpgradeButton) {
      return SizedBox(
        width: 120,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    // Default style for current level
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isActiveButton ? Colors.white24 : const Color(0xFF006FCD),
          foregroundColor: isActiveButton ? Colors.white54 : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
