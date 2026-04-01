import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/walletSystem/transaction/transaction_history_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TransactionHistoryFilter extends StatefulWidget {
  final TransactionHistoryFilterArgs initialFilters;

  const TransactionHistoryFilter({
    super.key,
    this.initialFilters = const TransactionHistoryFilterArgs(),
  });

  @override
  State<TransactionHistoryFilter> createState() =>
      _TransactionHistoryFilterState();
}

class _TransactionHistoryFilterState extends State<TransactionHistoryFilter> {
  String status = 'None';
  String operation = 'None';
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    status = widget.initialFilters.status.isNotEmpty
        ? _toTitleCase(widget.initialFilters.status)
        : 'None';
    operation = widget.initialFilters.operation.isNotEmpty
        ? _toTitleCase(widget.initialFilters.operation)
        : 'None';
    _startDateController = TextEditingController(
      text: widget.initialFilters.startDate,
    );
    _endDateController = TextEditingController(
      text: widget.initialFilters.endDate,
    );
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

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
                          context.pop();
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
                InkWell(
                  onTap: _resetFilters,
                  borderRadius: BorderRadius.circular(36),
                  child: Container(
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
                ),
              ],
            ),
            const Gap(16),
            _customTextfield(
              context,
              title: 'Start Date',
              controller: _startDateController,
              onTap: () => _pickDate(_startDateController),
            ),
            const Gap(16),
            _customTextfield(
              context,
              title: 'End Date',
              controller: _endDateController,
              onTap: () => _pickDate(_endDateController),
            ),
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
            InkWell(
              onTap: _applyFilters,
              borderRadius: BorderRadius.circular(38),
              child: Container(
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
            ),
            const Gap(30),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate == null || !mounted) return;
    controller.text =
        '${pickedDate.year}-${_twoDigits(pickedDate.month)}-${_twoDigits(pickedDate.day)}';
  }

  void _applyFilters() {
    context.pop(
      TransactionHistoryFilterArgs(
        status: status == 'None' ? '' : status.toLowerCase(),
        operation: operation == 'None' ? '' : operation.toLowerCase(),
        startDate: _startDateController.text.trim(),
        endDate: _endDateController.text.trim(),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      status = 'None';
      operation = 'None';
      _startDateController.clear();
      _endDateController.clear();
    });
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _toTitleCase(String value) {
    if (value.isEmpty) return 'None';
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
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
                      "Completed",
                      "Pending",
                      "Failed",
                    ].map(
                      (e) {
                        return DropdownMenuItem(
                          value: e,
                          child: switch (e) {
                            'Completed' => _statusWidget(
                                context, e, Colors.green),
                            'Pending' =>
                              _statusWidget(context, e, Colors.orange),
                            'Failed' => _statusWidget(context, e, Colors.red),
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
                ),
        )
      ],
    );

Widget _customTextfield(
  BuildContext context, {
  required String title,
  required TextEditingController controller,
  VoidCallback? onTap,
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
          child: TextField(
            controller: controller,
            readOnly: true,
            onTap: onTap,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );

Widget _statusWidget(BuildContext context, String label, Color color) => Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 4,
        ),
        Gap(4.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
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
