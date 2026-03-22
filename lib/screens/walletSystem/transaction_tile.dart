import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.swap_horiz, color: Colors.blueAccent),
      title: const Text("Swap"),
      subtitle: const Text("400 CAPP • \$25"),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("07 March",
              style: TextStyle(fontSize: 12, color: Colors.white70)),
          Text("Completed", style: TextStyle(color: Colors.green, fontSize: 12))
        ],
      ),
    );
  }
}
