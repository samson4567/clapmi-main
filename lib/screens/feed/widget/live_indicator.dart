import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:flutter/material.dart';

Widget liveIndicator(ComboEntity comboModel) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.red,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    child: comboModel.status == "LIVE"
        ? const Text(
            "LIVE",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          )
        : const Icon(Icons.watch_later_outlined, size: 12),
  );
}

Widget nameIndicator(String name) {
  return Flexible(
    child: Text(
      name,
      style: TextStyle(
          fontSize: 10,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: 1.4), // Reduced font size
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
  );
}
