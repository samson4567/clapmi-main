import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WithdrawalSuccessful extends StatelessWidget {
  const WithdrawalSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              children: [
                Image.asset('assets/images/withdrawal_successful.png'),
                const Gap(24),
                Text(
                  'Withdrawal Successful',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: PillButton(
                width: double.infinity,
                // height: 12,
                onTap: () {
                  context.go(MyAppRouteConstant.walletGeneralPage);
                },
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
