import 'package:clapmi/features/wallet/data/models/transaction.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SingleTransactionDetail extends StatelessWidget {
  final TransactionHistoryModel transaction;

  const SingleTransactionDetail({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(MediaQuery.paddingOf(context).top + 16),

            /// Back Button
            Row(
              children: [
                InkWell(
                  onTap: context.pop,
                  child: const Icon(Icons.arrow_back_ios, size: 24),
                ),
                const Gap(8),
                Text(
                  'Back',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),

            const Gap(16),

            /// Amount & Icon Row
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: const Color(0xFF002F56),
                  ),
                  child: (transaction.operation == "swap")
                      ? Image.asset(
                          "assets/images/withdrawal.png",
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        )
                      : SvgPicture.asset(
                          "assets/icons/swap.svg",
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                ),
                const Gap(8),
                ClipOval(
                  child: Image.asset(
                    "assets/images/coin_big.png",
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                const Gap(4),
                Text(
                  transaction.amount ?? "",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 31,
                      ),
                ),
              ],
            ),

            const Gap(8),

            Text(
              transaction.operation ?? "",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.greyTextColorVariant,
                  ),
            ),

            const Gap(16),

            /// Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF121212),
                border: Border.all(color: const Color(0xFF3D3D3D)),
              ),
              child: Column(
                children: [
                  /// Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: AppColors.greyTextColorVariant,
                            ),
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 4,
                          ),
                          const Gap(4),
                          Text(
                            transaction.status ?? "",
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ),
                    ],
                  ),

                  const Gap(16),

                  _itemRow(
                    context,
                    title: 'Amount',
                    value:
                        "${transaction.currency ?? ""}${transaction.amount ?? ""}",
                  ),

                  const Gap(16),

                  /// From Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: AppColors.greyTextColorVariant,
                            ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/usdt.svg',
                            width: 24,
                            height: 24,
                          ),
                          const Gap(4),
                          Text('USDT',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      )
                    ],
                  ),

                  const Gap(16),

                  /// To Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'To',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: AppColors.greyTextColorVariant,
                            ),
                      ),
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              "assets/images/coin_big.png",
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Gap(4),
                          Text('Clap Point',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      )
                    ],
                  ),

                  const Gap(16),

                  _itemRow(
                    context,
                    title: 'Order ID',
                    value: transaction.orderId ?? "",
                  ),

                  const Gap(16),

                  _itemRow(
                    context,
                    title: 'Time',
                    value: transaction.time ?? "",
                  ),

                  const Gap(16),

                  _itemRow(
                    context,
                    title: 'Date',
                    value: transaction.date ?? "",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Row
Widget _itemRow(
  BuildContext context, {
  required String title,
  required String value,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: AppColors.greyTextColorVariant,
            ),
      ),
      Text(value,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 10)),
    ],
  );
}
