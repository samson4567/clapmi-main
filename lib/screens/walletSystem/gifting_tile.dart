import 'package:flutter/material.dart';

class GiftingTile extends StatelessWidget {
  const GiftingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.arrow_upward, color: Colors.red),
      title: const Text("-\$20"),
      subtitle: const Text("Gifted @Omaa 1200 CAPP"),
      trailing: const Text("3 days ago",
          style: TextStyle(fontSize: 12, color: Colors.white70)),
    );
  }
}
