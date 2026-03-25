import 'package:flutter/material.dart';

import 'checkout_flow.dart';
import 'tier_card_components.dart';

class ActiveLevelWidget extends StatelessWidget {
  final String level;
  final bool isActive;
  final String nextPayment;
  final String price;
  final String paymentMethod;
  final String imagePath;

  const ActiveLevelWidget({
    super.key,
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
        _glowingIcon(),
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

  Widget _glowingIcon() {
    return SizedBox(
      width: 100,
      height: 100,
      child: _buildImage(imagePath, 100, 100),
    );
  }

  Widget _buildImage(String path, double width, double height) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/icons/eli4.png',
            width: width,
            height: height,
          );
        },
      );
    } else {
      return Image.asset(path, width: width, height: height);
    }
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
    return Row(
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CancellationEffectiveDateScreen(),
                ),
              );
            },
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
                context,
                MaterialPageRoute(
                  builder: (_) => const UpgradePreviewScreen(
                    currentLevel: 'ELITE',
                    targetLevel: 'ICON',
                    price: 8000,
                    benefits: [
                      'Total livestreams: 40–100+',
                      'Avg. live viewers: 250–750',
                      'Engagement rate: 12–18%',
                      'Revenue generated: \$1501- \$4999',
                      'Returning viewers: ≥ 50%',
                      '90% cashback from livestream',
                    ],
                    currentImagePath: 'assets/icons/eli4.png',
                    targetImagePath: 'assets/icons/ic.png',
                    isCurrentActive: true,
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
    );
  }
}
