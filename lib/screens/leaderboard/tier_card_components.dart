import 'package:flutter/material.dart';

/// Reusable tier card decoration matching TierCard styling
class TierCardDecoration extends BoxDecoration {
  TierCardDecoration()
      : super(
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
}

/// Reusable coin display widget
class CoinDisplay extends StatelessWidget {
  final int coins;
  final double fontSize;
  final double iconSize;

  const CoinDisplay({
    super.key,
    required this.coins,
    this.fontSize = 25,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          'assets/icons/commentcoin.png',
          height: iconSize,
          width: iconSize,
        ),
        const SizedBox(width: 6),
        Text(
          coins.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (m) => '${m[1]},',
              ),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            height: 1.5,
            letterSpacing: 0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Reusable benefits list widget
class TierBenefitsList extends StatelessWidget {
  final List<String> benefits;
  final String headerText;

  const TierBenefitsList({
    super.key,
    required this.benefits,
    this.headerText = 'Access & Benefits',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headerText,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white60,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ...benefits.map((b) => Padding(
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
                      b,
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
      ],
    );
  }
}

/// Reusable tier button widget
class TierButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isActive;
  final double width;
  final double height;

  const TierButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isActive = false,
    this.width = 102,
    this.height = 38,
  });

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white24,
            foregroundColor: Colors.white54,
            disabledBackgroundColor: Colors.white24,
            disabledForegroundColor: Colors.white54,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Reusable page indicator dots
class PageIndicatorDots extends StatelessWidget {
  final int totalDots;
  final int currentIndex;

  const PageIndicatorDots({
    super.key,
    required this.totalDots,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (i) {
        final active = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
