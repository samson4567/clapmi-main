import 'package:clapmi/Uicomponent/walletComponents/more_button_for_wallet.dart';

import 'package:flutter/material.dart';

class ComponentDisplayScreen extends StatefulWidget {
  const ComponentDisplayScreen({super.key});

  @override
  State<ComponentDisplayScreen> createState() => _ComponentDisplayScreenState();
}

class _ComponentDisplayScreenState extends State<ComponentDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const MoreOptionWalletComponent(),
              );
            },
            icon: const Icon(Icons.visibility)),
      ),
    );
  }
}
