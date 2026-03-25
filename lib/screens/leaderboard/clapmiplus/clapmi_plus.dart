import 'dart:ui';
import 'package:flutter/material.dart';

class LevelOnboardingScreen extends StatefulWidget {
  const LevelOnboardingScreen({super.key});

  @override
  State<LevelOnboardingScreen> createState() => _LevelOnboardingScreenState();
}

class _LevelOnboardingScreenState extends State<LevelOnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final pages = [
    {
      "title": "Welcome to Clapmi+",
      "subtitle": "Take your Clapmi Experience Further.",
      "desc":
          "With Clapmi+, you earn more ClapCoins, gain stronger voting power in battles, and unlock exclusive perks designed for the most active members of the community."
    },
    {
      "title": "Earn More Rewards",
      "subtitle": "Increased Clap Coin Rewards",
      "desc":
          "Clapmi+ members earn more ClapCoins from daily rewards and platform activities."
    },
    {
      "title": "Stronger Voting Power",
      "subtitle": "Boost Your Influence",
      "desc": "With Clapmi+, your votes carry more impact during combo battles."
    },
    {
      "title": "Stand Out on Clapmi",
      "subtitle": "Premium Perks",
      "desc":
          "Unlock exclusive profile recognition and enhanced engagement features."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🔹 BACKGROUND 1
          Positioned.fill(
            child: Image.asset(
              'assets/icons/stuck.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 BACKGROUND 2 (overlay)
          Positioned.fill(
            child: Image.asset(
              'assets/icons/stuck2.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 CONTENT
          SafeArea(
            child: Column(
              children: [
                /// Back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back, color: Colors.white),
                      SizedBox(width: 6),
                      Text("Back", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// Logo
                Image.asset(
                  'assets/icons/elite.png',
                  height: 80,
                ),

                const SizedBox(height: 20),

                /// 🔹 PAGE VIEW
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (i) {
                      setState(() => currentIndex = i);
                    },
                    itemBuilder: (context, index) {
                      final item = pages[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _GlassCard(
                          title: item["title"]!,
                          subtitle: item["subtitle"]!,
                          description: item["desc"]!,
                        ),
                      );
                    },
                  ),
                ),

                /// 🔹 DOT INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (i) => Container(
                      margin: const EdgeInsets.all(4),
                      width: currentIndex == i ? 10 : 6,
                      height: currentIndex == i ? 10 : 6,
                      decoration: BoxDecoration(
                        color: currentIndex == i ? Colors.blue : Colors.white30,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 SUBSCRIBE BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Center(
                      child: Text(
                        "Subscribe",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;

  const _GlassCard({
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/icons/stuck.png',
            fit: BoxFit.cover,
          ),
          // Glassmorphism overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Content
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Close icon
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.close, color: Colors.white70),
                ),

                const SizedBox(height: 10),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                /// bottom icons (fake placeholders)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.flash_on, color: Colors.white30),
                    Icon(Icons.monetization_on, color: Colors.white30),
                    Icon(Icons.verified, color: Colors.white30),
                    Icon(Icons.person, color: Colors.white30),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
