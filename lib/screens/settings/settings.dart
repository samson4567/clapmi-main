import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String? _selectedTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const SizedBox(height: 10),
          _buildSettingOption(
            imagePath: "assets/icons/user.png",
            title: "Account",
            subtitle:
                "Update your personal details like name, bio, and contact info",
            onTap: () {
              setState(() => _selectedTitle = "Account");
              context.push(MyAppRouteConstant.account);
            },
          ),
          _buildSettingOption(
            imagePath: "assets/icons/security.png",
            title: "Security",
            subtitle:
                "Manage your account's security settings to keep your data safe",
            onTap: () {
              setState(() => _selectedTitle = "Security");
              context.push(MyAppRouteConstant.security);
            },
          ),
          _buildSettingOption(
            imagePath: "assets/icons/lock.png",
            title: "Privacy",
            subtitle: "Keep your data safe by controlling what users see",
            onTap: () {
              setState(() => _selectedTitle = "Privacy");
              context.push(MyAppRouteConstant.privacy);
            },
          ),
          _buildSettingOption(
            imagePath: "assets/images/kyc.png",
            title: "KYC",
            subtitle: "Add your details",
            onTap: () {
              setState(() => _selectedTitle = "KYC");
              context.push(MyAppRouteConstant.kyc);
            },
          ),
          _buildSettingOption(
            imagePath: "assets/icons/notification.png",
            title: "Notification",
            subtitle: "Choose which alerts you want to receive on your device",
            onTap: () {
              setState(() => _selectedTitle = "Notification");
              context.push(MyAppRouteConstant.notification);
            },
          ),
          _buildSettingOption(
            imagePath: "assets/icons/useroct.png",
            title: "Delete Account",
            subtitle: "Delete your clapmi account permanently",
            onTap: () {
              setState(() => _selectedTitle = "Delete Account");
              context.push(MyAppRouteConstant.delete);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingOption({
    required String imagePath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isHighlighted = _selectedTitle == title;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted
              ? const Color(0xFF0E3C8A).withOpacity(0.8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: 30,
              height: 30,
              color: isHighlighted ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isHighlighted ? FontWeight.w600 : FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isHighlighted ? Colors.white : Colors.white60,
                      height: 1.3,
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
