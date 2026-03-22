import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<Map<String, String>> items;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.primaryColor,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[400],
      onTap: onTap,
      items: items.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> item = entry.value;
        bool isSelected = currentIndex == index;

        return BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            margin: EdgeInsets.only(
                bottom: isSelected ? 8.0 : 0.0), // Makes it go up
            child: Image.asset(
              item['icon']!,
              height: isSelected ? 28 : 24, // Increase size when selected
              color: isSelected ? Colors.white : Colors.grey[400],
            ),
          ),
          label: item['label'],
        );
      }).toList(),
    );
  }
}
