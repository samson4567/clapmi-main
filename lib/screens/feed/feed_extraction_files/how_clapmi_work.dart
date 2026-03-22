import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/Authentication/googlesigin_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HowToClapmiScreen extends StatefulWidget {
  const HowToClapmiScreen({super.key});

  @override
  State<HowToClapmiScreen> createState() => _HowToClapmiScreenState();
}

class _HowToClapmiScreenState extends State<HowToClapmiScreen> {
  int? expandedIndex;

  final List<Map<String, dynamic>> tutorials = [
    {
      "title": "Getting started with clapmi",
      "icon": "assets/images/dee.png",
      "videoUrl": "https://www.youtube.com/watch?v=CniA7AJgGJ4",
    },
    {
      "title": "How the combo ground Works",
      "icon": "assets/images/lie.png",
      "videoUrl": "https://www.youtube.com/watch?v=iRfhUCt27m4",
    },
    {
      "title": "How to challenge a post",
      "icon": "assets/images/box.png",
      "videoUrl": "https://www.youtube.com/watch?v=iRfhUCt27m4",
    },
    {
      "title": "How to accept a challenge",
      "icon": "assets/images/tick.png",
      "videoUrl": "https://www.youtube.com/watch?v=ybWBWTWeDG8",
    },
    {
      "title": "How the Reward Works",
      "icon": "assets/images/block.png",
      "videoUrl": "https://www.youtube.com/embed/4YYMNTdRfNw",
    },
    {
      "title": "How the deposit works",
      "icon": "assets/images/money.png",
      "videoUrl": "https://www.youtube.com/watch?v=ybWBWTWeDG8",
    },
    {
      "title": "How the withdrawal works",
      "icon": "assets/images/ri.png",
      "videoUrl": "https://www.youtube.com/watch?v=ybWBWTWeDG8",
    },
    {
      "title": "How the wallet works",
      "icon": "assets/images/tee.png",
      "videoUrl": "https://www.youtube.com/watch?v=ybWBWTWeDG8",
    },
    {
      "title": "How to buy points",
      "icon": "assets/images/shop.png",
      "videoUrl": "https://www.youtube.com/watch?v=ybWBWTWeDG8",
    },
    {
      "title": "Gifting a Streamer",
      "icon": "assets/images/gift-2.png",
      "videoUrl": "https://www.youtube.com/watch?v=ybWBWTWeDG8",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            context.push(MyAppRouteConstant.feedScreen);
          },
        ),
        title: Text(
          "How to clapmi works videos ",
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: ListView.builder(
          itemCount: tutorials.length,
          itemBuilder: (context, index) {
            final item = tutorials[index];
            final isExpanded = expandedIndex == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFF181919),
                borderRadius: BorderRadius.circular(12.r),
                border: isExpanded
                    ? Border.all(color: const Color(0xFF2D74FF), width: 1)
                    : null,
              ),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () {
                      setState(() {
                        expandedIndex = isExpanded ? null : index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        children: [
                          // Arrow icon
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_right_rounded,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 8.w),

                          // Replaced emoji with image asset
                          Image.asset(
                            item["icon"],
                            width: 24.w,
                            height: 24.h,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.white38,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 10.w),

                          // Title text
                          Expanded(
                            child: Text(
                              item["title"],
                              style: TextStyle(
                                fontFamily: 'Geist',
                                color: const Color(0XFFFFFFFF),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expanded section (video)
                  if (isExpanded)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: TutorialWebView(videoUrl: item["videoUrl"]),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
