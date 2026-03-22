
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferSummaryComponent extends StatefulWidget {
  const TransferSummaryComponent({super.key});

  @override
  State<TransferSummaryComponent> createState() =>
      _TransferSummaryComponentState();
}

class _TransferSummaryComponentState extends State<TransferSummaryComponent> {
  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      nulledAlign: true,
      radius: 20,
      padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
      backgroundColor: getFigmaColor("222222"),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transfer summary",
            style: TextStyle(color: Colors.white.withOpacity(.56)),
          ),
          SizedBox(height: 28.h),
          const Align(
            alignment: Alignment.center,
            child: Text("Transfer - 0 CAP"),
          ),
          SizedBox(height: 28.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "From",
                    style: TextStyle(color: Colors.white.withOpacity(.56)),
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "ClapMi walllet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "to",
                    style: TextStyle(color: Colors.white.withOpacity(.56)),
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "Web3 wallet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const PillButton(
            child: Text("Transfer"),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
