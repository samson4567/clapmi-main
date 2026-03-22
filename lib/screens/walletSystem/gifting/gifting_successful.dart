import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class GiftingSuccessful extends StatelessWidget {
  const GiftingSuccessful(
      {super.key, required this.name, required this.selectedPoint});
  final String name;
  final int selectedPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/coin_huge.png',
                  height: 36,
                  width: 36,
                ),
                Text(
                  selectedPoint.toString(),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Gap(16),
                Text(
                  'Sent to ',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  '@$name',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                ),
              ],
            ),
            const Gap(50),
            Image.asset(
              'assets/images/gift.png',
              height: 250,
              width: 250,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                alignment: Alignment.center,
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
    );
  }
}
