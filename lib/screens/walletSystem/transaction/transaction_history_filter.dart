import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TransactionHistoryFilter extends StatefulWidget {
  const TransactionHistoryFilter({super.key});

  @override
  State<TransactionHistoryFilter> createState() =>
      _TransactionHistoryFilterState();
}

class _TransactionHistoryFilterState extends State<TransactionHistoryFilter> {
  String status = 'None';
  String operation = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Gap(MediaQuery.paddingOf(context).top + 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          context.pop(MyAppRouteConstant.transactionHistory);
                        },
                        child: Icon(Icons.arrow_back_ios)),
                    SvgPicture.asset(
                      'assets/icons/filter.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                      height: 36.h,
                      width: 36.h,
                    ),
                    const Gap(8),
                    Text(
                      'Filter',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    color: AppColors.primaryColor,
                    border: const Border(
                        bottom: BorderSide(
                      color: Color(0xFF3D3D3D),
                      width: .5,
                    )),
                  ),
                  child: Text(
                    'Refresh',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const Gap(16),
            _customTextfield(context, title: 'Start Date'),
            const Gap(16),
            _customTextfield(context, title: 'End Date'),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: _customDropdown(
                    context,
                    title: 'Status',
                    value: status,
                    onchanged: (value) {
                      if (value == null) return;
                      setState(() {
                        status = value;
                      });
                    },
                  ),
                ),
                const Gap(4),
                Expanded(
                  child: _customDropdown(
                    context,
                    title: 'Operation',
                    value: operation,
                    onchanged: (value) {
                      if (value == null) return;
                      setState(() {
                        operation = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
                color: AppColors.primaryColor,
              ),
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                'Done',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            const Gap(30),
          ],
        ),
      ),
    );
  }
}

Widget _customDropdown(
  BuildContext context, {
  required String title,
  required String value,
  required Function(String?) onchanged,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.greyTextColorVariant,
              ),
        ),
        const Gap(16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(38),
            color: const Color(0xFF121212),
            border: Border.all(
              color: const Color(0xFF3D3D3D),
            ),
          ),
          child: title == 'Status'
              ? DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: [
                      "None",
                      "Swap",
                      "Withdraw",
                      "Deposit",
                    ].map(
                      (e) {
                        return DropdownMenuItem(
                          value: e,
                          child: switch (e) {
                            'Swap' => _swapWidget(context, e),
                            'Withdraw' => _withdrawalWidget(context, e),
                            'Deposit' => _depositWidget(context, e),
                            _ => Text(e),
                          },
                        );
                      },
                    ).toList(),
                    value: value,
                    onChanged: onchanged,
                  ),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton(
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.red),
                    items: [
                      "None",
                      "Completed",
                      "Failed",
                    ].map(
                      (e) {
                        return DropdownMenuItem(
                          value: e,
                          child: switch (e) {
                            'None' => Text(
                                e,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            _ => Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: e == 'Failed'
                                        ? Colors.red
                                        : Colors.green,
                                    radius: 4,
                                  ),
                                  Gap(4.h),
                                  Text(
                                    e,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              ),
                          },
                        );
                      },
                    ).toList(),
                    value: value,
                    onChanged: onchanged,
                  ),
                ),
        )
      ],
    );

Widget _customTextfield(
  BuildContext context, {
  required String title,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.greyTextColorVariant,
              ),
        ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(38),
            color: const Color(0xFF121212),
            border: Border.all(
              color: const Color(0xFF3D3D3D),
            ),
          ),
          child: const TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );

Widget _swapWidget(BuildContext context, String val) => Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: const Color(0xFF002F56),
          ),
          child: SvgPicture.asset(
            "assets/icons/swap.svg",
            width: 16,
            height: 16,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(10),
        Text(
          val,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
Widget _withdrawalWidget(BuildContext context, String val) => Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFF032F07),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            'assets/icons/outgoing.svg',
            height: 16,
            width: 16,
            colorFilter: const ColorFilter.mode(
              Colors.green,
              BlendMode.srcIn,
            ),
          ),
        ),
        const Gap(10),
        Text(
          val,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
Widget _depositWidget(BuildContext context, String val) => Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFF002F56),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            'assets/icons/incoming.svg',
            height: 16,
            width: 16,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        const Gap(10),
        Text(
          val,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
