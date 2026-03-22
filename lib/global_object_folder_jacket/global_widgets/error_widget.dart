import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget errorWidget(String errorMessage) {
  return SingleChildScrollView(
    physics: NeverScrollableScrollPhysics(),
    child: Container(
      clipBehavior: Clip.hardEdge,
      height: 40.h,
      width: 90.w,
      margin: EdgeInsets.only(bottom: 30.h),
      padding: EdgeInsets.only(left: 1.w),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.white,
            size: 25.w,
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Oops",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                errorMessage,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ))
        ],
      ),
    ),
  );
}
