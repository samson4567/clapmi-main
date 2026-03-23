import 'package:flutter/material.dart';

/// Shared decoration styles for the upgrade flow
class UpgradeFlowStyles {
  // Card gradient - matches TierCard
  static BoxDecoration get cardDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment(-0.7, -1.0),
          end: Alignment(1, 1.0),
          colors: [
            Color(0xFF7A7F7F),
            Color(0xFF1E1E1E),
          ],
          stops: [-0.2, 0.3],
        ),
        border: Border.all(color: const Color(0XFFFFF7E8)),
      );

  // Background decoration - matches LevelUpAnimatedScreen
  static BoxDecoration get backgroundDecoration => const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/levelc.png'),
          fit: BoxFit.cover,
        ),
      );

  // Radial gradient background - matches LevelAnimated
  static BoxDecoration get radialBackgroundDecoration => const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF0B1E3A),
            Colors.black,
          ],
          radius: 1.2,
          center: Alignment(0, -0.3),
        ),
      );

  // Button styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF006FCD),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );

  static ButtonStyle get doneButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E73BE),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      );

  // Text styles
  static TextStyle get titleStyle => const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.5,
        letterSpacing: 0,
        color: Colors.white,
      );

  static TextStyle get subtitleStyle => const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white70,
        height: 1.5,
      );

  static TextStyle get successTitleStyle => const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}

/// Reusable floating icon widget
class FloatingUpgradeIcon extends StatelessWidget {
  final String asset;
  final double delay;
  final double size;

  const FloatingUpgradeIcon({
    super.key,
    required this.asset,
    this.delay = 0,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Image.asset(asset, width: size, height: size),
    );
  }
}

/// Reusable benefit item widget
class BenefitItem extends StatelessWidget {
  final String text;

  const BenefitItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable info row widget
class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
}
