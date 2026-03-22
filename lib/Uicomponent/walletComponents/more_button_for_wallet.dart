import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MoreOptionWalletComponent extends StatefulWidget {
  const MoreOptionWalletComponent({super.key});

  @override
  State<MoreOptionWalletComponent> createState() =>
      _MoreOptionWalletComponentState();
}

class _MoreOptionWalletComponentState extends State<MoreOptionWalletComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  const Text("More "),
                  Text(
                    "(Web3 wallet)",
                    style: fadedTextStyle,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.cancel_outlined),
              )
            ],
          ),
          const SizedBox(height: 30),
          InkWell(
              onTap: () {
                context.pop();
                context.push(MyAppRouteConstant.depositScreen);
              },
              child: const Text("Deposit")),
          const Divider(),
          InkWell(
              onTap: () {
                context.pop();
                context.push(MyAppRouteConstant.withdrawPage);
              },
              child: const Text("Withdraw")),
          const Divider(),
          InkWell(
              onTap: () {
                context.pop();
                context.push(MyAppRouteConstant.transferPage);
              },
              child: const Text("Transfer")),
          SizedBox(height: 30.h)
        ],
      ),
    );
  }
}
