import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpectatorIconsRow extends StatelessWidget {
  const SpectatorIconsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        SpectatorSvgIcon(
          iconPath: "assets/images/mic2.svg",
        ),
        SpectatorSvgIcon(
          iconPath: "assets/images/minimize.svg",
        ),
        SpectatorSvgIcon(
          iconPath: "assets/images/challen.svg",
        ),
        SpectatorSvgIcon(
          iconPath: "assets/icons/screen.svg",
        ),
      ],
    );
  }
}

class SpectatorSvgIcon extends StatelessWidget {
  final String iconPath;

  const SpectatorSvgIcon({
    super.key,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 60,
        height: 60,
        color: const Color(0xFF444444),
        padding: const EdgeInsets.all(16),
        child: SvgPicture.asset(
          iconPath,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
