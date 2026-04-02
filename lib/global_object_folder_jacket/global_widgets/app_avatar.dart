import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.memoryBytes,
    this.name,
    this.fallbackText,
    this.size = 40,
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.foregroundColor = Colors.white,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackChild,
  });

  final String? imageUrl;
  final Uint8List? memoryBytes;
  final String? name;
  final String? fallbackText;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? fallbackChild;

  bool _isSvg(String? value) {
    final normalized = value?.trim().split('?').first.toLowerCase() ?? '';
    return normalized.endsWith('.svg');
  }

  String _resolvedFallbackText() {
    final explicit = fallbackText?.trim() ?? '';
    if (explicit.isNotEmpty) {
      return explicit.substring(0, explicit.length > 2 ? 2 : explicit.length);
    }

    final trimmedName = name?.trim() ?? '';
    if (trimmedName.isEmpty) {
      return '';
    }

    final parts = trimmedName
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) {
      return '';
    }

    return parts.map((part) => part.substring(0, 1).toUpperCase()).join();
  }

  Widget _buildFallback() {
    final text = _resolvedFallbackText();
    return Container(
      width: size,
      height: size,
      color: backgroundColor,
      alignment: Alignment.center,
      child: fallbackChild ??
          (text.isNotEmpty
              ? Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                    fontSize: size * 0.34,
                  ),
                )
              : Icon(
                  Icons.person,
                  color: foregroundColor.withValues(alpha: 0.9),
                  size: size * 0.5,
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(size / 2);
    Widget child;

    if (memoryBytes != null && memoryBytes!.isNotEmpty) {
      child = Image.memory(
        memoryBytes!,
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    } else if (imageUrl == null || imageUrl!.trim().isEmpty) {
      child = _buildFallback();
    } else if (_isSvg(imageUrl)) {
      child = SvgPicture.network(
        imageUrl!,
        width: size,
        height: size,
        fit: fit,
        placeholderBuilder: (_) => _buildFallback(),
      );
    } else {
      child = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: fit,
        placeholder: (_, __) => _buildFallback(),
        errorWidget: (_, __, ___) => _buildFallback(),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: size,
        height: size,
        child: child,
      ),
    );
  }
}
