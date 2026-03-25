import 'dart:convert';
import 'package:flutter/material.dart';

import 'active_level_update.dart';
import 'upgrade_flow_styles.dart';
import 'package:clapmi/core/di/injector.dart';
import 'package:clapmi/features/user/data/datasources/user_remote_datasource.dart';
import 'package:clapmi/features/user/data/models/payment_grade_model.dart';
import 'package:dio/dio.dart' as dio;

class LeaderboardPayemtUpgrade extends StatefulWidget {
  final String? tierUuid;
  final String? tierName;
  final int? tierPrice;

  const LeaderboardPayemtUpgrade({
    super.key,
    this.tierUuid,
    this.tierName,
    this.tierPrice,
  });

  @override
  State<LeaderboardPayemtUpgrade> createState() =>
      _LeaderboardPayemtUpgradeState();
}

class _LeaderboardPayemtUpgradeState extends State<LeaderboardPayemtUpgrade> {
  bool _isLoading = false;
  String _currentLevel = 'ROOKIE';
  bool _isCurrentLevelActive = false;
  String _nextPayment = '';
  String _currentPrice = '0';
  String _paymentMethod = 'Clapmi Wallet';
  String _currentBadge = 'assets/icons/eli4.png';

  final UserRemoteDatasource _datasource =
      getItInstance<UserRemoteDatasource>();

  @override
  void initState() {
    super.initState();
    _fetchCurrentLevel();
  }

  Future<void> _fetchCurrentLevel() async {
    try {
      final response = await _datasource.getCreatorLevels();
      if (response.success) {
        // Find the current level (highest position achieved)
        final levels = response.data.creatorLevels;
        if (levels.isNotEmpty) {
          // Sort by position descending to get the highest level
          levels.sort((a, b) => b.position.compareTo(a.position));
          final currentLevel = levels.first;
          setState(() {
            _currentLevel = currentLevel.name;
            _currentPrice = currentLevel.subscriptionAmount.toString();
            _currentBadge = currentLevel.badge ?? 'assets/icons/eli4.png';
          });
        }
      }
    } catch (e) {
      print('Error fetching creator levels: $e');
    }
  }

  Future<void> _handleSubscribe() async {
    if (widget.tierUuid == null) {
      // If no UUID, just navigate to success screen (for demo purposes)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PaymentSuccessScreen(levelName: widget.tierName ?? 'Level'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _datasource.subscribeToGrade(widget.tierUuid!);

      if (response.success == "true") {
        // Navigate to success screen on successful subscription
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PaymentSuccessScreen(levelName: widget.tierName ?? 'Level'),
            ),
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      }
    } catch (e) {
      String errorMessage = 'An error occurred';

      // Check if it's a DioException
      if (e is dio.DioException) {
        final response = e.response;
        if (response?.data != null) {
          // Try to extract message from response data
          final data = response!.data;
          if (data is Map) {
            errorMessage = data['message'] ?? errorMessage;
          } else if (data is String) {
            // Try to parse the string as JSON
            try {
              final jsonData = json.decode(data);
              if (jsonData is Map) {
                errorMessage = jsonData['message'] ?? errorMessage;
              }
            } catch (_) {}
          }
        } else {
          // Use the error message from DioException
          errorMessage = e.message ?? errorMessage;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
            width: 20,
            height: 20,
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
            _card(
              title: 'Payment method:',
              value: 'Clapmi Wallet',
            ),
            const SizedBox(height: 12),
            _card(
              title: 'Subscription:',
              value: widget.tierName ?? 'ELITE',
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
    // Use tier price or default to 4000
    final price = widget.tierPrice ?? 4000;

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
                      height: 24, width: 24),
                  const SizedBox(width: 4),
                  Text('$price', style: const TextStyle(color: Colors.white)),
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
    // Use tier price or default to 4000
    final price = widget.tierPrice ?? 4000;

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
            Image.asset('assets/icons/commentcoin.png', height: 24, width: 24),
            Text(
              '$price',
              style: const TextStyle(
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
        onPressed: _isLoading ? null : _handleSubscribe,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
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

class LevelUpAnimatedScreen extends StatefulWidget {
  final String levelName;

  const LevelUpAnimatedScreen({super.key, required this.levelName});

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
                  '${widget.levelName} Unlocked',
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
  final String levelName;

  const PaymentSuccessScreen({super.key, required this.levelName});

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
                        builder: (_) =>
                            LevelUpAnimatedScreen(levelName: levelName),
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
class ActiveLevelScreen extends StatefulWidget {
  const ActiveLevelScreen({super.key});

  @override
  State<ActiveLevelScreen> createState() => _ActiveLevelScreenState();
}

class _ActiveLevelScreenState extends State<ActiveLevelScreen> {
  bool _isLoading = true;
  String? _error;
  PaymentGradeModel? _currentLevel;

  final UserRemoteDatasource _datasource =
      getItInstance<UserRemoteDatasource>();

  @override
  void initState() {
    super.initState();
    _fetchCurrentLevel();
  }

  Future<void> _fetchCurrentLevel() async {
    try {
      final response = await _datasource.getPaymentGrades();
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Find the current level (where isCurrentLevel is true)
          _currentLevel = response.data.data.firstWhere(
            (grade) => grade.isCurrentLevel,
            orElse: () => response.data.data.isNotEmpty
                ? response.data.data.first
                : throw Exception('No levels available'),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _fetchCurrentLevel();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final levelName = _currentLevel?.name ?? 'Unknown';
    final levelImage = _currentLevel?.badgeUrl;

    return Scaffold(
      body: Container(
        decoration: UpgradeFlowStyles.backgroundDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ActiveLevelWidget(
                level: levelName,
                isActive: _currentLevel?.isCurrentLevel ?? false,
                nextPayment: 'N/A',
                price: _currentLevel?.subscriptionAmount.toString() ?? '0',
                paymentMethod: 'Clapmi Wallet',
                imagePath: levelImage ?? 'assets/icons/eli4.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
