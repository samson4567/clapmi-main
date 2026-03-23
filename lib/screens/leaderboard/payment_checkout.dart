import 'package:flutter/material.dart';

import 'active_level_update.dart';
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
            _card(
              title: 'Payment method:',
              value: 'Clapmi Wallet',
            ),
            const SizedBox(height: 12),
            _card(
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

  Widget _card({required String title, required String value}) {
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
              Row(
                children: [
                  Image.asset('assets/icons/commentcoin.png',
                      height: 40, width: 40),
                  const SizedBox(width: 4),
                  const Text('4,000', style: TextStyle(color: Colors.white)),
                ],
              ),
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
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Image.asset('assets/icons/commentcoin.png', height: 40, width: 40),
            const Text(
              '4,000',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
                letterSpacing: 0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _checkoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: UpgradeFlowStyles.primaryButtonStyle,
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
            color: Color(0XFFFFFFFF),
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class PaymentSuccessScreenAnimated extends StatelessWidget {
  const PaymentSuccessScreenAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return const LevelUpAnimatedScreen();
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
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/icons/levelc.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Level Up',
                  textAlign: TextAlign.center,
                  style: UpgradeFlowStyles.titleStyle,
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
                Text(
                  'Prime Unlocked',
                  style: UpgradeFlowStyles.titleStyle,
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
              Text(
                'Payment Successful',
                textAlign: TextAlign.center,
                style: UpgradeFlowStyles.successTitleStyle,
              ),
              const SizedBox(height: 16),
              Text(
                'Your clapmi subscription has successfully been activated',
                textAlign: TextAlign.center,
                style: UpgradeFlowStyles.subtitleStyle,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: UpgradeFlowStyles.doneButtonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PaymentSuccessScreenAnimated(),
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

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: UpgradeFlowStyles.radialBackgroundDecoration,
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
                  FloatingUpgradeIcon(asset: 'assets/icons/pay1.png', delay: 0),
                  FloatingUpgradeIcon(
                      asset: 'assets/icons/pay2.png', delay: 100),
                  FloatingUpgradeIcon(
                      asset: 'assets/icons/pay3.png', delay: 200),
                  FloatingUpgradeIcon(
                      asset: 'assets/icons/pay6.png', delay: 300),
                  FloatingUpgradeIcon(
                      asset: 'assets/icons/pay5.png', delay: 400),
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
                    child: Text(
                      'Prime Unlocked',
                      textAlign: TextAlign.center,
                      style:
                          UpgradeFlowStyles.titleStyle.copyWith(fontSize: 32),
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

/// Active level screen with levelc.png background
class ActiveLevelScreen extends StatelessWidget {
  const ActiveLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: UpgradeFlowStyles.backgroundDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ActiveLevelWidget(
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
