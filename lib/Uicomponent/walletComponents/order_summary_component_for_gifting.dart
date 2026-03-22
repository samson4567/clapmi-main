
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummaryComponentForGifting extends StatefulWidget {
  const OrderSummaryComponentForGifting({super.key});

  @override
  State<OrderSummaryComponentForGifting> createState() =>
      _OrderSummaryComponentForGiftingState();
}

class _OrderSummaryComponentForGiftingState
    extends State<OrderSummaryComponentForGifting> {
  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      nulledAlign: true,
      radius: 20,
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
      backgroundColor: getFigmaColor("222222"),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order summary",
            style: TextStyle(color: Colors.white.withOpacity(.56)),
          ),
          SizedBox(height: 28.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gifting",
                    style: TextStyle(color: Colors.white.withOpacity(.56)),
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "6,000 points",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Recipient",
                    style: TextStyle(color: Colors.white.withOpacity(.56)),
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "@John_Doe",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Checkbox(
                  value: isWarningConfirmed,
                  onChanged: (value) {
                    isWarningConfirmed = value ?? false;
                  }),
              Expanded(
                child: Text(
                  "Warning!!! Confirm user’s username before sending to avoid loss of funds .",
                  style:
                      TextStyle(fontSize: 14, color: getFigmaColor("E87400")),
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          const PillButton(
            child: Text("Gift"),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  bool isWarningConfirmed = false;
}
