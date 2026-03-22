import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversionSummaryComponent extends StatefulWidget {
  const ConversionSummaryComponent({super.key});

  @override
  State<ConversionSummaryComponent> createState() =>
      _ConversionSummaryComponentState();
}

class _ConversionSummaryComponentState
    extends State<ConversionSummaryComponent> {
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
            "Conversion summary",
            style: TextStyle(color: Colors.white.withOpacity(.56)),
          ),
          SizedBox(height: 28.h),
          SizedBox(height: 28.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "You pay",
                    style: TextStyle(color: Colors.white.withOpacity(.56)),
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "0 CAP",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You get",
                    style: TextStyle(color: Colors.white.withOpacity(.56)),
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "0 USDT",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const PillButton(
            child: Text("Convert"),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
