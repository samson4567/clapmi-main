import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummaryComponentForBuying extends StatefulWidget {
  const OrderSummaryComponentForBuying({super.key});

  @override
  State<OrderSummaryComponentForBuying> createState() =>
      _OrderSummaryComponentForBuyingState();
}

class _OrderSummaryComponentForBuyingState
    extends State<OrderSummaryComponentForBuying> {
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
                    "Buying",
                    style: TextStyle(color: Colors.white.withOpacity(.56)),
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "6,000 points",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Cost",
                    style: TextStyle(color: Colors.white.withOpacity(.56)),
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    "151 USDT",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20.h),
          const PillButton(
            child: Text("Buy"),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
