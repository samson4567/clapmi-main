import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CoinAdded extends StatelessWidget {
  const CoinAdded({super.key, required this.addedCoin});
  final String addedCoin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        onPopInvokedWithResult: (popUp, result) {
          print('______________________________poppng up the screen');
          //   if (popUp) {
          context.goNamed(MyAppRouteConstant.walletGeneralPage);
          //}
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(),
              const Spacer(),
              Image.asset(
                'assets/images/coin_huge.png',
                height: 250,
                width: 250,
              ),
              const Gap(4),
              Text(
                '+$addedCoin Clap Point',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.goNamed(MyAppRouteConstant.walletGeneralPage);
                },
                child: Container(
                  // margin: EdgeInsets.only(bottom: 20.h),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  alignment: Alignment.center,
                  height: 45.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Text(
                    'Done',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),
              Gap(MediaQuery.paddingOf(context).bottom + 30),
            ],
          ),
        ),
      ),
    );
  }
}
