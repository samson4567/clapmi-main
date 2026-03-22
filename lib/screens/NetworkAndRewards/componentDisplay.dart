import 'package:clapmi/screens/NetworkAndRewards/connect_wallet_component.dart';
import 'package:flutter/material.dart';

class MyComponents extends StatefulWidget {
  const MyComponents({super.key});

  @override
  State<MyComponents> createState() => _MyComponentsState();
}

class _MyComponentsState extends State<MyComponents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => const Dialog(
                        clipBehavior: Clip.hardEdge,
                        backgroundColor: Colors.red,
                        child: ConnectWalletComponent(),
                      ));
            },
            icon: const Icon(Icons.visibility)),
      ),
    );
  }
}
