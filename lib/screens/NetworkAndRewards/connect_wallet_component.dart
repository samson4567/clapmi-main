import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class ConnectWalletComponent extends StatelessWidget {
  const ConnectWalletComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FancyContainer(
        height: 200,
        backgroundColor: getFigmaColor("181919"),
        radius: 16,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Connect Wallet to Claim your \$CAP"),
            FancyContainer(
              action: () {},
              height: 45,
              radius: 36,
              backgroundColor: AppColors.primaryColor,
              child: const Text(
                "Connect Wallet",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
